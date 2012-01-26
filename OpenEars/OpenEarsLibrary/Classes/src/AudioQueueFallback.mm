//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  AudioQueueFallback.mm
//  OpenEars
//
//  AudioQueueFallback is a class which simulates speech recognition on the Simulator since the low-latency audio unit driver doesn't work on the Simulator. 
//  Please do not ever make a bug report about this driver; it is only here as a convenience for you so that you can test recognition logic in the Simulator,
//  but it is not the supported driver for OpenEars and using it gives you no information about the performance or behavior of the actual OpenEars audio driver.
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

#if defined TARGET_IPHONE_SIMULATOR && TARGET_IPHONE_SIMULATOR

#import "AudioQueueFallback.h"
#import "ContinuousAudioUnit.h"
#import "AudioConstants.h"

#define kPredictedSizeOfRenderFramesPerCallbackRoundAudioQueue 8092 * 10

static pocketsphinxAudioDevice *audioDriver; // The struct that contains all of the Audio Queue- and Pocketsphinx-required elements.

#pragma mark -
#pragma mark Audio Queue functions

void AudioQueueInputBufferCallback(void *inUserData,
								   AudioQueueRef inAudioQueue,
								   AudioQueueBufferRef inBuffer,
								   const AudioTimeStamp *inStartTime,
								   UInt32 inNumberOfPackets,
								   const AudioStreamPacketDescription *inPacketDescription) { // This is the buffer callback for the AudioQueue.
	
	// If there are packets, we can write them to the record file here if recognition isn't suspended and speech isn't in progress.
	
	if (inNumberOfPackets > 0 && (audioDriver->recordData == 1 && audioDriver->recognitionIsInProgress == 1) && audioDriver->endingLoop == FALSE) {
		
		// let's only do the following when we aren't calibrating for now
		
		if(audioDriver->calibrating == FALSE) {
			
			SInt16 chunkToWriteTo;
			// Increment indexOfLastWrittenChunk unless it is equal to numberofchunks in which case loop around and set it to zero. 
			// Then use lastchunkwritten as the indicator of what chunk to do stuff to.
			
			if(audioDriver->indexOfLastWrittenChunk == kNumberOfChunksInRingbufferAudioQueue-1) { // If we're on the last index, loop around to zero.
				chunkToWriteTo = 0;
			} else { // Otherwise increment indexOfLastWrittenChunk.
				chunkToWriteTo = audioDriver->indexOfLastWrittenChunk+1;
			}
			
			// First of all we'll need to add some extra samples if there are any waiting for us.
			if(audioDriver->extraSamples == TRUE) {
				audioDriver->extraSamples = FALSE;
				// add the extra samples from the buffer
				memcpy((SInt16 *)audioDriver->ringBuffer[chunkToWriteTo].buffer,(SInt16 *)audioDriver->extraSampleBuffer,audioDriver->numberOfExtraSamples*2); // Copy this queue's samples into the ringbuffer
				
				memcpy((SInt16 *)audioDriver->ringBuffer[chunkToWriteTo].buffer + audioDriver->numberOfExtraSamples,(SInt16 *)inBuffer->mAudioData,inNumberOfPackets*2); // Copy this queue's samples into the ringbuffer
				
				audioDriver->ringBuffer[chunkToWriteTo].numberOfSamples = inNumberOfPackets + audioDriver->numberOfExtraSamples; // set this ringbuffer chunk's numberOfSamples to the queue's inNumberOfPackets.
				
				audioDriver->ringBuffer[chunkToWriteTo].writtenTimestamp = CFAbsoluteTimeGetCurrent(); // Timestamp when we wrote this so the read function can decide if it's read this chunk already or not.
				
			} else {
				memcpy(audioDriver->ringBuffer[chunkToWriteTo].buffer,(SInt16 *)inBuffer->mAudioData,inNumberOfPackets*2); // Copy this queue's samples into the ringbuffer
				
				audioDriver->ringBuffer[chunkToWriteTo].numberOfSamples = inNumberOfPackets; // set this ringbuffer chunk's numberOfSamples to the queue's inNumberOfPackets.
				
				audioDriver->ringBuffer[chunkToWriteTo].writtenTimestamp = CFAbsoluteTimeGetCurrent(); // Timestamp when we wrote this so the read function can decide if it's read this chunk already or not.
				
			}
			
			if(audioDriver->indexOfLastWrittenChunk == kNumberOfChunksInRingbufferAudioQueue-1) { // If we're on the last index, loop around to zero.
				audioDriver->indexOfLastWrittenChunk = 0;
			} else { // Otherwise increment indexOfLastWrittenChunk.
				audioDriver->indexOfLastWrittenChunk++;
			}
			
			// That's it.
			
		} else { // for now, we're still using the audio file when we're calibrating.
			
			if(audioDriver->roundsOfCalibration == 0 || audioDriver->roundsOfCalibration == 1) {
				// Ignore the first couple of buffers, they are sometimes full of null input.
				audioDriver->roundsOfCalibration++;
			} else {
				
				SInt16 *calibrationSamples = (SInt16 *)inBuffer->mAudioData;
				
				int i;
				for ( i = 0; i < inNumberOfPackets; i++ ) {  //So when we get here, we loop through the frames and write the samples there to the calibration buffer starting at the last end index we stopped at
					audioDriver->calibrationBuffer[i + audioDriver->availableSamplesDuringCalibration] = calibrationSamples[i];
				}
				audioDriver->availableSamplesDuringCalibration = audioDriver->availableSamplesDuringCalibration + inNumberOfPackets;
			}
			
		}
	}
	
	// If we're still working, re-enqueue the buffer so it is refilled.
	if (audioDriver->audioQueueIsRunning == 1) {
		OSStatus enqueueBufferError =AudioQueueEnqueueBuffer(inAudioQueue, inBuffer, 0, NULL);
		if(enqueueBufferError != 0) {
#ifdef OPENEARSLOGGING			
			printf("Error %d: Unable to enqueue buffer.\n", (int)enqueueBufferError);
#endif			
		}
	}
}

