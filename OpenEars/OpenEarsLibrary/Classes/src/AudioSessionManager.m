//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  AudioSessionManager.m
//  OpenEars
//
//  AudioSessionManager is a class for initializing the Audio Session and forwarding changes in the Audio
//  Session to the OpenEarsEventsObserver class so they can be reacted to when necessary.
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

#import "AudioSessionManager.h"
@implementation AudioSessionManager

void audioSessionInterruptionListener(void *inClientData,
									  UInt32 inInterruptionState) { // Listen for interruptions to the Audio Session.
	
	
	// It's important on the iPhone to have the ability to react to an interruption in app audio such as an incoming or user-initiated phone call.
	// For Pocketsphinx it might be necessary to restart the recognition loop afterwards, or the app's UI might need to be reset or redrawn. 
	// By observing for the AudioSessionInterruptionDidBegin and AudioQueueInterruptionEnded NSNotifications and forwarding them to OpenEarsEventsObserver,
	// the developer using OpenEars can react to an interruption.
	 
	if (inInterruptionState == kAudioSessionBeginInterruption) { // There was an interruption.

		
		OpenEarsLog("The Audio Session was interrupted.");
		NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:@"AudioSessionInterruptionDidBegin" forKey:@"OpenEarsNotificationType"]; // Send notification to OpenEarsEventsObserver.
		NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
		
		
	} else if (inInterruptionState == kAudioSessionEndInterruption) { // The interruption is over.
	
		NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:@"AudioSessionInterruptionDidEnd" forKey:@"OpenEarsNotificationType"]; // Send notification to OpenEarsEventsObserver.
		NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
		OpenEarsLog("The Audio Session interruption is over.");
	}
}

void performRouteChange() {
	
	OpenEarsLog(@"Performing Audio Route change.");
	CFStringRef audioRoute;
	UInt32 size = sizeof(CFStringRef);
	OSStatus getAudioRouteError = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &audioRoute); /* Get the new route */
	
	if (getAudioRouteError != 0) {
		OpenEarsLog("Error %d: Unable to get new audio route.", (int)getAudioRouteError);
	} else {
		
		OpenEarsLog("The new audio route is %@",(NSString *)audioRoute);			
		
		NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"AudioRouteDidChangeRoute",[NSString stringWithFormat:@"%@",audioRoute],nil] forKeys:[NSArray arrayWithObjects:@"OpenEarsNotificationType",@"AudioRoute",nil]];
		NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES]; // Forward the audio route change to OpenEarsEventsObserver.
	}

}


