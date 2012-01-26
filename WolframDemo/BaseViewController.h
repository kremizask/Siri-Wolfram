//
//  BaseViewController.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

// We use this class as a parent class for our controllers so that we can display loading indicators when necessary

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController {
    UIView *progressView;
}
@property (retain, nonatomic) UIView *progressView;
@property (retain, nonatomic) IBOutlet UILabel *activityLabel;

- (void)showNetworkActivity;
- (void)hideNetworkActivity;
- (void)showLoadingIndicatorsWithMessage:(NSString *)message;
- (void)hideLoadingIndicators;

@end
