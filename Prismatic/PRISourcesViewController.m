//
//  PRISourcesViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRISourcesViewController.h"
#import "UIFont+Prismatic.h"


#import "NSString+PRIURLHelpers.h"
#import "PRIFile.h"
#import "PRIAppDelegate.h"


@implementation PRISourcesViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if ([identifier isEqualToString:@"debugShowPrintViewSegue"]) {
		[NSOperationQueue.mainQueue addOperationWithBlock:^{
			PRIFile *file = [PRIFile fileWithURL:@"file://lol/This is one long file name.pdf".pri_fileURL name:@"This is one long file name.pdf" pages:32];
			[PRIAppDelegate.sharedAppDelegate showPrintViewForFile:file];
		}];
		return NO;
	}
	
	return YES;
}

@end
