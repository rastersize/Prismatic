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
	
	CGFloat greyComponent = (154.f/256.f);
	UIColor *printerSelectionSeparatorLineColor = [UIColor colorWithRed:greyComponent green:greyComponent blue:greyComponent alpha:1.f];
	self.printerSelectionTopSeparatorView.lineColor = printerSelectionSeparatorLineColor;
	self.printerSelectionBottomSeparatorView.lineColor = printerSelectionSeparatorLineColor;
	
	self.printerSelectionTopSeparatorView.insetColor = nil;
	self.printerSelectionBottomSeparatorView.insetColor = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UIEdgeInsets currentInset = self.tableView.contentInset;
	self.tableView.contentInset = UIEdgeInsetsMake(-CGRectGetHeight(self.tableView.tableHeaderView.bounds), currentInset.left, currentInset.bottom, currentInset.right);
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