Float32 pocketsphinxAudioDeviceMeteringLevel(pocketsphinxAudioDevice * audioDriver) { // Function which returns the metering level of the AudioQueue input.
	if(audioDriver && audioDriver->levelMeterState && audioDriver->recording == 1) {
		UInt32 data_sz = sizeof(AudioQueueLevelMeterState) * audioDriver->audioQueueRecordFormat.mChannelsPerFrame;
		OSErr status = AudioQueueGetProperty(audioDriver->audioQueue, kAudioQueueProperty_CurrentLevelMeterDB, audioDriver->levelMeterState, &data_sz);
		if (status != 0) {
#ifdef OPENEARSLOGGING			
			printf("Error %d: Unable to get metering.\n", (int)status);
#endif	
			return 0.0;
		}
		return audioDriver->levelMeterState->mAveragePower;	
	} else {
		return 0.0;	
	}
}

#pragma mark -
#pragma mark Continuous recognition audio driver functions

pocketsphinxAudioDevice *openAudioDevice (const char *audioDevice, SInt32 samplesPerSecond) { // Function to open the "audio device" or in this case instantiate a new Audio Queue.
	OpenEarsLog(@"Starting openAudioDevice on the simulator. This Simulator-compatible audio driver is only provided to you as a convenience so you can use the Simulator to test recognition logic, however, its audio driver is not supported and bug reports for it will be circular-filed.");
    if ((audioDriver = (pocketsphinxAudioDevice *) calloc(1, sizeof(pocketsphinxAudioDevice))) == NULL) {
        return NULL;
	}
	
	// Set the initial values for the device.
	audioDriver->audioQueueIsRunning = 0;
	audioDriver->recordPacket = 0;
	audioDriver->recording = 0;
	audioDriver->sps = 16000;
    audioDriver->bps = 2;
	
	CFStringRef audioRoute;
	UInt32 audioRouteSize = sizeof(CFStringRef);
	OSStatus getAudioRouteError = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &audioRouteSize, &audioRoute); // Get the audio route.
	if (getAudioRouteError != 0) {
#ifdef OPENEARSLOGGING			
		printf("Error %d: Unable to get the audio route.\n", (int)getAudioRouteError);
#endif
	}
	
	audioDriver->currentRoute = audioRoute; // Set currentRoute to the audio route.
	
    return audioDriver;	
}

SInt32 startRecordingWithLeader(pocketsphinxAudioDevice * audioDevice) { // An optional function that starts Audio Queue recording after a second and a half so that calibration can happen with full buffers.
	
	// This may be necessary to use for the first startRecording of a continuous loop when the background levels are calibrated
	// instead of startRecording. IME it resulted in a faster calibration since the buffers were full when calibration began. It
	// shouldn't be used for any of the later calls to startRecording in a continuous recognition loop, though, since
	// it will just add time to the process without any upside.
	
	
	startRecording(audioDevice);
	
	[NSThread sleepForTimeInterval:1.5]; // Sleep for the length of all three buffers.
	
    return 0;
}

