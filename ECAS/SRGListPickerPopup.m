//
//  SRGListPickerPopup.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/5/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "SRGListPickerPopup.h"

@interface SRGListPopupOption ()
@property (nonatomic) NSString *value;
@property (nonatomic) NSString *name;
@end

@implementation SRGListPopupOption

+ (instancetype)optionWithValue:(NSString *)value name:(NSString *)name {
	SRGListPopupOption *_self = [self.class new];
	_self.value = value;
	_self.name = name;
	return _self;
}

- (NSUInteger)hash {
	return self.value.hash;
}

- (BOOL)isEqual:(id)object {
	return [object isKindOfClass:self.class] && [self.value isEqual:[(SRGListPopupOption *)object value]];
}

@end


@interface SRGViewPopup ()
- (instancetype)initWithNib:(NSString *)nibFilename;
- (void)presentUI;
- (void)dismissUIWithCompletion:(void (^)())completionBlock;
@end

@interface SRGListPickerPopup () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *listPickerView;

@property (nonatomic, copy) void (^completionBlock)(SRGListPopupOption *option);
@property (nonatomic, copy) void (^cancelBlock)();

@property (nonatomic) NSString *defaultPlaceholder;
@property (nonatomic) NSArray *options;
//@property (nonatomic)

@end

@implementation SRGListPickerPopup

+ (void)presentListPickerWithOptions:(NSArray *)optionsList
					withInitalOption:(SRGListPopupOption *)option
					  withCompletion:(void (^)(SRGListPopupOption *option))completionBlock
					   withCancelled:(void (^)())cancelBlock {
	NSParameterAssert(optionsList.count);
	
	SRGListPickerPopup *_self = [[SRGListPickerPopup alloc] initWithNib:nil];
	_self.options = optionsList;
	_self.completionBlock = completionBlock;
	_self.cancelBlock = ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
		(void)_self;
#pragma clang diagnostic pop
		if (cancelBlock) {
			cancelBlock();
		}
	};
	NSUInteger selectedOption = [optionsList indexOfObject:option];
	selectedOption = (selectedOption == NSNotFound) ? 0 : selectedOption;
	
	[_self.listPickerView selectRow:selectedOption inComponent:0 animated:NO];
	[_self presentUI];
}


#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.defaultPlaceholder.length ? self.options.count + 1 :  self.options.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.options[row] name];
}

#pragma mark - User action handlers
- (IBAction)cancelButtonPressed:(id)sender {
	[self dismissUIWithCompletion:^{
		self.cancelBlock = nil;
		self.completionBlock = nil;
	}];
	if (self.cancelBlock) {
		self.cancelBlock();
	}
}

- (IBAction)doneButtonPressed:(id)sender {
	[self dismissUIWithCompletion:^{
		self.cancelBlock = nil;
		self.completionBlock = nil;
	}];
	
	if (self.completionBlock) {
		self.completionBlock(self.options[[self.listPickerView selectedRowInComponent:0]]);
	}
}

@end
