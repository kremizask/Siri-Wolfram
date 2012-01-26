//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  ContinuousModel.mm
//  OpenEars
//
//  ContinuousModel is a class which consists of the continuous listening loop used by Pocketsphinx.
//
//  This is a Pocketsphinx continuous listening loop based on modifications to the Pocketsphinx file continuous.c.
//
//  Copyright Halle Winkler 2010, 2011 excepting that which falls under the copyright of Carnegie Mellon University as part
//  of their file continuous.c.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  Excepting that which falls under the license of Carnegie Mellon University as part of their file continuous.c, 
//  licensed under the Common Development and Distribution License (CDDL) Version 1.0
//  http://www.opensource.org/licenses/cddl1.txt or see included file license.txt
//  with the single exception to the license that you may distribute executable-only versions
//  of software using OpenEars files without making source code available under the terms of CDDL Version 1.0 
//  paragraph 3.1 if source code to your software isn't otherwise available, and without including a notice in 
//  that case that that source code is available. Exception applies exclusively to compiled binary apps such as can be
//  downloaded from the App Store, and not to frameworks or systems, to which the un-altered CDDL applies
//  unless other terms are agreed to by the copyright holder.
//
//  Header for original source file continuous.c which I modified to create this file is as follows:
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
 * demo.c -- An example SphinxII program using continuous listening/silence filtering
 * 		to segment speech into utterances that are then decoded.
 * 
 * HISTORY
 *
 * 15-Jun-99    Kevin A. Lenzo (lenzo@cs.cmu.edu) at Carnegie Mellon University
 *              Added i386_linux and used ad_open_sps instead of ad_open
 * 
 * 14-Jun-96	M K Ravishankar (rkm@cs.cmu.edu) at Carnegie Mellon University.
 * 		Created.
 */

/*
 * This is a simple, tty-based example of a SphinxII client that uses continuous listening
 * with silence filtering to automatically segment a continuous stream of audio input
 * into utterances that are then decoded.
 * 
 * Remarks:
 *   - Each utterance is ended when a silence segment of at least 1 sec is recognized.
 *   - Single-threaded implementation for portability.
 *   - Uses fbs8 audio library; can be replaced with an equivalent custom library.
 */
#import "AudioConstants.h"


#import "ContinuousAudioUnit.h"

#import "ContinuousModel.h"
#import "pocketsphinx.h"
#import "ContinuousADModule.h"
#import "unistd.h"
#import "OpenEarsConfig.h"
#import "PocketsphinxRunConfig.h"
#import "fsg_search_internal.h"

@implementation ContinuousModel

@synthesize inMainRecognitionLoop; // Have we entered the main part of the loop yet?
@synthesize exitListeningLoop; // Should we be breaking out of the loop at the nearest opportunity?
@synthesize thereIsALanguageModelChangeRequest;
@synthesize languageModelFileToChangeTo;
@synthesize dictionaryFileToChangeTo;

static pocketsphinxAudioDevice *audioDevice; // The "device", which is actually a struct containing an Audio Unit.
static ps_decoder_t *pocketSphinxDecoder; // The Pocketsphinx decoder which will perform the actual speech recognition on recorded speech.
FILE *err_set_logfp(FILE *logfp); // This function will allow us to make Pocketsphinx run quietly.

- (void)dealloc {
	[languageModelFileToChangeTo release];
	[dictionaryFileToChangeTo release];
    [super dealloc];
}

- (NSString *)languageModelFileToChangeTo {
	if (languageModelFileToChangeTo == nil) {
		languageModelFileToChangeTo = [[NSString alloc] init];
	}
	return languageModelFileToChangeTo;
}

- (NSString *) compileKnownWordsFromFileAtPath:(NSString *)filePath {
	NSArray *dictionaryArray = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSMutableString *allWords = [[[NSMutableString alloc] init]autorelease];
	for(NSString *string in dictionaryArray) {
		NSArray *lineArray = [string componentsSeparatedByString:@"\t"];
		[allWords appendString:[NSString stringWithFormat:@"%@\n",[lineArray objectAtIndex:0]]];
	}
	return allWords;
}

