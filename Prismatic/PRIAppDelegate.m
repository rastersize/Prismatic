//
//  PRIAppDelegate.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIAppDelegate.h"
#import "PRIStyleController.h"
#import "PRIPrintClient.h"
#import <Crashlytics/Crashlytics.h>
#import "AFNetworkActivityIndicatorManager.h"


@implementation PRIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Crashlytics startWithAPIKey:@"bede20b91f373b5268c4ce52bf52d6a0fbeb391b"];
	[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
	[PRIPrintClient.sharedClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		NSString *statusString = @"unknown";
		if (status == AFNetworkReachabilityStatusNotReachable) {
			statusString = @"not reachable";
		} else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
			statusString = @"reachable via WWAN";
		} else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
			statusString = @"reachable via Wi-Fi";
		}
		DLog(@"network reachability changed to %@", statusString);
	}];
	
	[PRIStyleController applyStyles];
	
	DLog(@"%@", launchOptions);
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
		UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
		splitViewController.delegate = (id)navigationController.topViewController;
	}
	
	return YES;
}
					
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	DLog(@"url = %@; sourceApp: %@; annotation: %@", url, sourceApplication, annotation);
	
	return NO;
}

@end
