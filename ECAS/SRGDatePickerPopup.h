//
//  SRGDatePickerPopup.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/2/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGViewPopup.h"

@interface SRGDatePickerPopup : SRGViewPopup

+ (void)presentDatePickerWithInitialDate:(NSDate *)date
						  withCompletion:(void (^)(NSDate *date))completionBlock
						   withCancelled:(void (^)())cancelBlock;

@end
