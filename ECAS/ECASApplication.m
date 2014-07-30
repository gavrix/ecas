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
@property (nonatomic) NSURL *detailsUrl;
@property (nonatomic) NSString *status;
@end

@implementation ECASApplication

+ (instancetype)applicationWithName:(NSString *)name status:(NSString *)status detailsUrl:(NSURL *)detailsUrl {
	ECASApplication *_self = [self new];
	_self.name = name;
	_self.detailsUrl = detailsUrl;
	_self.status = status;
	return _self;
}
@end
