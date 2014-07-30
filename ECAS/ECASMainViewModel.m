//
//  ECASMainViewModel.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/7/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASMainViewModel.h"
#import "ECASBackendService.h"
#import "ECASIdentity.h"
#import "ECASApplication.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFHTTPRequestOperation.h>


@implementation ECASMainViewModel

- (instancetype)init {
	self = [super init];
	if (self) {
		RACSignal *(^loginSignal)(ECASIdentity *identity) = ^RACSignal *(ECASIdentity *identity) {
			return [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
			    NSOperation *operation = [[ECASBackendService sharedService] authenticateIdentity:identity
			                                                                  withCompletionBlock: ^(NSError *error) {
			        if (error) {
			            [subscriber sendError:error];
					}
			        else {
			            [subscriber sendNext:identity];
			            [subscriber sendCompleted];
					}
				}];
			    return [RACDisposable disposableWithBlock: ^{
			        [operation cancel];
				}];
			}];
		};
		
		RACSignal *applicationsSignalTemplate = [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
			NSOperation *operation = [[ECASBackendService sharedService] queryECASStatusWithCompletionBlock: ^(NSArray *applications, NSError *error) {
				if (error) {
					[subscriber sendError:error];
				}
				else {
					[subscriber sendNext:applications];
					[subscriber sendCompleted];
				}
			}];
			return [RACDisposable disposableWithBlock: ^{
				[operation cancel];
			}];
		}];

		self.loadingSignal = [RACObserve(self, identity) map:^id(ECASIdentity *identity) {
			return identity ? [loginSignal(identity) map:^id(id _) {
				return applicationsSignalTemplate;
			}].switchToLatest : [RACSignal return:nil];
		}];
		
		RAC(self, applications) = RACObserve(self, loadedResult);
	}
	return self;
}

@end
