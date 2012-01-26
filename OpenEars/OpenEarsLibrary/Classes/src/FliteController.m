//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  FliteController.m
//  OpenEars
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

#import "FliteController.h"

#import "OpenEarsConfig.h"

@implementation FliteController

@synthesize audioPlayer; // The audio player used to play back the speech.
@synthesize openEarsEventsObserver; // We'll use the OpenEarsEventsObserver class to stay informed about important changes in status to other parts of OpenEars.
@synthesize speechData;
@synthesize speechInProgress;
@synthesize duration_stretch;
@synthesize target_mean;
@synthesize target_stddev;

// Conditionally add some function declarations depending on what voice the developer has chosen to use in OpenEarsVoiceConfig.h.

#ifdef cmu_us_awb8k
void unregister_cmu_us_awb8k(cst_voice *vox);
cst_voice *register_cmu_us_awb8k(const char *voxdir);
#endif

#ifdef cmu_us_rms8k
void unregister_cmu_us_rms8k(cst_voice *vox);
cst_voice *register_cmu_us_rms8k(const char *voxdir);
#endif

#ifdef cmu_us_slt8k
void unregister_cmu_us_slt8k(cst_voice *vox);
cst_voice *register_cmu_us_slt8k(const char *voxdir);
#endif

#ifdef cmu_time_awb
void unregister_cmu_time_awb(cst_voice *vox);
cst_voice *register_cmu_time_awb(const char *voxdir);
#endif

#ifdef cmu_us_awb
void unregister_cmu_us_awb(cst_voice *vox);
cst_voice *register_cmu_us_awb(const char *voxdir);
#endif

#ifdef cmu_us_kal
void unregister_cmu_us_kal(cst_voice *vox);
cst_voice *register_cmu_us_kal(const char *voxdir);
#endif

#ifdef cmu_us_kal16
void unregister_cmu_us_kal16(cst_voice *vox);
cst_voice *register_cmu_us_kal16(const char *voxdir);
#endif

#ifdef cmu_us_rms
void unregister_cmu_us_rms(cst_voice *vox);
cst_voice *register_cmu_us_rms(const char *voxdir);
#endif

#ifdef cmu_us_slt
void unregister_cmu_us_slt(cst_voice *vox);
cst_voice *register_cmu_us_slt(const char *voxdir);
#endif

#pragma mark -
#pragma mark Memory Management and Initialization


- (void)dealloc {
	[audioPlayer release];
	openEarsEventsObserver.delegate = nil; // It's always a good idea to set the OpenEarsEventsObserver delegate to nil before releasing it.
	[openEarsEventsObserver release];
	[speechData release];
    [super dealloc];
}

- (id) init {
    if (self = [super init]) {
		[self.openEarsEventsObserver setDelegate:self]; // Sign up for the OpenEarsEventsObserver delegate methods at initialization.
		speechInProgress = FALSE;
		flite_init(); // Initialize Flite so it's always ready to run.
    }
    return self;
}

#pragma mark -
#pragma mark Lazy Accessors

// Lazy accessor for the AVAudioPlayer that will play back the file recorded by Flite.
- (AVAudioPlayer *)audioPlayer {
	if (audioPlayer == nil) {
		OpenEarsLog(@"Flite audio player was nil when referenced so attempting to allocate a new audio player.");		
		NSError *dataError = nil;
		audioPlayer = [[AVAudioPlayer alloc] initWithData:self.speechData error:&dataError];
		if(dataError) {
			OpenEarsLog(@"Error while loading speech data for Flite: %@", [dataError description]);		
		} else {
			OpenEarsLog(@"Loading speech data for Flite concluded successfully.");		
		}
			
		audioPlayer.meteringEnabled = TRUE; // Enable metering so we can expose the metering function to developers.
		audioPlayer.delegate = self; // I'm not sure if I'm ultimately going to use these AVAudioPlayerDelegate methods since one of them was being a bit weird but this is on for now.
	}
	return audioPlayer;
}

// Lazy accessor for the OpenEarsEventsObserver object.
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}


#pragma mark -
#pragma mark AVAudioPlayer Delegate Methods

// I think I'm just using these for interruption notifications and error logging at the moment.

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	OpenEarsLog(@"AVAudioPlayer begin interruption called.");		
	[self interruptionRoutine:player];
}