- (void) changeLanguageModelForDecoder:(ps_decoder_t *)pocketsphinxDecoder languageModelIsJSGF:(BOOL)languageModelIsJSGF {
			
	OpenEarsLog(@"A request has been made to change an ARPA grammar on the fly. The language model to change to is %@", self.languageModelFileToChangeTo);		
	NSNumber *languageModelID = [NSNumber numberWithInt:999];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *error = nil;
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:self.languageModelFileToChangeTo error:&error];
	if(error) {
		OpenEarsLog(@"Error: couldn't get attributes of language model file.");		
	} else {	
		OpenEarsLog(@"In this session, the requested language model will be known to Pocketsphinx as id %@.",[fileAttributes valueForKey:NSFileSystemFileNumber]);		
		languageModelID = [fileAttributes valueForKey:NSFileSystemFileNumber];
	}
	
	[fileManager release];
	
	ngram_model_t *baseLanguageModel, *newLanguageModelToAdd;
	
	newLanguageModelToAdd = ngram_model_read(pocketsphinxDecoder->config, (char *)[self.languageModelFileToChangeTo UTF8String], NGRAM_AUTO, pocketsphinxDecoder->lmath);
	
	baseLanguageModel = ps_get_lmset(pocketsphinxDecoder);
	
	OpenEarsLog(@"languageModelID is %s",(char *)[[languageModelID stringValue] UTF8String]);
	ngram_model_set_add(baseLanguageModel, newLanguageModelToAdd, (char *)[[languageModelID stringValue] UTF8String], 1.0, TRUE);
	ngram_model_set_select(baseLanguageModel, (char *)[[languageModelID stringValue] UTF8String]);
	
	ps_update_lmset(pocketsphinxDecoder, baseLanguageModel);
	
	int loadingDictionaryResult = ps_load_dict(pocketsphinxDecoder, (char *)[self.dictionaryFileToChangeTo UTF8String],NULL, NULL);
	
	if(loadingDictionaryResult > -1) {
		OpenEarsLog(@"Success loading the dictionary file %@.",self.dictionaryFileToChangeTo);		
	} else {
		OpenEarsLog(@"Error: could not load the specified dictionary file.");		
	}
	
	
	NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"PocketsphinxDidChangeLanguageModel",self.languageModelFileToChangeTo, self.dictionaryFileToChangeTo,nil] forKeys:[NSArray arrayWithObjects:@"OpenEarsNotificationType",@"LanguageModelFilePath",@"DictionaryFilePath",nil]];
	NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
	
	self.languageModelFileToChangeTo = nil;
	self.thereIsALanguageModelChangeRequest = FALSE;
	
	OpenEarsLog(@"Changed language model. Project has these words in its dictionary:\n%@", [self compileKnownWordsFromFileAtPath:self.dictionaryFileToChangeTo]);
	
}

- (pocketsphinxAudioDevice *) continuousAudioDevice { // Return the device to an Objective-C class.
	return audioDevice;	
}

- (CFStringRef) getCurrentRoute {
	if(audioDevice != NULL) {
		return audioDevice->currentRoute;
	}
	return NULL;
}


//- (void) setCurrentRouteTo:(NSString *)newRoute {
//	if(audioDevice != NULL & audioDevice->currentRoute != NULL) {
//		audioDevice->currentRoute = (CFStringRef)newRoute;
//	}
//}

// fix for issue #7930

- (void) setCurrentRouteTo:(NSString *)newRoute {
    if(audioDevice != NULL && audioDevice->currentRoute != NULL) {
        [newRoute retain];
        audioDevice->currentRoute = (CFStringRef)newRoute;
    }
}

- (int) getRecognitionIsInProgress {
	if(audioDevice != NULL) {
		return audioDevice->recognitionIsInProgress;
	}
	return 0;
}

- (void) setRecognitionIsInProgressTo:(int)recognitionIsInProgress {
	if(audioDevice != NULL) {
		audioDevice->recognitionIsInProgress = recognitionIsInProgress;
	}
}


- (int) getRecordData {
	if(audioDevice != NULL) {
		return audioDevice->recordData;
	}
	return 0;
}

- (void) setRecordDataTo:(int)recordData {
	if(audioDevice != NULL) {
		audioDevice->recordData = recordData;
	}
}

- (Float32) getMeteringLevel {
	if(audioDevice != NULL) {	
		return pocketsphinxAudioDeviceMeteringLevel(audioDevice);
	}
	return 0.0;
}

#pragma mark -
#pragma mark Pocketsphinx Listening Loop


