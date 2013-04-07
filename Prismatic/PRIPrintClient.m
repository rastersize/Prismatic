//
//  PRIPrintClient.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintClient.h"
#import "PRIPrintersAvailableParseOperation.h"
#import "PRIAppDelegate.h"
#import "NSString+PRIURLHelpers.h"


NSString *const kPRIPrintClientErrorDomain = @"com.cedercrantz.Prismatic.print-client.error";

NSString *const kPRIPrintClientErrorInvalidResponseOriginalResponseKey = @"PRIPrintClientErrorInvalidResponseOriginalResponseKey";


NSString *const kPRIPrintClientBaseURLString = @"https://print.chalmers.se/";
NSString *const kPRIPrintClientUploadPath = @"auth/uploadme.cgi";


@interface PRIPrintClient (/*Private*/)
@property (assign) BOOL isAuthorizationSet;

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

- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password
{
	[super setAuthorizationHeaderWithUsername:username password:password];
	self.isAuthorizationSet = (username.length > 0 && password.length > 0);
}

- (void)performRequestWhenLoggedIn:(void (^)())requestBlock
{
	NSParameterAssert(requestBlock);
	
//	if (!self.isAuthorizationSet) {
//		[PRIAppDelegate openURL:@"prismatic://login".pri_URL];
//	} else {
		requestBlock();
//	}
}

- (void)printersAvailableSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
	NSParameterAssert(success);
	
	[self performRequestWhenLoggedIn:^{
		void (^successBLock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
			if (responseObject && [responseObject isKindOfClass:NSData.class]) {
				PRIPrintersAvailableParseOperation *parseOperation = [PRIPrintersAvailableParseOperation parserWithHTMLData:responseObject completion:^(NSArray *printers) {
					success(operation, printers);
				}];
				[self.parserQueue addOperation:parseOperation];
			} else if (failure != nil) {
				NSError *error = [NSError errorWithDomain:kPRIPrintClientErrorDomain code:kPRIPrintClientErrorInvalidResponse userInfo:@{ kPRIPrintClientErrorInvalidResponseOriginalResponseKey: (responseObject ?: NSNull.null) }];
				failure(operation, error);
			}
		};
		
		[self getPath:kPRIPrintClientUploadPath parameters:nil success:successBLock failure:failure];
	}];
}

- (void)printFile:(PRIFile *)file usingPrinter:(PRIPrinter *)printer uploadProgressBlock:(void (^)(NSUInteger, long long, long long))uploadProgressBlock success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
	NSParameterAssert(success);
	
	[self performRequestWhenLoggedIn:^{
		DLog(@"Print file not yet implemented.\n\tFile: %@\n\tPrinter: %@", file, printer);
	}];
}

@end
