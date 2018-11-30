//
//	LYVideoRange.m
//	LYImagePicker
//
//	CREATED BY LUO YU ON 2018-11-30.
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

#import "LYVideoRange.h"
#import "LYRangeIndicator.h"
#import <Masonry/Masonry.h>


@interface LYVideoRange () {
	
	CGFloat padding;
}
@end

@implementation LYVideoRange

// MARK: - ACTION

// MARK: - INIT

- (void)initial {
	[super initial];
	
	{
		// MARK: CONF
		self.backgroundColor = [UIColor clearColor];
		padding = 5;
	}
	
	{
		// MARK: THUMBNAILS
		UIScrollView *scrollview = [[UIScrollView alloc] init];
		[self addSubview:scrollview];
		_svCont = scrollview;
		
		[scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(padding);
			make.bottom.equalTo(self).offset(-padding);
			make.left.right.equalTo(self);
			make.height.mas_equalTo(60);
		}];
	}
	
	{
		LYRangeIndicator *indicator = [LYRangeIndicator view];
		indicator.frame = (CGRect){0, padding, 20, 60};
		[self addSubview:indicator];
		_indicatorBegin = indicator;
	}
	
	{
		LYRangeIndicator *indicator = [LYRangeIndicator view];
		indicator.frame = (CGRect){100, padding, 20, 60};
		[self addSubview:indicator];
		_indicatorEnd = indicator;
	}
}

// MARK: - METHOD

// MARK: PRIVATE METHOD

@end
