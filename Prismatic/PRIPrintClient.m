//
//  PRIPrintClient.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintClient.h"
#import "PRIPrintersAvailableParseOperation.h"


NSString *const kPRIPrintClientErrorDomain = @"com.cedercrantz.Prismatic.print-client.error";

NSString *const kPRIPrintClientErrorInvalidResponseOriginalResponseKey = @"PRIPrintClientErrorInvalidResponseOriginalResponseKey";


NSString *const kPRIPrintClientBaseURLString = @"https://print.chalmers.se/";
NSString *const kPRIPrintClientUploadPath = @"auth/uploadme.cgi";


@interface PRIPrintClient (/*Private*/)
@property (strong, readonly) NSOperationQueue *parserQueue;
@end


@implementation PRIPrintClient

+ (instancetype)sharedClient
{
	static PRIPrintClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURL *baseUrl = [NSURL URLWithString:kPRIPrintClientBaseURLString];
		_sharedClient = [self clientWithBaseURL:baseUrl];
	});
	return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
	self = [super initWithBaseURL:url];
	if (self) {
		_parserQueue = [[NSOperationQueue alloc] init];
		_parserQueue.name = @"com.cedercrantz.Prismatic.print-client.parser-queue";
	}
	return self;
}

- (void)printersAvailableSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
	NSParameterAssert(success);
	
	[self getPath:kPRIPrintClientUploadPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (responseObject && [responseObject isKindOfClass:NSData.class]) {
			PRIPrintersAvailableParseOperation *parseOperation = [PRIPrintersAvailableParseOperation parserWithHTMLData:responseObject completion:^(NSArray *printers) {
				success(operation, printers);
			}];
			[self.parserQueue addOperation:parseOperation];
		} else if (failure != nil) {
			NSError *error = [NSError errorWithDomain:kPRIPrintClientErrorDomain code:kPRIPrintClientErrorInvalidResponse userInfo:@{ kPRIPrintClientErrorInvalidResponseOriginalResponseKey: (responseObject ?: NSNull.null) }];
			failure(operation, error);
		}
	} failure:failure];
}

@end
