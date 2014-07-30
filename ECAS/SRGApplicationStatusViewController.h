//
//  SRGApplicationStatusViewController.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/23/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SRGApplicationStatusViewModel;

@interface SRGApplicationStatusViewController : UITableViewController
@property (nonatomic) SRGApplicationStatusViewModel *viewModel;
@end
