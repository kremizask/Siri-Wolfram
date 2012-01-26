//
//  SearchViewController.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class PocketsphinxController;
@class FliteController;

#import "OpenEarsEventsObserver.h" // We need to import this here in order to use the delegate.

@interface SearchViewController : BaseViewController <UITextFieldDelegate, OpenEarsEventsObserverDelegate> {
    PocketsphinxController *pocketsphinxController; // The controller for Pocketsphinx (voice recognition).
    OpenEarsEventsObserver *openEarsEventsObserver; // A class whose delegate methods which will allow us to stay informed of changes in the Flite and Pocketsphinx statuses.
	FliteController *fliteController; // The controller for Flite (speech).


    // Strings which aren't required for OpenEars but which will help us show off the dynamic language features in this sample app.
	NSString *pathToGrammarToStartAppWith;
	NSString *pathToDictionaryToStartAppWith;
    
    // Strings which aren't required for OpenEars but which will help us show off the dynamic voice features in this sample app.
	NSString *firstVoiceToUse;
    
    BOOL listeningLoopRunning;
    BOOL waitingForResponse; //if YES, waiting for the user to answer YES or NO 
    
}
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, retain) PocketsphinxController *pocketsphinxController;
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, retain) FliteController *fliteController;

// Things which help us show off the dynamic language features.
@property (nonatomic, copy) NSString *pathToGrammarToStartAppWith;
@property (nonatomic, copy) NSString *pathToDictionaryToStartAppWith;

// Things which will help us to show off the dynamic voice feature
@property (nonatomic, copy) NSString *firstVoiceToUse;

@property (nonatomic, retain) NSString *currentHypothesis;
@property (retain, nonatomic) IBOutlet UIButton *recordButton;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)voiceBtnPressed:(id)sender;
@end
