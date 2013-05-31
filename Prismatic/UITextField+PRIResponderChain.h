//
//  UITextField+PRIResponderChain.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 31-05-2013.
//  Copyright (c) 2013 Numero Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PRIResponderChain)

/**
 The next responder.
 
 @discussion If it’s a button then it will recieve the event
 `UIControlEventTouchUpInside`, otherwise it will be sent the
 `becomeFirstResponder` message.
 */
@property (strong, nonatomic, getter = pri_nextResponder, setter = pri_setNextResponder:) UIResponder *pri_nextResponder;

/**
 This would typically be sent in the textFieldShouldReturn: method of the text
 field’s delegate.
 
 @see pri_nextResponder
 */
- (BOOL)pri_moveToNextControl;

@end
