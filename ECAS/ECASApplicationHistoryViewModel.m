//
//  SRGApplicationStatusViewModel.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/23/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASApplicationHistoryViewModel.h"
#import "ECASBackendService.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

@implementation ECASApplicationHistoryViewModel

- (instancetype)init {
	self = [super init];
	if (self) {
		
		self.loadingSignal = [RACObserve(self, application) map:^id(ECASApplication *application) {
			return application ? [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
				NSOperation *operation = [[ECASBackendService sharedService] queryApplicationStatus:application
				                                                                withCompletionBlock: ^(NSArray *statusRecords, NSError *error) {
				    if (error) {
				        [subscriber sendError:error];
					}
				    else {
				        [subscriber sendNext:statusRecords];
				        [subscriber sendCompleted];
					}
				}];
				return [RACDisposable disposableWithBlock: ^{
				    [operation cancel];
				}];
			}] : [RACSignal return:nil];
		}];
		
		RAC(self, statuses) = RACObserve(self, loadedResult);
	}
	return self;
}
@end
