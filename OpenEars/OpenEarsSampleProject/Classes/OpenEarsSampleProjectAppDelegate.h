//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  OpenEarsSampleProjectAppDelegate.h
//  OpenEarsSampleProject
//
//  OpenEarsSampleProjectAppDelegate is the app delegate of the OpenEars sample project.
//
//  Copyright Halle Winkler 2010,2011. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  This file is licensed under the Common Development and Distribution License (CDDL) Version 1.0
//  http://www.opensource.org/licenses/cddl1.txt or see included file license.txt
//  with the single exception to the license that you may distribute executable-only versions
//  of software using OpenEars files without making source code available under the terms of CDDL Version 1.0 
//  paragraph 3.1 if source code to your software isn't otherwise available, and without including a notice in 
//  that case that that source code is available. Exception applies exclusively to compiled binary apps such as can be
//  downloaded from the App Store, and not to frameworks or systems, to which the un-altered CDDL applies
//  unless other terms are agreed to by the copyright holder.
//
//  The only generally interesting thing to observe about this app delegate is that OpenEars' AudioSessionManager
//  should be instantiated here and left instantiated for the life of the app.  It will forward important information
//  about changes in the audio session like plugging/unplugging headphones or incoming calls to the OpenEarsEventsObserver
//  class.

// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// IMPORTANT NOTE: This version of OpenEars introduces a much-improved low-latency audio driver for recognition. However, it is no longer compatible with the Simulator.
// Because I understand that it can be very frustrating to not be able to debug application logic in the Simulator, I have provided a second driver that is based on
// Audio Queue Services instead of Audio Units for use with the Simulator exclusively. However, this is purely provided as a convenience for you: please do not evaluate
// OpenEars' recognition quality based on the Simulator because it is better on the device, and please do not report Simulator-only bugs since I only actively support 
// the device driver and generally, audio code should never be seriously debugged on the Simulator since it is just hosting your own desktop audio devices. Thanks!
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************
// ********************************************************************************************************************************************************************

#import <UIKit/UIKit.h>
#import "AudioSessionManager.h" // Importing OpenEars' AudioSessionManager class header.
@class TestViewController;

@class OpenEarsSampleProjectViewController;

@interface OpenEarsSampleProjectAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OpenEarsSampleProjectViewController *viewController;
	AudioSessionManager *audioSessionManager; // This is OpenEars' AudioSessionManager class. 
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OpenEarsSampleProjectViewController *viewController;
@property (nonatomic, retain) AudioSessionManager *audioSessionManager; // This is OpenEars' AudioSessionManager class.

@end