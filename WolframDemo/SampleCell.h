//
//  SampleCell.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/20/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleCell : UITableViewCell

// IBOutlets are properties that are connected to interface builders views.
// By changing programmatically an IBOutlet property, you change the corresponding view in the xib file
@property (retain, nonatomic) IBOutlet UILabel *searchLabel; // IBOutlets are properties that are connected to interface builders views.
// IBActions are methods connected to interface builders controls' touch events
// An easy way to create both IBOutlets and IBActions is to ctri+click on a control 
// in IB and drag n drop to the owner classes header. To do this you need to use the helper editor 
// navigate to the corresponding header file
//
- (IBAction)searchButtonClicked:(id)sender;
@end
