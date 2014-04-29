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
		self.identity = [ECASIdentity globalIdentity];
		
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

		RACSubject *errorSignal = [RACSubject subject];
		RACSignal *loginReusableSignal = [[[[[RACObserve(self, identity) merge:[errorSignal ignoreValues]] map: ^id (ECASIdentity *value) {
		    return value ? loginSignal(value) : [RACSignal return :nil];
		}] switchToLatest] repeat] replay];

		RACSignal *applicationSignals = [[[loginReusableSignal flattenMap: ^RACStream *(id value) {
		    return value ? [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
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
			}] : nil;
		}] replayLast] repeat];

		[[applicationSignals ignoreValues] subscribe:errorSignal];

		[[applicationSignals map:^id(NSArray *applications) {
			return [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
			    NSOperation *operation = [[ECASBackendService sharedService] queryApplicationStatus:applications[0]
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
			}];
			
		}].switchToLatest subscribeNext:^(NSArray *statuses) {
			NSLog(@"%@", statuses);
		}];
		
		RAC(self, applications) = [applicationSignals doNext:^(NSArray *x) {
			NSLog(@"Application status URL: %@", [x[0] statusUrl]);
		}];
	}
	return self;
}

@end
