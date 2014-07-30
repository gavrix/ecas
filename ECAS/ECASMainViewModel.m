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

@interface ECASMainViewModel ()
@property (nonatomic) id refreshTrigger;
@end

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
		RACSignal *identitySignal = RACObserve(self, identity);
		RACSignal *applicationSignals = [[identitySignal merge:[RACObserve(self, refreshTrigger) flattenMap:^RACStream *(id value) {
			return [identitySignal take:1];
		}]] map: ^id (ECASIdentity *identity) {
		    return identity ? [loginSignal(identity) map:^id(id _) {
				return applicationsSignalTemplate;
			}].switchToLatest.replayLazily : [RACSignal return :nil];
		}].replayLast;

		RAC(self, lastError) = [[applicationSignals map:^id(RACSignal *signal) {
			return [[signal.ignoreValues.materialize filter:^BOOL(RACEvent *event) {
				return event.eventType == RACEventTypeError;
			}] map:^id(RACEvent *event) {
				return event.error;
			}];
		}].switchToLatest doNext:^(NSError *error) {
			NSLog(@"Error while getting applications: %@", error);
		}];
		
		RAC(self, applications) = [applicationSignals map:^id(RACSignal *signal) {
			return [signal catchTo:RACSignal.empty];
		}].switchToLatest;
		
		RAC(self, loading) = [applicationSignals map:^id(RACSignal *signal) {
			return [RACSignal concat:@[[RACSignal return:@YES],
									   [signal.ignoreValues catchTo:RACSignal.empty],
									   [RACSignal return:@NO],
									   ]];
		}].switchToLatest;
	}
	return self;
}

- (void)reloadApplications:(id)sender {
	self.refreshTrigger = @YES;
}
@end
