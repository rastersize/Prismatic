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
#import "PRIPrinter.h"
#import "PRIFile.h"

#import "NSString+PRIURLHelpers.h"

#import "PRIAuthorizationViewController.h"
#import "PRIPrintViewController.h"

#import <CDKitt/NSFileManager+CDKitt.h>
#import "AFNetworkActivityIndicatorManager.h"
#import <Crashlytics/Crashlytics.h>
#import <Mantle/Mantle.h>
#import <BlocksKit/BlocksKit.h>


@interface PRIAppDelegate (/*Private*/)
@property (strong) UIViewController *presentedPrintViewController;
@property (strong) PRIAuthorizationViewController *presentedAuthorizationViewController;

@property (strong) dispatch_queue_t printersQueue;
@property (copy, readwrite) NSArray *printers;
@end


@implementation PRIAppDelegate

+ (instancetype)sharedAppDelegate
{
	return UIApplication.sharedApplication.delegate;
}

- (id)init
{
	self = [super init];
	if (self) {
		_printersQueue = dispatch_queue_create("com.cedercrantz.Prismatic.Printers", DISPATCH_QUEUE_SERIAL);
		_printers = NSMutableArray.array;
	}
	return self;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Crashlytics startWithAPIKey:@"bede20b91f373b5268c4ce52bf52d6a0fbeb391b"];
	[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
	[PRIStyleController applyStyles];
	
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
	
	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
		UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
		splitViewController.delegate = (id)navigationController.topViewController;
	}
	
	dispatch_async(self.printersQueue, ^{
		[self loadPrinters];
	});
	
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
	
	if (url.isFileURL) {
		NSString *name = url.lastPathComponent;
		PRIFile *file = [PRIFile fileWithURL:url name:name pages:0];
		[self showPrintViewForFile:file];
		return YES;
	}
	
	return NO;
}


#pragma mark -
- (void)printFile:(PRIFile *)file usingPrinter:(PRIPrinter *)printer
{
	[PRIPrintClient.sharedClient printFile:file usingPrinter:printer uploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		DLog(@"print progress: %lu (%lld of %lld)", (unsigned long)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
	} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"print success: %@ with response: %@", operation, responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLogWarning(@"print failed: %@ with error: %@", operation, error);
	}];
}

- (void)showPrintViewForFile:(PRIFile *)file
{
	if (self.presentedPrintViewController) {
		[self.presentedPrintViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
		self.presentedPrintViewController = nil;
	}
	
	UIViewController *presentingController = PRIAppDelegate.sharedAppDelegate.rootNavigationController.topViewController;
	PRIPrintViewController *printViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"PrintViewController"];
	printViewController.file = file;
	
	void (^dismissCompletion)() = ^ { self.presentedPrintViewController = nil; };
	printViewController.cancelBlock = ^ {
		[presentingController dismissViewControllerAnimated:YES completion:dismissCompletion];
	};
	printViewController.printFileUsingPrinterBlock = ^(PRIFile *file, PRIPrinter *printer) {
		[self printFile:file usingPrinter:printer];
		[presentingController dismissViewControllerAnimated:YES completion:dismissCompletion];
	};
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:printViewController];
	self.presentedPrintViewController = navigationController;
	[presentingController presentViewController:navigationController animated:YES completion:nil];
}

- (void)showAuthorizationView
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.presentedAuthorizationViewController == nil) {
			self.presentedAuthorizationViewController = [self.storyboard instantiateViewControllerWithIdentifier:PRIAuthorizationViewController.storyboardIdentifier];
			
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.presentedAuthorizationViewController];
			
			self.presentedAuthorizationViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(__unused id _) {
				[self.rootNavigationController dismissViewControllerAnimated:YES completion:^{
					self.presentedAuthorizationViewController = nil;
				}];
			}];
			
			__weak PRIAppDelegate *weakSelf = self;
			self.presentedAuthorizationViewController.authorizationSucceededHandler = ^(NSString *username, NSString *password) {
				__strong PRIAppDelegate *self = weakSelf;
				[PRIPrintClient.sharedClient setAuthorizationHeaderWithUsername:username password:password];
				[self.rootNavigationController dismissViewControllerAnimated:YES completion:^{
					self.presentedAuthorizationViewController = nil;
				}];
			};
			
			[self.rootNavigationController presentViewController:navigationController animated:YES completion:nil];
		}
	});
}

