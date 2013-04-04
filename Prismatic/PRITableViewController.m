//
//  PRITableViewController.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRITableViewController.h"
#import "UIFont+Prismatic.h"

@implementation PRITableViewController

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
	UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
	headerView.textLabel.font = [UIFont pri_boldAppFontOfSize:headerView.textLabel.font.pointSize];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
	UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
	footerView.textLabel.font = [UIFont pri_appFontOfSize:footerView.textLabel.font.pointSize];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.textLabel.font = [UIFont pri_boldAppFontOfSize:cell.textLabel.font.pointSize];
	cell.detailTextLabel.font = [UIFont pri_appFontOfSize:cell.detailTextLabel.font.pointSize];
}


@end
