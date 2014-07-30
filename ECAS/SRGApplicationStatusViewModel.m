//
//  SRGApplicationStatusViewModel.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/23/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "SRGApplicationStatusViewModel.h"
#import "ECASBackendService.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

@implementation SRGApplicationStatusViewModel

- (instancetype)init {
	self = [super init];
	if (self) {
		RAC(self, statuses) = [RACObserve(self, application) map:^id(ECASApplication *application) {
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
		}].switchToLatest.replayLazily;
	}
	return self;
}
@end
