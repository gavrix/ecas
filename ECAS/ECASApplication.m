//
//  ECASApplication.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/6/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASApplication.h"

@interface ECASApplication ()
@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *statusUrl;
@end

@implementation ECASApplication

+ (instancetype)applicationWithName:(NSString *)name statusUrl:(NSURL *)statusUrl {
	ECASApplication *_self = [self new];
	_self.name = name;
	_self.statusUrl = statusUrl;
	return _self;
}
@end
