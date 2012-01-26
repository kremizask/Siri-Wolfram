//
//  AppDelegate.m
//  WolframDemo
//
//  Created by Kostas Kremizas on 1/18/12.
//  Copyright (c) 2012 kremizask@niobiumlabs.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ResultsViewController.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window = _window, audioSessionManager;



- (void)dealloc
{
    [audioSessionManager release];
    [_window release];
    [super dealloc];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Family names:%@",[UIFont familyNames]);
    NSLog(@"Fonts:%@", [UIFont fontNamesForFamilyName:@"PF Highway Gothic Ext"]);
    // PFHighwayGothicExtLight
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    MainViewController *mainViewController=[[MainViewController alloc] init];

    UINavigationController *navCon=[[UINavigationController alloc] initWithRootViewController:mainViewController];
    [navCon setNavigationBarHidden:YES];
    [mainViewController release];
    self.window.rootViewController=navCon;
    [navCon release];
    
    
//    ResultsViewController *resultsViewController=[[ResultsViewController alloc] init];
//    self.window.rootViewController=resultsViewController;
//    [resultsViewController release];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Voice Recognition methods

// Lazily instantiated AudioSessionManager object. This class can definitely only be instantiated as an object once in the app, so this is a pretty safe way to allocate it.
- (AudioSessionManager *)audioSessionManager {
	if (audioSessionManager == nil) {
		audioSessionManager = [[AudioSessionManager alloc] init];
	}
	return audioSessionManager;
}

@end
