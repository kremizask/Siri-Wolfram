//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  GraphemeGenerator.m
//  OpenEars
// 
//  GraphemeGenerator is a class which creates pronunciations for words which aren't in the dictionary
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

#import "GraphemeGenerator.h"
#import "flite.h"

cst_voice *v;
@implementation GraphemeGenerator

void unregister_cmu_us_slt8k(cst_voice *vox);
cst_voice *register_cmu_us_slt8k(const char *voxdir);

- (void)dealloc {
	unregister_cmu_us_slt8k(v);

    [super dealloc];
}

- (id) init 
{
    self = [super init];
    if (self)
    {
		flite_init();
		
		cst_voice *desired_voice = 0;
		
		cst_features *extra_feats;
		
		extra_feats = new_features();
		
		flite_voice_list = cons_val(voice_val(register_cmu_us_slt8k(NULL)),flite_voice_list);
		
		feat_set_string(extra_feats,"print_info_relation","Segment");
		
		if (desired_voice == 0) desired_voice = flite_voice_select(NULL);
		
		v = desired_voice;
		feat_copy_into(extra_feats,v->features);
		
		delete_features(extra_feats);
		flite_voice_list=0;
    }
    return self;
}


- (NSString *) convertGraphemes:(NSString *)phrase {
	
	OpenEarsLog(@"Using convertGraphemes for the word or phrase %@ which doesn't appear in the dictionary", phrase);
	
    cst_utterance *u = flite_synth_text((char *)[phrase UTF8String],v);

	NSMutableString *phonesMutableString = [[NSMutableString alloc] init];
	cst_item *item;
	
	const char *relname = utt_feat_string(u,"print_info_relation");
    for (item=relation_head(utt_relation(u,relname)); 
		 item; 
		 item=item_next(item))
    {
		NSString *bufferString = [[NSString alloc] initWithCString:item_feat_string(item,"name")];
		[phonesMutableString appendString:[NSString stringWithFormat:@"%@ ",bufferString]];
		[bufferString release];
    }
	
	const char *destinationString = [(NSString *)phonesMutableString UTF8String];
	[phonesMutableString release];
	
    delete_utterance(u);
	
	NSString *stringToReturn = [[[NSString alloc] initWithCString:destinationString]autorelease];
	return stringToReturn;
}

@end

