//
//  SearchViewController.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsViewController.h"

#import "PocketsphinxController.h"
#import "FliteController.h"
@interface SearchViewController()
- (void)startListening;
- (void)stopListening;
- (void) searchForTerm: (NSString *)term;
@end

@implementation SearchViewController
@synthesize recordButton;
@synthesize textField;
@synthesize pocketsphinxController, openEarsEventsObserver, fliteController, pathToGrammarToStartAppWith, pathToDictionaryToStartAppWith, firstVoiceToUse, currentHypothesis;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.openEarsEventsObserver setDelegate:self]; // Make this class the delegate of OpenEarsObserver so we can get all of the messages about what OpenEars is doing.
    
    self.firstVoiceToUse = @"cmu_us_rms"; 
    
    self.pathToGrammarToStartAppWith = [[NSBundle mainBundle] pathForResource:@"hub4.5000" ofType:@"DMP"];
     
    self.pathToDictionaryToStartAppWith = [[NSBundle mainBundle] pathForResource:@"hub4.5000" ofType:@"dic"];
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setRecordButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc {
    [openEarsEventsObserver release];
    [pocketsphinxController release];
	[fliteController release];
    [textField release];
    [currentHypothesis release];
    [recordButton release];
    [super dealloc];
}


#pragma mark - UITextField Delegate methods
- (BOOL) textFieldShouldReturn:(UITextField *)_textField {
    [self searchForTerm:_textField.text];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.pocketsphinxController stopListening];
}

#pragma mark - Action methods

- (IBAction)backBtnPressed:(id)sender {
    [recordButton setSelected:NO];
    listeningLoopRunning=NO;
    [self.pocketsphinxController stopListening];
    [self hideLoadingIndicators];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)voiceBtnPressed:(id)sender {
    UIButton *btn=(UIButton *)sender;
    if (btn.selected) {
        [btn setSelected:NO];
        [self stopListening];
    }
    else {
        [btn setSelected:YES];
        [self startListening];
    }
}

#pragma mark -
#pragma mark Lazy Allocation

// Lazily allocated PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController { 
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

// Lazily allocated FliteController.
- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}


// Lazily allocated OpenEarsEventsObserver.
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// An optional delegate method of OpenEarsEventsObserver which delivers the text of speech that Pocketsphinx heard and analyzed, along with its accuracy score and utterance ID.
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.
	self.currentHypothesis=hypothesis;
    // This is how to use an available instance of FliteController. We're going to repeat back the command that we heard with the voice we've chosen.
//	[self.fliteController say:[NSString stringWithFormat:@"Do you want me to search for %@",hypothesis] withVoice:self.firstVoiceToUse];
    [self hideLoadingIndicators];
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@""
                          message:[NSString stringWithFormat:@"Search for \"%@\"",hypothesis]
                          delegate:self 
                          cancelButtonTitle:@"NO" 
                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was an interruption to the audio session (e.g. an incoming phone call).
- (void) audioSessionInterruptionDidBegin {
	NSLog(@"AudioSession interruption began."); // Log it.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since it will need to restart its loop after an interruption.
    [self hideLoadingIndicators];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the interruption to the audio session ended.
- (void) audioSessionInterruptionDidEnd {
	NSLog(@"AudioSession interruption ended."); // Log it.
	// We're restarting the previously-stopped listening loop.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the audio input became unavailable.
- (void) audioInputDidBecomeUnavailable {
	NSLog(@"The audio input has become unavailable"); // Log it.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since there is no available input
}

// An optional delegate method of OpenEarsEventsObserver which informs that the unavailable audio input became available again.
- (void) audioInputDidBecomeAvailable {
	NSLog(@"The audio input is available"); // Log it.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was a change to the audio route (e.g. headphones were plugged in or unplugged).
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute {
	NSLog(@"Audio route change. The new audio route is %@", newRoute); // Log it.
    
	[self.pocketsphinxController stopListening]; // React to it by telling the Pocketsphinx loop to shut down and then start listening again on the new route
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop hit the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx. Another good reason to know when you're in the middle of
// calibration is that it is a timeframe in which you want to avoid playing any other sounds including speech so the calibration will be successful.
- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started."); // Log it.
    [self showLoadingIndicatorsWithMessage:@"Calibrating..."];
    
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop completed the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete."); // Log it.
    [self hideLoadingIndicators];
    
	self.fliteController.duration_stretch = .9; // Change the speed
	self.fliteController.target_mean = 1.2; // Change the pitch
	self.fliteController.target_stddev = 1.5; // Change the variance
	
//	[self.fliteController say:@"Welcome to OpenEars." withVoice:self.firstVoiceToUse]; // The same statement with the pitch and other voice values changed.
	
	self.fliteController.duration_stretch = 1.0; // Reset the speed
	self.fliteController.target_mean = 1.0; // Reset the pitch
	self.fliteController.target_stddev = 1.0; // Reset the variance
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxRecognitionLoopDidStart {
    
	NSLog(@"Pocketsphinx is starting up."); // Log it.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is now listening for speech.
- (void) pocketsphinxDidStartListening {
	
	NSLog(@"Pocketsphinx is now listening."); // Log it.
	
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech."); // Log it.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected a second of silence, indicating the end of an utterance. 
// This was added because developers requested being able to time the recognition speed without the speech time. The processing time is the time between 
// this method being called and the hypothesis being returned.
- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a second of silence, concluding an utterance."); // Log it.
    [self showLoadingIndicatorsWithMessage:@"Detecting..."];
}


// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx has exited its recognition loop, most 
// likely in response to the PocketsphinxController being told to stop listening via the stopListening method.
- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening."); // Log it.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
// Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
// in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to suspend recognition via the suspendRecognition method.
- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition."); // Log it.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop and after recognition
// having been suspended it is now resuming.  This can happen as a result of Flite speech completing
// on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to resume recognition via the resumeRecognition method.
- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition."); // Log it.
}


// An optional delegate method of OpenEarsEventsObserver which informs that Flite is speaking, most likely to be useful if debugging a
// complex interaction between sound classes. You don't have to do anything yourself in order to prevent Pocketsphinx from listening to Flite talk and trying to recognize the speech.
- (void) fliteDidStartSpeaking {
	NSLog(@"Flite has started speaking"); // Log it.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Flite is finished speaking, most likely to be useful if debugging a
// complex interaction between sound classes.
- (void) fliteDidFinishSpeaking {
	NSLog(@"Flite has finished speaking"); // Log it.
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OPENEARSLOGGING in OpenEarsConfig.h to learn more."); // Log it.
}

#pragma mark -
#pragma mark UI

// This is not OpenEars-specific stuff, just some UI behavior

- (IBAction) suspendListeningButtonAction { // This is the action for the button which suspends listening without ending the recognition loop
	[self.pocketsphinxController suspendRecognition];	

}

- (void) startListening {  
    if (!listeningLoopRunning) {
        [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
        listeningLoopRunning=YES;
        return;
    }
	[self.pocketsphinxController resumeRecognition];
}

- (void) stopListening {
    [self.pocketsphinxController suspendRecognition];
}

#pragma mark - UIAlertView delegate method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [self.pocketsphinxController stopListening];
       [recordButton setSelected:NO];
        listeningLoopRunning=NO;
       [self searchForTerm:currentHypothesis] ;
    }
}

#pragma mark - Other Methods

- (void) searchForTerm: (NSString *)term {
    ResultsViewController *resultsViewController=[[ResultsViewController alloc] init];
    resultsViewController.searchTerm=term;
    [self.navigationController pushViewController:resultsViewController animated:YES];
    [resultsViewController release];
    return;
}
@end