- (void) setupCalibrationBuffer {
	
	int numberOfRounds = 25; // This is the minimum number of rounds that appear to be required to be available under normal usage;
	int numberOfSamples = kPredictedSizeOfRenderFramesPerCallbackRound; // This is the current number of samples that is called in a single callback buffer round but this could change based on hardware, etc so keep an eye on it
	int safetyMultiplier = audioDevice->bps * 3; // this is the safety multiplier so that under normal usage we don't overrun this buffer, bps * 3 for device independence.

	if(audioDevice->calibrationBuffer == NULL) {
		audioDevice->calibrationBuffer = (SInt16*) malloc(audioDevice->bps * numberOfSamples * numberOfRounds * safetyMultiplier); // this only needs to be the size of the amount of data used to calibrate, and then some		
	} else {
		audioDevice->calibrationBuffer = (SInt16*) realloc(audioDevice->calibrationBuffer, audioDevice->bps * numberOfSamples * numberOfRounds * safetyMultiplier); // this only needs to be the size of the amount of data used to calibrate, and then some				
	}
	
	audioDevice->availableSamplesDuringCalibration = 0;
	audioDevice->samplesReadDuringCalibration = 0;
}


- (void) putAwayCalibrationBuffer {
	if(audioDevice->calibrationBuffer != NULL) {
		free(audioDevice->calibrationBuffer);
		audioDevice->calibrationBuffer = NULL;
	}
	audioDevice->availableSamplesDuringCalibration = 0;
	audioDevice->samplesReadDuringCalibration = 0;
}

- (void) changeLanguageModelToFile:(NSString *)languageModelPathAsString withDictionary:(NSString *)dictionaryPathAsString {
	self.thereIsALanguageModelChangeRequest = TRUE;
	self.languageModelFileToChangeTo = languageModelPathAsString;
	self.dictionaryFileToChangeTo = dictionaryPathAsString;
}


- (void) listeningLoopWithLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF { // The big recognition loop.
	
	NSDictionary *userInfoDictionaryForStartup = [NSDictionary dictionaryWithObject:@"PocketsphinxRecognitionLoopDidStart" forKey:@"OpenEarsNotificationType"]; // Forward the info that we're starting to OpenEarsEventsObserver.
	NSNotification *notificationForStartup = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForStartup];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForStartup waitUntilDone:NO];

	OpenEarsLog(@"Recognition loop has started");
	
	UInt32 maximumAndBufferIndices = 32368;
	int16 audioDeviceBuffer[maximumAndBufferIndices]; // The following are all used by Pocketsphinx.
    int32 speechData;
	int32 timestamp;
	int32 remainingSpeechData;
	int32 recognitionScore;
    char const *hypothesis;
    char const *utteranceID;
    cont_ad_t *continuousListener;
	
#ifndef VERBOSEPOCKETSPHINX
	err_set_logfp(NULL); // If VERBOSEPOCKETSPHINX isn't defined, this will quiet the output from Pocketsphinx.
