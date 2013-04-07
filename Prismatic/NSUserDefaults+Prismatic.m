//
//  NSUserDefaults+Prismatic.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 07-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "NSUserDefaults+Prismatic.h"

static NSString *const kPRIUserDefaultsDefaultPrinterIdentifierKey = @"PRIUserDefaultsDefaultPrinterIdentifierKey";
static NSString *const kPRIUserDefaultsLastUsedPrinterAsDefaultKey = @"PRIUserDefaultsLastUsedPrinterAsDefaultKey";


@implementation NSUserDefaults (Prismatic)

+ (void)initialize
{
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{
		kPRIUserDefaultsDefaultPrinterIdentifierKey: @"",
		kPRIUserDefaultsLastUsedPrinterAsDefaultKey: @(YES),
	}];
}

+ (void)setLastUsedPrinterAsDefault:(BOOL)lastUsedPrinterAsDefault
{
	[NSUserDefaults.standardUserDefaults setBool:lastUsedPrinterAsDefault forKey:kPRIUserDefaultsLastUsedPrinterAsDefaultKey];
}

+ (BOOL)lastUsedPrinterAsDefault
{
	return [NSUserDefaults.standardUserDefaults boolForKey:kPRIUserDefaultsLastUsedPrinterAsDefaultKey];
}

+ (void)setDefaultPrinterIdentifier:(NSString *)identifier
{
	[NSUserDefaults.standardUserDefaults setObject:identifier forKey:kPRIUserDefaultsDefaultPrinterIdentifierKey];
}

+ (NSString *)defaultPrinterIdentifier
{
	return [NSUserDefaults.standardUserDefaults objectForKey:kPRIUserDefaultsDefaultPrinterIdentifierKey];
}

@end
