//
//  AppDelegate.h
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioSessionManager.h" // Importing OpenEars' AudioSessionManager class header.

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    AudioSessionManager *audioSessionManager; // This is OpenEars' AudioSessionManager class. 
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) AudioSessionManager *audioSessionManager; // This is OpenEars' AudioSessionManager class.

@end
