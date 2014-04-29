//
//  ECASApplication.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/6/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECASApplication : NSObject
+ (instancetype)applicationWithName:(NSString *)name statusUrl:(NSURL *)statusUrl;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSURL *statusUrl;

@end