#endif
	
	NSString *languageModelToUse = nil;
	
	if(languageModelIsJSGF == TRUE) {
		languageModelToUse = @"-jsgf";
	} else {
		languageModelToUse = @"-lm";
	}
	
	NSArray *commandArray = [[NSArray alloc] initWithObjects: // This is an array that is used to set up the run arguments for Pocketsphinx. 
							 // Never change any of the values here directly.  They can be changed using the file PocketsphinxRunConfig.h (although you shouldn't 
							 // change anything there unless you are absolutely 100% clear on why you'd want to and what the outcome will be).
							 // See PocketsphinxRunConfig.h for explanations of these constants and the run arguments they correspond to.
							 languageModelToUse, languageModelPath,		 
#ifdef kADCDEV
							 @"-adcdev", kADCDEV,
#endif
							 
#ifdef kAGC
							 @"-agc", kAGC,
#endif
							 
#ifdef kAGCTHRESH
							 @"-agcthresh", kAGCTHRESH,
#endif
							 
#ifdef kALPHA
							 @"-alpha", kALPHA,
#endif
							 
#ifdef kARGFILE
							 @"-argfile", kARGFILE,
#endif
							 
#ifdef kASCALE
							 @"-ascale", kASCALE,
#endif
							 
#ifdef kBACKTRACE
							 @"-backtrace", kBACKTRACE,
#endif
							 
#ifdef kBEAM
							 @"-beam", kBEAM,
#endif
							 
#ifdef kBESTPATH
							 @"-bestpath", kBESTPATH,
#endif
							 
#ifdef kBESTPATHLW
							 @"-bestpathlw", kBESTPATHLW,
#endif
							 
#ifdef kBGHIST
							 @"-bghist", kBGHIST,
#endif
							 
#ifdef kCEPLEN
							 @"-ceplen", kCEPLEN,
#endif
							 
#ifdef kCMN
							 @"-cmn", kCMN,
#endif
							 
#ifdef kCMNINIT
							 @"-cmninit", kCMNINIT,
#endif
							 
#ifdef kCOMPALLSEN
							 @"-compallsen", kCOMPALLSEN,
#endif
							 
#ifdef kDEBUG
							 @"-debug", kDEBUG,
#endif
							 
#ifdef kDICT
							 @"-dict", dictionaryPath,
#endif
							 
#ifdef kDICTCASE
							 @"-dictcase", kDICTCASE,
#endif
							 
#ifdef kDITHER
							 @"-dither", kDITHER,
#endif
							 
#ifdef kDOUBLEBW
							 @"-doublebw", kDOUBLEBW,
#endif
							 
#ifdef kDS
							 @"-ds", kDS,
#endif
							 
#ifdef kFDICT
							 @"-fdict",  [NSString stringWithFormat:@"%@/noisedict",[[NSBundle mainBundle] resourcePath]],
#endif
							 
#ifdef kFEAT
							 @"-feat", kFEAT,
#endif
							 
#ifdef kFEATPARAMS
							 @"-featparams", kFEATPARAMS,
#endif
							 
#ifdef kFILLPROB
							 @"-fillprob", kFILLPROB,
#endif
							 
#ifdef kFRATE
							 @"-frate", kFRATE,
#endif
							 
#ifdef kFSG
							 @"-fsg", kFSG,
#endif
							 
#ifdef kFSGUSEALTPRON
							 @"-fsgusealtpron", kFSGUSEALTPRON,
#endif
							 
#ifdef kFSGUSEFILLER
							 @"-fsgusefiller", kFSGUSEFILLER,
#endif
							 
#ifdef kFWDFLAT
							 @"-fwdflat", kFWDFLAT,
#endif
							 
#ifdef kFWDFLATBEAM
							 @"-fwdflatbeam", kFWDFLATBEAM,
#endif
							 
#ifdef kFWDFLATWID
							 @"-fwdflatefwid", kFWDFLATWID,
#endif
							 
#ifdef kFWDFLATLW
							 @"-fwdflatlw", kFWDFLATLW,
#endif
							 
#ifdef kFWDFLATSFWIN
							 @"-fwdflatsfwin", kFWDFLATSFWIN,
#endif
							 
#ifdef kFWDFLATBEAM
							 @"-fwdflatwbeam", kFWDFLATBEAM,
#endif
							 
#ifdef kFWDTREE
							 @"-fwdtree", kFWDTREE,
#endif
							 
#ifdef kHMM
							 @"-hmm", [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] resourcePath]],
#endif
							 
#ifdef kINPUT_ENDIAN
							 @"-input_endian", kINPUT_ENDIAN,
#endif
							 
#ifdef kKDMAXBBI
							 @"-kdmaxbbi", kKDMAXBBI,
#endif
							 
#ifdef kKDMAXDEPTH
							 @"-kdmaxdepth", kKDMAXDEPTH,
#endif
							 
#ifdef kKDTREE
							 @"-kdtree", kKDTREE,
#endif
							 
#ifdef kLATSIZE
							 @"-latsize", kLATSIZE,
#endif
							 
#ifdef kLDA
							 @"-lda", kLDA,
#endif
							 
#ifdef kLDADIM
							 @"-ldadim", kLDADIM,
#endif
							 
#ifdef kLEXTREEDUMP
							 @"-lextreedump", kLEXTREEDUMP,
#endif
							 
#ifdef kLIFTER
							 @"-lifter",	kLIFTER,
#endif
							 
#ifdef kLMCTL
							 @"-lmctl",	kLMCTL,
#endif
							 
#ifdef kLMNAME
							 @"-lmname",	kLMNAME,
#endif
							 
#ifdef kLOGBASE
							 @"-logbase", kLOGBASE,
#endif
							 
#ifdef kLOGFN
							 @"-logfn", kLOGFN,
#endif
							 
#ifdef kLOGSPEC
							 @"-logspec", kLOGSPEC,
#endif
							 
#ifdef kLOWERF
							 @"-lowerf", kLOWERF,
