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
//	UIFont *regularFont = [UIFont pri_appFontOfSize:0.f];
	UIFont *boldFont = [UIFont pri_boldAppFontOfSize:0.f];
//	UIFont *italicsFont = [UIFont pri_italicsAppFontOfSize:0.f];
	
	// Navigation bars
	[UIBarButtonItem.appearance setTitleTextAttributes:@{ UITextAttributeFont: boldFont } forState:0];
	[UINavigationBar.appearance setTitleTextAttributes:@{ UITextAttributeFont: boldFont }];
}

@end
