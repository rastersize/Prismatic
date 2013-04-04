//
//  PRIPrintViewControllerDelegate.h
//  Prismatic
//
//  Created by Aron Cedercrantz on 04-04-2013.
//  Copyright (c) 2013 Aron Cedercrantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRIFile;
@class PRIPrintViewController;


@protocol PRIPrintViewControllerDelegate <NSObject>

- (void)printViewControllerWasCancelled:(PRIPrintViewController *)printViewController;
- (void)printViewController:(PRIPrintViewController *)printViewController wantsToPrintFile:(PRIFile *)file;

@end