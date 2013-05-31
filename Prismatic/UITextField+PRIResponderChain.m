//
//  UITextField+PRIResponderChain.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 31-05-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "UITextField+PRIResponderChain.h"
#import <objc/runtime.h>

static void *const kUITextFieldPRIResponderChainNextResponder;

@implementation UITextField (PRIResponderChain)

- (UIResponder *)pri_nextResponder
{
	UIResponder *nextResponder = objc_getAssociatedObject(self, kUITextFieldPRIResponderChainNextResponder);
	return nextResponder;
}

- (void)pri_setNextResponder:(UIResponder *)nextResponder
{
	objc_setAssociatedObject(self, kUITextFieldPRIResponderChainNextResponder, nextResponder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pri_moveToNextControl
{
	BOOL didResign = [self resignFirstResponder];
	if (!didResign) { return NO; }
	
	UIResponder *nextResponder = self.pri_nextResponder;
	if ([nextResponder isKindOfClass:[UIButton class]]) {
		[(UIButton *)nextResponder sendActionsForControlEvents:UIControlEventTouchUpInside];
	} else {
		[nextResponder becomeFirstResponder];
	}
	
	return YES;
}

@end
