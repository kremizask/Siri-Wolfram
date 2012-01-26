//
//  ResultsViewController.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pod.h"
#import "BaseViewController.h"
@class ASIHTTPRequest;


@interface ResultsViewController : BaseViewController <UIWebViewDelegate, PodDelegate, UITableViewDataSource, UITableViewDelegate> {
    BOOL first;
    UIView *aView;
}
@property (nonatomic, retain) NSString *searchTerm;
//@property (nonatomic, retain) UIWebView *webView; // If you want to use the to use the html elements
                                                    // response of the WolframAlpha API and display it in 
                                                    // a uiwebview instead of a UITableView uncomment all the 
                                                    // UIWebView code and comment out all the UITableView code

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *imageViews;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableDictionary *pods;
@end
