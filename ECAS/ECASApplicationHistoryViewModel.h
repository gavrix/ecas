//
//  SRGApplicationStatusViewModel.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/23/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGLoadableViewModel.h"

@class ECASApplication;

@interface ECASApplicationHistoryViewModel : SRGLoadableViewModel

@property (nonatomic) ECASApplication *application;
@property (nonatomic) NSArray *statuses;

@end
