//
//  Pod.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/19/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PodDelegate <NSObject>

- (void) podImageUpdated;

@end
@interface Pod : NSObject 
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, readonly) UIImage *image;
//@property (nonatomic, retain) NSString *title;
@end
