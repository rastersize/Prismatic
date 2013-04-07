//
//  PRIPrintersViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintersViewController.h"
#import "PRIPrinterTableViewCell.h"
#import "PRIAppDelegate.h"
#import "PRIPrintClient.h"
#import "PRIPrinter.h"



@interface PRIPrintersViewController ()
// An array of indexed, sorted printers.
// That is:
// [
//     0 => [ a-0000-aaa, a-0001-aaa, … ],
//     1 => [ b-0000-aaa, b-0001-aaa, … ],
//     …
// ]
@property (strong) NSMutableArray *printers;
@property (strong) NSIndexPath *selectedPrinterCellIndexPath;
@end

@implementation PRIPrintersViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_printers = [NSMutableArray arrayWithCapacity:1000];
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[self updateWithPrintersArray:PRIAppDelegate.sharedAppDelegate.printers];
	}];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)updateWithPrintersArray:(NSArray *)printers
{
	NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
	
	NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionTitlesCount];
	for (NSInteger idx = 0; idx < sectionTitlesCount; idx++) {
		[sections addObject:NSMutableArray.array];
	}

	SEL selector = @selector(identifier);
	for (PRIPrinter *printer in printers) {
		NSInteger sectionIndex = [[UILocalizedIndexedCollation currentCollation] sectionForObject:printer collationStringSelector:selector];
		[sections[sectionIndex] addObject:printer];
	}
	
	for (NSInteger idx = 0; idx < sectionTitlesCount; idx++) {
		NSArray *objectsForSection = sections[idx];
		NSArray *sortedObjectsForSection = [[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector];
		[sections replaceObjectAtIndex:idx withObject:sortedObjectsForSection];
	}
	
	self.printers = sections;
	self.selectedPrinterCellIndexPath = nil;
	[self.tableView reloadData];
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.printers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.printers[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *PrinterCellIdentifier = @"printerCell";
	NSString *selectedPrinterIdentifier = (self.selectedPrinter.identifier.length > 0 ? self.selectedPrinter.identifier : NSUserDefaults.defaultPrinterIdentifier);
	
	PRIPrinterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PrinterCellIdentifier forIndexPath:indexPath];
	cell.printer = self.printers[indexPath.section][indexPath.row];
	cell.accessoryType = [cell.printer.identifier isEqualToString:selectedPrinterIdentifier] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		self.selectedPrinterCellIndexPath = indexPath;
	}
	
	return cell;
}


#pragma mark - Index
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *previouslySelectedCell = [tableView cellForRowAtIndexPath:self.selectedPrinterCellIndexPath];
	previouslySelectedCell.accessoryType = UITableViewCellAccessoryNone;
	
	PRIPrinterTableViewCell *selectedCell = (PRIPrinterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
	self.selectedPrinterCellIndexPath = indexPath;
	
	PRIPrinter *printer = selectedCell.printer;
	self.selectedPrinter = printer;
	if (self.selectedPrinterChangedBlock) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.selectedPrinterChangedBlock(printer);
		});
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSMutableArray *indexTitles = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
	[indexTitles addObjectsFromArray:[UILocalizedIndexedCollation.currentCollation sectionIndexTitles]];
	return indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

@end
