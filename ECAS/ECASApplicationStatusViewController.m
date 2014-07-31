//
//  SRGApplicationStatusViewController.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/23/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASApplicationStatusViewController.h"
#import "ECASApplicationStatusViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>


@interface ECASApplicationStatusViewController ()

@end

@implementation ECASApplicationStatusViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	self.viewModel = [ECASApplicationStatusViewModel new];
	[self rac_liftSelector:@selector(statusesUpdated:) withSignals:RACObserve(self, viewModel.statuses), nil];
	[self rac_liftSelector:@selector(setRefreshing:) withSignals:RACObserve(self, viewModel.loading), nil];
	[self.viewModel rac_liftSelector:@selector(reload:)
						 withSignals:[[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged]
									  mapReplace:self.refreshControl], nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.refreshControl = [[UIRefreshControl alloc] init];
}

#pragma mark - Reactive-backed methods

- (void)statusesUpdated:(NSArray *)statuses {
	[self.tableView reloadData];
}

- (void)setRefreshing:(BOOL)refreshing {
	if (refreshing) {
		[self.refreshControl beginRefreshing];
		[UIView animateWithDuration:0.25
		                 animations: ^(void) {
		    [UIView setAnimationBeginsFromCurrentState:YES];
		    self.tableView.contentOffset = CGPointMake(0, -(self.refreshControl.frame.size.height + self.topLayoutGuide.length));
		}];
	}
	else {
		[self.refreshControl endRefreshing];
	}
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