#endif
							 
#ifdef kLPBEAM
							 @"-lpbeam", kLPBEAM,
#endif
							 
#ifdef kLPONLYBEAM
							 @"-lponlybeam", kLPONLYBEAM,
#endif
							 
#ifdef kLW
							 @"-lw",	kLW,
#endif
							 
#ifdef kMAXHMMPF
							 @"-maxhmmpf", kMAXHMMPF,
#endif
							 
#ifdef kMAXNEWOOV
							 @"-maxnewoov", kMAXNEWOOV,
#endif
							 
#ifdef kMAXWPF
							 @"-maxwpf", kMAXWPF,
#endif
							 
#ifdef kMDEF
							 @"-mdef", kMDEF,
#endif
							 
#ifdef kMEAN
							 @"-mean", kMEAN,
#endif
							 
#ifdef kMFCLOGDIR
							 @"-mfclogdir", kMFCLOGDIR,
#endif
							 
#ifdef kMIXW
							 @"-mixw", kMIXW,
#endif
							 
#ifdef kMIXWFLOOR
							 @"-mixwfloor", kMIXWFLOOR,
#endif
							 
#ifdef kMLLR
							 @"-mllr", kMLLR,
#endif
							 
#ifdef kMMAP
							 @"-mmap", kMMAP,
#endif
							 
#ifdef kNCEP
							 @"-ncep", kNCEP,
#endif
							 
#ifdef kNFFT
							 @"-nfft", kNFFT,
#endif
							 
#ifdef kNFILT
							 @"-nfilt", kNFILT,
#endif
							 
#ifdef kNWPEN
							 @"-nwpen", kNWPEN,
#endif
							 
#ifdef kPBEAM
							 @"-pbeam", kPBEAM,
#endif
							 
#ifdef kPIP
							 @"-pip", kPIP,
#endif
							 
#ifdef kPL_BEAM
							 @"-pl_beam", kPL_BEAM,
#endif
							 
#ifdef kPL_PBEAM
							 @"-pl_pbeam", kPL_PBEAM,
#endif
							 
#ifdef kPL_WINDOW
							 @"-pl_window", kPL_WINDOW,
#endif
							 
#ifdef kRAWLOGDIR
							 @"-rawlogdir", kRAWLOGDIR,
#endif
							 
#ifdef kREMOVE_DC
							 @"-remove_dc", kREMOVE_DC,
#endif
							 
#ifdef kROUND_FILTERS
							 @"-round_filters", kROUND_FILTERS,
#endif
							 
#ifdef kSAMPRATE
							 @"-samprate", kSAMPRATE,
#endif
							 
#ifdef kSEED
							 @"-seed",kSEED,
#endif
							 
#ifdef kSENDUMP
							 @"-sendump", kSENDUMP,
#endif
							 
#ifdef kSENMGAU
							 @"-senmgau", kSENMGAU,
#endif
							 
#ifdef kSILPROB
							 @"-silprob", kSILPROB,
#endif
							 
#ifdef kSMOOTHSPEC
							 @"-smoothspec", kSMOOTHSPEC,
#endif
							 
#ifdef kSVSPEC
							 @"-svspec", kSVSPEC,
#endif
							 
#ifdef kTMAT
							 @"-tmat", kTMAT,
#endif
							 
#ifdef kTMATFLOOR
							 @"-tmatfloor", kTMATFLOOR,
#endif
							 
#ifdef kTOPN
							 @"-topn", kTOPN,
#endif
							 
#ifdef kTOPN_BEAM
							 @"-topn_beam", kTOPN_BEAM,
#endif
							 
#ifdef kTOPRULE
							 @"-toprule", kTOPRULE,
#endif
							 
#ifdef kTRANSFORM
							 @"-transform", kTRANSFORM,
#endif
							 
#ifdef kUNIT_AREA
							 @"-unit_area", kUNIT_AREA,
#endif
							 
#ifdef kUPPERF
							 @"-upperf", kUPPERF,
#endif
							 
#ifdef kUSEWDPHONES
							 @"-usewdphones", kUSEWDPHONES,
#endif
							 
#ifdef kUW
							 @"-uw", kUW,
#endif
							 
#ifdef kVAR
							 @"-var", kVAR,
#endif
							 
#ifdef kVARFLOOR
							 @"-varfloor", kVARFLOOR,
#endif
							 
#ifdef kVARNORM
							 @"-varnorm", kVARNORM,