SInt32 startRecording(pocketsphinxAudioDevice * audioDevice) { // Tell the Audio Queue to start recording.
	
	if (audioDriver->recording == 1) { // Don't start recording if we're already recording.
        return -1;
	}
	
	// Set the name of the file and set the record packet to zero.
	
	//audioDriver->recordFileName = CFStringCreateCopy(kCFAllocatorDefault, CFSTR("sphinx_record_file.wav"));
	audioDriver->recordPacket = 0;
	
	// Set the parameters of the recording format.
	
	memset(&audioDriver->audioQueueRecordFormat, 0, sizeof(audioDriver->audioQueueRecordFormat));
	
	UInt32 size = sizeof(audioDriver->audioQueueRecordFormat.mSampleRate);
	OSStatus sampleRateError = AudioSessionGetProperty(	kAudioSessionProperty_CurrentHardwareSampleRate,
													   &size, 
													   &audioDriver->audioQueueRecordFormat.mSampleRate);
	if(sampleRateError != 0) {
#ifdef OPENEARSLOGGING		
		printf("Error %d: Unable to get hardware sample rate.\n", (int)sampleRateError);
#endif
	}
	
	size = sizeof(audioDriver->audioQueueRecordFormat.mChannelsPerFrame);
	OSStatus inputNumberChannelsError = AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, 
																&size, 
																&audioDriver->audioQueueRecordFormat.mChannelsPerFrame);
	if(inputNumberChannelsError != 0) {
#ifdef OPENEARSLOGGING		
		printf("Error %d: Unable to get number of input channels\n", (int)inputNumberChannelsError);
#endif
	}
	
	audioDriver->audioQueueRecordFormat.mFormatID = kAudioFormatLinearPCM;
	audioDriver->audioQueueRecordFormat.mChannelsPerFrame = 1; 
	audioDriver->audioQueueRecordFormat.mSampleRate = 16000; 
	audioDriver->audioQueueRecordFormat.mBytesPerPacket = audioDriver->audioQueueRecordFormat.mChannelsPerFrame * 2;
	audioDriver->audioQueueRecordFormat.mFramesPerPacket = 1;
	audioDriver->audioQueueRecordFormat.mBytesPerFrame = audioDriver->audioQueueRecordFormat.mBytesPerPacket;
	audioDriver->audioQueueRecordFormat.mBitsPerChannel = 16; 
	audioDriver->audioQueueRecordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
	audioDriver->roundsOfCalibration = 0;
	audioDriver->endingLoop = FALSE;
	
	// Create a new Audio Queue for recording, using the defined format.
	
	OSStatus audioQueueNewInputError = AudioQueueNewInput(&audioDriver->audioQueueRecordFormat,
														  AudioQueueInputBufferCallback,
														  audioDriver,
														  NULL, 
														  NULL,
														  0, 
														  &audioDriver->audioQueue);
	if(audioQueueNewInputError != 0) {
#ifdef OPENEARSLOGGING		
		printf("Error %d: Unable to queue new audio input\n", (int)audioQueueNewInputError);
#endif
	}
	audioDriver->audioQueueIsRunning = 1; // Set audioQueueIsRunning to true.

	SInt32 bufferByteSize = 16000;
	
	for (int i = 0; i < 3; ++i) { 
		
		OSStatus allocateBufferError = AudioQueueAllocateBuffer(audioDriver->audioQueue, bufferByteSize, &audioDriver->audioQueueBuffers[i]);
		if(allocateBufferError != 0) {
#ifdef OPENEARSLOGGING			
			printf("Error %d: Unable to allocate Audio Queue buffer.\n", (int)allocateBufferError);
#endif
		}
		
		// Enqueue the buffers.
		
		OSStatus enqueueBufferError = AudioQueueEnqueueBuffer(audioDriver->audioQueue, audioDriver->audioQueueBuffers[i], 0, NULL);
		if(enqueueBufferError != 0) {
#ifdef OPENEARSLOGGING			
			printf("Error %d: Unable to enqueue the Audio Queue buffer.\n", (int)enqueueBufferError);
#endif
		}
	}
	
	// Start the audio queue.
	
	OSStatus audioQueueStartError = AudioQueueStart(audioDriver->audioQueue, NULL);
	if(audioQueueStartError != 0) {
#ifdef OPENEARSLOGGING		
		printf("Error %d: Unable to start the Audio Queue.\n", (int)audioQueueStartError);
#endif
	}
	
	// Enable metering.
	
	UInt32 enableMetering = 1;
	OSStatus audioQueueSetPropertyError = AudioQueueSetProperty(audioDriver->audioQueue, kAudioQueueProperty_EnableLevelMetering, &enableMetering, sizeof(UInt32));
	if(audioQueueSetPropertyError != 0) {
#ifdef OPENEARSLOGGING		
		printf("Error %d: Unable to enable Audio Queue level metering.\n", (int)audioQueueSetPropertyError);
#endif
	}
	
	// let's set up the extra sample buffer here
	
	audioDriver->extraSamples = FALSE;
	audioDriver->numberOfExtraSamples = 0;
	
	
	audioDriver->extraSampleBuffer = (SInt16 *)realloc(audioDriver->extraSampleBuffer, 16184 * 4); // 16184 is the probably number coming in, x4 for safety and device independence.
	if (audioDriver->extraSampleBuffer == NULL) { 
#ifdef OPENEARSLOGGING		
		printf("Error: Unable to allocate memory to the extra sample buffer.\n");
#endif
	}

	// Malloc the AudioQueueLevelMeterState object so we aren't doing that in the middle of the level metering function.
	audioDriver->levelMeterState = (AudioQueueLevelMeterState *)realloc(audioDriver->levelMeterState, sizeof(AudioQueueLevelMeterState) * audioDriver->audioQueueRecordFormat.mChannelsPerFrame);
	if (audioDriver->levelMeterState == NULL) { 
#ifdef OPENEARSLOGGING		
		printf("Error: Unable to allocate memory to the level meter state.\n");
#endif
	}
	
	
	int i;
	for ( i = 0; i < kNumberOfChunksInRingbufferAudioQueue; i++ ) { // malloc each individual buffer in the ringbuffer in advance to an overall size with some wiggle room.
		
		audioDriver->ringBuffer[i].buffer = (SInt16 *)realloc(audioDriver->ringBuffer[i].buffer, kChunkSizeInBytesAudioQueue);
		if (audioDriver->ringBuffer[i].buffer == NULL) { 
#ifdef OPENEARSLOGGING		
			printf("Error: Unable to allocate memory to ringbuffer chunk %d.\n",i);
#endif
		}
		
		audioDriver->ringBuffer[i].numberOfSamples = 0;
		audioDriver->ringBuffer[i].writtenTimestamp = CFAbsoluteTimeGetCurrent();
	}
	
	int j;
	for ( j = 0; j < kNumberOfChunksInRingbufferAudioQueue; j++ ) { // set the consumed time stamps to now.
		audioDriver->consumedTimeStamp[j] = CFAbsoluteTimeGetCurrent();
	}
	
	audioDriver->indexOfLastWrittenChunk = kNumberOfChunksInRingbufferAudioQueue-1;
	audioDriver->indexOfChunkToRead = 0;
	
	audioDriver->calibrating = 0;
	// Turn recording on.
	audioDriver->recording = 1;
	
    return 0;
}

