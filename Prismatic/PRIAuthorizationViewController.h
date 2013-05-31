//
//  PRIAuthorizationViewController.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 30-05-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRITableViewController.h"
#import "UITextField+PRIResponderChain.h"


typedef void (^PRIAuthorizationSucceeded)(NSString *username, NSString *password);


@interface PRIAuthorizationViewController : PRITableViewController <UITextFieldDelegate>

+ (NSString *)storyboardIdentifier;
@property (copy) PRIAuthorizationSucceeded authorizationSucceededHandler;

@end
