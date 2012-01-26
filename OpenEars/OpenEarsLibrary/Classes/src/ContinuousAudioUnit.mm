//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  ContinuousAudioUnit.mm
//  OpenEars
//
//  ContinuousAudioUnit is a class which handles the interaction between the Pocketsphinx continuous recognition loop and Core Audio.
//
//  This is a sphinx ad based on modifications to the Sphinxbase template file ad_base.c.
//
//  Copyright Halle Winkler 2010, 2011 excepting that which falls under the copyright of Carnegie Mellon University
//  as part of their file ad_base.c
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  Excepting that which falls under the license of Carnegie Mellon University as part of their file ad_base.c,
//  licensed under the Common Development and Distribution License (CDDL) Version 1.0
//  http://www.opensource.org/licenses/cddl1.txt or see included file license.txt
//  with the single exception to the license that you may distribute executable-only versions
//  of software using OpenEars files without making source code available under the terms of CDDL Version 1.0 
//  paragraph 3.1 if source code to your software isn't otherwise available, and without including a notice in 
//  that case that that source code is available. Exception applies exclusively to compiled binary apps such as can be
//  downloaded from the App Store, and not to frameworks or systems, to which the un-altered CDDL applies
//  unless other terms are agreed to by the copyright holder.
//
//  Header for original source file ad_base.c which I modified to create this driver is as follows:
//
/* -*- c-basic-offset: 4; indent-tabs-mode: nil -*- */
/* ====================================================================
 * Copyright (c) 1999-2001 Carnegie Mellon University.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer. 
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * This work was supported in part by funding from the Defense Advanced 
 * Research Projects Agency and the National Science Foundation of the 
 * United States of America, and the CMU Sphinx Speech Consortium.
 *
 * THIS SOFTWARE IS PROVIDED BY CARNEGIE MELLON UNIVERSITY ``AS IS'' AND 
 * ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
 * NOR ITS EMPLOYEES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ====================================================================
 *
 */

/*
 * ad.c -- Wraps a "sphinx-II standard" audio interface around the basic audio
 * 		utilities.
 *
 * HISTORY
 * 
 * 11-Jun-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University.
 * 		Modified to conform to new A/D API.
 * 
 * 12-May-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University.
 * 		Dummy template created.
 */


#if defined TARGET_IPHONE_SIMULATOR && TARGET_IPHONE_SIMULATOR // This is the driver for the simulator only, since the low-latency audio unit driver doesn't work with the simulator at all.
#import "AudioQueueFallback.h"

#else

#import "ContinuousAudioUnit.h"

static pocketsphinxAudioDevice *audioDriver;

