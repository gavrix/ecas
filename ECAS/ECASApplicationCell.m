//
//  SRGApplicationCell.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/1/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASApplicationCell.h"

#import "SRGApplicationCellViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ECASApplicationCell ()
@property (weak, nonatomic) IBOutlet UILabel *applicationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicationStatusLabel;

@property (nonatomic) SRGApplicationCellViewModel *viewModel;
@end

@implementation ECASApplicationCell


- (void)awakeFromNib {
	self.viewModel = [SRGApplicationCellViewModel new];
	
	RAC(self, applicationNameLabel.text) = RACObserve(self, viewModel.appName);
	RAC(self, applicationStatusLabel.text) = RACObserve(self, viewModel.appStatus);
}


@end
