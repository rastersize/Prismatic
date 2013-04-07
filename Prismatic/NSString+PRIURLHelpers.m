//
//  NSString+PRIURLHelpers.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 07-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "NSString+PRIURLHelpers.h"

@implementation NSString (PRIURLHelpers)

- (NSURL *)pri_URL
{
	return [NSURL URLWithString:self];
}

- (NSURL *)pri_fileURL
{
	return [NSURL fileURLWithPath:self];
}

@end
