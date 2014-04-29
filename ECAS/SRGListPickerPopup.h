//
//  SRGListPickerPopup.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/5/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "SRGViewPopup.h"

@interface SRGListPopupOption : NSObject

+ (instancetype)optionWithValue:(NSString *)value name:(NSString *)name;

@property (nonatomic, readonly) NSString *value;
@property (nonatomic, readonly) NSString *name;
@end

@interface SRGListPickerPopup : SRGViewPopup

+ (void)presentListPickerWithOptions:(NSArray *)optionsList
					withInitalOption:(SRGListPopupOption *)option
					  withCompletion:(void (^)(SRGListPopupOption *option))completionBlock
					   withCancelled:(void (^)())cancelBlock;

@end
