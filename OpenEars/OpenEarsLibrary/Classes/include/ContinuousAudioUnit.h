//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  ContinuousAudioUnit.h
//  OpenEars
//
//  ContinuousAudioUnit is a class which handles the interaction between the Pocketsphinx continuous recognition loop and Core Audio.
//
//  This is a sphinx ad header based on modifications to the Sphinxbase file ad.h.
//
//  Copyright Halle Winkler 2010, 2011 excepting that which falls under the copyright of Carnegie Mellon University
//  as part of their file ad.h.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  Excepting that which falls under the license of Carnegie Mellon University as part of their file ad.h, 
//  licensed under the Common Development and Distribution License (CDDL) Version 1.0
//  http://www.opensource.org/licenses/cddl1.txt or see included file license.txt
//  with the single exception to the license that you may distribute executable-only versions
//  of software using OpenEars files without making source code available under the terms of CDDL Version 1.0 
//  paragraph 3.1 if source code to your software isn't otherwise available, and without including a notice in 
//  that case that that source code is available. Exception applies exclusively to compiled binary apps such as can be
//  downloaded from the App Store, and not to frameworks or systems, to which the un-altered CDDL applies
//  unless other terms are agreed to by the copyright holder.
//
//  Header for original source file ad.h which I modified to create this header is as follows:
//
/* -*- c-basic-offset: 4; indent-tabs-mode: nil -*- */
/* ====================================================================
 * Copyright (c) 1999-2004 Carnegie Mellon University.  All rights
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
 * ad.h -- generic live audio interface for recording and playback
 * 
 * **********************************************
 * CMU ARPA Speech Project
 *
 * Copyright (c) 1996 Carnegie Mellon University.
 * ALL RIGHTS RESERVED.
 * **********************************************
 * 
 * HISTORY
 * 
 * $Log: ad.h,v $
 * Revision 1.8  2005/06/22 08:00:06  arthchan2003
 * Completed all doxygen documentation on file description for libs3decoder/libutil/libs3audio and programs.
 *
 * Revision 1.7  2004/12/14 00:39:49  arthchan2003
 * add <s3types.h> to the code, change some comments to doxygen style
 *
 * Revision 1.6  2004/12/06 11:17:55  arthchan2003
 * Update the copyright information of ad.h, *sigh* start to feel tired of updating documentation system.  Anyone who has time, please take up libs3audio. That is the last place which is undocumented
 *
 * Revision 1.5  2004/07/23 23:44:46  egouvea
 * Changed the cygwin code to use the same audio files as the MS Visual code, removed unused variables from fe_interface.c
 *
 * Revision 1.4  2004/02/29 23:48:31  egouvea
 * Updated configure.in to the recent automake/autoconf, fixed win32
 * references in audio files.
 *
 * Revision 1.3  2002/11/10 19:27:38  egouvea
 * Fixed references to sun's implementation of audio interface,
 * referring to the correct .h file, and replacing sun4 with sunos.
 *
 * Revision 1.2  2001/12/11 04:40:55  lenzo
 * License cleanup.
 *
 * Revision 1.1.1.1  2001/12/03 16:01:45  egouvea
 * Initial import of sphinx3
 *
 * Revision 1.1.1.1  2001/01/17 05:17:14  ricky
 * Initial Import of the s3.3 decoder, has working decodeaudiofile, s3.3_live
 *
 * 
 * 19-Jan-1999	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University
 * 		Added AD_ return codes.  Added ad_open_sps_bufsize(), and
 * 		ad_rec_t.n_buf.
 * 
 * 17-Apr-98	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University
 * 		Added ad_open_play_sps().
 * 
 * 07-Mar-98	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University
 * 		Added ad_open_sps().
 * 
 * 10-Jun-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University
 * 		Added ad_wbuf_t, ad_rec_t, and ad_play_t types, and augmented all
 * 		recording functions with ad_rec_t, and playback functions with
 * 		ad_play_t.
 * 
 * 06-Jun-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University
 *		Created.
 */

