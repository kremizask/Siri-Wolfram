//  OpenEars version 0.913
//  http://www.politepix.com/openears
//
//  OpenEarsSampleProjectAppDelegate.m
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

#import "OpenEarsSampleProjectAppDelegate.h"
#import "OpenEarsSampleProjectViewController.h"

@implementation OpenEarsSampleProjectAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize audioSessionManager; // AudioSessionManager.

#pragma mark -
#pragma mark Lazy Accessors

// Lazily instantiated AudioSessionManager object. This class can definitely only be instantiated as an object once in the app, so this is a pretty safe way to allocate it.
- (AudioSessionManager *)audioSessionManager {
	if (audioSessionManager == nil) {
		audioSessionManager = [[AudioSessionManager alloc] init];
	}
	return audioSessionManager;
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	// This is how you initialize the audio session using OpenEars' AudioSessionManager. If you don't do this early on, you will have strange behavior from Pocketsphinx and Flite
	// and other symptoms such as extremely quiet recording or playback. I consider didFinishLaunchingWithOptions: to be a good location for it.
	
	// You also have to take care to not re-initialize the audio session (for instance, sometimes developers put audio session code in invocations of 
	// AVAudioPlayer where it isn't necessary). Doing this will override AudioSessionManager and it will cause Flite and Pocketsphinx to not work. If you have symptoms of not having
	// the audio session set correctly (quiet playback, Flite or Pocketsphinx not working at all on the device), do a case-insensitive search of your app for the term "audiosession"
	// and comment out anything that isn't the statement below or part of OpenEars' AudioSessionManager interface and implementation. Generally speaking, in any iOS app there should 
	// only be a single initialization of audio session settings (which OpenEars for you using AudioSessionManager when you message it with startAudioSession).
	
	[self.audioSessionManager startAudioSession];
	
    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
	[audioSessionManager release];
    [super dealloc];
}


@end
