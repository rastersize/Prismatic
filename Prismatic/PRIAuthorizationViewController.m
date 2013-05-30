//
//  PRIAuthorizationViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 30-05-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIAuthorizationViewController.h"

@interface PRIAuthorizationViewController (/*Private*/)

@end

@implementation PRIAuthorizationViewController

+ (NSString *)storyboardIdentifier
{
	return @"AuthorizationViewController";
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
