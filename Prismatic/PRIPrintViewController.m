//
//  PRIPrintViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintViewController.h"
#import <SSToolkit/SSLineView.h>

@class PRIPrinter;

@interface PRIPrintViewController ()

@property (strong) PRIPrinter *printer;

@end


@implementation PRIPrintViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.printerSelectionSeparatorView.insetColor = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions
- (IBAction)print:(id)sender
{
	[self.delegate printViewController:self wantsToPrintFile:self.file];
}

- (IBAction)cancel:(id)sender
{
	[self.delegate printViewControllerWasCancelled:self];
}

@end
