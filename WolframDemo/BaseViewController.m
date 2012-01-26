//
//  BaseViewController.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController (Private)
- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;

@end

@implementation BaseViewController
@synthesize progressView;
@synthesize activityLabel;

- (void)viewDidLoad {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProgressView" owner:self options:nil];
    
    NSEnumerator *enumerator = [nib objectEnumerator];
    id object;
    
    while ((object = [enumerator nextObject])) {
        if ([object isMemberOfClass:[UIView class]]) {
            self.progressView =  (UIView *)object;
        }
    }    
    [super viewDidLoad];
}

- (void)showNetworkActivity {
    [self showLoadingIndicatorsWithMessage:@"Loading"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;    
}

- (void)hideNetworkActivity {
    [self hideLoadingIndicators];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)dealloc {
    [activityLabel release];
    [super dealloc];
}


// loading indicator


- (void)showLoadingIndicatorsWithMessage:(NSString *)message {
    activityLabel.text=message;
    self.progressView.center = CGPointMake(160, 182);
    [self.view addSubview:progressView];
}

- (void)hideLoadingIndicators
{
    [self.progressView removeFromSuperview];    
}

- (void)viewDidUnload {
    [self setActivityLabel:nil];
    [super viewDidUnload];
}
@end