- (void) finishPlaying {
	[NSThread sleepForTimeInterval:.15]; // This amount is basically to account for the possible latency between the AVAudioPlayer thinking it is finished and the end of sound emerging from the speaker. If it turns out that speech recognition is switching on too soon, it might need to be longer.
	self.speechInProgress = FALSE;
	[self performSelectorOnMainThread:@selector(sendResumeNotificationOnMainThread) withObject:nil waitUntilDone:NO];
	self.audioPlayer = nil;
}

/* audioPlayerEndInterruption:withFlags: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
#if defined(__MAC_10_7) || defined(__IPHONE_4_0)
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
	OpenEarsLog(@"AVAudioPlayer end interruption called.");		
	[self interruptionOverRoutine:player];
}

#else

/* audioPlayerEndInterruption: is called when the preferred method, audioPlayerEndInterruption:withFlags:, is not implemented. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	OpenEarsLog(@"AVAudioPlayer end interruption called.");		
	[self interruptionOverRoutine:player];
}
#endif

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	OpenEarsLog(@"AVAudioPlayer did finish playing with success flag of %d", flag);
	[self finishPlaying];

}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	OpenEarsLog(@"Error while decoding AVAudioPlayer: %@", [error description]);
[self finishPlaying];
}



#pragma mark -
#pragma mark Interruption Handling

// If an interruption is received or ended either via the AVAudioPlayer delegate methods or OpenEarsEventsObserver, stop playing.

- (void) interruptionRoutine:(AVAudioPlayer *)player {
	
	OpenEarsLog(@"AVAudioPlayer received an interruption");			
	
	if(player.playing == TRUE) {
		[player stop];
		self.speechInProgress = FALSE;
	}
}

- (void) interruptionOverRoutine:(AVAudioPlayer *)player {
	
	OpenEarsLog(@"AVAudioPlayer interruption ended");			
	
	
	if(player.playing == TRUE) {
		[player stop];
		self.speechInProgress = FALSE;
	}
}

#pragma mark -
#pragma mark Notification Routing

// Notify OpenEarsEventsObserver that Flite needs recognition suspended due to speech.

- (void) sendSuspendNotificationOnMainThread {
	OpenEarsLog(@"Flite sending suspend recognition notification.");		
	NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:@"FliteDidStartSpeaking" forKey:@"OpenEarsNotificationType"];
	NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
	[[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) withObject:notification afterDelay:0.0];
}

- (void) sendResumeNotificationOnMainThread {
	OpenEarsLog(@"Flite sending resume recognition notification.");		
	NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:@"FliteDidFinishSpeaking" forKey:@"OpenEarsNotificationType"];
	NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
	// need delay of length of buffer next (half a sec) since it is the last buffer-full that is being analyzed, not the next one.
	[[NSNotificationCenter defaultCenter] performSelector:@selector(postNotification:) withObject:notification afterDelay:0.5];
}

#pragma mark -
#pragma mark OpenEarsEventsObserver delegate methods

// If the developer has uncommented the USERCANINTERRUPTSPEECH define in OpenEarsConfig.h, interrupt the playback if a new hypothesis is received via OpenEarsEventsObserver.

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	OpenEarsLog(@"Flite sending interrupt speech request.");		
#ifdef USERCANINTERRUPTSPEECH
	[self interruptTalking];
#endif
}

#pragma mark -
#pragma mark View Controller Methods

// Externally-accessed method that returns the playback levels of the Flite audio file.

- (Float32) fliteOutputLevel {
	if(self.speechInProgress == TRUE) {
		[self.audioPlayer updateMeters];		
		return [self.audioPlayer averagePowerForChannel:0];
	} return 0.0;
}

- (void) interruptTalking {
	OpenEarsLog(@"Flite interrupting existing talking if necessary.");		
	/* If there is a statement being made already, let's do some cleanup */

	if(self.speechInProgress == TRUE) {
		OpenEarsLog(@"Flite speech is in progress so in order to interrupt it we are stopping playback.");		
		[self.audioPlayer stop];
	}
	
	if(self.speechInProgress == TRUE) {
		OpenEarsLog(@"Flite audio player is instantiated while trying to interrupt speech so we are setting the audio player to nil.");
		audioPlayer = nil;
	}
}

