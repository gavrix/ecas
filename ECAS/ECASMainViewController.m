//
//  SRGViewController.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 4/29/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASMainViewController.h"
#import "ECASSettingsViewController.h"
#import "ECASMainViewModel.h"
#import "ECASApplication.h"
#import "ECASIdentity.h"

#import "ECASApplicationCell.h"
#import "ECASApplicationCellViewModel.h"

#import "ECASApplicationHistoryViewController.h"
#import "ECASApplicationHistoryViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@import iAd;

@interface ECASMainViewController ()
@property (nonatomic) ECASMainViewModel *viewModel;
@end

@implementation ECASMainViewController

- (void)awakeFromNib {
	[super awakeFromNib];

	self.viewModel = [[ECASMainViewModel alloc] init];

	RAC(self, viewModel.identity) = [[RACSignal return:ECASIdentity.globalIdentity]
									 concat:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kECASIdentityUpdatedNotification object:nil]
											 map: ^id (NSNotification *value) {
	    return value.userInfo[kECASIdentityNotificationKey];
	}]].distinctUntilChanged;
	
	[self rac_liftSelector:@selector(applicationsUpdated:) withSignals:RACObserve(self, viewModel.applications), nil];
	[self rac_liftSelector:@selector(setRefreshing:) withSignals:RACObserve(self, viewModel.loading), nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.refreshControl = [[UIRefreshControl alloc] init];
	self.navigationItem.title = NSLocalizedString(@"Applications", "UIViewController's navigation title");
	
	[self.viewModel rac_liftSelector:@selector(reload:)
						 withSignals:[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged], nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)applicationsUpdated:(NSArray *)applications {
	[self.tableView reloadData];
}

#pragma mark - Reactive-backed methods

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

#pragma mark - UITableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.viewModel.applications.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 95.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ECASApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplicationCell" forIndexPath:indexPath];
	ECASApplication *application = self.viewModel.applications[indexPath.row];
	cell.viewModel.application = application;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self performSegueWithIdentifier:@"applicationStatus" sender:self.viewModel.applications[indexPath.row]];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"applicationStatus"]) {
		[(ECASApplicationHistoryViewController *)segue.destinationViewController viewModel].application = sender;
	}
}

@end
