//
//  SRGApplicationStatusViewController.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/23/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "SRGApplicationStatusViewController.h"
#import "SRGApplicationStatusViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>


@interface SRGApplicationStatusViewController ()

@end

@implementation SRGApplicationStatusViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	self.viewModel = [SRGApplicationStatusViewModel new];
	[self rac_liftSelector:@selector(statusesUpdated:) withSignals:RACObserve(self, viewModel.statuses), nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)statusesUpdated:(NSArray *)statuses {
	[self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.viewModel.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
	cell.textLabel.text = self.viewModel.statuses[indexPath.row];
	return cell;
}

@end
