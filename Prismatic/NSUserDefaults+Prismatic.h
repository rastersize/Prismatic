//
//  NSUserDefaults+Prismatic.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 07-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Prismatic)

+ (void)setLastUsedPrinterAsDefault:(BOOL)lastUsedPrinterAsDefault;
+ (BOOL)lastUsedPrinterAsDefault;

+ (void)setDefaultPrinterIdentifier:(NSString *)identifier;
+ (NSString *)defaultPrinterIdentifier;

@end
