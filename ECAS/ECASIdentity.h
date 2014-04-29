//
//  ECASIdentity.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 4/29/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>

NSArray *ECASIdentificationTypes();
NSArray *ECASCountries();
NSDictionary *ECASKeydConutriesNames();

@interface ECASIdentity : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *lastName;
@property (nonatomic) NSDate *birthday;
@property (nonatomic) NSNumber *identificationType;
@property (nonatomic) NSString *identificationNumber;
@property (nonatomic) NSString *placeOfBirth;

+ (instancetype)globalIdentity;
@end
