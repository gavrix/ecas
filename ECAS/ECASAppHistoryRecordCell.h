//
//  ECASAppHistoryRecordCell.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/31/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECASAppHistoryRecordViewModel;

@interface ECASAppHistoryRecordCell : UITableViewCell
@property (nonatomic, readonly) ECASAppHistoryRecordViewModel *viewModel;
@end
