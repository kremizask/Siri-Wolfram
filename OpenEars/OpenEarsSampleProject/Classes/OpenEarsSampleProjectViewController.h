//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  OpenEarsSampleProjectViewController.h
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

#import <UIKit/UIKit.h>

@class PocketsphinxController;
@class FliteController;
#import "OpenEarsEventsObserver.h" // We need to import this here in order to use the delegate.

@interface OpenEarsSampleProjectViewController : UIViewController <OpenEarsEventsObserverDelegate> {
	
	// These three are important OpenEars classes that OpenEarsSampleProjectViewController demonstrates the use of. There is a fourth important class (AudioSessionManager) 
	// demonstrated in OpenEarsSampleProjectAppDelegate in the method didFinishLaunchingWithOptions: and there is a fifth important class (LanguageModelGenerator) demonstrated
	// inside the OpenEarsSampleProjectViewController implementation in the method viewDidLoad.
	
	OpenEarsEventsObserver *openEarsEventsObserver; // A class whose delegate methods which will allow us to stay informed of changes in the Flite and Pocketsphinx statuses.
	PocketsphinxController *pocketsphinxController; // The controller for Pocketsphinx (voice recognition).
	FliteController *fliteController; // The controller for Flite (speech).

	// Some UI, not specifically related to OpenEars.
	IBOutlet UIButton *stopButton;
	IBOutlet UIButton *startButton;	
	IBOutlet UIButton *suspendListeningButton;	
	IBOutlet UIButton *resumeListeningButton;
	IBOutlet UITextView *statusTextView;
	IBOutlet UITextView *heardTextView;
	IBOutlet UILabel *pocketsphinxDbLabel;
	IBOutlet UILabel *fliteDbLabel;
		
	BOOL usingStartLanguageModel;
	
	// Strings which aren't required for OpenEars but which will help us show off the dynamic language features in this sample app.
	NSString *pathToGrammarToStartAppWith;
	NSString *pathToDictionaryToStartAppWith;
	
	NSString *pathToDynamicallyGeneratedGrammar;
	NSString *pathToDynamicallyGeneratedDictionary;
	
	// Strings which aren't required for OpenEars but which will help us show off the dynamic voice features in this sample app.
	NSString *firstVoiceToUse;
	NSString *secondVoiceToUse;
	
	// Our NSTimer that will help us read and display the input and output levels without locking the UI
	NSTimer *uiUpdateTimer;
}

// UI actions, not specifically related to OpenEars other than the fact that they invoke OpenEars methods.
- (IBAction) stopButtonAction;
- (IBAction) startButtonAction;
- (IBAction) suspendListeningButtonAction;
- (IBAction) resumeListeningButtonAction;

// Example for reading out the input audio levels without locking the UI using an NSTimer

- (void) startDisplayingLevels;
- (void) stopDisplayingLevels;

// These three are the important OpenEars objects that this class demonstrates the use of.

@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, retain) PocketsphinxController *pocketsphinxController;
@property (nonatomic, retain) FliteController *fliteController;

// Some UI, not specifically related to OpenEars.
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *suspendListeningButton;	
@property (nonatomic, retain) IBOutlet UIButton *resumeListeningButton;	
@property (nonatomic, retain) IBOutlet UITextView *statusTextView;
@property (nonatomic, retain) IBOutlet UITextView *heardTextView;
@property (nonatomic, retain) IBOutlet UILabel *pocketsphinxDbLabel;
@property (nonatomic, retain) IBOutlet UILabel *fliteDbLabel;

@property (nonatomic, assign) BOOL usingStartLanguageModel;

// Things which help us show off the dynamic language features.
@property (nonatomic, copy) NSString *pathToGrammarToStartAppWith;
@property (nonatomic, copy) NSString *pathToDictionaryToStartAppWith;
@property (nonatomic, copy) NSString *pathToDynamicallyGeneratedGrammar;
@property (nonatomic, copy) NSString *pathToDynamicallyGeneratedDictionary;

// Things which will help us to show off the dynamic voice feature
@property (nonatomic, copy) NSString *firstVoiceToUse;
@property (nonatomic, copy) NSString *secondVoiceToUse;

// Our NSTimer that will help us read and display the input and output levels without locking the UI
@property (nonatomic, retain) 	NSTimer *uiUpdateTimer;

@end

