//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  OpenEarsSampleProjectViewController.m
//  OpenEarsSampleProject
//
//  OpenEarsSampleProjectViewController is a class which demonstrates
//  all of the capabilities of OpenEars.
//
//  Copyright Halle Winkler 2010,2011. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  This file is licensed under the Common Development and Distribution License (CDDL) Version 1.0
//  http://www.opensource.org/licenses/cddl1.txt or see included file license.txt
//  with the single exception to the license that you may distribute executable-only versions
//  of software using OpenEars files without making source code available under the terms of CDDL Version 1.0 
//  paragraph 3.1 if source code to your software isn't otherwise available, and without including a notice in 
//  that case that that source code is available. Exception applies exclusively to compiled binary apps such as can be
//  downloaded from the App Store, and not to frameworks or systems, to which the un-altered CDDL applies
//  unless other terms are agreed to by the copyright holder.

// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// IMPORTANT NOTE: This version of OpenEars introduces a much-improved low-latency audio driver for recognition. However, it is no longer compatible with the Simulator.
// Because I understand that it can be very frustrating to not be able to debug application logic in the Simulator, I have provided a second driver that is based on
// Audio Queue Services instead of Audio Units for use with the Simulator exclusively. However, this is purely provided as a convenience for you: please do not evaluate
// OpenEars' recognition quality based on the Simulator because it is better on the device, and please do not report Simulator-only bugs since I only actively support 
// the device driver and generally, audio code should never be seriously debugged on the Simulator since it is just hosting your own desktop audio devices. Thanks!
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************

#import "OpenEarsSampleProjectViewController.h"
#import "PocketsphinxController.h"
#import "FliteController.h"
#import "LanguageModelGenerator.h"
@implementation OpenEarsSampleProjectViewController

@synthesize pocketsphinxController;
@synthesize startButton;
@synthesize stopButton;
@synthesize resumeListeningButton;
@synthesize suspendListeningButton;
@synthesize fliteController;
@synthesize statusTextView;
@synthesize heardTextView;
@synthesize pocketsphinxDbLabel;
@synthesize fliteDbLabel;
@synthesize openEarsEventsObserver;
@synthesize usingStartLanguageModel;
@synthesize pathToGrammarToStartAppWith;
@synthesize pathToDictionaryToStartAppWith;
@synthesize pathToDynamicallyGeneratedGrammar;
@synthesize pathToDynamicallyGeneratedDictionary;
@synthesize firstVoiceToUse;
@synthesize secondVoiceToUse;
@synthesize uiUpdateTimer;

#define kLevelUpdatesPerSecond 18 // We'll have the ui update 18 times a second to show some fluidity without hitting the CPU too hard.

#pragma mark - 
#pragma mark Memory Management

