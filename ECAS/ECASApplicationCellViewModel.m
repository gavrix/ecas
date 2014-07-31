//
//  SRGApplicationCellViewModel.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/28/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASApplicationCellViewModel.h"

#import "ECASApplication.h"

#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation ECASApplicationCellViewModel
- (instancetype)init {
	self = [super init];
	if (self) {
		RAC(self, appName) = RACObserve(self, application.name);
		RAC(self, appStatus) = RACObserve(self, application.status);
	}
	return self;
}
@end
