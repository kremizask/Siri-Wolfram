//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  FliteController.h
//  OpenEars
//
//  FliteController is a class which manages text-to-speech
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

#import <AVFoundation/AVFoundation.h>
#import "flite.h"
#import "OpenEarsEventsObserver.h"
#import "AudioConstants.h"

@interface FliteController : NSObject <AVAudioPlayerDelegate, OpenEarsEventsObserverDelegate> {

	AVAudioPlayer *audioPlayer; // Plays back the speech
	OpenEarsEventsObserver *openEarsEventsObserver; // Observe status changes from audio sessions and Pocketsphinx
	NSData *speechData;
	BOOL speechInProgress;
	float duration_stretch;
	float target_mean;
	float target_stddev;
}

// These are the only methods to be called directly by an OpenEars project
- (void) say:(NSString *)statement withVoice:(NSString *)voice;
- (Float32) fliteOutputLevel;
// End methods to be called directly by an OpenEars project

// Interruption handling
- (void) interruptionRoutine:(AVAudioPlayer *)player;
- (void) interruptionOverRoutine:(AVAudioPlayer *)player;

// Handling not doing voice recognition on Flite speech, do not directly call
- (void) sendResumeNotificationOnMainThread;
- (void) sendSuspendNotificationOnMainThread;
- (void) interruptTalking;
@property (nonatomic, assign) BOOL speechInProgress;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;  // Plays back the speech
@property (nonatomic, retain) OpenEarsEventsObserver *openEarsEventsObserver; // Observe status changes from audio sessions and Pocketsphinx
@property (nonatomic, retain) NSData *speechData;
@property (nonatomic, assign) float duration_stretch;
@property (nonatomic, assign) float target_mean;
@property (nonatomic, assign) float target_stddev;

@end





