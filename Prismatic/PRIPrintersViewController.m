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


@interface PRIPrintersViewController ()
@property (strong, readonly) NSMutableArray *printers;
@end

@implementation PRIPrintersViewController

- (void)viewWillAppear:(BOOL)animated
{
	[[PRIPrintClient sharedClient] setAuthorizationHeaderWithUsername:@"cedercra" password:@"4--iJD_H"];
	[[PRIPrintClient sharedClient] printersAvailableSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		DLog(@"operation: %@", operation);
		DLog(@"response: %@", responseObject);
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[self updateWithPrintersArray:responseObject];
		}];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		DLog(@"FAILURE: %@", error);
	}];
}

- (void)updateWithPrintersArray:(NSArray *)printers
{
	[self.printers setArray:printers];
	[self.tableView reloadData];
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.printers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *PrinterCellIdentifier = @"printerCell";
	PRIPrinterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PrinterCellIdentifier forIndexPath:indexPath];
	cell.printer = self.printers[indexPath.row];
	return cell;
}

@end
