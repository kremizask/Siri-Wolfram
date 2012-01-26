//
//  MainViewController.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "MainViewController.h"
#import "SamplesViewController.h"
#import "SearchViewController.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc {
    
    [super dealloc];
}

- (IBAction)sampleButtonClicked:(id)sender {
    SamplesViewController *samplesViewController=[[SamplesViewController alloc] init];
    [self.navigationController pushViewController:samplesViewController animated:YES];
    [samplesViewController release];
}

- (IBAction)searchButtonClicked:(id)sender {
    SearchViewController *searchViewController=[[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
    [searchViewController release];
}
@end