- (UIStoryboard *)storyboard
{
	return self.window.rootViewController.storyboard;
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


#pragma mark - Printers
@synthesize printers = _printers;
- (NSArray *)printers
{
	__block NSArray *printers = nil;
	dispatch_sync(self.printersQueue, ^{
		printers = _printers;
	});
	return printers;
}

- (void)setPrinters:(NSArray *)printers
{
	dispatch_async(self.printersQueue, ^{
		if (_printers != printers) {
			_printers = printers.copy;
		}
	});
}

- (NSURL *)printersCacheFileURL
{
	NSURL *url = [NSFileManager cd_cacheDirectoryURLForBundleWithIdentifier:NSBundle.mainBundle.bundleIdentifier];
	DLog(@"URL: %@", url);
	return [url URLByAppendingPathComponent:@"printers.json"];
}

- (void)savePrinters
{
	NSArray *printers = self.printers;
	NSMutableArray *printerDicts = [NSMutableArray arrayWithCapacity:printers.count];
	for (PRIPrinter *printer in printers) {
		NSDictionary *printerDict = [MTLJSONAdapter JSONDictionaryFromModel:printer];
		if (printerDict != nil) {
			[printerDicts addObject:printerDict];
		}
	}
	
	NSData *printersJsonData = [NSJSONSerialization dataWithJSONObject:printerDicts options:0 error:NULL];
	NSURL *printersCacheFileUrl = self.printersCacheFileURL;
	[printersJsonData writeToURL:printersCacheFileUrl atomically:YES];
}

- (void)loadPrinters
{
	double delayInSeconds = 0.f;
	NSURL *printersCacheFileUrl = self.printersCacheFileURL;
	NSData *printersJsonData = [NSData dataWithContentsOfURL:printersCacheFileUrl];
	NSArray *printers = [self printerObjectsFromJSONData:printersJsonData];
	if (printers != nil) {
		self.printers = printers;
		delayInSeconds = 10.f;
	}
	
	DLog(@"delay: %f", delayInSeconds);
	
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
////////////////////////////////////////////////////////////////////////////////
		[[PRIPrintClient sharedClient] setAuthorizationHeaderWithUsername:@"" password:@""];
////////////////////////////////////////////////////////////////////////////////
		[[PRIPrintClient sharedClient] printersAvailableSuccess:^(AFHTTPRequestOperation *operation, NSArray *updatedPrinters) {
			self.printers = updatedPrinters;
			[self savePrinters];
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			DLog(@"Could not update printers list: %@", error);
		}];
	});
}

- (NSArray *)printerObjectsFromJSONData:(NSData *)printersJsonData
{
	NSArray *printers = nil;
	if (printersJsonData.length > 0) {
		printers = [NSJSONSerialization JSONObjectWithData:printersJsonData options:0 error:NULL];
		
		if (printers != nil && [printers isKindOfClass:NSArray.class]) {
			NSMutableArray *mutablePrinters = [NSMutableArray arrayWithCapacity:printers.count];
			for (NSDictionary *printerDict in printers) {
				if ([printerDict isKindOfClass:NSDictionary.class]) {
					PRIPrinter *printer = [MTLJSONAdapter modelOfClass:PRIPrinter.class fromJSONDictionary:printerDict error:NULL];
					if (printer != nil) {
						[mutablePrinters addObject:printer];
					}
				}
			}
			printers = mutablePrinters;
		}
	}
	return printers;
}

@end
