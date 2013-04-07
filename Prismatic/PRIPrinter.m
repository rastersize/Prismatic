//
//  PRIPrinter.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrinter.h"

@implementation PRIPrinter

+ (instancetype)printerWithIdentifier:(NSString *)identifier name:(NSString *)name location:(NSString *)location
{
	return [[self alloc] initWithIdentifier:identifier name:name location:location];
}

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name location:(NSString *)location
{
	NSParameterAssert(identifier);
	NSParameterAssert(identifier.length > 0);
	
	self = [super init];
	if (self) {
		_identifier = identifier.copy;
		_name = name.copy;
		_location = location.copy;
	}
	return self;
}

@end
