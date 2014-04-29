//
//  SRGViewPopup.m
//  ECAS
//
//  Created by Sergey Gavrilyuk on 5/5/14.
//  Copyright (c) 2014 Sergey Gavrilyuk. All rights reserved.
//

#import "SRGViewPopup.h"

@interface SRGViewPopup ()
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *visibilityConstraint;

@end

@implementation SRGViewPopup

- (instancetype)initWithNib:(NSString *)nibFilename {
	self = [super init];
	if (self) {
		[[NSBundle mainBundle] loadNibNamed:nibFilename.length ? nibFilename : NSStringFromClass(self.class)
									  owner:self
									options:nil];
	}
	return self;
}


- (void)presentUI {
	UIView *container = [UIApplication sharedApplication].keyWindow;
	self.mainView.frame = container.bounds;
	[container addSubview:self.mainView];
	self.mainView.backgroundColor = [UIColor clearColor];
	self.visibilityConstraint.constant = -self.popupView.frame.size.height;
	[self.mainView setNeedsLayout];
	[self.mainView layoutIfNeeded];
	
	[UIView animateWithDuration:.3
						  delay:0
						options:(7 << 16)
					 animations:^{
						 self.visibilityConstraint.constant = 0;
						 [self.mainView setNeedsLayout];
						 [self.mainView layoutIfNeeded];
					 }
					 completion:nil];
	
	[UIView animateWithDuration:0.3
					 animations:^{
						 self.mainView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:.3];
					 }];
}

- (void)dismissUIWithCompletion:(void (^)())completionBlock {
	[UIView animateWithDuration:.3
						  delay:0
						options:(7 << 16)
					 animations:^{
						 self.visibilityConstraint.constant = -self.popupView.frame.size.height;
						 [self.mainView setNeedsLayout];
						 [self.mainView layoutIfNeeded];
					 }
					 completion:^(BOOL finished) {
						 [self.mainView removeFromSuperview];
						 if (completionBlock) {
							 completionBlock();
						 }
					 }];
	
	[UIView animateWithDuration:0.3
					 animations:^{
						 self.mainView.backgroundColor = UIColor.clearColor;
					 }];
}


@end