#pragma mark -
#pragma mark Audio Unit Callback
static OSStatus	AudioUnitRenderCallback (void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
	
	if (inNumberFrames > 0) {

		OSStatus renderStatus = AudioUnitRender(audioDriver->audioUnit, ioActionFlags, inTimeStamp,1, inNumberFrames, ioData);
		
		if(renderStatus != noErr) {
			switch (renderStatus) {
				case kAudioUnitErr_InvalidProperty:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_InvalidProperty");
					break;
				case kAudioUnitErr_InvalidParameter:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_InvalidParameter");
					break;
				case kAudioUnitErr_InvalidElement:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_InvalidElement");
					break;
				case kAudioUnitErr_NoConnection:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_NoConnection");
					break;
				case kAudioUnitErr_FailedInitialization:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_FailedInitialization");
					break;
				case kAudioUnitErr_TooManyFramesToProcess:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_TooManyFramesToProcess");
					break;
				case kAudioUnitErr_InvalidFile:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_InvalidFile");
					break;
				case kAudioUnitErr_FormatNotSupported:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_FormatNotSupported");
					break;
				case kAudioUnitErr_Uninitialized:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_Uninitialized");
					break;
				case kAudioUnitErr_InvalidScope:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_InvalidScope");
					break;
				case kAudioUnitErr_PropertyNotWritable:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_PropertyNotWritable");
					break;
				case kAudioUnitErr_CannotDoInCurrentContext:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_CannotDoInCurrentContext");
					break;
				case kAudioUnitErr_InvalidPropertyValue:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_InvalidPropertyValue");
					break;
				case kAudioUnitErr_PropertyNotInUse:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_PropertyNotInUse");
					break;
				case kAudioUnitErr_InvalidOfflineRender:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_InvalidOfflineRender");
					break;
				case kAudioUnitErr_Unauthorized:
					OpenEarsLog(@"Audio Unit render error: kAudioUnitErr_Unauthorized");
					break;
				case -50:
					OpenEarsLog(@"Audio Unit render error: error in user parameter list (-50)");
					break;														
				default:
					OpenEarsLog(@"Audio Unit render error %d: unknown error", (int)renderStatus);
					break;
			}
			
			return renderStatus;
			
		} else { // if the render was successful,
			
			
			if (inNumberFrames > 0 && (audioDriver->recordData == 1 && audioDriver->recognitionIsInProgress == 1) && audioDriver->endingLoop == FALSE) {
				
				// let's only do the following when we aren't calibrating for now
				
				if(audioDriver->calibrating == FALSE) {
					
					
					SInt16 chunkToWriteTo;
					// Increment indexOfLastWrittenChunk unless it is equal to numberofchunks in which case loop around and set it to zero. 
					// Then use lastchunkwritten as the indicator of what chunk to do stuff to.
					
					if(audioDriver->indexOfLastWrittenChunk == kNumberOfChunksInRingbuffer-1) { // If we're on the last index, loop around to zero.
						chunkToWriteTo = 0;
					} else { // Otherwise increment indexOfLastWrittenChunk.
						chunkToWriteTo = audioDriver->indexOfLastWrittenChunk+1;
					}
					
					// First of all we'll need to add some extra samples if there are any waiting for us.
					if(audioDriver->extraSamples == TRUE) {
						audioDriver->extraSamples = FALSE;
						// add the extra samples from the buffer
						memcpy((SInt16 *)audioDriver->ringBuffer[chunkToWriteTo].buffer,(SInt16 *)audioDriver->extraSampleBuffer,audioDriver->numberOfExtraSamples*2); // Copy this unit's samples into the ringbuffer
						
						memcpy((SInt16 *)audioDriver->ringBuffer[chunkToWriteTo].buffer + audioDriver->numberOfExtraSamples,(SInt16 *)ioData->mBuffers[0].mData,inNumberFrames*2); // Copy this unit's samples into the ringbuffer
						
						audioDriver->ringBuffer[chunkToWriteTo].numberOfSamples = inNumberFrames + audioDriver->numberOfExtraSamples; // set this ringbuffer chunk's numberOfSamples to the unit's inNumberFrames.
						
						audioDriver->ringBuffer[chunkToWriteTo].writtenTimestamp = CFAbsoluteTimeGetCurrent(); // Timestamp when we wrote this so the read function can decide if it's read this chunk already or not.
						
					} else {
						memcpy(audioDriver->ringBuffer[chunkToWriteTo].buffer,(SInt16 *)ioData->mBuffers[0].mData,inNumberFrames*2); // Copy this unit's samples into the ringbuffer
						
						audioDriver->ringBuffer[chunkToWriteTo].numberOfSamples = inNumberFrames; // set this ringbuffer chunk's numberOfSamples to the unit's inNumberFrames.
						
						audioDriver->ringBuffer[chunkToWriteTo].writtenTimestamp = CFAbsoluteTimeGetCurrent(); // Timestamp when we wrote this so the read function can decide if it's read this chunk already or not.
						
					}
					
					if(audioDriver->indexOfLastWrittenChunk == kNumberOfChunksInRingbuffer-1) { // If we're on the last index, loop around to zero.
						audioDriver->indexOfLastWrittenChunk = 0;
					} else { // Otherwise increment indexOfLastWrittenChunk.
						audioDriver->indexOfLastWrittenChunk++;
					}

					SInt16 *samples = (SInt16 *)ioData->mBuffers[0].mData;
					getDecibels(samples,inNumberFrames); // Get the decibels
					
					// That's it.
					
					
				} else { 
					
					if(audioDriver->roundsOfCalibration == 0 || audioDriver->roundsOfCalibration == 1) {
						// Ignore the first couple of buffers, they are sometimes full of null input.
						audioDriver->roundsOfCalibration++;
					} else {
						
						SInt16 *calibrationSamples = (SInt16 *)(ioData->mBuffers[0].mData);
						
						int i;
						for ( i = 0; i < inNumberFrames; i++ ) {  //So when we get here, we loop through the frames and write the samples there to the calibration buffer starting at the last end index we stopped at
							audioDriver->calibrationBuffer[i + audioDriver->availableSamplesDuringCalibration] = calibrationSamples[i];
						}
						audioDriver->availableSamplesDuringCalibration = audioDriver->availableSamplesDuringCalibration + inNumberFrames;
					}
				}
			}
			
			memset(ioData->mBuffers[0].mData, 0, ioData->mBuffers[0].mDataByteSize); // write out silence to the buffer for no-playback times
		}
		
	}
	
	return 0;
}

