//
//	LYMediaGridCell.m
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

#import "LYMediaGridCell.h"
#import <Masonry/Masonry.h>


NSString *const LYMediaGridCellIdentifier = @"LYMediaGridCellIdentifier";


@interface LYMediaGridCell () {
	__weak UIControl *cSelIdx;
}
@end

@implementation LYMediaGridCell

// MARK: - ACTION

- (void)mediaSelectionTapped:(id)sender {
	if ([self.delegate respondsToSelector:@selector(selectMediaInLYMediaGridCell:)]) {
		[self.delegate selectMediaInLYMediaGridCell:self];
	} else {
		NSLog(@"DELEGATE NOT FOUND");
	}
}

// MARK: - INIT

- (void)initial {
	[super initial];
	
	self.backgroundColor = [UIColor whiteColor];
	
	{
		// MARK: PICTURE
		UIImageView *imageview = [[UIImageView alloc] init];
		imageview.clipsToBounds = YES;
		[self addSubview:imageview];
		_ivPic = imageview;
		
		[imageview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
	}
	
	{
		// MARK: INDEX SELECTOR
		UIControl *control = [[UIControl alloc] init];
		[self addSubview:control];
		cSelIdx = control;
		
		[control mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(5);
			make.right.equalTo(self).offset(-5);
			make.width.height.mas_equalTo(18);
		}];
		
		[cSelIdx roundedCornerRadius:9];
		cSelIdx.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
		[cSelIdx borderWithWidth:2 andColor:[UIColor whiteColor]];
		cSelIdx.userInteractionEnabled = NO;
		[cSelIdx addTarget:self action:@selector(mediaSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	{
		// MARK: SELECTION INDEX LABEL
		UILabel *label = [[UILabel alloc] init];
		[cSelIdx addSubview:label];
		_lblSelIdx = label;
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self->cSelIdx);
		}];
		
		_lblSelIdx.font = [UIFont systemFontOfSize:14];
		_lblSelIdx.textColor = [UIColor whiteColor];
		_lblSelIdx.textAlignment = NSTextAlignmentCenter;
		_lblSelIdx.text = @"";
	}
	
	{
		// MARK: DURATION LABEL
		UILabel *label = [[UILabel alloc] init];
		[self addSubview:label];
		_lblDuration = label;
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.bottom.equalTo(self).offset(-5);
		}];
		
		_lblDuration.font = [UIFont systemFontOfSize:13];
		_lblDuration.textColor = [UIColor whiteColor];
		_lblDuration.textAlignment = NSTextAlignmentRight;
		_lblDuration.shadowOffset = (CGSize){1, 1};
		_lblDuration.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	
	if (selected) {
		cSelIdx.backgroundColor = self.tintColor;
	} else {
		cSelIdx.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
	}
}

@end
