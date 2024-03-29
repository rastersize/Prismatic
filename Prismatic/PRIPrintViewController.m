//
//  PRIPrintViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintViewController.h"
#import "PRIPrintersViewController.h"
#import "PRIPrinter.h"
#import "PRIFile.h"

#import <SSToolkit/SSLineView.h>


@interface PRIPrintViewController ()
@property (strong) PRIPrinter *printer;
@property (strong) id userDefaultsChangeNotification;

@property (assign) BOOL isFirstTime;
@end


@implementation PRIPrintViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.isFirstTime = YES;
	
	CGFloat greyComponent = (200.f/256.f);
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
	
	[self updateViewsBasedOnFile];
	[self updateSelectedPrinter];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if (self.isFirstTime && self.printer.identifier.length == 0 && NSUserDefaults.defaultPrinterIdentifier.length == 0) {
		[self performSegueWithIdentifier:@"showSelectPrinterSegue" sender:self];
	}
	
	self.isFirstTime = NO;
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


#pragma mark - Properties and Outlets
@synthesize file = _file;
- (PRIFile *)file
{
	return _file;
}

- (void)setFile:(PRIFile *)file
{
	if (_file != file) {
		_file = file;
		[self updateViewsBasedOnFile];
	}
}

- (void)updateViewsBasedOnFile
{
	self.nameLabel.text = (self.file.name.length > 0 ? self.file.name : NSLocalizedString(@"Unkown file name", @"Print title when no file name is available."));
	self.pagesLabel.text = [NSString localizedStringWithFormat:@"%lu pages", (unsigned long)self.file.pages];
	
	BOOL isColorPrinter = ([self.printer.identifier rangeOfString:@"color"].location != NSNotFound);
	NSUInteger quotaEstimate = self.file.pages * (isColorPrinter ? 2 : 1);
	self.quotaLabel.text = [NSString localizedStringWithFormat:@"~%lu quota", (unsigned long)quotaEstimate];
}

- (void)updateSelectedPrinter
{
	NSString *printerIdentifier = (self.printer.identifier.length > 0 ? self.printer.identifier : NSUserDefaults.defaultPrinterIdentifier);
	self.selectedPrinterNameLabel.text = (printerIdentifier.length > 0 ? printerIdentifier : NSLocalizedString(@"No printer selected", @"No printer selected detail text."));
}


#pragma mark - Actions and Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showSelectPrinterSegue"]) {
		PRIPrintersViewController *printersViewController = segue.destinationViewController;
		printersViewController.selectedPrinter = self.printer;
		printersViewController.selectedPrinterChangedBlock = ^(PRIPrinter *printer) {
			self.printer = printer;
			if (NSUserDefaults.lastUsedPrinterAsDefault || NSUserDefaults.defaultPrinterIdentifier) {
				NSUserDefaults.defaultPrinterIdentifier = printer.identifier;
			}
		};
	}
}

- (IBAction)print:(id)sender
{
	if (self.printFileUsingPrinterBlock) {
		PRIPrinter *printer = self.printer;
		DLog(@"NSUserDefaults.defaultPrinterIdentifier: %@", NSUserDefaults.defaultPrinterIdentifier);
		if ((printer.identifier.length == 0 || printer == nil) && NSUserDefaults.defaultPrinterIdentifier.length > 0) {
			printer = [PRIPrinter printerWithIdentifier:NSUserDefaults.defaultPrinterIdentifier name:nil location:nil];
		}
		
		if (printer) {
			self.printFileUsingPrinterBlock(self.file, printer);
		} else {
			self.cancelBlock();
		}
	}
}

- (IBAction)cancel:(id)sender
{
	if (self.cancelBlock) {
		self.cancelBlock();
	}
}

@end
