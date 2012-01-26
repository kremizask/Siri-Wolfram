//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  OpenEarsEventsObserver.h
//  OpenEars
// 
//  OpenEarsEventsObserver is a class which allows the return of delegate methods delivering the status of various functions of Flite, Pocketsphinx and OpenEars
//
//  Copyright Halle Winkler 2010, 2011. All rights reserved.
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

#import <Foundation/NSObject.h>
#import "AudioConstants.h"

@protocol OpenEarsEventsObserverDelegate;

@interface OpenEarsEventsObserver : NSObject { // All the action is in the delegate methods of this class.

	id<OpenEarsEventsObserverDelegate> delegate;
}

@property (assign) id<OpenEarsEventsObserverDelegate> delegate; // the delegate will be sent events.

@end

// A protocol for delegates of OpenEarsEventsObserver.
@protocol OpenEarsEventsObserverDelegate <NSObject>
@optional 

// Delegate Methods you can implement in your app.

// Audio Session Status Methods.

- (void) audioSessionInterruptionDidBegin; // There was an interruption.
- (void) audioSessionInterruptionDidEnd; // The interruption ended.
- (void) audioInputDidBecomeUnavailable; // The input became unavailable.
- (void) audioInputDidBecomeAvailable; // The input became available again.
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute; // The audio route changed.

// Pocketsphinx Status Methods.

- (void) pocketsphinxDidStartCalibration; // Pocketsphinx isn't listening yet but it started calibration.
- (void) pocketsphinxDidCompleteCalibration; // Pocketsphinx isn't listening yet but calibration completed.
- (void) pocketsphinxRecognitionLoopDidStart; // Pocketsphinx isn't listening yet but it has entered the main recognition loop.
- (void) pocketsphinxDidStartListening; // Pocketsphinx is now listening.
- (void) pocketsphinxDidDetectSpeech; // Pocketsphinx heard speech and is about to process it.
- (void) pocketsphinxDidDetectFinishedSpeech; // Pocketsphinx detected a second of silence indicating the end of an utterance
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID; // Pocketsphinx has a hypothesis.
- (void) pocketsphinxDidStopListening; // Pocketsphinx has exited the continuous listening loop.
- (void) pocketsphinxDidSuspendRecognition; // Pocketsphinx has not exited the continuous listening loop but it will not attempt recognition.
- (void) pocketsphinxDidResumeRecognition; // Pocketsphinx has not existed the continuous listening loop and it will now start attemption recognition again.
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString; // Pocketsphinx switched language models inline.
- (void) pocketSphinxContinuousSetupDidFail; // Some aspect of setting up the continuous loop failed, turn on OPENEARSLOGGING for more info.

// Flite Status Methods.

- (void) fliteDidStartSpeaking; // Flite started speaking. You probably don't have to do anything about this.
- (void) fliteDidFinishSpeaking; // Flite finished speaking. You probably don't have to do anything about this.
	
@end
