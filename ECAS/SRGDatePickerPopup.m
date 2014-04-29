//
//  SRGDatePickerPopup.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/2/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "SRGDatePickerPopup.h"

@interface SRGViewPopup (Private)
- (instancetype)initWithNib:(NSString *)nibFilename;
- (void)presentUI;
- (void)dismissUIWithCompletion:(void (^)())completionBlock;

@end

@interface SRGDatePickerPopup ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, copy) void (^completionBlock)(NSDate *date);
@property (nonatomic, copy) void (^cancelBlock)();
@end

@implementation SRGDatePickerPopup

- (instancetype)initWithNib:(NSString *)nibFilename {
	self = [super initWithNib:nibFilename];
	if (self) {
		self.datePicker.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

+ (void)presentDatePickerWithInitialDate:(NSDate *)date
						  withCompletion:(void (^)(NSDate *date))completionBlock
						   withCancelled:(void (^)())cancelBlock {
	SRGDatePickerPopup *_self = [[SRGDatePickerPopup alloc] initWithNib:nil];
	_self.datePicker.date = date;
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
	[_self presentUI];
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
		self.completionBlock(self.datePicker.date);
	}
}

@end
