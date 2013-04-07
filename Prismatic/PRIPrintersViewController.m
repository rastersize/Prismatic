//
//  PRIPrintersViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrintersViewController.h"
#import "PRIPrinterTableViewCell.h"
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
	
	[[PRIPrintClient sharedClient] setAuthorizationHeaderWithUsername:@"" password:@""];
	[[PRIPrintClient sharedClient] printersAvailableSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[self updateWithPrintersArray:responseObject];
		}];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"FAILURE: %@", error);
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
	NSString *selectedPrinterIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultPrinterIdentifier"];
	
	PRIPrinterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PrinterCellIdentifier forIndexPath:indexPath];
	cell.printer = self.printers[indexPath.section][indexPath.row];
	cell.accessoryType = [cell.printer.identifier isEqualToString:selectedPrinterIdentifier] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		self.selectedPrinterCellIndexPath = indexPath;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *previouslySelectedCell = [tableView cellForRowAtIndexPath:self.selectedPrinterCellIndexPath];
	previouslySelectedCell.accessoryType = UITableViewCellAccessoryNone;
	
	self.selectedPrinterCellIndexPath = indexPath;
	PRIPrinterTableViewCell *selectedCell = (PRIPrinterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	[[NSUserDefaults standardUserDefaults] setObject:selectedCell.printer.identifier forKey:@"defaultPrinterIdentifier"];
	
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
	// + 1 as we add UITableViewIndexSearch to the section index.
	return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

@end
