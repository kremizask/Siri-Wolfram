//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  ContinuousModel.h
//  OpenEars
//
//  ContinuousModel is a class which consists of the continuous listening loop used by Pocketsphinx.
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

//  This class is _never_ directly accessed by a project making use of OpenEars.

@interface ContinuousModel : NSObject {

	BOOL exitListeningLoop; // Should we break out of the loop?
	BOOL inMainRecognitionLoop; // Have we entered the recognition loop or are we still setting up or in a state of having exited?
	BOOL thereIsALanguageModelChangeRequest;
	NSString *languageModelFileToChangeTo;
	NSString *dictionaryFileToChangeTo;
}

- (void) listeningLoopWithLanguageModelAtPath:(NSString *)languageModelPath dictionaryAtPath:(NSString *)dictionaryPath languageModelIsJSGF:(BOOL)languageModelIsJSGF; // Start the loop.
- (void) changeLanguageModelToFile:(NSString *)languageModelPathAsString withDictionary:(NSString *)dictionaryPathAsString;

- (CFStringRef) getCurrentRoute;
- (void) setCurrentRouteTo:(NSString *)newRoute;

- (int) getRecognitionIsInProgress;
- (void) setRecognitionIsInProgressTo:(int)recognitionIsInProgress;

- (int) getRecordData;
- (void) setRecordDataTo:(int)recordData;

- (float) getMeteringLevel;

@property (nonatomic, assign) BOOL exitListeningLoop; // Should we break out of the loop?
@property (nonatomic, assign) BOOL inMainRecognitionLoop; // Have we entered the recognition loop or are we still setting up or in a state of having exited?
@property (nonatomic, assign) BOOL thereIsALanguageModelChangeRequest;
@property (nonatomic, retain) NSString *languageModelFileToChangeTo;
@property (nonatomic, retain) NSString *dictionaryFileToChangeTo;


@end
