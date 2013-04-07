//
//  PRIFile.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 07-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIFile.h"

@implementation PRIFile

+ (instancetype)fileWithURL:(NSURL *)url name:(NSString *)name pages:(NSUInteger)pages
{
	return [[self alloc] initWithURL:url name:name pages:pages];
}

- (instancetype)initWithURL:(NSURL *)url name:(NSString *)name pages:(NSUInteger)pages
{
	self = [super init];
	if (self) {
		_identifier = NSUUID.UUID;
		_URL = url;
		_name = name.copy;
		_pages = pages;
	}
	return self;
}

@end