#endif
							 
#ifdef kVERBOSE
							 @"-verbose", kVERBOSE,
#endif
							 
#ifdef kWARP_PARAMS
							 @"-warp_params", kWARP_PARAMS,
#endif
							 
#ifdef kWARP_TYPE
							 @"-warp_type", kWARP_TYPE,
#endif
							 
#ifdef kWBEAM
							 @"-wbeam", kWBEAM,
#endif
							 
#ifdef kWIP
							 @"-wip", kWIP,
#endif
							 
#ifdef kWLEN
							 @"-wlen", kWLEN,
#endif
							 nil];
	
	char* argv[[commandArray count]]; // We're simulating the command-line run arguments for Pocketsphinx.
	
	for (int i = 0; i < [commandArray count]; i++ ) { // Grab all the set arguments.

		char *argument = const_cast<char*> ([[commandArray objectAtIndex:i]UTF8String]);
		argv[i] = argument;
	}
	
	arg_t cont_args_def[] = { // Grab any extra arguments.
		POCKETSPHINX_OPTIONS,
		{ "-argfile", ARG_STRING, NULL, "Argument file giving extra arguments." },
		CMDLN_EMPTY_OPTION
	};
	
	cmd_ln_t *configuration; // The Pocketsphinx run configuration.
	
    if ([commandArray count] == 2) { // Fail if there aren't really any arguments.
		OpenEarsLog(@"Initial Pocketsphinx command failed because there aren't any arguments in the command");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
        configuration = cmd_ln_parse_file_r(NULL, cont_args_def, argv[1], TRUE);
    }  else { // Set the Pocketsphinx run configuration to the selected arguments and values.
        configuration = cmd_ln_parse_r(NULL, cont_args_def, [commandArray count], argv, FALSE);
    }
	[commandArray release];

    pocketSphinxDecoder = ps_init(configuration); // Initialize the decoder.
	
    if ((audioDevice = openAudioDevice("device",kSamplesPerSecond)) == NULL) { // Open the audio device (actually the struct containing the Audio Unit).
		OpenEarsLog(@"openAudioDevice failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];		
	}
	
    if ((continuousListener = cont_ad_init(audioDevice, readBufferContents)) == NULL) { // Initialize the continuous recognition module.
        OpenEarsLog(@"cont_ad_init failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];
	}
	
	audioDevice->recordData = 1; // Set the device to record data rather than ignoring it (it will ignore data when PocketsphinxController receives the suspendRecognition method).
	audioDevice->recognitionIsInProgress = 1;
	
    if (startRecording(audioDevice) < 0) { // Start recording.
        OpenEarsLog(@"startRecording failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];
	}
	
	[self setupCalibrationBuffer];
	audioDevice->roundsOfCalibration = 0;
	audioDevice->calibrating = TRUE;
	
	NSDictionary *userInfoDictionaryForCalibrationStarted = [NSDictionary dictionaryWithObject:@"PocketsphinxDidStartCalibration" forKey:@"OpenEarsNotificationType"];
	NSNotification *notificationForCalibrationStarted = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForCalibrationStarted];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForCalibrationStarted waitUntilDone:NO];
	// Forward notification that calibration is starting to OpenEarsEventsObserver.
	OpenEarsLog(@"Calibration has started");
	
	[NSThread sleepForTimeInterval:kLeaderLength]; // Getting some samples in the buffer is necessary before we start calibrating.
    if (cont_ad_calib(continuousListener) < 0) { // Start calibration.
		OpenEarsLog(@"cont_ad_calib failed");
		NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
		NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];
	}
	
	NSDictionary *userInfoDictionaryForCalibrationComplete = [NSDictionary dictionaryWithObject:@"PocketsphinxDidCompleteCalibration" forKey:@"OpenEarsNotificationType"];
	NSNotification *notificationForCalibrationComplete = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForCalibrationComplete];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForCalibrationComplete waitUntilDone:NO];
	// Forward notification that calibration finished to OpenEarsEventsObserver.
	OpenEarsLog(@"Calibration has completed");
	
	audioDevice->calibrating = FALSE;
	audioDevice->roundsOfCalibration = 0;
	[self putAwayCalibrationBuffer];
	

	
	OpenEarsLog(@"Project has these words in its dictionary:\n%@", [self compileKnownWordsFromFileAtPath:dictionaryPath]);
	
    for (;;) { // This is the main loop.
				
		self.inMainRecognitionLoop = TRUE; // Note that we're in the main loop.
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		
		// We're now listening for speech.
		OpenEarsLog(@"Listening.");
		
		NSArray *objectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidStartListening",nil];
		NSArray *keysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
		NSDictionary *userInfoDictionaryForListening = [[NSDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
		NSNotification *notificationForListening = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForListening];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForListening waitUntilDone:NO];
		[userInfoDictionaryForListening release];
		[objectsArray release];
		[keysArray release];
		
		// Forward notification that we're now listening for speech to OpenEarsEventsObserver.
		
		// If there is a request to change the lm let's do it here:
		
		if(thereIsALanguageModelChangeRequest == TRUE) {
			
			OpenEarsLog(@"there is a request to change to the language model file %@", self.languageModelFileToChangeTo);
			
			if(languageModelIsJSGF == FALSE) {
				[self changeLanguageModelForDecoder:pocketSphinxDecoder languageModelIsJSGF:languageModelIsJSGF];
			} else {      
				OpenEarsLog(@"Sorry, switching JSGF grammars on the fly isn't supported in this version of OpenEars. You can dynamically generate and switch ARPA grammars.");
			}
		}
		// Wait for speech and sleep when we don't have any yet.
        while ((speechData = cont_ad_read(continuousListener, audioDeviceBuffer, maximumAndBufferIndices)) == 0) {
			
            usleep(30000);
			if(exitListeningLoop == 1) {
				break; // Break if we're trying to exit the loop.
			}
		}
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
        if (speechData < 0) { // This is an error.
			OpenEarsLog(@"cont_ad_read failed");
			NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
			NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
			[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
		}
		
        if (ps_start_utt(pocketSphinxDecoder, NULL) < 0) { // Data has been received and recognition is starting.
			OpenEarsLog(@"ps_start_utt() failed");
			NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
			NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
			[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
		}
		
		ps_process_raw(pocketSphinxDecoder, audioDeviceBuffer, speechData, TRUE, FALSE); // Process the data.
		
		OpenEarsLog(@"Speech detected...");
		
		NSArray *speechNotificationObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidDetectSpeech",nil];
		NSArray *speechNotificationKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
		NSDictionary *userInfoDictionaryForSpeechDetection = [[NSDictionary alloc] initWithObjects:speechNotificationObjectsArray forKeys:speechNotificationKeysArray];
		NSNotification *notificationForSpeechDetection = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForSpeechDetection];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForSpeechDetection waitUntilDone:NO];
		[userInfoDictionaryForSpeechDetection release];
		[speechNotificationObjectsArray release];
		[speechNotificationKeysArray release];
		// Forward to OpenEarsEventsObserver than speech has been detected.
		
		timestamp = continuousListener->read_ts;
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		
        for (;;) { // An inner loop in which the received speech will be decoded up to the point of a silence longer than a second.
			
			
			if(exitListeningLoop == 1) {
				break; // Break if we're trying to exit the loop.
			}
            if ((speechData = cont_ad_read(continuousListener, audioDeviceBuffer, maximumAndBufferIndices)) < 0) { // Read the available data.
				
				OpenEarsLog(@"cont_ad_read failed");
				NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
				NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
				[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];				
			}
			
			if(exitListeningLoop == 1)  {
				break; // Break if we're trying to exit the loop.
			}
			
            if (speechData == 0) { // No speech data, could be the end of a statement if it's been more than a second since the last received speech.
				
                if ((continuousListener->read_ts - timestamp) > (kSamplesPerSecond * kSecondsOfSilenceToDetect)) {
					
					NSArray *speechFinishedNotificationObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidDetectFinishedSpeech",nil];
					NSArray *speechFinishedNotificationKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
					NSDictionary *userInfoDictionaryForSpeechFinished = [[NSDictionary alloc] initWithObjects:speechFinishedNotificationObjectsArray forKeys:speechFinishedNotificationKeysArray];
					NSNotification *notificationForSpeechFinished = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForSpeechFinished];
					[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForSpeechFinished waitUntilDone:NO];
					[userInfoDictionaryForSpeechFinished release];
					[speechFinishedNotificationObjectsArray release];
					[speechFinishedNotificationKeysArray release];
                    break;
				}
            } else { // New speech data.
				
				timestamp = continuousListener->read_ts;
            }
			
			if(exitListeningLoop == 1) {
				break; // Break if we're trying to exit the loop.
			}
			// Decode the data.
			remainingSpeechData = ps_process_raw(pocketSphinxDecoder, audioDeviceBuffer, speechData, TRUE, FALSE);
			
            if ((remainingSpeechData == 0) && (speechData == 0)) { // If nothing more to be done for now, sleep.
				usleep(5000);
				if(exitListeningLoop == 1) {
					break; // Break if we're trying to exit the loop.
				}
			}
			
			if(exitListeningLoop == 1) {
				break; // Break if we're trying to exit the loop.
			}
        }
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		audioDevice->endingLoop = TRUE;
		int i;
		for ( i = 0; i < 10; i++ ) {
			readBufferContents(audioDevice, audioDeviceBuffer, maximumAndBufferIndices); // Make several attempts to read anything remaining in the buffer.
		}
		
        stopRecording(audioDevice); // Stop recording.
        audioDevice->endingLoop = FALSE;

        cont_ad_reset(continuousListener); // Reset the continuous module.
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		OpenEarsLog(@"Processing speech, please wait...");
		
		ps_end_utt(pocketSphinxDecoder); // The utterance is ended,
		hypothesis = ps_get_hyp(pocketSphinxDecoder, &recognitionScore, &utteranceID); // Return the hypothesis.
		int32 probability = ps_get_prob(pocketSphinxDecoder, &utteranceID);
		
		OpenEarsLog(@"Pocketsphinx heard \"%s\" with a score of (%d) and an utterance ID of %s.", hypothesis, probability, utteranceID);
		
		NSString *hypothesisString = [[NSString alloc] initWithFormat:@"%s",hypothesis];
		NSString *probabilityString = [[NSString alloc] initWithFormat:@"%d",probability];
		NSString *uttidString = [[NSString alloc] initWithFormat:@"%s",utteranceID];
		NSArray *hypothesisObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidReceiveHypothesis",hypothesisString,probabilityString,uttidString,nil];
		NSArray *hypothesisKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",@"Hypothesis",@"RecognitionScore",@"UtteranceID",nil];
		NSDictionary *userInfoDictionary = [[NSDictionary alloc] initWithObjects:hypothesisObjectsArray forKeys:hypothesisKeysArray];
		NSNotification *notification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionary];
		[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
		[userInfoDictionary release];
		[hypothesisObjectsArray release];
		[hypothesisKeysArray release];
		[hypothesisString release];
		[probabilityString release];
		[uttidString release];

		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
		
        if (startRecording(audioDevice) < 0) { // Start over.
			OpenEarsLog(@"startRecording failed");
			NSDictionary *userInfoDictionaryForContinuousSetupFailure = [NSDictionary dictionaryWithObject:@"PocketsphinxContinuousSetupDidFail" forKey:@"OpenEarsNotificationType"];
			NSNotification *notificationForContinuousSetupFailure = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForContinuousSetupFailure];
			[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notificationForContinuousSetupFailure waitUntilDone:NO];			
		}
		
		if(exitListeningLoop == 1) {
			break; // Break if we're trying to exit the loop.
		}
    }
	
	self.inMainRecognitionLoop = FALSE; // We broke out of the loop.
	exitListeningLoop = 0; // We don't want to prompt further exiting attempts since we're out.
	stopRecording(audioDevice); // Stop recording if necessary.
    cont_ad_close(continuousListener); // Close the continuous module.
    ps_free(pocketSphinxDecoder); // Free the decoder.
	closeAudioDevice(audioDevice); // Close the device, i.e. stop and dispose of the Audio Unit.

	OpenEarsLog(@"No longer listening.");	
	
	NSArray *stopListeningObjectsArray = [[NSArray alloc] initWithObjects:@"PocketsphinxDidStopListening",nil];
	NSArray *stopListeningKeysArray = [[NSArray alloc] initWithObjects:@"OpenEarsNotificationType",nil];
	NSDictionary *userInfoDictionaryForStop = [[NSDictionary alloc] initWithObjects:stopListeningObjectsArray forKeys:stopListeningKeysArray];
	NSNotification *stopNotification = [NSNotification notificationWithName:@"OpenEarsNotification" object:nil userInfo:userInfoDictionaryForStop];
	[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:stopNotification waitUntilDone:NO];
	[userInfoDictionaryForStop release];
	[stopListeningObjectsArray release];
	[stopListeningKeysArray release];

}


@end
