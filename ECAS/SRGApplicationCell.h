//
//  SRGApplicationCell.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/1/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRGApplicationCellViewModel;

@interface SRGApplicationCell : UITableViewCell
@property (nonatomic, readonly) SRGApplicationCellViewModel *viewModel;
@end
