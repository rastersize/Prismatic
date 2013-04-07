//
//  PRIFile.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 07-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PRIFile : MTLModel

+ (instancetype)fileWithURL:(NSURL *)url name:(NSString *)name pages:(NSUInteger)pages;
- (instancetype)initWithURL:(NSURL *)url name:(NSString *)name pages:(NSUInteger)pages;

@property (strong, readonly) NSUUID *identifier;

@property (copy, readonly) NSString *name;
@property (assign, readonly) NSUInteger pages;

@property (strong, readonly) NSURL *URL;

@end
