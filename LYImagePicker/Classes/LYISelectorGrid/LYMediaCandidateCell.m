//
//	LYMediaCandidateCell.m
//	LYImagePicker
//
//	CREATED BY LUO YU ON 2018-11-28.
//	COPYRIGHT © 2017-2018 LUO YU <indie.luo@gmail.com>. ALL RIGHTS RESERVED.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
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
		
		[_btnDel addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
