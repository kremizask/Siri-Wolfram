//
//  SamplesViewController.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SamplesViewController : UIViewController
@property (nonatomic, retain) NSArray *samples;
- (IBAction)backBtnClicked:(id)sender;
@end
