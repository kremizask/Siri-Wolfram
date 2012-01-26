//
//  ResultsViewController.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "ResultsViewController.h"
#import "ASIHTTPRequest.h"
#import "TouchXML.h"
#import "ResultCellView.h"
#import "Pod.h"
@interface ResultsViewController()
- (void) parseXMLString:(NSData *)xmlData;
@end

@implementation ResultsViewController
@synthesize tableView, imageViews, images, pods, searchTerm;
//@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageViews=[NSMutableArray arrayWithCapacity:20];
        self.images=[NSMutableArray arrayWithCapacity:20];
        self.pods=[NSMutableDictionary dictionaryWithCapacity:20];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)loadView
{

    // We override this method in order to 
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = view;
    [view release];
    
    //Init Webview
//    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    webView.delegate = self;
//    webView.scalesPageToFit=YES;
//    [view addSubview:webView];
    

    

    // background
    UIImage *bgImage=[UIImage imageNamed:@"results_bg.png"];
    UIImageView *bgImageView=[[UIImageView alloc] initWithImage:bgImage];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    // back button
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnNormalImage=[UIImage imageNamed:@"back_btn_normal.png"];
    [backBtn setImage:backBtnNormalImage forState:UIControlStateNormal];
    UIImage *backBtnHighlightedImage=[UIImage imageNamed:@"back_btn_selected.png"];
    [backBtn setImage:backBtnHighlightedImage forState:UIControlStateHighlighted];
    backBtn.frame=CGRectMake(12, 10, backBtnNormalImage.size.width, backBtnNormalImage.size.height);
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // search label
    UILabel *searchLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 83, 247, 39)];
    searchLabel.font=[UIFont fontWithName:kFont size:12];
    searchLabel.text=searchTerm;
    searchLabel.textColor=[UIColor colorWithRed:47.0/255 green:47.0/255 blue:47.0/255 alpha:1.0];
    searchLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:searchLabel];
    [searchLabel release];
    
    // tableView
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 132, 320, 460-132) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    

}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Make Wolfram Alpha API call
    NSString *urlString=[NSString stringWithFormat:@"http://api.wolframalpha.com/v2/query?appid=KT6V2Y-HTU8RA8X3R&input=%@&format=image", searchTerm];
    ;
    NSLog(@"url request:%@", urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setCompletionBlock:^{
        // this code will be executed as soon as the response arrives, provided that the request succeeded.
        [self parseXMLString:request.responseData];
        [self hideLoadingIndicators];
    }];
    [request setFailedBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@""
                              message:NSLocalizedString(@"Request Failed!.", @"Request failure alert message.") 
                              delegate:nil 
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Request failure alert OK.") 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }];
    [request startAsynchronous];
    // Display loading indicators (BaseViewController method. cmd+click on method name below to go to definition)
    [self showLoadingIndicatorsWithMessage:@"Loading..."];
}


- (void)viewDidUnload
{
    self.searchTerm=nil;
    self.imageViews=nil;
    [super viewDidUnload];
    self.tableView=nil;
//    webView.delegate=nil;
//    self.webView=nil;
}

- (void) dealloc {
    [searchTerm release];
    [pods release];
    [imageViews release];
    [tableView release];
//    [webView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) parseXMLString:(NSData *)xmlData {
    
//////////////////////////////////////////////////////////////////////////////////////////////    
    
//    uncomment this code and comment out the 
//    rest of the method's code for usage with UIWebView
    
    
//    NSMutableString *htmlString=[NSMutableString stringWithFormat:
//                                 @"<html> "
//                                 "<head></head> "
//                                 "<body> "];
//    
//    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:xmlData options:0 error:nil];
//    NSArray *scripts = [doc nodesForXPath:@"//queryresult/script" error:nil];
//    for (CXMLElement *script in scripts) {
//        [htmlString appendFormat:script.stringValue];
//    }
//    
//    // use cssTags if you want to use the css privided by the API
//    NSArray *cssTags = [doc nodesForXPath:@"//queryresult/css" error:nil];
//    for (CXMLElement *css in cssTags) {
//        [htmlString appendFormat:css.stringValue];
//    }
//    
//    NSArray *pods = [doc nodesForXPath:@"//queryresult/pod/markup" error:nil];
//    for (CXMLElement *pod in pods) {
//        [htmlString appendFormat:pod.stringValue];
//    }
//    [htmlString appendFormat:@"</body></html>"];
//    [webView loadHTMLString:htmlString baseURL:nil];
//    [doc release];
    
//////////////////////////////////////////////////////////////////////////////////////////////    
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    NSArray *scripts = [doc nodesForXPath:@"//queryresult/pod/subpod/img" error:nil];
    int i=0;
    for (CXMLElement *script in scripts) {
        NSString *imageUrl=[script attributeForName:@"src"].stringValue;
        
        
        Pod *pod=[[Pod alloc] init];
        pod.imageUrl=imageUrl;
        pod.delegate=self;
        [pods setObject:pod forKey:[NSIndexPath indexPathForRow:i inSection:0]];
        [pod release];
        
        i++;
    }
    [doc release];

}

#pragma mark - 
#pragma mark UITableViewDataSource

// We have only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// The number of rows is equal to the number od pods of the API response
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pods count];
}


// This method sould return the height of the cell for a specific indexPath
// Since a cell's height depends on the cell's image, we calculate it.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pod *currentPod=[pods objectForKey:indexPath];
    UIImage *separatorImage=[UIImage imageNamed:@"results_cell_separator.png"];

    if (currentPod.image==nil) {
        UIImage *defaultImage=[UIImage imageNamed:@"results_default_image.png"];
        return defaultImage.size.height+kCellPaddingTop+kCellPaddingBottom+separatorImage.size.height;
    }
    NSLog(@"currentPod.image.size.height:%f", currentPod.image.size.height+kCellPaddingTop+kCellPaddingBottom+separatorImage.size.height);
    NSLog(@"image:%f, kCellPaddingTop:%f, kCellPaddingBottom:%f, separatorImage:%f", currentPod.image.size.height,kCellPaddingTop,kCellPaddingBottom,separatorImage.size.height);
    return currentPod.image.size.height+kCellPaddingTop+kCellPaddingBottom+separatorImage.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ResultPodCell";
    
    ResultCellView *cell = (ResultCellView *) [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[[ResultCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    
    Pod *currentPod=[pods objectForKey:indexPath];
    [cell setPod:currentPod];
    return cell;
}


#pragma mark - PodDelegate Methods
// Called by the Pod when it's image has downloaded
- (void) podImageUpdated {
    [self.tableView reloadData];
}

#pragma mark - Action methods

- (void) backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
