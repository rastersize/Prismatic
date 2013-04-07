//
//  PRIPrintersViewController.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRITableViewController.h"

@class PRIPrinter;


@interface PRIPrintersViewController : PRITableViewController
@property (strong) void (^selectedPrinterChangedBlock)(PRIPrinter *printer);
@property (strong) PRIPrinter *selectedPrinter;
@end