SInt32 stopRecording(pocketsphinxAudioDevice * audioDevice) { // Tell the Audio Queue to stop recording.
	// If the device isn't actually recording, bail.
	
	if (audioDriver->recording == 0) {
        return -1;
	}
	
	// Dispose of the queue and close the audio file. If we've already done this there won't be a recordFileName.
	// This should really be checking the status of recordFileID or recording, but is a weird leftover from a previous 
	// approach that has already been tested that I'd like to change when there's time.
	
	
	if(audioDriver->audioQueueIsRunning == 1) {
		
		audioDriver->audioQueueIsRunning = 0;
		OSStatus audioQueueStopError = AudioQueueStop(audioDriver->audioQueue, true);
		if(audioQueueStopError != 0) {
#ifdef OPENEARSLOGGING				
			printf("Error %d: Unable to stop the Audio Queue.\n", (int)audioQueueStopError);
#endif
		}

		OSStatus audioQueueDisposeError = AudioQueueDispose(audioDriver->audioQueue, true);
		if(audioQueueDisposeError != 0) {
#ifdef OPENEARSLOGGING				
			printf("Error %d: Unable to dispose of the Audio Queue.\n", (int)audioQueueDisposeError);
#endif
		}

	}
	
	
	// Set recording to off.
	
	
	// Let's free the extrasamples buffer here
	
	audioDriver->extraSamples = FALSE;
	audioDriver->numberOfExtraSamples = 0;
	audioDriver->endingLoop = FALSE;
	
	audioDriver->calibrating = 0;
    
	if(audioDriver) audioDriver->recording = 0;
	
    return 0;
}

