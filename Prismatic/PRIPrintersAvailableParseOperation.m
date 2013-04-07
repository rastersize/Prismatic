//
//  PRIPrintersAvailableParseOperation.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintersAvailableParseOperation.h"
#import "PRIPrinter.h"


NSString *const kPRIParserSelect = @"select";
// The name of the select element we are looking for which contains all the
// options which in turn contain the printers.
NSString *const kPRIParserSelectName = @"printers";

NSString *const kPRIParserOption = @"option";
NSString *const kPRIParserOptionValue = @"value";


@interface PRIPrintersAvailableParseOperation (/*Private*/)
@property (strong) NSData *HTMLData;
@property (strong, readonly) void (^completionBlock)(NSArray *);

@property (strong) NSXMLParser *parser;
@property (strong) NSMutableArray *workingArray;
@property (copy) NSString *workingPrinterIdentifier;
@property (strong) NSMutableString *workingPrinterString;
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
		_completionBlock = [completion copy];
	}
	return self;
}


#pragma mark -
- (NSString *)sanitizeInputString:(NSString *)string
{
	return [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}


#pragma mark - NSOperation Methods
- (void)main
{
	@autoreleasepool {
		self.workingArray = NSMutableArray.array;
		self.workingPrinterString = NSMutableString.string;
		
		self.parser = [[NSXMLParser alloc] initWithData:self.HTMLData];
		self.parser.delegate = self;
		[self.parser parse];
		
		if (!self.isCancelled) {
			self.completionBlock(self.workingArray.copy);
		}
		
		self.workingArray = nil;
		self.workingPrinterString = nil;
		self.HTMLData = nil;
		self.parser = nil;
	}
}

#pragma mark - NSXMLParserDelegate Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:kPRIParserOption]) {
		DLog(@"attributes: %@", attributeDict);
		self.workingPrinterIdentifier = [NSUUID.UUID UUIDString];//[self sanitizeInputString:attributeDict[kPRIParserOptionValue]];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if (self.workingPrinterIdentifier) {
		// printerString ≈ am-m-5153a-laser1 (am-m-5153a-laser1 (HP LaserJet 5M) @ M-Huset AM Vån. 4)
		NSString *printerString = [self sanitizeInputString:self.workingPrinterString];
		
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(([\\wåäöÅÄÖ\\-.\\s]+)\\)?\\s@\\s(.+)\\)" options:0 error:NULL];
		NSMutableArray *matches = NSMutableArray.array;
		[regex enumerateMatchesInString:printerString options:0 range:NSMakeRange(0, printerString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
			for (NSUInteger i = 0; i < result.numberOfRanges; ++i) {
				NSString *capture = [printerString substringWithRange:[result rangeAtIndex:i]];
				[matches addObject:capture];
			}
		}];
		
		// [0] == entire string
		// [1] == first capture group (name)
		// [2] == second capture group (location)
		NSString *name = (matches.count >= 2 ? matches[1] : nil);
		NSString *location = (matches.count >= 3 ? matches[2] : nil);;
		
		PRIPrinter *printer = [PRIPrinter printerWithIdentifier:self.workingPrinterIdentifier name:name location:location];
		[self.workingArray addObject:printer];
		
		[self.workingPrinterString setString:@""];
		self.workingPrinterIdentifier = nil;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (self.workingPrinterIdentifier) {
		[self.workingPrinterString appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	DLogWarning(@"%@", parseError);
}


@end
