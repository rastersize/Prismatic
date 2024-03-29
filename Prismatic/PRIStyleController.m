//
//  PRIStyleController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIStyleController.h"
#import "UIFont+Prismatic.h"


@implementation PRIStyleController

+ (void)applyStyles
{
	[self applyFontStyles];
}

+ (void)applyFontStyles
{
	UIFont *regularFont = [UIFont pri_appFontOfSize:0.f];
	UIFont *boldFont = [UIFont pri_boldAppFontOfSize:0.f];
//	UIFont *italicsFont = [UIFont pri_italicsAppFontOfSize:0.f];
	
	// Navigation bars
	[UIBarButtonItem.appearance setTitleTextAttributes:@{ NSFontAttributeName: boldFont } forState:0];
	[UINavigationBar.appearance setTitleTextAttributes:@{ NSFontAttributeName: boldFont }];
	
	// Search bars
	[[UITextField appearanceWhenContainedIn:UISearchBar.class , nil] setFont:[regularFont fontWithSize:UIFont.systemFontSize]];
	[[UISearchBar appearance] setSearchTextPositionAdjustment:UIOffsetMake(0.f, 1.f)];
}

@end
