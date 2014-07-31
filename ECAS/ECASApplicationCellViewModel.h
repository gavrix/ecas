//
//  SRGApplicationCellViewModel.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 7/28/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ECASApplication;

@interface ECASApplicationCellViewModel : NSObject
@property (nonatomic) ECASApplication *application;

@property (nonatomic) NSString *appName;
@property (nonatomic) NSString *appStatus;

@end