void audioSessionPropertyListener(void *inClientData,
								  AudioSessionPropertyID inID,
								  UInt32 inDataSize,
								  const void *inData) { // We also listen to some Audio Session properties so that we can react to changes such as new audio routes (e.g. headphones plugged/unplugged).
	
	 // It may be necessary to react to changes in the audio route; for instance, if the user inserts or removes the headphone mic, 
	 // it's probably necessary to restart a continuous recognition loop in order to calibrate to the changed background levels.
	 
	
	if (inID == kAudioSessionProperty_AudioRouteChange) { // If the property change triggering the function is a change of audio route,

#ifdef OPENEARSLOGGING
		CFStringRef audioRouteOldRoute = (CFStringRef)[(NSDictionary *)inData valueForKey:CFSTR(kAudioSession_AudioRouteChangeKey_OldRoute)];
#endif		
		CFNumberRef audioRouteChangeReasonKey = (CFNumberRef)CFDictionaryGetValue((CFDictionaryRef)inData, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 audioRouteChangeReason;
		CFNumberGetValue(audioRouteChangeReasonKey, kCFNumberSInt32Type, &audioRouteChangeReason); // Get the reason for the route change.
			
		OpenEarsLog(@"Audio route has changed for the following reason:");
		
		BOOL performChange = TRUE;
		
		// We only want to perform the OpenEars full-on notification and delegate method route change for a device change or a wake from sleep. We don't want to do it for programmatic changes to the audio session or mysterious reasons.
		
		switch (audioRouteChangeReason) {
			case kAudioSessionRouteChangeReason_Unknown:
				performChange = FALSE;
				OpenEarsLog(@"Reason unknown");
				break;
			case kAudioSessionRouteChangeReason_NewDeviceAvailable:
				performChange = TRUE;
				OpenEarsLog(@"A new device has become available");
				break;	
			case kAudioSessionRouteChangeReason_OldDeviceUnavailable:
				performChange = TRUE;
				OpenEarsLog(@"An old device has become unavailable");
				break;
			case kAudioSessionRouteChangeReason_CategoryChange:
				performChange = FALSE;
				OpenEarsLog(@"There has been a change of category");
				break;	
			case kAudioSessionRouteChangeReason_Override:
				performChange = FALSE;
				OpenEarsLog(@"There has been an override to the audio session");
				break;
			case kAudioSessionRouteChangeReason_WakeFromSleep:
				performChange = TRUE;
				OpenEarsLog(@"The device has awoken from sleep");
				break;	
			case kAudioSessionRouteChangeReason_NoSuitableRouteForCategory:
				performChange = FALSE;
				OpenEarsLog(@"There is no suitable route for the category");
				break;				
			default:
				performChange = FALSE;
				OpenEarsLog(@"Unknown reason");
				break;
		}

		OpenEarsLog(@"The previous audio route was %@", (NSString *)audioRouteOldRoute);

		CFStringRef audioRoute;
		UInt32 size = sizeof(CFStringRef);
		OSStatus getAudioRouteError = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &audioRoute);
		if(getAudioRouteError) {
			OpenEarsLog(@"Error getting current audio route: %d", getAudioRouteError);	
		}
		
		if(performChange == TRUE) {
	
			OpenEarsLog(@"This is a case for performing a route change. Before the route change, the current route is %@",(NSString *)audioRoute);
			performRouteChange();
		} else {
			OpenEarsLog(@"This is not a case in which OpenEars performs a route change voluntarily. At the close of this function, the audio route is %@",(NSString *)audioRoute);
		}
		
	} else if (inID == kAudioSessionProperty_AudioInputAvailable) {
		
		 // Here we're listening and sending notifications for changes in the availability of the input device.
		 
		OpenEarsLog("There was a change in input device availability: ");
		if (inDataSize == sizeof(UInt32)) {
			UInt32 audioInputIsAvailable = *(UInt32*)inData;
			if(audioInputIsAvailable == 0) { // Input became unavailable.
				
				NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:@"AudioInputDidBecomeUnavailable" forKey:@"OpenEarsNotificationType"];
				NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
				[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES]; // Forward the input availability change to OpenEarsEventsObserver.
				OpenEarsLog("the audio input is now unavailable.");
			} else if (audioInputIsAvailable == 1) { // Input became available again.
				
				OpenEarsLog(@"the audio input is now available.");
				NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:@"AudioInputDidBecomeAvailable" forKey:@"OpenEarsNotificationType"];
				NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
				[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES]; // Forward the input availability change to OpenEarsEventsObserver.
			}
		}
	}
}


// Here is where we're initiating the audio session.  This should only happen once in an app session.  If a second attempt is made to initiate an audio session using this class, it will hopefully