int32 readBufferContents(pocketsphinxAudioDevice * audioDevice, int16 * buffer, int32 maximum) { // Scan the buffer for speech.
	
	// Only read if we're recording.
	
	if(audioDevice->recording == 0) {
		return -1;
	}
	
	// let's only do the following when we aren't calibrating for now
	
	if(audioDriver->calibrating == FALSE) {
		
		// So, we have a ringbuffer that may or may not have fresh data for us to read.
		// We want to start out with the first read at chunk zero and sample zero, so this has to be set in StartRecording().
		// We will know if there is nothing there yet to read if chunk index zero has a read datestamp that is fresher than its written datestamp. If that happens it should return zero samples.
		// If that doesn't happen it should read the contents of the chunk for the full reported number of its samples (or max, whichever is smaller) and return the number of samples or max, datestamp the chunk 
		// and then increment the current chunk index.  SIMPLES!
		
		// Step one:
		
		// For the current chunk, compare its timestamp to the timestamp of that chunk index in the ringbuffer and see which is fresher:
		
		if(audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].writtenTimestamp>=audioDriver->consumedTimeStamp[audioDriver->indexOfChunkToRead]) { // If this chunk was written to more recently than it was read, it can be read.
			
			//NSLog(@"the chunk we want to read (%d) is fresh so we will read it",audioDriver->indexOfChunkToRead);
			
			// Read the whole chunk, return its number of samples, timestamp the index for this chunk.	
			
			// Put the total number of samples or max, whichever is smaller, in the pointer to the buffer which is an argument of this function.
			// Return the number of samples we put in there or max
			// Put the read timestamp in the index of chunk read timestamps.
			// increment indexOfChunkToRead or if it is on the last index, loop it around to zero.
			
			// OK, if max is bigger than the number of samples in the chunk, set max to the number of samples in the chunk:
			
			if(maximum >= audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples) {
				maximum = audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples;
				//NSLog(@"Maximum was larger than the number of samples in the buffer so we copied them all");
			} else {
				//NSLog(@"Maximum was smaller than the number of samples in the buffer which means we're only copying out %d out of %d total available.", maximum, audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples);
				// Put the rest into the extras buffer
				
				SInt16 numberOfUncopiedSamples = audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].numberOfSamples - maximum;
				UInt32 startingSampleIndexForExtraSamples = maximum;
				audioDriver->extraSamples = TRUE;
				
				audioDriver->numberOfExtraSamples = numberOfUncopiedSamples;

				memcpy((SInt16 *)audioDriver->extraSampleBuffer, (SInt16 *)audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].buffer + startingSampleIndexForExtraSamples, audioDriver->numberOfExtraSamples * 2);
				
			}
			
			memcpy(buffer,audioDriver->ringBuffer[audioDriver->indexOfChunkToRead].buffer, maximum * 2); // memcpy copies bytes, so this needs to be max times 2 which is how many bytes are in one of our samples
			
			audioDriver->consumedTimeStamp[audioDriver->indexOfChunkToRead] = CFAbsoluteTimeGetCurrent(); // Timestamp to the current time.
			
			if(audioDriver->indexOfChunkToRead == kNumberOfChunksInRingbufferAudioQueue - 1) { // If this is the last chunk index, loop around to zero.
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

SInt32 closeAudioDevice(pocketsphinxAudioDevice * audioDevice) { // Close the "audio device" or in this case stop and free the Audio Queue.
	// First clean up if this has somehow been called out of sequence.
	
	if (audioDevice && audioDevice->recording == 1) {
		
		stopRecording(audioDevice);
		audioDevice->recording = 0;
		
	} else {
		
		audioDevice->recording = 0;
	}
	
	// If there is an audio queue and it's running, dispose of it.
	if(audioDevice->audioQueue && audioDevice->audioQueueIsRunning == 1) {
		AudioQueueDispose(audioDevice->audioQueue, true);
		audioDevice->audioQueue = NULL;
	}
	
	free(audioDriver->extraSampleBuffer); // Let's free the extra sample buffer now.
	int i;
	for ( i = 0; i < kNumberOfChunksInRingbufferAudioQueue; i++ ) { // free each individual chunk in the ringbuffer
		free(audioDriver->ringBuffer[i].buffer);
	}
	free(audioDriver->levelMeterState);
	if(audioDevice) free(audioDevice); 	// Finally, free the Sphinx audio device.
	
    return 0;
}
#else
#endif