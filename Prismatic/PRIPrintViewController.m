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
@property (strong) id userDefaultsChangeNotification;

@end


@implementation PRIPrintViewController

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
	
	self.userDefaultsChangeNotification = [NSNotificationCenter.defaultCenter addObserverForName:NSUserDefaultsDidChangeNotification object:NSUserDefaults.standardUserDefaults queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
		[self updateSelectedPrinter];
	}];
	
	[self updateSelectedPrinter];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ([[NSUserDefaults.standardUserDefaults objectForKey:@"defaultPrinterIdentifier"] length] == 0) {
		[self performSegueWithIdentifier:@"showSelectPrinterSegue" sender:self];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self stopObservingNotifications];
}

- (void)dealloc
{
	[self stopObservingNotifications];	
}

- (void)stopObservingNotifications
{
	if (self.userDefaultsChangeNotification) {
		[NSNotificationCenter.defaultCenter removeObserver:self.userDefaultsChangeNotification name:NSUserDefaultsDidChangeNotification object:NSUserDefaults.standardUserDefaults];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - 
- (void)updateSelectedPrinter
{
	NSString *printerIdentifier = [NSUserDefaults.standardUserDefaults objectForKey:@"defaultPrinterIdentifier"];
	self.selectedPrinterNameLabel.text = (printerIdentifier.length > 0 ? printerIdentifier : NSLocalizedString(@"No printer selected", @"No printer selected detail text."));
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
