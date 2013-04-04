//
//  PRIPrintViewController.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRITableViewController.h"
#import "PRIPrintViewControllerDelegate.h"

@class SSLineView;
@class PRIFile;


@interface PRIPrintViewController : PRITableViewController

#pragma mark - Delegate
@property (weak) id<PRIPrintViewControllerDelegate> delegate;


#pragma mark - File
// The file to be printed
@property (strong) PRIFile *file;


#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *pagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *quotaLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedPrinterNameLabel;
@property (weak, nonatomic) IBOutlet SSLineView *printerSelectionSeparatorView;


#pragma mark - Actions
- (IBAction)print:(id)sender;
- (IBAction)cancel:(id)sender;


@end
