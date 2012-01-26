//
//  SamplesViewController.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "SamplesViewController.h"
#import "SampleCell.h"
#import "ResultsViewController.h"

@implementation SamplesViewController
@synthesize samples;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SamplesView" bundle:nil];
    if (self) {
        // initialize abd populate the samples property with the contents of sampleSearches.plist file (/resources/data)
        NSDictionary *data=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleSearches" ofType:@"plist"]];
        self.samples=[data valueForKey:@"searches"];
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.samples=nil;
}


- (void) dealloc {
    [samples release];
    [super dealloc];
}

#pragma mark - 
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [samples count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SampleCellIdentifier";
    
    SampleCell *cell = (SampleCell *) [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
    // if there is no Cell available to use, create a new one by loading the SampleCell nib
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SampleCell" 
													 owner:self options:nil];
		for (id oneObject in nib)
			if ([oneObject isKindOfClass:[SampleCell class]])
				cell = (SampleCell *)oneObject;
        cell.searchLabel.font=[UIFont fontWithName:kFont size:12];
    }
    cell.searchLabel.text=[samples objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - 
#pragma mark UITableViewDelegate
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a new ResultsViewController object set it's searchTerm property 
    // depending on the row selected and push it on the navigationController stack
    ResultsViewController *resultsViewController=[[ResultsViewController alloc] init];
    resultsViewController.searchTerm=[samples objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:resultsViewController animated:YES];
    [resultsViewController release];
}

#pragma mark - Action Methods

- (IBAction)backBtnClicked:(id)sender {
    // Pop the current controller from the navigationController stack in order
    // to go back to the previous controller
    [self.navigationController popViewControllerAnimated:YES];
}
@end
