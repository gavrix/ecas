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

#import <ReactiveCocoa/ReactiveCocoa.h>

@import iAd;

@interface ECASMainViewController ()
@property (nonatomic) ECASMainViewModel *viewModel;
@end

@implementation ECASMainViewController

- (void)awakeFromNib {
	[super awakeFromNib];

	self.viewModel = [[ECASMainViewModel alloc] init];

	RAC(self, viewModel.identity) = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kECASIdentityUpdatedNotification object:nil] map: ^id (NSNotification *value) {
	    return value.userInfo[kECASIdentityNotificationKey];
	}];
	
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark - UITableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.viewModel.applications.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplicationCell" forIndexPath:indexPath];
	ECASApplication *application = self.viewModel.applications[0];
	cell.textLabel.text = application.name;
	return cell;
}


@end
