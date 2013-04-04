//
//  UIFont+Prismatic.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "UIFont+Prismatic.h"

NSString *const kPRIStyleFontFamilyDefault		= @"Avenir Next";
NSString *const kPRIStyleFontNameDefault		= @"AvenirNext-Regular";
NSString *const kPRIStyleFontNameDefaultBold	= @"AvenirNext-Bold";
NSString *const kPRIStyleFontNameDefaultItalic	= @"AvenirNext-Italic";

@implementation UIFont (Prismatic)

+ (NSString *)pri_appFontFamilyName
{
	return kPRIStyleFontFamilyDefault;
}

+ (instancetype)pri_appFontOfSize:(CGFloat)fontSize
{
	NSParameterAssert(fontSize > 0.f);
	return [self fontWithName:kPRIStyleFontNameDefault size:fontSize];
}

+ (instancetype)pri_boldAppFontOfSize:(CGFloat)fontSize
{
	NSParameterAssert(fontSize > 0.f);
	return [self fontWithName:kPRIStyleFontNameDefaultBold size:fontSize];
}

+ (instancetype)pri_italicsAppFontOfSize:(CGFloat)fontSize
{
	NSParameterAssert(fontSize > 0.f);
	return [self fontWithName:kPRIStyleFontNameDefaultItalic size:fontSize];
}

@end
