//
//  PRIPrintClient.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "AFNetworking.h"

@class PRIFile;
@class PRIPrinter;


extern NSString *const kPRIPrintClientErrorDomain;

typedef enum : NSInteger {
	kPRIPrintClientErrorInvalidResponse	= 0,
} PRIPrintClientError;

extern NSString *const kPRIPrintClientErrorInvalidResponseOriginalResponseKey;



@interface PRIPrintClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password;

// The response object will be an array of printers.
- (void)printersAvailable:(void (^)(NSURLSessionDataTask *task, BOOL success, id responseObject))completionBlock;

- (void)quotaCostForFile:(PRIFile *)file usingPrinter:(PRIPrinter *)printer success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)printFile:(PRIFile *)file usingPrinter:(PRIPrinter *)printer uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))uploadProgressBlock success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)attemptAuthorizationWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
