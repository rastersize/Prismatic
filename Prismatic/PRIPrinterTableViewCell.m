//
//  PRIPrinterTableViewCell.m
//  Prismatic
//
//  Created by Aron Cedercrantz on 06-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import "PRIPrinterTableViewCell.h"
#import "PRIPrinter.h"

@interface PRIPrinterTableViewCell (/*Private*/)

@property (weak) IBOutlet UILabel *identifier;
@property (weak) IBOutlet UILabel *name;
@property (weak) IBOutlet UILabel *location;

@end


@implementation PRIPrinterTableViewCell

@synthesize printer = _printer;
- (PRIPrinter *)printer
{
	return _printer;
}

- (void)setPrinter:(PRIPrinter *)printer
{
	if (_printer != printer) {
		_printer = printer;
		[self updateLabels];
	}
}

- (void)updateLabels
{
	self.identifier.text = self.printer.identifier;
	self.name.text = self.printer.name ?: self.printer.identifier;
	self.location.text = self.printer.location ?: NSLocalizedString(@"Unknown location", @"Unknown printer location text.");
}

- (void)prepareForReuse
{
	self.printer = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