/** \file ad.h
 * \brief generic live audio interface for recording and playback
 */

#if defined TARGET_IPHONE_SIMULATOR && TARGET_IPHONE_SIMULATOR // The simulator uses an audio queue driver because it doesn't work at all with the low-latency audio unit driver. 
#import "AudioQueueFallback.h"

#else // The real driver is the low-latency audio unit driver:

#define _AD_H_
#import <AudioToolbox/AudioToolbox.h>
#import <prim_type.h>
#import "AudioConstants.h"

extern "C" {

typedef struct Chunk { // The audio device struct used by Pocketsphinx.
	SInt16 *buffer; // The buffer of SInt16 samples
	SInt32 numberOfSamples; // The number of samples in the buffer
	CFAbsoluteTime writtenTimestamp; // When this buffer was written
} RingBuffer;	
	
typedef struct {
	
	BOOL interruptionWasReceived;
	BOOL reactivatingAfterInterruption;
	AudioUnit audioUnit;
	AudioStreamBasicDescription thruFormat;
	int16 deviceIsOpen;
	int16 unitIsRunning;
	CFStringRef currentRoute; // The current Audio Route for the device (e.g. headphone mic or external mic).
	SInt64 recordPacket; // The current packet of the Audio unit.
	BOOL recordData; // Should data be recorded?
	BOOL recognitionIsInProgress; // Is the recognition loop in effect?
	BOOL audioUnitIsRunning; // Is the unit instantiated? 
	BOOL recording; // Is the Audio unit currently recording sound? 
	SInt32 sps;		// Samples per second.
	SInt32 bps;		// Bytes per sample.
	RingBuffer ringBuffer[kNumberOfChunksInRingbuffer]; // The ringbuffer
	SInt16 indexOfLastWrittenChunk; // The index of the ringbuffer section that was last written to
	SInt16 indexOfChunkToRead; // The index of the ringbuffer section that next needs reading
	CFAbsoluteTime consumedTimeStamp[kNumberOfChunksInRingbuffer]; // The ringbuffer section timestamp array
	BOOL calibrating; // let's classes interacting with this class get/set the state of whether the driver is calibrating
	SInt16 *calibrationBuffer; // The buffer of calibration samples
	UInt32 availableSamplesDuringCalibration; // The number of calibration samples that are available for reading
	UInt32 samplesReadDuringCalibration; // The number of calibration samples which have been read
	SInt16 roundsOfCalibration; // The number of calibration rounds
	BOOL extraSamples; // Are there extra samples to read beyond the ringbuffer (this is an adaptation to the pocketsphinx-required driver setup, which results in a chunk of extra samples after processing the main results of a recording round)
	UInt32 numberOfExtraSamples; // The number of extra samples to read
	SInt16 *extraSampleBuffer; // The buffer of extra samples to read
	BOOL endingLoop; // We do things slightly differently if we are trying to exit the continuous recognition loop
	Float32 pocketsphinxDecibelLevel; // The decibel level of mic input
	
	
} pocketsphinxAudioDevice;	

Float32 pocketsphinxAudioDeviceMeteringLevel(pocketsphinxAudioDevice * audioDriver); // Returns the decibel level of mic input to controller classes
pocketsphinxAudioDevice *openAudioDevice(const char *dev, int32 samples_per_sec); // Opens the audio device
int32 startRecording(pocketsphinxAudioDevice * audioDevice); // Starts the audio device
int32 stopRecording(pocketsphinxAudioDevice * audioDevice); // Stops the audio device
int32 closeAudioDevice(pocketsphinxAudioDevice * audioDevice); // Closes the audio device
int32 readBufferContents(pocketsphinxAudioDevice * audioDevice, int16 * buffer, int32 maximum); // reads the buffer samples for speech data and silence data
void setRoute(); // Sets the audio route as read from the audio session manager
void getDecibels(SInt16 * samples, UInt32 inNumberFrames); // Reads the buffer samples and converts them to decibel readings

}

#endif