- (void)dealloc {
	[self stopDisplayingLevels]; // We'll need to stop any running timers before attempting to deallocate here.
	[uiUpdateTimer release];
	[pathToGrammarToStartAppWith release];
	[pathToDictionaryToStartAppWith release];
	[pathToDynamicallyGeneratedGrammar release];
	[pathToDynamicallyGeneratedDictionary release];
	[pocketsphinxController release];
	[fliteController release];
	[suspendListeningButton release];
	[resumeListeningButton release];
	[startButton release];
	[stopButton release];
	[statusTextView release];
	[heardTextView release];
	[pocketsphinxDbLabel release];
	[fliteDbLabel release];
	[firstVoiceToUse release];
	[secondVoiceToUse release];
	openEarsEventsObserver.delegate = nil;
	[openEarsEventsObserver release];
    [super dealloc];
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

// The last class we're using here is LanguageModelGenerator but I don't think it's advantageous to lazily instantiate it. You can see how it's used below.

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.openEarsEventsObserver setDelegate:self]; // Make this class the delegate of OpenEarsObserver so we can get all of the messages about what OpenEars is doing.

	// The following strings could be set to any of the following voices (you would also need to uncomment them in OpenEarsVoiceConfig.h):
	// cmu_us_awb8k // 8k version of the us_awb voice
	// cmu_us_rms8k // 8k version of the us_rms voice
	// cmu_us_slt8k // 8k version of the us_slt voice
	// cmu_time_awb // 16k awb time voice, unlikely to do much unless used to read time
	// cmu_us_awb //  16k us_awb voice
	// cmu_us_kal //  8k us_kal voice
	// cmu_us_kal16 // 16k us_kal voice
	// cmu_us_rms // 16k us_rms voice
	// cmu_us_slt // 16k us_slt voice
	
	 // The first voice is a 16kHz voice. It says "Welcome to OpenEars". You don't have to store this info in class properties, you can also put them directly into
	// [FliteController say:withVoice:], I'm just storing them right now so I can easily list them here for you and switch between them later in the code.

	self.firstVoiceToUse = @"cmu_us_rms";
	// The second voice is an 8kHz voice, demonstrating mixing these two voice types, which is a new feature of OpenEars. This voice is the one that says "You said <hypothesis>"
	self.secondVoiceToUse = @"cmu_us_slt8k"; 
	
	// Again, any voice that you use here must also be uncommented in OpenEarsVoiceConfig.h. This is for your benefit because it prevents the app from linking to voices 
	// that aren't used and blowing up the app size unnecessarily. If you don't use Flite and you don't use any voices, you can comment them all out to save app filesize. 
	// This has absolutely no effect on performance, memory or CPU, it just affects the filesize of your app.

	// This is the language model we're going to start up with. The only reason I'm making it a class property is that I reuse it a bunch of times in this example, 
	// but you can pass the string contents directly to PocketsphinxController:startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF:
	
	self.pathToGrammarToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.languagemodel"]; 

	// This is the dictionary we're going to start up with. The only reason I'm making it a class property is that I reuse it a bunch of times in this example, 
	// but you can pass the string contents directly to PocketsphinxController:startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF:
	self.pathToDictionaryToStartAppWith = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.dic"]; 
	
	self.usingStartLanguageModel = TRUE; // This is not an OpenEars thing, this is just so I can switch back and forth between the two models in this sample app.
	
	// Here is an example of dynamically creating an in-app grammar.
	
	// We want it to be able to response to the speech "CHANGE MODEL" and a few other things.  Items we want to have recognized as a whole phrase (like "CHANGE MODEL") 
	// we put into the array as one string (e.g. "CHANGE MODEL" instead of "CHANGE" and "MODEL"). This increases the probability that they will be recognized as a phrase.
	
	NSArray *languageArray = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects: // All capital letters.
															 @"CHANGE MODEL",
															 @"MONDAY",
															 @"TUESDAY",
															 @"WEDNESDAY",
															 @"THURSDAY",
															 @"FRIDAY",
															 @"SATURDAY",
															 @"SUNDAY",
															 @"QUIDNUNC",
															 nil]];  
	
	// The last entry, quidnunc, is an example of a word which will not be found in the lookup dictionary and will be passed to the fallback method. The fallback method is slower,
	// so, for instance, creating a new language model from dictionary words will be pretty fast, but a model that has a lot of unusual names in it or invented/rare/recent-slang
	// words will be potentially very slow to generate. You can use this information to give your users good UI feedback about what the expectations for wait times should be.
	
	// Turning on OPENEARSLOGGING will tell you how long the language model took to generate.

	// I don't think it's beneficial to lazily instantiate LanguageModelGenerator because you only need to give it a single message and then release it.
	// If you need to create a very large model or any size of model that has many unusual words that have to make use of the fallback generation method,
	// you will want to run this on a background thread so you can give the user some UI feedback that the task is in progress.
	LanguageModelGenerator *languageModelGenerator = [[LanguageModelGenerator alloc] init]; 

	// generateLanguageModelFromArray:withFilesNamed returns an NSError which will either have a value of noErr if everything went fine or a specific error if it didn't.
	NSError *error = [languageModelGenerator generateLanguageModelFromArray:languageArray withFilesNamed:@"OpenEarsDynamicGrammar"]; 
	NSDictionary *dynamicLanguageGenerationResultsDictionary = nil;
	if([error code] != noErr) {
		NSLog(@"Dynamic language generator reported error %@", [error description]);	
	} else {
		dynamicLanguageGenerationResultsDictionary = [error userInfo];
		
		// A useful feature of the fact that generateLanguageModelFromArray:withFilesNamed: always returns an NSError is that when it returns noErr (meaning there was
		// no error, or an [NSError code] of zero), the NSError also contains a userInfo dictionary which contains the path locations of your new files.
		
		// What follows demonstrates how to get the paths for your created dynamic language models out of that userInfo dictionary.
		NSString *lmFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMFile"];
		NSString *dictionaryFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryFile"];
		NSString *lmPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMPath"];
		NSString *dictionaryPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryPath"];
		
		NSLog(@"Dynamic language generator completed successfully, you can find your new files %@\n and \n%@\n at the paths \n%@ \nand \n%@", lmFile,dictionaryFile,lmPath,dictionaryPath);	
		
		// pathToDynamicallyGeneratedGrammar/Dictionary aren't OpenEars things, they are just the way I'm controlling being able to switch between the grammars in this sample app.
		self.pathToDynamicallyGeneratedGrammar = lmPath; // We'll set our new .languagemodel file to be the one to get switched to when the words "CHANGE MODEL" are recognized.
		self.pathToDynamicallyGeneratedDictionary = dictionaryPath; // We'll set our new dictionary to be the one to get switched to when the words "CHANGE MODEL" are recognized.
	}
	
	// There isn't any reason to keep a LanguageModelGenerator around indefinitely so IMO it makes more sense to instatiate it briefly, let it do it's work, and then put it away.
	[languageModelGenerator release]; 
	
	[languageArray release]; // We're done with the array of words
	
	NSLog(@"\n\nWelcome to the OpenEars sample project. This project understands the words:\nBACKWARD,\nCHANGE,\nFORWARD,\nGO,\nLEFT,\nMODEL,\nRIGHT,\nTURN,\nand if you say \"CHANGE MODEL\" it will switch to its dynamically-generated model which understands the words:\nCHANGE,\nMODEL,\nMONDAY,\nTUESDAY,\nWEDNESDAY,\nTHURSDAY,\nFRIDAY,\nSATURDAY,\nSUNDAY,\nQUIDNUNC");
	
	// This is how to start the continuous listening loop of an available instance of PocketsphinxController. We won't do this if the language generation failed since it will be listening for a command to change over to the generated language.
	if(dynamicLanguageGenerationResultsDictionary) {
		
		// startListeningWithLanguageModelAtPath:dictionaryAtPath:languageModelIsJSGF always needs to know the grammar file being used, 
		// the dictionary file being used, and whether the grammar is a JSGF. You must put in the correct value for languageModelIsJSGF.
		// Inside of a single recognition loop, you can only use JSGF grammars or ARPA grammars, you can't switch between the two types.
		
		// An ARPA grammar is the kind with a .languagemodel or .DMP file, and a JSGF grammar is the kind with a .gram file.
		[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
	}
		
	// [self startDisplayingLevels] is not an OpenEars method, just an approach for level reading
	// that I've included with this sample app. My example implementation does make use of two OpenEars
	// methods:	the pocketsphinxInputLevel method of PocketsphinxController and the fliteOutputLevel
	// method of fliteController. 
	//
	// The example is meant to show one way that you can read those levels continuously without locking the UI, 
	// by using an NSTimer, but the OpenEars level-reading methods 
	// themselves do not include multithreading code since I believe that you will want to design your own 
	// code approaches for level display that are tightly-integrated with your interaction design and the  
	// graphics API you choose. 
	// 
	// Please note that if you use my sample approach, you should pay attention to the way that the timer is always stopped in
	// dealloc. This should prevent you from having any difficulties with deallocating a class due to a running NSTimer process.
	
	[self startDisplayingLevels];

	// Here is some UI stuff that has nothing specifically to do with OpenEars implementation
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = TRUE;
	self.suspendListeningButton.hidden = TRUE;
	self.resumeListeningButton.hidden = TRUE;
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// What follows are all of the delegate methods you can optionally use once you've instantiated an OpenEarsEventsObserver and set its delegate to self. 
// I've provided some pretty granular information about the exact phase of the Pocketsphinx listening loop, the Audio Session, and Flite, but I'd expect 
// that the ones that will really be needed by most projects are the following:
//
//- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID;
//- (void) audioSessionInterruptionDidBegin;
//- (void) audioSessionInterruptionDidEnd;
//- (void) audioRouteDidChangeToRoute:(NSString *)newRoute;
//- (void) pocketsphinxDidStartListening;
//- (void) pocketsphinxDidStopListening;
//
// It isn't necessary to have a PocketsphinxController or a FliteController instantiated in order to use these methods.  If there isn't anything instantiated that will
// send messages to an OpenEarsEventsObserver, all that will happen is that these methods will never fire.  You also do not have to create a OpenEarsEventsObserver in
// the same class or view controller in which you are doing things with a PocketsphinxController or FliteController; you can receive updates from those objects in
// any class in which you instantiate an OpenEarsEventsObserver and set its delegate to self.

// An optional delegate method of OpenEarsEventsObserver which delivers the text of speech that Pocketsphinx heard and analyzed, along with its accuracy score and utterance ID.
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.
	if([hypothesis isEqualToString:@"CHANGE MODEL"]) { // If the user says "CHANGE MODEL", we will switch to the alternate model (which happens to be the dynamically generated model).

		// Here is an example of language model switching in OpenEars. Deciding on what logical basis to switch models is your responsibility.
		// For instance, when you call a customer service line and get a response tree that takes you through different options depending on what you say to it,
		// the models are being switched as you progress through it so that only relevant choices can be understood. The construction of that logical branching and 
		// how to react to it is your job, OpenEars just lets you send the signal to switch the language model when you've decided it's the right time to do so.
		
		if(self.usingStartLanguageModel == TRUE) { // If we're on the starting model, switch to the dynamically generated one.
			
			// You can only change language models with ARPA grammars in OpenEars (the ones that end in .languagemodel or .DMP). 
			// Trying to switch between JSGF models (the ones that end in .gram) will return no result.
			[self.pocketsphinxController changeLanguageModelToFile:self.pathToDynamicallyGeneratedGrammar withDictionary:self.pathToDynamicallyGeneratedDictionary]; 
			self.usingStartLanguageModel = FALSE;
		} else { // If we're on the dynamically generated model, switch to the start model (this is just an example of a trigger and method for switching models).
			[self.pocketsphinxController changeLanguageModelToFile:self.pathToGrammarToStartAppWith withDictionary:self.pathToDictionaryToStartAppWith];
			self.usingStartLanguageModel = TRUE;
		}
	}
	
	self.heardTextView.text = [NSString stringWithFormat:@"Heard: \"%@\"", hypothesis]; // Show it in the status box.
	
	// This is how to use an available instance of FliteController. We're going to repeat back the command that we heard with the voice we've chosen.
	[self.fliteController say:[NSString stringWithFormat:@"You said %@",hypothesis] withVoice:self.secondVoiceToUse];
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was an interruption to the audio session (e.g. an incoming phone call).
- (void) audioSessionInterruptionDidBegin {
	NSLog(@"AudioSession interruption began."); // Log it.
	self.statusTextView.text = @"Status: AudioSession interruption began."; // Show it in the status box.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since it will need to restart its loop after an interruption.
}

// An optional delegate method of OpenEarsEventsObserver which informs that the interruption to the audio session ended.
- (void) audioSessionInterruptionDidEnd {
	NSLog(@"AudioSession interruption ended."); // Log it.
	self.statusTextView.text = @"Status: AudioSession interruption ended."; // Show it in the status box.
	// We're restarting the previously-stopped listening loop.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the audio input became unavailable.
- (void) audioInputDidBecomeUnavailable {
	NSLog(@"The audio input has become unavailable"); // Log it.
	self.statusTextView.text = @"Status: The audio input has become unavailable"; // Show it in the status box.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since there is no available input
}

// An optional delegate method of OpenEarsEventsObserver which informs that the unavailable audio input became available again.
- (void) audioInputDidBecomeAvailable {
	NSLog(@"The audio input is available"); // Log it.
	self.statusTextView.text = @"Status: The audio input is available"; // Show it in the status box.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was a change to the audio route (e.g. headphones were plugged in or unplugged).
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute {
	NSLog(@"Audio route change. The new audio route is %@", newRoute); // Log it.
	self.statusTextView.text = [NSString stringWithFormat:@"Status: Audio route change. The new audio route is %@",newRoute]; // Show it in the status box.

	[self.pocketsphinxController stopListening]; // React to it by telling the Pocketsphinx loop to shut down and then start listening again on the new route
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop hit the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx. Another good reason to know when you're in the middle of
// calibration is that it is a timeframe in which you want to avoid playing any other sounds including speech so the calibration will be successful.
- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx calibration has started."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop completed the calibration stage in its startup.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx calibration is complete."; // Show it in the status box.

	self.fliteController.duration_stretch = .9; // Change the speed
	self.fliteController.target_mean = 1.2; // Change the pitch
	self.fliteController.target_stddev = 1.5; // Change the variance
	
	[self.fliteController say:@"Welcome to OpenEars." withVoice:self.firstVoiceToUse]; // The same statement with the pitch and other voice values changed.
	
	self.fliteController.duration_stretch = 1.0; // Reset the speed
	self.fliteController.target_mean = 1.0; // Reset the pitch
	self.fliteController.target_stddev = 1.0; // Reset the variance
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxRecognitionLoopDidStart {
    
	NSLog(@"Pocketsphinx is starting up."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx is starting up."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is now listening for speech.
- (void) pocketsphinxDidStartListening {
	
	NSLog(@"Pocketsphinx is now listening."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx is now listening."; // Show it in the status box.
	
	self.startButton.hidden = TRUE; // React to it with some UI changes.
	self.stopButton.hidden = FALSE;
	self.suspendListeningButton.hidden = FALSE;
	self.resumeListeningButton.hidden = TRUE;
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has detected speech."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx detected a second of silence, indicating the end of an utterance. 
// This was added because developers requested being able to time the recognition speed without the speech time. The processing time is the time between 
// this method being called and the hypothesis being returned.
- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a second of silence, concluding an utterance."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has detected finished speech."; // Show it in the status box.
}


// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx has exited its recognition loop, most 
// likely in response to the PocketsphinxController being told to stop listening via the stopListening method.
- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has stopped listening."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
// Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
// in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to suspend recognition via the suspendRecognition method.
- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has suspended recognition."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Pocketsphinx is still in its listening loop and after recognition
// having been suspended it is now resuming.  This can happen as a result of Flite speech completing
// on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
// or as a result of the PocketsphinxController being told to resume recognition via the resumeRecognition method.
- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition."); // Log it.
	self.statusTextView.text = @"Status: Pocketsphinx has resumed recognition."; // Show it in the status box.
}

// An optional delegate method which informs that Pocketsphinx switched over to a new language model at the given URL in the course of
// recognition. This does not imply that it is a valid file or that recognition will be successful using the file.
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

// An optional delegate method of OpenEarsEventsObserver which informs that Flite is speaking, most likely to be useful if debugging a
// complex interaction between sound classes. You don't have to do anything yourself in order to prevent Pocketsphinx from listening to Flite talk and trying to recognize the speech.
- (void) fliteDidStartSpeaking {
	NSLog(@"Flite has started speaking"); // Log it.
	self.statusTextView.text = @"Status: Flite has started speaking."; // Show it in the status box.
}

// An optional delegate method of OpenEarsEventsObserver which informs that Flite is finished speaking, most likely to be useful if debugging a
// complex interaction between sound classes.
- (void) fliteDidFinishSpeaking {
	NSLog(@"Flite has finished speaking"); // Log it.
	self.statusTextView.text = @"Status: Flite has finished speaking."; // Show it in the status box.
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OPENEARSLOGGING in OpenEarsConfig.h to learn more."); // Log it.
	self.statusTextView.text = @"Status: Not possible to start recognition loop."; // Show it in the status box.	
}


#pragma mark -
#pragma mark UI

// This is not OpenEars-specific stuff, just some UI behavior

- (IBAction) suspendListeningButtonAction { // This is the action for the button which suspends listening without ending the recognition loop
	[self.pocketsphinxController suspendRecognition];	
	
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = FALSE;
	self.suspendListeningButton.hidden = TRUE;
	self.resumeListeningButton.hidden = FALSE;
}

- (IBAction) resumeListeningButtonAction { // This is the action for the button which resumes listening if it has been suspended
	[self.pocketsphinxController resumeRecognition];
	
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = FALSE;
	self.suspendListeningButton.hidden = FALSE;
	self.resumeListeningButton.hidden = TRUE;	
}

- (IBAction) stopButtonAction { // This is the action for the button which shuts down the recognition loop.
	[self.pocketsphinxController stopListening];
	
	self.startButton.hidden = FALSE;
	self.stopButton.hidden = TRUE;
	self.suspendListeningButton.hidden = TRUE;
	self.resumeListeningButton.hidden = TRUE;
}

- (IBAction) startButtonAction { // This is the action for the button which starts up the recognition loop again if it has been shut down.
	[self.pocketsphinxController startListeningWithLanguageModelAtPath:self.pathToGrammarToStartAppWith dictionaryAtPath:self.pathToDictionaryToStartAppWith languageModelIsJSGF:FALSE];
	
	self.startButton.hidden = TRUE;
	self.stopButton.hidden = FALSE;
	self.suspendListeningButton.hidden = FALSE;
	self.resumeListeningButton.hidden = TRUE;
}

#pragma mark -
#pragma mark Example for reading out Pocketsphinx and Flite audio levels without locking the UI by using an NSTimer

// What follows are not OpenEars methods, just an approach for level reading
// that I've included with this sample app. My example implementation does make use of two OpenEars
// methods:	the pocketsphinxInputLevel method of PocketsphinxController and the fliteOutputLevel
// method of fliteController. 
//
// The example is meant to show one way that you can read those levels continuously without locking the UI, 
// by using an NSTimer, but the OpenEars level-reading methods 
// themselves do not include multithreading code since I believe that you will want to design your own 
// code approaches for level display that are tightly-integrated with your interaction design and the  
// graphics API you choose. 
// 
// Please note that if you use my sample approach, you should pay attention to the way that the timer is always stopped in
// dealloc. This should prevent you from having any difficulties with deallocating a class due to a running NSTimer process.

- (void) startDisplayingLevels { // Start displaying the levels using a timer
	[self stopDisplayingLevels]; // We never want more than one timer valid so we'll stop any running timers first.
	self.uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/kLevelUpdatesPerSecond target:self selector:@selector(updateLevelsUI) userInfo:nil repeats:YES];
}

- (void) stopDisplayingLevels { // Stop displaying the levels by stopping the timer if it's running.
	if(self.uiUpdateTimer && [self.uiUpdateTimer isValid]) { // If there is a running timer, we'll stop it here.
		[self.uiUpdateTimer invalidate];
		self.uiUpdateTimer = nil;
	}
}

- (void) updateLevelsUI { // And here is how we obtain the levels.  This method includes the actual OpenEars methods and uses their results to update the UI of this view controller.
   
	self.pocketsphinxDbLabel.text = [NSString stringWithFormat:@"Pocketsphinx Input level:%f",[self.pocketsphinxController pocketsphinxInputLevel]];  //pocketsphinxInputLevel is an OpenEars method of the class PocketsphinxController.
    
	if(self.fliteController.speechInProgress == TRUE) {
		self.fliteDbLabel.text = [NSString stringWithFormat:@"Flite Output level: %f",[self.fliteController fliteOutputLevel]]; // fliteOutputLevel is an OpenEars method of the class FliteController.
	}
}


@end
