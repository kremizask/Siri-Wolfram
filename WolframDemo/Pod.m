//
//  Pod.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/19/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "Pod.h"
#import "ASIHTTPRequest.h"

@implementation Pod
@synthesize imageUrl, image, delegate;//, title;



- (void) dealloc {
//    [title release];
    [image release];
    [imageUrl release];
    [super dealloc];
}

- (void)setImageUrl:(NSString *)_imageUrl{
    if (_imageUrl == imageUrl)
        return;
    [imageUrl release];
    imageUrl = [_imageUrl retain];
    
    
    // Download the image
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setCompletionBlock:^{
        image=[[UIImage imageWithData:request.responseData] retain]; 
        [delegate podImageUpdated];
    }];
    [request startAsynchronous];
}

@end
