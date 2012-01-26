//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  OpenEarsConfig.h
//  OpenEars
//
//  OpenEarsConfig.h controls all of the OpenEars settings other than which voice to use for Flite, which is controlled by OpenEarsVoiceConfig.h
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

// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// IMPORTANT NOTE: This version of OpenEars introduces a much-improved low-latency audio driver for recognition. However, it is no longer compatible with the Simulator.
// Because I understand that it can be very frustrating to not be able to debug application logic in the Simulator, I have provided a second driver that is based on
// Audio Queue Services instead of Audio Units for use with the Simulator exclusively. However, this is purely provided as a convenience for you: please do not evaluate
// OpenEars' recognition quality based on the Simulator because it is better on the device, and please do not report Simulator-only bugs since I only actively support 
// the device driver and generally, audio code should never be seriously debugged on the Simulator since it is just hosting your own desktop audio devices. Thanks!
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************

#import "OpenEarsVoiceConfig.h"

//#define OPENEARSLOGGING // Turn this on to get logging output from audio driver initialization, etc. Please turn on and submit output when reporting a problem.
//#define VERBOSEPOCKETSPHINX // Leave this uncommented to get verbose output from Pocketsphinx, comment it out for quiet operation. I'd recommend starting with it uncommented and then commenting when you're pretty sure things are working.
//#define VERBOSEMITLM // Leave this uncommented to get more output from language model generation
//#define USERCANINTERRUPTSPEECH // Turn this on if you wish to let users cut off Flite speech by talking (only possible when headphones are plugged in). Not sure if this is 100% functional in v 0.913
#define kSecondsOfSilenceToDetect .7 // This is the amount of time that Pocketsphinx should wait before deciding that an utterance is complete and trying to decode it as speech. Make it longer (for instance 1.0 to have decoding take place after a second of silence, which is the Pocketsphinx default) if you find Pocketsphinx isn't letting your users finish sentences, make it shorter if you only use a small number of single words in your command and control grammar and want more responsiveness. Do not comment, this is not an optional constant.