- (void) startAudioSession {
		
	OSStatus audioSessionInitializationError = AudioSessionInitialize(NULL, NULL, audioSessionInterruptionListener, NULL); // Try to initialize the audio session.

	if (audioSessionInitializationError !=0 && audioSessionInitializationError != kAudioSessionAlreadyInitialized) { // There was an error and it wasn't that the audio session is already initialized.
		OpenEarsLog(@"Error %d: Unable to initialize the audio session.", (int)audioSessionInitializationError);
	} else { // If there was no error we'll set the properties of the audio session now.
		
		if (audioSessionInitializationError !=0 && audioSessionInitializationError == kAudioSessionAlreadyInitialized) {
			OpenEarsLog(@"The audio session has already been initialized but we will override its properties.");
		} else {
			OpenEarsLog(@"The audio session has never been initialized so we will do that now.");
		}
		// Projects using Pocketsphinx and Flite should use the Audio Session Category kAudioSessionCategory_PlayAndRecord.
		// Using this category routes playback to the ear speaker when the headphones aren't plugged in.
		// This isn't really appropriate for a speech recognition/tts app as far as I can see so I'm re-routing the output to the 
		// main speaker.
		
		UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord; // Set the Audio Session category to kAudioSessionCategory_PlayAndRecord.
		OSStatus audioCategoryStatus = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
		if (audioCategoryStatus != 0) {
			OpenEarsLog(@"Error %d: Unable to set audio category.", (int)audioCategoryStatus);
		}

		UInt32 bluetoothInput = 1;
		OSStatus bluetoothInputStatus = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryEnableBluetoothInput,sizeof (bluetoothInput), &bluetoothInput);
		if (bluetoothInputStatus != 0) {
			OpenEarsLog(@"Error %d: Unable to set bluetooth input.", (int)bluetoothInputStatus);
		}
		
		UInt32 overrideCategoryDefaultToSpeaker = 1; // Re-route sound output to the main speaker.
		OSStatus overrideCategoryDefaultToSpeakerError = AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (overrideCategoryDefaultToSpeaker), &overrideCategoryDefaultToSpeaker);
		if (overrideCategoryDefaultToSpeakerError != 0) {
			OpenEarsLog(@"Error %d: Unable to override the default speaker.", (int)overrideCategoryDefaultToSpeakerError);
		}

		Float32 currentPreferredBufferSize = kBufferLength;
		UInt32 sizeOfCurrentPreferredBufferSize = sizeof(currentPreferredBufferSize);
		OSStatus getCurrentPreferredBufferSizeStatus = AudioSessionGetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, &sizeOfCurrentPreferredBufferSize, &currentPreferredBufferSize);
		if(getCurrentPreferredBufferSizeStatus != noErr) {
			OpenEarsLog(@"getCurrentPreferredBufferSizeStatus is %d, currentPreferredBufferSize is %f",(int)getCurrentPreferredBufferSizeStatus, currentPreferredBufferSize);
		}

		if(!currentPreferredBufferSize || currentPreferredBufferSize != kBufferLength) {

			Float32 preferredBufferSize = kBufferLength; // apparently for best results this should be divisible by 2 so once you've found the best rate, make it even. It was previously working reliably with 1/18
			
			OSStatus preferredBufferSizeStatus = AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(preferredBufferSize), &preferredBufferSize);
			if(preferredBufferSizeStatus != noErr) {
				OpenEarsLog(@"Not able to set the preferred buffer size: %d", preferredBufferSizeStatus);
			}
		}
		
		Float64 currentPreferredSampleRate = kSamplesPerSecond;
		UInt32 sizeOfCurrentPreferredSampleRate = sizeof(currentPreferredSampleRate);
		OSStatus getCurrentPreferredSampleRateStatus = AudioSessionGetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, &sizeOfCurrentPreferredSampleRate, &currentPreferredSampleRate);
		if(getCurrentPreferredSampleRateStatus != noErr){
			OpenEarsLog(@"getCurrentPreferredSampleRateStatus is %d, currentPreferredSampleRate is %f",(int)getCurrentPreferredSampleRateStatus, currentPreferredSampleRate);
		}
		
		if(!currentPreferredSampleRate || currentPreferredSampleRate != kSamplesPerSecond) {
			Float64 preferredSampleRate = kSamplesPerSecond;
			OSStatus setPreferredHardwareSampleRate = AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, sizeof(preferredSampleRate), &preferredSampleRate);
			if(setPreferredHardwareSampleRate != noErr) {
				OpenEarsLog(@"Couldn't set preferred hardware sample rate: %d", setPreferredHardwareSampleRate);
			}
		}
		
		OSStatus setAudioSessionActiveError = AudioSessionSetActive(true);  // Finally, start the audio session.
		if (setAudioSessionActiveError != 0) {
			OpenEarsLog(@"Error %d: Unable to set the audio session active.", (int)setAudioSessionActiveError);
		}
		
		UInt32 audioInputAvailable = 0;  // Find out if there is an available audio input. We are adding these listeners after the session has started because sometimes the category change doesn't complete before adding the listeners and the category change is heard as a route change.
		UInt32 size = sizeof(audioInputAvailable);
		OSStatus audioInputAvailableError = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &audioInputAvailable);
		if (audioInputAvailableError != 0) {
			OpenEarsLog(@"Error %d: Unable to get the availability of the audio input.", (int)audioInputAvailableError);
		}
		if(audioInputAvailableError == 0 && audioInputAvailable == 0) {
			OpenEarsLog(@"There is no audio input available.");
		}
		
		OSStatus addAvailabilityListenerError = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, audioSessionPropertyListener, NULL); // Create listener for changes in the Audio Session properties.
		if (addAvailabilityListenerError != 0) {
			
			OpenEarsLog(@"Error %d: Unable to add the listener for changes in input availability.", (int)addAvailabilityListenerError);
		}
		
		OSStatus audioRouteChangeListenerError = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioSessionPropertyListener, NULL); // Create listener for changes in the audio route.
		if (audioRouteChangeListenerError != 0) {
			OpenEarsLog(@"Error %d: Unable to start audio route change listener.", (int)audioRouteChangeListenerError);
		}
		
		OpenEarsLog(@"AudioSessionManager startAudioSession has reached the end of the initialization.");
	}
	
	OpenEarsLog(@"Exiting startAudioSession.");
}
@end