- (void) say:(NSString *)statement withVoice:(NSString *)voiceToUse {
	
	cst_voice *voice = nil; // Flite uses this to generate speech
	
	float target_mean_default = 110.0;
	float target_stddev_default = 15.0;
	float duration_stretch_default = 1.0;
	
	if([voiceToUse isEqualToString:@"cmu_us_awb8k"]) { // Use cmu_us_awb8k
#ifdef cmu_us_awb8k
		voice = register_cmu_us_awb8k(NULL);
		target_mean_default = 270.0;
		target_stddev_default = 55.0;
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif
		
	} else if([voiceToUse isEqualToString:@"cmu_us_rms8k"]) { // Use cmu_us_rms8k
#ifdef cmu_us_rms8k		
		voice = register_cmu_us_rms8k(NULL);
		target_mean_default = 186.0;
		target_stddev_default = 55.0;
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_slt8k"]) { // Use cmu_us_slt8k
#ifdef cmu_us_slt8k			
		voice = register_cmu_us_slt8k(NULL);
		target_mean_default = 270.0;
		target_stddev_default = 55.0;
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_time_awb"]) { // Use cmu_time_awb
#ifdef cmu_time_awb			
		voice = register_cmu_time_awb(NULL);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_awb"]) { // Use cmu_us_awb
#ifdef cmu_us_awb			
		voice = register_cmu_us_awb(NULL);	
		target_mean_default = 127.0;
		target_stddev_default = 15.0;
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_kal"]) { // Use cmu_us_kal
#ifdef cmu_us_kal				
		voice = register_cmu_us_kal(NULL);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_kal16"]) { // Use cmu_us_kal16
#ifdef cmu_us_kal16			
		voice = register_cmu_us_kal16(NULL);
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_rms"]) { // Use cmu_us_rms
#ifdef cmu_us_rms			
		voice = register_cmu_us_rms(NULL);	
		target_mean_default = 100.0;
		target_stddev_default = 15.0;
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_slt"]) { // Use cmu_us_slt
#ifdef cmu_us_slt		
		voice = register_cmu_us_slt(NULL);	
		target_mean_default = 170.0;
		target_stddev_default = 15.0;
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voiceToUse);
#endif		
	} else {
		OpenEarsLog(@"Error: requested voice %@ not recognized.", voiceToUse);
	}
	
	OpenEarsLog(@"I'm running flite"); 
#ifdef OPENEARSLOGGING	
	NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate]; // If logging is on, let's time the Flite processing time so the developer can see if the voice chosen is fast enough.
