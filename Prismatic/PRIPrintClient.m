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


NSString *const kPRIPrintClientBackgroundSessionIdentifier = @"com.cedercrantz.Prismatic.print-client.background-session";
NSString *const kPRIPrintClientErrorDomain = @"com.cedercrantz.Prismatic.print-client.error";

NSString *const kPRIPrintClientErrorInvalidResponseOriginalResponseKey = @"PRIPrintClientErrorInvalidResponseOriginalResponseKey";


NSString *const kPRIPrintClientBaseURLString = @"https://print.chalmers.se/";
NSString *const kPRIPrintClientUploadPath = @"auth/uploadme.cgi";


#define PRIDispatchCompletionBlock(completionBlockCall)		do { dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ (completionBlockCall); }); } while(0)


@interface PRIPrintClient (/*Private*/)
@property (assign, nonatomic) BOOL hasAuthorizationHeader;

@property (strong, readonly) NSOperationQueue *requestsQueue;
@property (strong, readonly) NSOperationQueue *parserQueue;
@end


@implementation PRIPrintClient

+ (instancetype)sharedClient
{
	static PRIPrintClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURL *baseUrl = [NSURL URLWithString:kPRIPrintClientBaseURLString];
		_sharedClient = [[self alloc] initWithBaseURL:baseUrl];
	});
	return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
	NSURLSessionConfiguration *sessionConfiguration = nil;//[NSURLSessionConfiguration backgroundSessionConfiguration:kPRIPrintClientBackgroundSessionIdentifier];
	self = [super initWithBaseURL:url sessionConfiguration:sessionConfiguration];
	if (self) {
		self.responseSerializer = AFHTTPResponseSerializer.serializer;
		
		_hasAuthorizationHeader = NO;
		
		_parserQueue = [[NSOperationQueue alloc] init];
		_parserQueue.name = @"com.cedercrantz.Prismatic.print-client.parser-queue";
		
		_requestsQueue = [[NSOperationQueue alloc] init];
		_requestsQueue.name = @"com.cedercrantz.Prismatic.print-client.requests-queue";
		_requestsQueue.maxConcurrentOperationCount = 1;
		_requestsQueue.suspended = YES;
	}
	return self;
}


#pragma mark - Authorization
- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password
{
	[self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
	self.hasAuthorizationHeader = (username.length > 0 && password.length > 0);
}

- (void)setHasAuthorizationHeader:(BOOL)hasAuthorizationHeader
{
	_hasAuthorizationHeader = hasAuthorizationHeader;
	self.requestsQueue.suspended = (_hasAuthorizationHeader == NO);
}



#pragma mark - Perform Requests Logged In
- (void)performRequestWhenLoggedIn:(void (^)())requestBlock
{
	NSParameterAssert(requestBlock);
	
	if (!self.hasAuthorizationHeader) {
		[self.requestsQueue addOperationWithBlock:requestBlock];
		[PRIAppDelegate.sharedAppDelegate showAuthorizationView];
	} else {
		requestBlock();
	}
}


#pragma mark - Requests
- (void)printersAvailable:(void (^)(NSURLSessionDataTask *task, BOOL success, id responseObject))completionBlock
{
	NSParameterAssert(completionBlock);
	
	[self performRequestWhenLoggedIn:^{
		void (^successBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id responseObject) {
			if (responseObject && [responseObject isKindOfClass:NSData.class]) {
				PRIPrintersAvailableParseOperation *parseOperation = [PRIPrintersAvailableParseOperation parserWithHTMLData:responseObject completion:^(NSArray *printers) {
					PRIDispatchCompletionBlock(completionBlock(task, YES, printers));
				}];
				[self.parserQueue addOperation:parseOperation];
			} else {
				NSError *error = [NSError errorWithDomain:kPRIPrintClientErrorDomain code:kPRIPrintClientErrorInvalidResponse userInfo:@{ kPRIPrintClientErrorInvalidResponseOriginalResponseKey: (responseObject ?: NSNull.null) }];
				PRIDispatchCompletionBlock(completionBlock(task, NO, error));
			}
		};
		void (^failureBlock)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, NSError *error) {
			PRIDispatchCompletionBlock(completionBlock(task, NO, error));
		};
		
		[self GET:kPRIPrintClientUploadPath parameters:nil success:successBlock failure:failureBlock];
	}];
}

- (void)printFile:(PRIFile *)file usingPrinter:(PRIPrinter *)printer uploadProgressBlock:(void (^)(NSUInteger, long long, long long))uploadProgressBlock success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
	NSParameterAssert(success);
	
	[self performRequestWhenLoggedIn:^{
		DLog(@"Print file not yet implemented.\n\tFile: %@\n\tPrinter: %@", file, printer);
	}];
}

- (void)quotaCostForFile:(PRIFile *)file usingPrinter:(PRIPrinter *)printer success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
	NSParameterAssert(success);
	
	[self performRequestWhenLoggedIn:^{
		DLog(@"Quota cost for file not yet implemented.\n\tFile: %@\n\tPrinter: %@", file, printer);
	}];
}


@end
