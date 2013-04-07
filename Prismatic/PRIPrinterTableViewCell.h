//
//  PRIPrinterTableViewCell.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRIPrinter;

@interface PRIPrinterTableViewCell : UITableViewCell

@property (strong, nonatomic) PRIPrinter *printer;

@end
