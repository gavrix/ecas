//
//  ECASAppHistoryRecordCell.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/31/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASAppHistoryRecordCell.h"

#import "ECASAppHistoryRecordViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ECASAppHistoryRecordCell ()
@property (nonatomic) ECASAppHistoryRecordViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *historyRecordLabel;

@end

@implementation ECASAppHistoryRecordCell

- (void)awakeFromNib {
	self.viewModel = [ECASAppHistoryRecordViewModel new];
	RAC(self, historyRecordLabel.text) = RACObserve(self, viewModel.historyRecord);
}


@end
