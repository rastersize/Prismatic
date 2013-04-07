//
//  PRIPrintersAvailableParseOperation.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRIPrintersAvailableParseOperation : NSOperation <NSXMLParserDelegate>

+ (instancetype)parserWithHTMLData:(NSData *)htmlData completion:(void (^)(NSArray *printers))completion;
- (instancetype)initWithHTMLData:(NSData *)htmlData completion:(void (^)(NSArray *printers))completion;

@end
