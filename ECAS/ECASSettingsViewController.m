//
//  ECASSettingsViewController.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 4/29/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "ECASSettingsViewController.h"
#import "ECASIdentity.h"
#import "ECASIdentityViewModel.h"

#import "SRGDatePickerPopup.h"
#import "SRGListPickerPopup.h"

#import "ECASBackendService.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

NSString *kECASIdentityUpdatedNotification = @"kECASIdentityUpdatedNotification";
NSString *kECASIdentityNotificationKey = @"kECASIdentityNotificationKey";

@interface ECASSettingsViewController ()
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextfield;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayPlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *identificationTypeLabel;
@property (strong, nonatomic) IBOutlet UITextField *identificationNumberLabel;

@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayPlaceCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *identificationTypeCell;

@property (strong, nonatomic) IBOutlet UIToolbar *keyboardAccessoryView;


@property (nonatomic) ECASIdentityViewModel* identityViewModel;
@end

@implementation ECASSettingsViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	self.identityViewModel = [ECASIdentityViewModel new];
	self.identityViewModel.identity = [ECASIdentity globalIdentity];
}

- (void)setupUIBindings {
	[self.lastNameTextfield rac_textSignal];

	RACChannelTerminal *lastNameTerminal = RACChannelTo(self, identityViewModel.lastName);
	RAC(self, lastNameTextfield.text) = lastNameTerminal;
	[[RACObserve(self, lastNameTextfield) flattenMap:^RACStream *(UITextField *value) {
		return value.rac_textSignal;
	}] subscribe:lastNameTerminal];
	
	RAC(self.birthdayLabel, text) = RACObserve(self, identityViewModel.birthday);
	RAC(self.birthdayPlaceLabel, text) = RACObserve(self, identityViewModel.birthPlace);
	RAC(self.identificationTypeLabel, text) = RACObserve(self, identityViewModel.identificationType);
	
	RACChannelTerminal *identificationNumberTerminal = RACChannelTo(self, identityViewModel.identificationNumber);
	RAC(self, identificationNumberLabel.text) = identificationNumberTerminal;
	[[RACObserve(self, identificationNumberLabel) flattenMap:^RACStream *(UITextField *value) {
		return value.rac_textSignal;
	}] subscribe:identificationNumberTerminal];
	
	RAC(self.birthdayLabel, textColor) = RACObserve(self, identityViewModel.birthdayColor);
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupUIBindings];
	
	self.identificationNumberLabel.inputAccessoryView = self.keyboardAccessoryView;
	self.lastNameTextfield.inputAccessoryView = self.keyboardAccessoryView;
}

#pragma mark - User interaction handlers

- (IBAction)keyboardDoneButtonPressed:(id)sender {
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:kECASIdentityUpdatedNotification
															object:self
														  userInfo:@{kECASIdentityNotificationKey: self.identityViewModel.identity}];
	}];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	if (selectedCell == self.birthdayCell) {
		[SRGDatePickerPopup presentDatePickerWithInitialDate:self.identityViewModel.birthdayDate?:[NSDate date]
											  withCompletion:^(NSDate *date) {
			self.identityViewModel.birthdayDate = date;
		} withCancelled:nil];

	}
	else if (selectedCell == self.birthdayPlaceCell) {
		[SRGListPickerPopup presentListPickerWithOptions:[ECASCountries().rac_sequence map:^id(NSDictionary *value) {
			return [SRGListPopupOption optionWithValue:value[@"value"] name:value[@"name"]];
		}].array
										withInitalOption:[SRGListPopupOption optionWithValue:self.identityViewModel.birthPlaceValue name:self.identityViewModel.birthPlace]
										  withCompletion:^(SRGListPopupOption *option) {
											  self.identityViewModel.birthPlaceValue = option.value;
										  }
										   withCancelled:nil];
	}
	else if (selectedCell == self.identificationTypeCell) {
		__block int number = 0;
		[SRGListPickerPopup presentListPickerWithOptions:[ECASIdentificationTypes().rac_sequence map:^id(NSString *value) {
			return [SRGListPopupOption optionWithValue:[NSString stringWithFormat:@"%d", number++] name:value];
		}].array
										withInitalOption:[SRGListPopupOption optionWithValue:[self.identityViewModel.identificationTypeNumber description] name:self.identityViewModel.identificationType]
										  withCompletion:^(SRGListPopupOption *option) {
											  self.identityViewModel.identificationTypeNumber = @([option.value intValue]);
										  }
										   withCancelled:nil];
	}
}

@end
