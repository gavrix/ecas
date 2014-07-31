//
//  SRGApplicationStatusViewController.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/23/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASApplicationHistoryViewController.h"
#import "ECASApplicationHistoryViewModel.h"
#import "ECASAppHistoryRecordCell.h"
#import "ECASAppHistoryRecordViewModel.h"


#import <ReactiveCocoa/ReactiveCocoa.h>


@interface ECASApplicationHistoryViewController ()

@property (strong, nonatomic) IBOutlet ECASAppHistoryRecordCell *prototypeCell;
@end

@implementation ECASApplicationHistoryViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	self.viewModel = [ECASApplicationHistoryViewModel new];
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

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	self.prototypeCell.bounds = (CGRect){
		.origin = CGPointZero,
		.size = {.width = self.tableView.bounds.size.width, 44.}
	};
	[self.prototypeCell setNeedsUpdateConstraints];
	[self.prototypeCell updateConstraintsIfNeeded];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = 44;
	
	self.prototypeCell.viewModel.historyRecord = self.viewModel.statuses[indexPath.row];
	
	[self.prototypeCell setNeedsLayout];
    [self.prototypeCell layoutIfNeeded];

	height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ECASAppHistoryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
	cell.viewModel.historyRecord = self.viewModel.statuses[indexPath.row];
	return cell;
}

@end
