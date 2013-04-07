//
//  PRIPrinter.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PRIPrinter : MTLModel <MTLJSONSerializing>

@property (copy, readonly) NSString *identifier;
@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *location;

+ (instancetype)printerWithIdentifier:(NSString *)identifier name:(NSString *)name location:(NSString *)location;
- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name location:(NSString *)location;

@end