#endif
	const char *statementToSay = [statement UTF8String];
	
	if(target_mean > 0) {
		float actual_target_mean = flite_get_param_float(voice->features, "int_f0_target_mean", target_mean_default);
		float new_target_mean = actual_target_mean * target_mean; 
		flite_feat_set_float(voice->features,"int_f0_target_mean",new_target_mean);
		
	}
	
	if(target_stddev > 0) {
		
		float actual_target_stddev = flite_get_param_float(voice->features, "int_f0_target_stddev", target_stddev_default);
		float new_target_stddev = actual_target_stddev * target_stddev; 
		flite_feat_set_float(voice->features,"int_f0_target_stddev",new_target_stddev);
		
	}
	
	if(duration_stretch > 0) {
		
		float actual_duration_stretch = flite_get_param_float(voice->features, "duration_stretch", duration_stretch_default);
		float new_duration_stretch = actual_duration_stretch * duration_stretch; 
		flite_feat_set_float(voice->features,"duration_stretch",new_duration_stretch);
		
	}
	
	cst_wave *speechwaveform = flite_text_to_wave(statementToSay,voice);
	
	// Let's make a virtual wav file
	
	char *headerstring;
    short headershort;
    int headerint;
    int numberofbytes;
	SInt8 *wavBuffer = (SInt8 *)malloc((speechwaveform->num_samples * 2) + 8 + 16 + 12 + 8);
	
	int writeoffset = 0;
    headerstring = "RIFF";
	memcpy(wavBuffer + writeoffset,headerstring,4);
	writeoffset += 4;
	
    numberofbytes = (speechwaveform->num_samples * 2) + 8 + 16 + 12;
	memcpy(wavBuffer + writeoffset,&numberofbytes,4);
	writeoffset += 4;
	
    headerstring = "WAVE";
	memcpy(wavBuffer + writeoffset,headerstring,4);
	writeoffset += 4;

    headerstring = "fmt ";
	memcpy(wavBuffer + writeoffset,headerstring,4);
	writeoffset += 4;

    numberofbytes = 16;
	memcpy(wavBuffer + writeoffset,&numberofbytes,4);
	writeoffset += 4;
       
    headershort = 0x0001;  // Type of sample, this is for PCM
	memcpy(wavBuffer + writeoffset,&headershort,2);
	writeoffset += 2;
       
    headershort = 1; // channels
	memcpy(wavBuffer + writeoffset,&headershort,2);
	writeoffset += 2;

    headerint = speechwaveform->sample_rate;  // rate
	memcpy(wavBuffer + writeoffset,&headerint,4);
	writeoffset += 4;
	
    headerint = (speechwaveform->sample_rate * 1 * sizeof(short)); // bytes per second
	memcpy(wavBuffer + writeoffset,&headerint,4);
	writeoffset += 4;

    headershort = (1 * sizeof(short)); // block alignment
	memcpy(wavBuffer + writeoffset,&headershort,2);
	writeoffset += 2;
       
    headershort = 2 * 8; // bits per sample
	memcpy(wavBuffer + writeoffset,&headershort,2);
	writeoffset += 2;
        
    headerstring = "data";
	memcpy(wavBuffer + writeoffset,headerstring,4);
	writeoffset += 4;
    
	headerint = (speechwaveform->num_samples * 2); // bytes in the sample buffer
	memcpy(wavBuffer + writeoffset,&headerint,4);
	writeoffset += 4;

	memcpy(wavBuffer + writeoffset,speechwaveform->samples,speechwaveform->num_samples * 2);

	int overallsize = (speechwaveform->num_samples * 1 * sizeof(short)) + 8 + 16 + 12 + 8;
	NSData *data = [[NSData alloc] initWithBytes:wavBuffer length:overallsize];
	self.speechData = data;
	[data release];
	free(wavBuffer);
	delete_wave(speechwaveform);
	OpenEarsLog(@"I'm done running flite and it took %f seconds", [NSDate timeIntervalSinceReferenceDate] - start); // Deliver the timing info if logging is on.
	[self performSelectorOnMainThread:@selector(sendSuspendNotificationOnMainThread) withObject:nil waitUntilDone:NO]; // Send a suspend notification so (under some circumstances) recognition isn't on while speaking is in progress.

	[self.audioPlayer play]; // Play the sound created by Flite.
	self.speechInProgress = TRUE;

	if([voiceToUse isEqualToString:@"cmu_us_awb8k"]) { // Use cmu_us_awb8k
#ifdef cmu_us_awb8k
		unregister_cmu_us_awb8k(voice);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif
		
	} else if([voiceToUse isEqualToString:@"cmu_us_rms8k"]) { // Use cmu_us_rms8k
#ifdef cmu_us_rms8k		
		unregister_cmu_us_rms8k(voice);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_slt8k"]) { // Use cmu_us_slt8k
#ifdef cmu_us_slt8k			
		unregister_cmu_us_slt8k(voice);				
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_time_awb"]) { // Use cmu_time_awb
#ifdef cmu_time_awb			
		unregister_cmu_time_awb(voice);		
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_awb"]) { // Use cmu_us_awb
#ifdef cmu_us_awb			
		unregister_cmu_us_awb(voice);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_kal"]) { // Use cmu_us_kal
#ifdef cmu_us_kal				
		unregister_cmu_us_kal(voice);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_kal16"]) { // Use cmu_us_kal16
#ifdef cmu_us_kal16			
		unregister_cmu_us_kal16(voice);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_rms"]) { // Use cmu_us_rms
#ifdef cmu_us_rms			
		unregister_cmu_us_rms(voice);		
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else if([voiceToUse isEqualToString:@"cmu_us_slt"]) { // Use cmu_us_slt
#ifdef cmu_us_slt		
		unregister_cmu_us_slt(voice);	
#else
		OpenEarsLog(@"Error: requested voice %@ has not been enabled in OpenEarsVoiceConfig.h.", voice);
#endif		
	} else {
		OpenEarsLog(@"Error: requested voice %@ not recognized.", voice);
	}	
}


@end

