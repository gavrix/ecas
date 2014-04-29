//
//  ECASSettingsViewController.h
//  ECAS
//
//  Created by Sergey Gavrilyuk on 4/29/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kECASIdentityUpdatedNotification;
extern NSString *kECASIdentityNotificationKey;

@class ECASIdentityViewModel;

@interface ECASSettingsViewController : UITableViewController

@property (nonatomic, readonly) ECASIdentityViewModel* identityViewModel;
@end
