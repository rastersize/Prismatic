//
//  PRIAuthorizationViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 30-05-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIAuthorizationViewController.h"

@interface PRIAuthorizationViewController (/*Private*/)

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *signInCell;

@end

@implementation PRIAuthorizationViewController

#pragma mark - Storyboard
+ (NSString *)storyboardIdentifier
{
	return @"AuthorizationViewController";
}


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Sign In", @"Authorization view controller title.");
	self.usernameTextField.pri_nextResponder = self.passwordTextField;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self updateSignInLabel];
}


#pragma mark - Signing In
// TODO: Attempt to sign in before calling the “succeeded” handler.
- (void)signIn
{
	NSParameterAssert(self.authorizationSucceededHandler != nil);
	
	if (self.authorizationSucceededHandler != nil) {
		self.authorizationSucceededHandler(self.usernameTextField.text, self.passwordTextField.text);
	}
}

- (BOOL)canSignIn
{
	return self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0;
}

- (void)updateSignInLabel
{
	self.signInCell.textLabel.enabled = self.canSignIn;
}


#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 2) {
		indexPath = self.canSignIn ? indexPath : nil;
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 2) {
		[self signIn];
	}
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	BOOL shouldReturn = YES;
	if (textField == self.passwordTextField) {
		shouldReturn = self.canSignIn;
	} else if ([textField respondsToSelector:@selector(pri_moveToNextControl)]) {
		shouldReturn = [textField pri_moveToNextControl];
	}
	return shouldReturn;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[self updateSignInLabel];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	[self updateSignInLabel];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (self.canSignIn) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self signIn];
		});
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	[self updateSignInLabel];
	return YES;
}

@end
