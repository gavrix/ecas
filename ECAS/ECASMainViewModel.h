//
//  ECASMainViewModel.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/7/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECASIdentity;
@class RACSignal;

@interface ECASMainViewModel : NSObject

@property (nonatomic) ECASIdentity *identity;
@property (nonatomic) NSArray *applications;

@end
