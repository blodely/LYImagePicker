//
//  LYMediaCandidateCell.m
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2018-11-28.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYMediaCandidateCell.h"
#import <Masonry/Masonry.h>


NSString *const LYMediaCandidateCellIdentifier = @"LYMediaCandidateCellIdentifier";

@interface LYMediaCandidateCell () {}
@end

@implementation LYMediaCandidateCell

// MARK: - ACTION

- (void)deleteButtonPressed:(id)sender {
	if ([self.delegate respondsToSelector:@selector(deleteActionInMediaCandidateCell:)]) {
		[self.delegate deleteActionInMediaCandidateCell:self];
	} else {
		NSLog(@"DELEGATE NOT FOUND");
	}
}

// MARK: - INIT

- (void)initial {
	[super initial];
	
	self.backgroundColor = [UIColor clearColor];
	
	{
		// MARK: PICTURE
		UIImageView *imageview = [[UIImageView alloc] init];
		[self addSubview:imageview];
		_ivPic = imageview;
		
		[imageview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 10, 10));
		}];
	}
	
	{
		// MARK: DELETE BUTTON
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:button];
		_btnDel = button;
		
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.top.equalTo(self);
			make.width.height.mas_equalTo(20);
		}];
	}
	
	{
		// MARK: DURATION LABEL
		UILabel *label = [[UILabel alloc] init];
		[self addSubview:label];
		_lblDuration = label;
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.right.equalTo(self->_ivPic).offset(-5);
		}];
		
		_lblDuration.font = [UIFont systemFontOfSize:13];
		_lblDuration.textAlignment = NSTextAlignmentRight;
		_lblDuration.textColor = [UIColor whiteColor];
	}
}

@end
