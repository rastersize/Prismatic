//
//  PRIStyleController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIStyleController.h"

NSString *const kPRIStyleFontFamilyDefault		= @"Avenir Next";
NSString *const kPRIStyleFontNameDefault		= @"AvenirNext-Regular";
NSString *const kPRIStyleFontNameDefaultBold	= @"AvenirNext-Bold";
NSString *const kPRIStyleFontNameDefaultItalic	= @"AvenirNext-Italic";


@implementation PRIStyleController

+ (void)applyStyles
{
	[self applyFontStyles];
}

+ (void)applyFontStyles
{
//	UIFont *regularFont = [UIFont fontWithName:kPRIStyleFontNameDefault size:UIFont.systemFontSize];
//	UIFont *boldFont = [UIFont fontWithName:kPRIStyleFontNameDefaultBold size:UIFont.systemFontSize];
//	UIFont *italicsFont = [UIFont fontWithName:kPRIStyleFontNameDefaultItalic size:UIFont.systemFontSize];
//	
//	[UILabel.appearance setFont:[regularFont fontWithSize:UIFont.labelFontSize]];
//	
//	[[UILabel appearanceWhenContainedIn:UITableViewCell.class, nil] setFont:boldFont];
}

@end
