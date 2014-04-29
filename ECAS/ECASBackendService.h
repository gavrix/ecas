//
//  ECASBackendService.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/6/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECASIdentity;
@class ECASApplication;
@class AFHTTPRequestOperation;

extern NSString *kECASBackendXPATHApplicationsKey;
extern NSString *kECASBackendXPATHApplicationNameKey;
extern NSString *kECASBackendXPATHApplicationLinkKey;


@interface ECASBackendService : NSObject

+ (instancetype)sharedService;

@property (nonatomic) NSDictionary *parserDescriptor;

- (AFHTTPRequestOperation *)authenticateIdentity:(ECASIdentity *)identity withCompletionBlock:(void (^)(NSError *error))completionBlock;
- (AFHTTPRequestOperation *)queryECASStatusWithCompletionBlock:(void (^)(NSArray *applications, NSError *error))completionBlock;
- (AFHTTPRequestOperation *)queryApplicationStatus:(ECASApplication *)application withCompletionBlock:(void (^)(NSArray *statusRecords, NSError *error))completionBlock;

@end
