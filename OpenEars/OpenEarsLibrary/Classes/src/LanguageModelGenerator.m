//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  LanguageModelGenerator.m
//  OpenEars
//
//  LanguageModelGenerator is a class which creates new grammars
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

#import "LanguageModelGenerator.h"
#import "OpenEarsErrorDictionary.h"
#import "GraphemeGenerator.h"
#import "MITLMModel.h"

@implementation LanguageModelGenerator

- (NSError *) generateLanguageModelFromArray:(NSArray *)languageModelArray withFilesNamed:(NSString *)fileName {
	// First check to see if there is anything in the array to convert -- an empty array or an array with only whitespace characters should return an error.
	if([languageModelArray count] < 1 || [[[languageModelArray componentsJoinedByString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] < 1) {
		return kOpenEarsErrorLanguageModelHasNoContent;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSError *error = nil; // Used throughout the method
	
	// Create a corpus so MITLM has something to process
	BOOL writeSuccess = [[languageModelArray componentsJoinedByString:@"\n"] writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.corpus",fileName]] atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	if (!writeSuccess){
		// Handle error here
		OpenEarsLog(@"Error: %@", error);

		return error; // End method early for any fatal error
	}

	OpenEarsLog(@"Starting dynamic language model generation"); 
#ifdef OPENEARSLOGGING
	NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate]; // If logging is on, let's time the language model processing time so the developer can profile it.
#endif

	MITLMModel *mitLMModel = [[MITLMModel alloc]init]; // First, use the MITLM port to create a language model
	[mitLMModel runMitLMOnCorpusFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.corpus",fileName]]];
	[mitLMModel release];

	NSError *deleteCorpusError = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager]; // Let's make a best effort to erase the corpus now that we're done with it, but we'll carry on if it gives an error.
	[fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.corpus",fileName]] error:&deleteCorpusError];
	if(deleteCorpusError != 0) {
		OpenEarsLog(@"Error while deleting language model corpus: %@", deleteCorpusError);
	}
	
	NSMutableArray *mutableDictionaryArray = [[NSMutableArray alloc] init]; // Now create a dictionary file from the same array

	// In order to maintain backwards compatibility, this is all done with NSScanners/NSSet/fast enumeration and it seems to be fast enough. Otherwise it would need to be some combination of a third-party regex solution and NSRegularExpression with all the attendant app submission drama, and NSScanner does very well on these pre-limited ranges so I think this works.
	
	int index = 0;
	for(NSString *string in languageModelArray) {  // For every array entry, if...
		if([string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location == NSNotFound) { // ...the string contains no spaces or returns of any variety, i.e. it's a single word, put it into a mutable array entry by itself
			[mutableDictionaryArray addObject:[[[string componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]]componentsJoinedByString:@""]uppercaseString]]; // only add letters and numbers
			
		} else { // ...otherwise create a temporary array which consists of all the whitespace-separated stuff, separated by its whitespace, and append that array's contents to the end of the mutable array
			NSArray *temporaryExplosionArray = [[NSArray alloc] initWithArray:[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

			for(NSString *wordString in temporaryExplosionArray) {
				[mutableDictionaryArray addObject:[[[wordString componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]]componentsJoinedByString:@""]uppercaseString]]; // only add letters and numbers; if there's something else in there, toss it.
			}
			[temporaryExplosionArray release];
		}

		index++;
	}

	// Let's remove all the duplicate words and sort the results alphabetically
	
	NSArray *arrayWithNoDuplicates = [[NSSet setWithArray:mutableDictionaryArray] allObjects]; // Remove duplicate words through the magic of NSSet

	NSArray *sortedArray = [[NSArray alloc] initWithArray:[arrayWithNoDuplicates sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]]; // Alphabetic sort

	NSRange nonRange = {0,1618}; // I have calculated all of the letter ranges in cmu07a.dic ahead of time so we just scan a specific letter range. This lets NSScanner have comparable results with a regex search
	NSRange aRange = {nonRange.location + nonRange.length,184807};
	NSRange bRange = {aRange.location + aRange.length,218828};
	NSRange cRange = {bRange.location + bRange.length,276254};
	NSRange dRange = {cRange.location + cRange.length,193003};
	NSRange eRange = {dRange.location + dRange.length,125144};
	NSRange fRange = {eRange.location + eRange.length,122367};
	NSRange gRange = {fRange.location + fRange.length,131982};
	NSRange hRange = {gRange.location + gRange.length,154022};
	NSRange iRange = {hRange.location + hRange.length,103438};
	NSRange jRange = {iRange.location + iRange.length,37122};
	NSRange kRange = {jRange.location + jRange.length,88859};
	NSRange lRange = {kRange.location + kRange.length,121489};
	NSRange mRange = {lRange.location + lRange.length,235031};
	NSRange nRange = {mRange.location + mRange.length,72766};
	NSRange oRange = {nRange.location + nRange.length,72337};
	NSRange pRange = {oRange.location + oRange.length,211315};
	NSRange qRange = {pRange.location + pRange.length,11595};
	NSRange rRange = {qRange.location + qRange.length,180242};
	NSRange sRange = {rRange.location + rRange.length,331677};
	NSRange tRange = {sRange.location + sRange.length,131260};
	NSRange uRange = {tRange.location + tRange.length,50495};
	NSRange vRange = {uRange.location + uRange.length,56477};
	NSRange wRange = {vRange.location + vRange.length,98311};
	NSRange xRange = {wRange.location + wRange.length,1598};
	NSRange yRange = {xRange.location + xRange.length,14528};
	NSRange zRange = {yRange.location + yRange.length,18779};
	
	// Load the pronunciation dictionary from the Pocketsphinx distribution
	NSString *pronunciationDictionary = [[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/cmu07a.dic",[[NSBundle mainBundle] resourcePath]] encoding:NSUTF8StringEncoding error:&error];
	
	
	if (error) { // If we can't load it, return an error immediately
		[mutableDictionaryArray release];
		[sortedArray release];
		[pronunciationDictionary release];
		return error;
	}
	
	GraphemeGenerator *graphemeGenerator = [[GraphemeGenerator alloc] init]; // This uses Flite to generate a pronunciation for any word that isn't present in the dictionary. It is a fallback in order to be able to deliver 100% coverage but by definition it is much slower than the dictionary lookup and the pronunciations are likely to be slow, best-guess and less accurate.
	
	NSMutableArray *dictionaryMutableArray = [[NSMutableArray alloc] init];
	
	for (NSString *dictionaryEntry in sortedArray) {	//for every entry in the unigram array for the dictionary
		
        NSAutoreleasePool *dictionaryCreationPool = [[NSAutoreleasePool alloc] init]; // pool is created
        
		NSString *firstLetter = [dictionaryEntry substringToIndex:1];
		NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		NSRange alphabetRange = [alphabet rangeOfString:firstLetter];
		int letterInAlphabet = alphabetRange.location + 1;
		
		NSRange limitingRange;
		NSRange fullRange = {0,3242613};
		switch (letterInAlphabet) { // This is a switch based on the alphabet letter than starts the word
			case 1:limitingRange = aRange;break;
			case 2:limitingRange = bRange;break;
			case 3:limitingRange = cRange;break;
			case 4:limitingRange = dRange;break;
			case 5:limitingRange = eRange;break;
			case 6:limitingRange = fRange;break;
			case 7:limitingRange = gRange;break;
			case 8:limitingRange = hRange;break;
			case 9:limitingRange = iRange;break;
			case 10:limitingRange = jRange;break;
			case 11:limitingRange = kRange;break;
			case 12:limitingRange = lRange;break;
			case 13:limitingRange = mRange;break;
			case 14:limitingRange = nRange;break;
			case 15:limitingRange = oRange;break;
			case 16:limitingRange = pRange;break;
			case 17:limitingRange = qRange;break;
			case 18:limitingRange = rRange;break;
			case 19:limitingRange = sRange;break;
			case 20:limitingRange = tRange;break;
			case 21:limitingRange = uRange;break;
			case 22:limitingRange = vRange;break;
			case 23:limitingRange = wRange;break;
			case 24:limitingRange = xRange;break;
			case 25:limitingRange = yRange;break;
			case 26:limitingRange = zRange;break;
			default:limitingRange = fullRange;break;
			break;
		}
		
		NSString *stringToMatch = [NSString stringWithFormat:@"\n%@\t",dictionaryEntry]; // This searches for the first four pronunciation variables. There aren't more than 4 pronunciations in the dictionary so this should suffice.
		NSString *stringToMatch1 = [NSString stringWithFormat:@"\n%@(2)\t",dictionaryEntry];
		NSString *stringToMatch2 = [NSString stringWithFormat:@"\n%@(3)\t",dictionaryEntry];
		NSString *stringToMatch3 = [NSString stringWithFormat:@"\n%@(4)\t",dictionaryEntry];
		
		NSString *foundString = nil;
		NSString *foundString1 = nil;
		NSString *foundString2 = nil;
		NSString *foundString3 = nil;
		
		NSScanner *scanner = [[NSScanner alloc] initWithString:[pronunciationDictionary substringWithRange:limitingRange]];
		[scanner setCaseSensitive:FALSE];
		[scanner scanUpToString:stringToMatch intoString:nil]; // Do the scan within the limiting range
		[scanner scanUpToString:@"\n" intoString:&foundString]; // put the results up to the linebreak into found string
		int position = [scanner scanLocation] - 1; // set position back 1 for the next scan
		[scanner release];
		
		if([foundString length] < 1) { // nothing found, using phonemefactory to generate an estimated pronunciation using Flite				
			foundString = [[[NSString stringWithFormat:@"%@\t%@",dictionaryEntry,[[[[graphemeGenerator convertGraphemes:dictionaryEntry]stringByReplacingOccurrencesOfString:@"ax" withString:@"ah"] uppercaseString]stringByReplacingOccurrencesOfString:@"PAU " withString:@""]]uppercaseString]stringByReplacingOccurrencesOfString:@" \n" withString:@"\n"];
		} else { // found a pronunciation. If 1 pronunciation found in dictionary, look for 2:
			
			//We are always short-circuiting this process when we don't find the next pronunciation so we only have a danger of doing one pointless check.
			NSRange abbreviatedRange = {limitingRange.location + position, 250}; // In order to keep this one potential wasted check ultra-cheap, we only search in the next 250 characters for an alternate pronunciation. We use a new scanner because we don't want a failed alternate pronunciation check to change the position of our main scanner.
			
			NSScanner *scanner1 = [[NSScanner alloc] initWithString:[pronunciationDictionary substringWithRange:abbreviatedRange]];
			[scanner1 scanUpToString:stringToMatch1 intoString:nil];
			[scanner1 scanUpToString:@"\n" intoString:&foundString1];
			[scanner1 setScanLocation:[scanner1 scanLocation]-1];
			[scanner1 release];
			
			if([foundString1 length] >= 1) {// If 2 pronunciations found in dictionary, look for 3
				
				NSScanner *scanner2 = [[NSScanner alloc] initWithString:[pronunciationDictionary substringWithRange:abbreviatedRange]];
				[scanner2 scanUpToString:stringToMatch2 intoString:nil];
				[scanner2 scanUpToString:@"\n" intoString:&foundString2];
				[scanner2 setScanLocation:[scanner2 scanLocation]-1];
				[scanner2 release];
				
				if([foundString2 length] >= 1) {// If 3 pronunciations found in dictionary, look for 4. 
					
					NSScanner *scanner3 = [[NSScanner alloc] initWithString:[pronunciationDictionary substringWithRange:abbreviatedRange]];
					[scanner3 scanUpToString:stringToMatch3 intoString:nil];
					[scanner3 scanUpToString:@"\n" intoString:&foundString3];
					[scanner3 setScanLocation:[scanner3 scanLocation]-1];
					[scanner3 release];
				}
			}
		}
		
		// Add any results of this process to the mutable array in uppercase form.
		
		if([foundString length] > 0 &&[foundString length] < 400)[dictionaryMutableArray addObject:[NSString stringWithFormat:@"%@",[foundString uppercaseString]]];
		if([foundString1 length] > 0 &&[foundString1 length] < 400)[dictionaryMutableArray addObject:[NSString stringWithFormat:@"%@",[foundString1 uppercaseString]]];
		if([foundString2 length] > 0 &&[foundString2 length] < 400)[dictionaryMutableArray addObject:[NSString stringWithFormat:@"%@",[foundString2 uppercaseString]]];
		if([foundString3 length] > 0 &&[foundString3 length] < 400)[dictionaryMutableArray addObject:[NSString stringWithFormat:@"%@",[foundString3 uppercaseString]]];
        
        [dictionaryCreationPool release];
	}
	
	[pronunciationDictionary release];
	[graphemeGenerator release];
	
	// Write out the mutable array as a dictionary file in the documents directory
	writeSuccess = [[dictionaryMutableArray componentsJoinedByString:@"\n"] writeToFile:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dic",fileName]] atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	if (!writeSuccess){ // If this fails, return an error.
		// Handle error here
		OpenEarsLog(@"Error: %@", error);
		[dictionaryMutableArray release];
		[sortedArray release];
		[mutableDictionaryArray release];
		return error;
	}
	[dictionaryMutableArray release];
	[mutableDictionaryArray release];
	[sortedArray release];
	
	OpenEarsLog(@"I'm done running dynamic language model generation and it took %f seconds", [NSDate timeIntervalSinceReferenceDate] - start); // Deliver the timing info if logging is on.

	// When this method succeeds, it returns a userInfo dictionary with its NSError that contains the locations of the newly-created files, just so you can verify where they ought to be if you are having issues.
	
	NSArray *objectsArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@.languagemodel",fileName],[NSString stringWithFormat:@"%@.dic",fileName],[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.languagemodel",fileName]],[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dic",fileName]],nil];
	NSArray *keysArray = [NSArray arrayWithObjects:@"LMFile",@"DictionaryFile",@"LMPath",@"DictionaryPath",nil];
							 
	NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keysArray];
							 
	return [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfoDictionary]; // Return the code-0 error with the paths in the userInfo dictionary.
}






@end
