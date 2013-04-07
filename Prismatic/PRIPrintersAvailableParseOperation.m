//
//  PRIPrintersAvailableParseOperation.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintersAvailableParseOperation.h"
#import "PRIPrinter.h"
#import "TFHpple.h"


NSString *const kPRIParserXPath = @"//select[@name='printers']/option";

NSString *const kPRIParserOption = @"option";
NSString *const kPRIParserOptionValue = @"value";
NSString *const kPRIParserOptionValueSkipped = @"noselected";


@interface PRIPrintersAvailableParseOperation (/*Private*/)
@property (strong) NSData *HTMLData;
@property (strong, readonly) void (^printersCompletionBlock)(NSArray *);

@property (strong, readonly) NSRegularExpression *printerTextRegularExpression;
@end


@implementation PRIPrintersAvailableParseOperation

+ (instancetype)parserWithHTMLData:(NSData *)htmlData completion:(void (^)(NSArray *))completion
{
	return [[self alloc] initWithHTMLData:htmlData completion:completion];
}

- (instancetype)initWithHTMLData:(NSData *)htmlData completion:(void (^)(NSArray *))completion
{
	self = [super init];
	if (self) {
		_HTMLData = htmlData;
		_printersCompletionBlock = [completion copy];
	}
	return self;
}


#pragma mark - NSOperation Methods
- (void)main
{
	@autoreleasepool {
		TFHpple *parser = [TFHpple hppleWithHTMLData:self.HTMLData];
		NSArray *printerOptionElements = [parser searchWithXPathQuery:kPRIParserXPath];
		
		NSMutableArray *printers = [NSMutableArray arrayWithCapacity:printerOptionElements.count];
		for (TFHppleElement *element in printerOptionElements) {
			if (self.isCancelled) { break; }
			NSString *identifier = [element objectForKey:kPRIParserOptionValue];
			if ([identifier isEqualToString:kPRIParserOptionValueSkipped] == NO) {
				PRIPrinter *printer = [self printerWithIdentifier:identifier textString:element.text];
				if (printer != nil) {
					[printers addObject:printer];
				}
			}
		}
		
		if (!self.isCancelled) {
			self.printersCompletionBlock(printers.copy);
		}
		
		self.HTMLData = nil;
		self.completionBlock = nil;
	}
}


#pragma mark -
- (PRIPrinter *)printerWithIdentifier:(NSString *)identifier textString:(NSString *)text
{
	identifier = [self sanitizeInputString:identifier];
	if (identifier.length == 0) { return nil; }
	
	NSString *printerString = [self sanitizeInputString:text];
	NSMutableArray *matches = nil;
	
	if (printerString.length > 1) {
		// Should match (as two groups; name and location):
		// (HP LaserJet 5M) @ M-Huset AM Vån. 4)
		// (HP-LaserJet.5M @ M-Huset éntre Vån. _5_)
		matches = [NSMutableArray arrayWithCapacity:3];
		[self.printerTextRegularExpression enumerateMatchesInString:printerString options:0 range:NSMakeRange(0, printerString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			for (NSUInteger i = 0; i < result.numberOfRanges; ++i) {
				NSString *capture = [printerString substringWithRange:[result rangeAtIndex:i]];
				[matches addObject:capture];
			}
		}];
	}
	
	// [0] == entire string
	// [1] == first capture group (name)
	// [2] == second capture group (location)
	NSString *name = (matches.count >= 2 ? matches[1] : nil);
	NSString *location = (matches.count >= 3 ? matches[2] : nil);;
	
	PRIPrinter *printer = [PRIPrinter printerWithIdentifier:identifier name:name location:location];
	return printer;
}

- (NSString *)sanitizeInputString:(NSString *)string
{
	return [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

@synthesize printerTextRegularExpression = _printerTextRegularExpression;
- (NSRegularExpression *)printerTextRegularExpression
{
	if (_printerTextRegularExpression == nil) {
		_printerTextRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"\\(([\\wåäöÅÄÖ\\-.\\s]+)\\)?\\s@\\s(.+)\\)" options:0 error:NULL];
	}
	return _printerTextRegularExpression;
}


@end
