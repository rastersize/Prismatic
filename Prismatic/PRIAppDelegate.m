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

#import "NSString+PRIURLHelpers.h"

#import "PRIPrintViewController.h"

#import "AFNetworkActivityIndicatorManager.h"
#import <JLRoutes/JLRoutes.h>
#import <Crashlytics/Crashlytics.h>


@implementation PRIAppDelegate

+ (instancetype)sharedAppDelegate
{
	return UIApplication.sharedApplication.delegate;
}

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
	return [JLRoutes routeURL:url];
}

+ (BOOL)openURL:(NSURL *)url
{
	return [[UIApplication sharedApplication] openURL:url];
}

+ (BOOL)showPrintViewForFile:(PRIFile *)file
{
	NSURL *url = nil;//[NSURL URLWithString:[NSString stringWithFormat:@"x-prismatic://print/id/", ]];
	return [self openURL:url];
}

+ (void)setUpAppRoutes
{
	[JLRoutes addRoute:@"/print/id/:id" priority:1 handler:^BOOL(NSDictionary *parameters) {
		id file = nil;//PRIFile *file = ???.files object with identifier = :id
		PRIPrintViewController *printViewController = [PRIAppDelegate.sharedAppDelegate.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PrintViewController"];
		printViewController.file = file;
		
		UIViewController *presentingController = PRIAppDelegate.sharedAppDelegate.rootNavigationController.topViewController;
		printViewController.printViewControllerWasCancelledBlock = ^(__weak PRIPrintViewController *viewController) {
			[viewController dismissViewControllerAnimated:YES completion:nil];
		};
		printViewController.printViewControllerWantsToPrintFileBlock = ^(__weak PRIPrintViewController *viewController, PRIFile *file, PRIPrinter *printer) {
			[PRIPrintClient.sharedClient printFile:file usingPrinter:printer uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
				NSLog(@"Print upload progress:\n\tWritten = %ld bytes\n\tTotal written = %lld bytes\n\tTotal expected to write = %lld", (unsigned long)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
			} success:^(__unused AFHTTPRequestOperation *operation, id responseObject) {
				DLog(@"Print job successfully sent to printer.");
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				DLog(@"Failed to send print job to the printer: %@", error);
			}];
			
			[viewController dismissViewControllerAnimated:YES completion:nil];
		};
		
		[presentingController presentViewController:printViewController animated:YES completion:nil];
		
		return YES;
	}];
	
	[JLRoutes addRoute:@"/print/:url" priority:0 handler:^BOOL(NSDictionary *parameters) {
		NSString *urlString = parameters[@"url"];
		NSURL *url = [NSURL URLWithString:urlString];
		
		if (url) {
			// Create a PRIFile object for the URL. PRIFile *file = ???;
			NSString *internalUrlString = [NSString stringWithFormat:@"prismatic://print/id/%@", [NSUUID.UUID UUIDString]];/*file.identifier*/
			[self openURL:internalUrlString.pri_URL];
		}
		return NO;
	}];
}

- (UINavigationController *)rootNavigationController
{
	UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
		navigationController = [splitViewController.viewControllers lastObject];
	}
	return navigationController;
}

@end
