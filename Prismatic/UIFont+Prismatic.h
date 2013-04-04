//
//  UIFont+Prismatic.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Prismatic)

+ (NSString *)pri_appFontFamilyName;

+ (instancetype)pri_appFontOfSize:(CGFloat)fontSize;
+ (instancetype)pri_boldAppFontOfSize:(CGFloat)fontSize;
+ (instancetype)pri_italicsAppFontOfSize:(CGFloat)fontSize;

@end