void getDecibels(SInt16 * samples, UInt32 inNumberFrames) {
	
	Float32 decibels = kDBOffset; // When we have no signal we'll leave this on the lowest setting
	Float32 currentFilteredValueOfSampleAmplitude; 
	Float32 previousFilteredValueOfSampleAmplitude = 0.0; // We'll need these in the low-pass filter
	Float32 peakValue = kDBOffset; // We'll end up storing the peak value here
	
	for (int i=0; i < inNumberFrames; i=i+10) { // We're incrementing this by 10 because there's actually too much info here for us for a conventional UI timeslice and it's a cheap way to save CPU
		
		Float32 absoluteValueOfSampleAmplitude = abs(samples[i]); //Step 2: for each sample, get its amplitude's absolute value.
		
		// Step 3: for each sample's absolute value, run it through a simple low-pass filter
		// Begin low-pass filter
		currentFilteredValueOfSampleAmplitude = kLowPassFilterTimeSlice * absoluteValueOfSampleAmplitude + (1.0 - kLowPassFilterTimeSlice) * previousFilteredValueOfSampleAmplitude;
		previousFilteredValueOfSampleAmplitude = currentFilteredValueOfSampleAmplitude;
		Float32 amplitudeToConvertToDB = currentFilteredValueOfSampleAmplitude;
		// End low-pass filter
		
		Float32 sampleDB = 20.0*log10(amplitudeToConvertToDB) + kDBOffset;
		// Step 4: for each sample's filtered absolute value, convert it into decibels
		// Step 5: for each sample's filtered absolute value in decibels, add an offset value that normalizes the clipping point of the device to zero.
		
		if((sampleDB == sampleDB) && (sampleDB <= DBL_MAX && sampleDB >= -DBL_MAX)) { // if it's a rational number and isn't infinite
			
			if(sampleDB > peakValue) peakValue = sampleDB; // Step 6: keep the highest value you find.
			decibels = peakValue; // final value
		}
	}
	audioDriver->pocketsphinxDecibelLevel = decibels;
}

void setRoute() {
	CFStringRef audioRoute;
	UInt32 audioRouteSize = sizeof(CFStringRef);
	OSStatus getAudioRouteStatus = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &audioRouteSize, &audioRoute); // Get the audio route.
	if (getAudioRouteStatus != 0) {
		OpenEarsLog(@"Error %d: Unable to get the audio route.", (int)getAudioRouteStatus);
	} else {
		OpenEarsLog(@"Set audio route to %@", (NSString *)audioRoute);	
	}
	
	audioDriver->currentRoute = audioRoute; // Set currentRoute to the audio route.
}

#pragma mark -
#pragma mark Pocketsphinx driver functionality

