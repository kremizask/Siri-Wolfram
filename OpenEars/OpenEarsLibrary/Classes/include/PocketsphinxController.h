//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  PocketsphinxController.h
//  OpenEars
//
//  PocketsphinxController is a class which controls the creation and management of
//  a continuous speech recognition loop.
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

#import <Foundation/Foundation.h>
#import "OpenEarsEventsObserver.h"
#import "ContinuousModel.h"
#import "AudioConstants.h"

@interface PocketsphinxController : NSObject <OpenEarsEventsObserverDelegate> {

	NSThread *voiceRecognitionThread; // The loop would lock if run on the main thread so it has a background thread in which it always runs.
	ContinuousModel *continuousModel; // The continuous model is the actual recognition loop.
	OpenEarsEventsObserver *openEarsEventsObserver; // We use an OpenEarsEventsObserver here to get important information from other objects which may be instantiated.
}

// These are the OpenEars methods for controlling Pocketsphinx. You should use these.

- (void) stopListening; // Exits from the recognition loop.
- (void) startListeningWithLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF;  // Starts the recognition loop.
- (void) suspendRecognition; // Stops interpreting sounds as speech without exiting from the recognition loop. You do not need to call these methods on behalf of Flite.
- (void) resumeRecognition; // Starts interpreting sounds as speech after suspending recognition with the preceding method. You do not need to call these methods on behalf of Flite.
- (void) changeLanguageModelToFile:(NSString *)languageModelPathAsString withDictionary:(NSString *)dictionaryPathAsString; // If you have already started the recognition loop and you want to switch to a different language model, you can use this and the model will be changed at the earliest opportunity. Will not have any effect unless recognition is already in progress.

// Here are all the multithreading methods, you should never do anything with any of these.
- (void) startVoiceRecognitionThreadWithLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF;
- (void) stopVoiceRecognitionThread;
- (void) waitForVoiceRecognitionThreadToFinish;
- (void) startVoiceRecognitionThreadAutoreleasePoolWithArray:(NSArray *)arrayOfLanguageModelItems; // This is the autorelease pool in which the actual business of our loop is handled.

// Suspend and resume that is initiated by Flite. Do not call these directly.
- (void) suspendRecognitionForFliteSpeech;
- (void) resumeRecognitionForFliteSpeech;

- (Float32) pocketsphinxInputLevel; // This gives the input metering levels. This can only be run in a background thread that you create, otherwise it will block recognition

@property (nonatomic, retain) NSThread *voiceRecognitionThread; // The loop would lock if run on the main thread so it has a background thread in which it always runs.
@property (nonatomic, retain) ContinuousModel *continuousModel; // The continuous model is the actual recognition loop.
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver; // We use an OpenEarsEventsObserver here to get important information from other objects which may be instantiated.
@end
