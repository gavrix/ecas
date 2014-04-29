//
//  ECASIdentityViewModel.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 4/29/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASIdentityViewModel.h"
#import "ECASIdentity.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

@interface ECASIdentityViewModel ()

@property (nonatomic) NSString *birthday;
@property (nonatomic) NSString *birthPlace;
@property (nonatomic) NSString *identificationNumber;
@property (nonatomic) NSString *identificationType;

@property (nonatomic) NSArray *erroringSignals;
@end

@implementation ECASIdentityViewModel

- (instancetype)init {
	self = [super init];
	if (self) {
		
		
		[self bindModelAttribute:@keypath(self.identity.lastName)
				 toViewAttribute:nil
			  toViewRawAttribute:@keypath(self.lastName)
				withMappingBlock:nil
			 withValidationBlock:^BOOL(NSString *value, NSError *__autoreleasing *errorPtr) {
				 if (!value.length) {
					 *errorPtr = [NSError errorWithDomain:@""
													 code:0
												 userInfo:@{NSLocalizedDescriptionKey: @"Lastname should not be empty"}];
					 return NO;
				 }
				 return YES;
			 }];
		
		[self bindModelAttribute:@keypath(self.identity.birthday)
				 toViewAttribute:@keypath(self.birthday)
			  toViewRawAttribute:@keypath(self.birthdayDate)
				withMappingBlock:^id(NSDate *value) {
					if (value) {
						NSDateFormatter *formatter = [NSDateFormatter new];
						[formatter setDateStyle:NSDateFormatterMediumStyle];
						return [formatter stringFromDate:value];
					}
					return @"Applicant's birthday";
				}
			 withValidationBlock:^BOOL(NSDate *value, NSError *__autoreleasing *errorPtr) {
				 if (!value) {
					 *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Birthday value should not be empty"}];
				 }
				 else {
					 NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
																			   fromDate:value
																				 toDate:[NSDate date]
																				options:0];
					 if (comps.year < 18) {
						 *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"You must be 18 to use this service"}];
					 }
				 }
				 return *errorPtr ? NO : YES;
			 }];
		
		[self bindModelAttribute:@keypath(self.identity.placeOfBirth)
				 toViewAttribute:@keypath(self.birthPlace)
			  toViewRawAttribute:@keypath(self.birthPlaceValue)
				withMappingBlock:^id(id value) {
					return ECASKeydConutriesNames()[value];
				}
			 withValidationBlock:^BOOL(NSString *value, NSError *__autoreleasing *errorPtr) {
				 if (!value.length) {
					 *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Place of birth value should not be empty"}];
				 }
				 else {
					 if (!ECASKeydConutriesNames()[value]) {
						 *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"No such place with code %@", value]}];
					 }
				 }
				 return *errorPtr ? NO : YES;
			 }];
		
		[self bindModelAttribute:@keypath(self.identity.identificationNumber)
				 toViewAttribute:nil
			  toViewRawAttribute:@keypath(self.identificationNumber)
				withMappingBlock:nil
			 withValidationBlock:^BOOL(NSString *value, NSError *__autoreleasing *errorPtr) {
				 if (!value.length) {
					 *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Identification Number should not be empty"}];
					 return NO;
				 }
				 return YES;
			 }];
		
		[self bindModelAttribute:@keypath(self.identity.identificationType)
				 toViewAttribute:@keypath(self.identificationType)
			  toViewRawAttribute:@keypath(self.identificationTypeNumber)
				withMappingBlock:^id(NSNumber *value) {
					return ECASIdentificationTypes()[value.intValue];
				}
			 withValidationBlock:^BOOL(NSNumber *value, NSError *__autoreleasing *errorPtr) {
				 if (!value) {
					 *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Identification Type should not be nil"}];
				 }
				 else if (value.intValue <0 || value.intValue >= ECASIdentificationTypes().count) {
					 *errorPtr = [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Identification Type number should fall into valid range"}];
				 }
				 return *errorPtr ? NO : YES;
			 }];
		
		RAC(self, birthdayColor) = [RACObserve(self, birthdayDate) map:^id(id value) {
			if (value) {
				return [UIColor blackColor];
			}
			return [UIColor lightGrayColor];
		}];
	}
	return self;
	
	
}

- (void)bindModelAttribute:(NSString *)modelKeypath
		   toViewAttribute:(NSString *)viewKeypath
		toViewRawAttribute:(NSString *)viewRawKeypath
		  withMappingBlock:(id (^)(id value))mappingBlock
	   withValidationBlock:(BOOL (^)(id value, NSError *__autoreleasing *errorPtr))validationBlock {

	NSParameterAssert(modelKeypath.length);
	NSParameterAssert(viewRawKeypath.length);
	
	RACChannelTerminal *modelTerminal = [[RACKVOChannel alloc] initWithTarget:self keyPath:modelKeypath nilValue:nil].followingTerminal;
	RACChannelTerminal *viewTerminal = [[RACKVOChannel alloc] initWithTarget:self keyPath:viewRawKeypath nilValue:nil].followingTerminal;
	
	
	RACSignal *viewValidatedSignal = [[viewTerminal skip:1] try:^BOOL(id value, NSError *__autoreleasing *errorPtr) {
		return validationBlock ? validationBlock(value, errorPtr) : YES;
	}];
		
	[modelTerminal subscribe:viewTerminal];
		
	if (viewKeypath.length) {
		[[RACSubscriptingAssignmentTrampoline alloc] initWithTarget:self nilValue:nil][viewKeypath] =
		[[self rac_valuesForKeyPath:modelKeypath observer:self] map:^id(id value) {
			return mappingBlock ? mappingBlock(value) : value;
		}];
	}
	[[[viewValidatedSignal catchTo:[RACSignal empty]] repeat] subscribe:modelTerminal];
	self.erroringSignals = [self.erroringSignals arrayByAddingObjectsFromArray:@[viewValidatedSignal]];
}


@end
