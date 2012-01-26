//
//  SearchCellView.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "ResultCellView.h"


@implementation ResultCellView
@synthesize imageUrl, imageView;


// Initialize the cell and add imageView and separatorImageView as subviews
//
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        imageView=[[UIImageView alloc] initWithFrame:CGRectZero]; //We will change the frame later in setPod according to the image size
        [self.contentView addSubview:imageView];
        
        UIImage *separatorImage=[UIImage imageNamed:@"results_cell_separator.png"];
        separatorImageView=[[UIImageView alloc] initWithImage:separatorImage];
        [self.contentView addSubview:separatorImageView];        
        
    }
    return self;
}


- (void) dealloc {
    [separatorImageView release];
    [imageView release];
    [super dealloc];
}


- (void)setPod:(Pod *)pod{
    UIImage *image=pod.image;
    if (image==nil) {
        
    //  if the image is nil because it has not downloaded yet, use a default image
        UIImage *defaultImage=[UIImage imageNamed:@"results_default_image.png"];
        imageView.image=defaultImage;
        
    //  define the imageView frame
        CGRect imageViewFrame=imageView.frame;
        imageViewFrame.size=defaultImage.size;
        imageViewFrame.origin.x=floorf((320-defaultImage.size.width)/2.0);
        imageViewFrame.origin.y=kCellPaddingTop;
        imageView.frame=imageViewFrame;
    }
    else {
    // set the new image and define the imageView frame
    
        imageView.image=image;
        CGRect imageViewFrame=imageView.frame;
        imageViewFrame.origin.x=0;
        imageViewFrame.origin.y=kCellPaddingTop;
        if (image.size.width>320) {
            imageViewFrame.size=CGSizeMake(320.0, floorf(320.0*image.size.height/image.size.width));
            
        }
        else {
            imageViewFrame.size=image.size;
        }
    
    imageView.frame=imageViewFrame;
    }
    
    // set the separator image frame origin
    CGRect separatorFrame=separatorImageView.frame;
    separatorFrame.origin.x=floorf((320.0-separatorFrame.size.width)/2.0);
    separatorFrame.origin.y=kCellPaddingTop+imageView.frame.size.height+kCellPaddingBottom;
    separatorImageView.frame=separatorFrame;
    
}

@end
