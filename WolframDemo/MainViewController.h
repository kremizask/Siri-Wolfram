//
//  MainViewController.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MainViewController : BaseViewController
- (IBAction)sampleButtonClicked:(id)sender;  // IBActions are methods connected to interface builders controls' touch events
- (IBAction)searchButtonClicked:(id)sender;  // An easy way to create them is to ctri+click on a control in IB and  
                                             // drag n drop to the owner classes header. To do this you need to use the helper editor 
@end                                         // and navigate to the corresponding header file