pocketsphinxAudioDevice *openAudioDevice(const char *dev, int32 samples_per_sec) {
	
	OpenEarsLog(@"Starting openAudioDevice on the device.");
					
	if(audioDriver != NULL) { // Audio unit wrapper has already been created
		closeAudioDevice(audioDriver);
	}
	
	if ((audioDriver = (pocketsphinxAudioDevice *) calloc(1, sizeof(pocketsphinxAudioDevice))) == NULL) {
		OpenEarsLog(@"There was an error while creating the device, returning null device.");
		return NULL;
	} else {
		OpenEarsLog(@"Audio unit wrapper successfully created.");
	}
	
	audioDriver->audioUnitIsRunning = 0;
	audioDriver->recording = 0;
	audioDriver->sps = kSamplesPerSecond;
	audioDriver->bps = 2;
	audioDriver->pocketsphinxDecibelLevel = 0.0;

	AURenderCallbackStruct inputProc;
	inputProc.inputProc = AudioUnitRenderCallback;
	inputProc.inputProcRefCon = audioDriver;
	
	AudioComponentDescription auDescription;
	
	auDescription.componentType = kAudioUnitType_Output;
	auDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	auDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	auDescription.componentFlags = 0;
	auDescription.componentFlagsMask = 0;
	
	AudioComponent component = AudioComponentFindNext(NULL, &auDescription);
	
	OSStatus newAudioUnitComponentInstanceStatus = AudioComponentInstanceNew(component, &audioDriver->audioUnit);
	if(newAudioUnitComponentInstanceStatus != noErr) {
		OpenEarsLog(@"Couldn't get new audio unit component instance: %d",newAudioUnitComponentInstanceStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}

	UInt32 maximumFrames = 4096;
	OSStatus maxFramesStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maximumFrames, sizeof(maximumFrames));
	if(maxFramesStatus != noErr) {
		OpenEarsLog(@"Error %d: unable to set maximum frames property.", (int)maxFramesStatus);
	}
	
	UInt32 enableIO = 1;
	
	OSStatus setEnableIOStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &enableIO, sizeof(enableIO));
	if(setEnableIOStatus != noErr) {
		OpenEarsLog(@"Couldn't enable IO: %d",setEnableIOStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	OSStatus setRenderCallbackStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &inputProc, sizeof(inputProc));
	if(setRenderCallbackStatus != noErr) {
		OpenEarsLog(@"Couldn't set render callback: %d",setRenderCallbackStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	audioDriver->thruFormat.mChannelsPerFrame = 1; 
	audioDriver->thruFormat.mSampleRate = kSamplesPerSecond; 
	audioDriver->thruFormat.mFormatID = kAudioFormatLinearPCM;
	audioDriver->thruFormat.mBytesPerPacket = audioDriver->thruFormat.mChannelsPerFrame * audioDriver->bps;
	audioDriver->thruFormat.mFramesPerPacket = 1;
	audioDriver->thruFormat.mBytesPerFrame = audioDriver->thruFormat.mBytesPerPacket;
	audioDriver->thruFormat.mBitsPerChannel = 16; 
	audioDriver->thruFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
	
	OSStatus setInputFormatStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &audioDriver->thruFormat, sizeof(audioDriver->thruFormat));
	if(setInputFormatStatus != noErr) {
		OpenEarsLog(@"Couldn't set stream input format: %d",setInputFormatStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	OSStatus setOutputFormatStatus = AudioUnitSetProperty(audioDriver->audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &audioDriver->thruFormat, sizeof(audioDriver->thruFormat));
	if(setOutputFormatStatus != noErr) {
		OpenEarsLog(@"Couldn't set stream output format: %d",setOutputFormatStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	OSStatus audioUnitInitializeStatus = AudioUnitInitialize(audioDriver->audioUnit);
	if(audioUnitInitializeStatus != noErr) {
		
		OpenEarsLog(@"Couldn't initialize audio unit: %d", audioUnitInitializeStatus);
		audioDriver->unitIsRunning = 0;
		return NULL;
	}
	
	audioDriver->unitIsRunning = 1;			
	audioDriver->deviceIsOpen = 1;
	
	setRoute();
	
    return audioDriver;
}

int32 startRecording(pocketsphinxAudioDevice * audioDevice) {
	
	if (audioDriver->recording == 1) {
		OpenEarsLog(@"This driver is already recording, returning.");
        return -1;
	}
	
	OpenEarsLog(@"Setting the variables for the device and starting it.");
	
	audioDriver->roundsOfCalibration = 0;
	audioDriver->endingLoop = FALSE;
	
	audioDriver->extraSamples = FALSE;
	audioDriver->numberOfExtraSamples = 0;
	
	if(audioDriver->extraSampleBuffer == NULL) {
		audioDriver->extraSampleBuffer = (SInt16 *)malloc(kExtraSampleBufferSize);		
	} else {
		audioDriver->extraSampleBuffer = (SInt16 *)realloc(audioDriver->extraSampleBuffer, kExtraSampleBufferSize); // ~16000 is the probable number coming in, x4 for safety and device independence.		
	}

	OpenEarsLog(@"Looping through ringbuffer sections and pre-allocating them.");

	int i;
	for ( i = 0; i < kNumberOfChunksInRingbuffer; i++ ) { // malloc each individual buffer in the ringbuffer in advance to an overall size with some wiggle room.
		
		if(audioDriver->ringBuffer[i].buffer == NULL) {
			audioDriver->ringBuffer[i].buffer = (SInt16 *)malloc(kChunkSizeInBytes);
		} else {
			audioDriver->ringBuffer[i].buffer = (SInt16 *)realloc(audioDriver->ringBuffer[i].buffer, kChunkSizeInBytes);
		}

		audioDriver->ringBuffer[i].numberOfSamples = 0;
		audioDriver->ringBuffer[i].writtenTimestamp = CFAbsoluteTimeGetCurrent();
	}
	
	int j;
	for ( j = 0; j < kNumberOfChunksInRingbuffer; j++ ) { // set the consumed time stamps to now.
		audioDriver->consumedTimeStamp[j] = CFAbsoluteTimeGetCurrent();
	}
	
	audioDriver->indexOfLastWrittenChunk = kNumberOfChunksInRingbuffer-1;
	audioDriver->indexOfChunkToRead = 0;
	
	audioDriver->calibrating = 0;

	
	OSStatus startAudioUnitOutputStatus = AudioOutputUnitStart(audioDriver->audioUnit);
	if(startAudioUnitOutputStatus != noErr) {
		OpenEarsLog(@"Couldn't start audio unit output: %d", startAudioUnitOutputStatus);	
		return -1;
	} else {
		OpenEarsLog(@"Started audio output unit.");		
	}

	audioDriver->audioUnitIsRunning = 1; // Set audioUnitIsRunning to true.
	
	audioDriver->recording = 1;
	
    return 0;
}

int32 stopRecording(pocketsphinxAudioDevice * audioDevice) {
	
	if (audioDriver->recording == 0) {
		OpenEarsLog(@"Can't stop audio device because it isn't currently recording, returning instead.");	
		return -1; // bail if this ad doesn't think it's recording
	}
	
	if(audioDriver->audioUnitIsRunning == 1) { // only stop recording if there is actually a unit
		OpenEarsLog(@"Stopping audio unit.");	

		OSStatus stopAudioUnitStatus = AudioOutputUnitStop(audioDriver->audioUnit);
		if(stopAudioUnitStatus != noErr) {
			OpenEarsLog(@"Couldn't stop audio unit: %d", stopAudioUnitStatus);
			return -1;
		} else {
			OpenEarsLog(@"Audio Output Unit stopped, cleaning up variable states.");	
		}
		
	} else {
		OpenEarsLog(@"Cleaning up driver variable states.");	
	}

	audioDriver->extraSamples = FALSE;
	audioDriver->numberOfExtraSamples = 0;
	audioDriver->endingLoop = FALSE;
	audioDriver->calibrating = 0;
	audioDriver->recording = 0;
	
    return 0;
}

Float32 pocketsphinxAudioDeviceMeteringLevel(pocketsphinxAudioDevice * audioDriver) { // Function which returns the metering level of the AudioUnit input.

	if(audioDriver != NULL && audioDriver->pocketsphinxDecibelLevel && audioDriver->pocketsphinxDecibelLevel > -161 && audioDriver->pocketsphinxDecibelLevel < 1) {
		return audioDriver->pocketsphinxDecibelLevel;
	}
	return 0.0;	
}

int32 closeAudioDevice(pocketsphinxAudioDevice * audioDevice) {
	

	
	if (audioDriver->recording == 1) {
		OpenEarsLog(@"This device is recording, so we will first stop it");
		stopRecording(audioDriver);
		audioDriver->recording = 0;

	} else {
		OpenEarsLog(@"This device is not recording, so first we will set its recording status to 0");
		audioDriver->recording = 0;
	}

	if(audioDriver->audioUnitIsRunning == 1) {
		OpenEarsLog(@"The audio unit is running so we are going to dispose of its instance");		
		OSStatus instanceDisposeStatus = AudioComponentInstanceDispose(audioDriver->audioUnit);
		
		if(instanceDisposeStatus != noErr) {
			OpenEarsLog(@"Couldn't dispose of audio unit instance: %d", instanceDisposeStatus);
			return -1;
		}

		audioDriver->audioUnit = nil;
	}
	
	if(audioDriver->extraSampleBuffer != NULL) {
		free(audioDriver->extraSampleBuffer); // Let's free the extra sample buffer now.
		audioDriver->extraSampleBuffer = NULL;
	}
		
	int i;
	for ( i = 0; i < kNumberOfChunksInRingbuffer; i++ ) { // free each individual chunk in the ringbuffer
		if(audioDriver->ringBuffer[i].buffer != NULL) {
			free(audioDriver->ringBuffer[i].buffer);
			audioDriver->ringBuffer[i].buffer = NULL;
		}
	}
	
	if(audioDriver != NULL) {
		audioDriver->deviceIsOpen = 0;	
		free(audioDriver); 	// Finally, free the Sphinx audio device.
		audioDriver = NULL;
	}
	
    return 0;
}

int32 readBufferContents(pocketsphinxAudioDevice * audioDevice, int16 * buffer, int32 maximum) { // Scan the buffer for speech.
	
	// Only read if we're recording.
	
	if(audioDevice->recording == 0) {
		return -1;
	}
	
	// let's only do the following when we aren't calibrating
	
	if(audioDriver->calibrating == FALSE) {
		
		// So, we have a ringbuffer that may or may not have fresh data for us to read.
		// We want to start out with the first read at chunk zero and sample zero, so this has to be set in StartRecording().
		// We will know if there is nothing there yet to read if chunk index zero has a read datestamp that is fresher than its written datestamp. If that happens it should return zero samples.
		// If that doesn't happen it should read the contents of the chunk for the full reported number of its samples (or max, whichever is smaller) and return the number of samples or max, datestamp the chunk 
		// and then increment the current chunk index.  SIMPLES!
		
		// For the current chunk, compare its timestamp to the timestamp of that chunk index in the ringbuffer and see which is fresher:
		
		if(audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].writtenTimestamp>=audioDriver->consumedTimeStamp[audioDriver->indexOfChunkToRead]) { // If this chunk was written to more recently than it was read, it can be read.
			
			// What we're gonna do:
			// Read the whole chunk, return its number of samples, timestamp the index for this chunk.	
			// Put the total number of samples or max, whichever is smaller, in the pointer to the buffer which is an argument of this function.
			// Return the number of samples we put in there or maximum
			// Put the read timestamp in the index of chunk read timestamps.
			// increment indexOfChunkToRead or if it is on the last index, loop it around to zero.
			
			
			
			// OK, if max is bigger than the number of samples in the chunk, set max to the number of samples in the chunk:
			
			if(maximum >= audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples) {
				maximum = audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples;
			} else {
				// Put the rest into the extras buffer
				
				SInt16 numberOfUncopiedSamples = audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples - maximum;
				UInt32 startingSampleIndexForExtraSamples = maximum;
				audioDriver->extraSamples = TRUE;
				audioDriver->numberOfExtraSamples = numberOfUncopiedSamples;				
				memcpy((SInt16 *)audioDriver->extraSampleBuffer, (SInt16 *)audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].buffer + startingSampleIndexForExtraSamples, audioDriver->numberOfExtraSamples * 2);
			}
			
			memcpy(buffer,audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].buffer, maximum * 2); // memcpy copies bytes, so this needs to be max times 2 which is how many bytes are in one of our samples
			
			audioDriver->consumedTimeStamp[audioDriver->indexOfChunkToRead] = CFAbsoluteTimeGetCurrent(); // Timestamp to the current time.
			
			if(audioDriver->indexOfChunkToRead == kNumberOfChunksInRingbuffer - 1) { // If this is the last chunk index, loop around to zero.
				audioDriver->indexOfChunkToRead = 0;
			} else { // Otherwise increment the index of the chunk to read.
				audioDriver->indexOfChunkToRead++;
			}
			
	
			return maximum; // Return max and that's actually it.
			
		} else { // if it was read more recently than it was written to, return 0.
			
			return 0;
		}
		
	} else {
		
		int j;	// next, read the samples starting from the point of already read and going to 256 more, then return 256
		for ( j = 0; j < 256; j++ ) { // until 256 packets have been copied,
			buffer[j] = audioDriver->calibrationBuffer[j + audioDriver->samplesReadDuringCalibration];
		}
		
		audioDriver->samplesReadDuringCalibration = audioDriver->samplesReadDuringCalibration + 256; // next, increase samplesReadDuringCalibration by the amount read
		
		maximum = 256; // set max to 256
		
	
		return maximum;
		
	}
	
	return 0;
}

#endif