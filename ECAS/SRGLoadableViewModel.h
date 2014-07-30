//
//  SRGLoadableViewModel.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/30/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface SRGLoadableViewModel : NSObject

@property (nonatomic) BOOL loading;
@property (nonatomic) NSError *lastError;

@property (nonatomic) id loadedResult;
@property (nonatomic) RACSignal *loadingSignal;

- (void)reload:(id)sender;
@end
