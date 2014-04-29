//
//  ECASIdentityViewModel.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 4/29/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECASIdentity;
@class RACSignal;

@interface ECASIdentityViewModel : NSObject

// model
@property (nonatomic) ECASIdentity *identity;

//properties
@property (nonatomic) NSString *lastName;

@property (nonatomic, readonly) NSString *birthday;
@property (nonatomic) NSDate *birthdayDate;
@property (nonatomic, readonly) UIColor *birthdayColor;

@property (nonatomic, readonly) NSString *birthPlace;
@property (nonatomic) NSString *birthPlaceValue;

@property (nonatomic, readonly) NSString *identificationNumber;

@property (nonatomic, readonly) NSString *identificationType;
@property (nonatomic) NSNumber *identificationTypeNumber;

@property (nonatomic, readonly) NSString *errorMessage;

@end
