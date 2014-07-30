//
//  SRGLoadableViewModel.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/30/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "SRGLoadableViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SRGLoadableViewModel ()
@property (nonatomic) id reloadTrigger;
@end

@implementation SRGLoadableViewModel

- (instancetype)init {
	self = [super init];
	if (self) {

		RACSignal *reloadTriggerSignal = [RACObserve(self, reloadTrigger) skip:1];
		RACSignal *loadableSignal = [[RACObserve(self, loadingSignal).switchToLatest
									  map: ^id (RACSignal *signal) {
		    return [[RACSignal return :signal] merge:[reloadTriggerSignal mapReplace:signal]];
		}].switchToLatest
									 map: ^id (RACSignal *loadingSignal) {
		    return loadingSignal.replayLazily;
		}].replayLast;
		
		RAC(self, lastError) = [loadableSignal map:^id(RACSignal *signal) {
			return [[signal.ignoreValues.materialize filter:^BOOL(RACEvent *event) {
				return event.eventType == RACEventTypeError;
			}] map:^id(RACEvent *event) {
				return event.error;
			}];
		}].switchToLatest;
		
		RAC(self, loadedResult) = [loadableSignal map:^id(RACSignal *signal) {
			return [signal catchTo:[RACSignal return:nil]];
		}].switchToLatest;
		
		RAC(self, loading) = [loadableSignal map:^id(RACSignal *signal) {
			return [RACSignal concat:@[
									   [RACSignal return:@YES],
									   [signal.ignoreValues catchTo:RACSignal.empty],
									   [RACSignal return:@NO]
									   ]];
		}].switchToLatest;

	}
	return self;
}

- (void)reload:(id)sender {
	self.reloadTrigger = @YES;
}
@end
