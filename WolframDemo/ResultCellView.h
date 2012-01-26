//
//  SearchCellView.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pod.h"
#define kCellPaddingTop 10.0
#define kCellPaddingBottom 10.0

@interface ResultCellView : UITableViewCell {
    UIImageView *separatorImageView;
}
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) UIImageView *imageView;

- (void) setPod:(Pod *)pod;
@end
