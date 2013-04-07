//
//  PRIAppDelegate.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRIFile;
@class PRIPrinter;

@interface PRIAppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)sharedAppDelegate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) UINavigationController *rootNavigationController;

- (void)showPrintViewForFile:(PRIFile *)file;

@end
