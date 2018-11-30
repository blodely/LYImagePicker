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
#import "LYImagePicker.h"
#import <Masonry/Masonry.h>


@interface LYVideoRange () {
	
	CGFloat cheight;
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
		cheight = 60;
	}
	
	{
		// MARK: THUMBNAILS
		UIScrollView *scrollview = [[UIScrollView alloc] init];
		[self addSubview:scrollview];
		_svCont = scrollview;
		
		[scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(self->padding);
			make.bottom.equalTo(self).offset(-self->padding);
			make.left.right.equalTo(self);
			make.height.mas_equalTo(self->cheight);
		}];
		
		_svCont.showsVerticalScrollIndicator = NO;
		_svCont.showsHorizontalScrollIndicator = NO;
		_svCont.backgroundColor = [UIColor clearColor];
	}
	
	{
		LYRangeIndicator *indicator = [LYRangeIndicator view];
		indicator.frame = (CGRect){0, self->padding, 20, 60};
		[self addSubview:indicator];
		_indicatorBegin = indicator;
	}
	
	{
		LYRangeIndicator *indicator = [LYRangeIndicator view];
		indicator.frame = (CGRect){100, self->padding, 20, 60};
		[self addSubview:indicator];
		_indicatorEnd = indicator;
	}
}

// MARK: - METHOD

- (void)updateThumbnails {
	
	for (id one in [_svCont subviews]) {
		[one removeFromSuperview];
	}
	
	[[LYImagePicker kit] generateThumbnailsForAsset:_asset bound:(CGSize){120, 120} numbers:10 completed:^(NSArray<UIImage *> *thumbnails) {
		
		if (thumbnails == nil) {
			// NO IMAGE
			return;
		}
		
		CGSize size = (CGSize){floorf(thumbnails.firstObject.size.width / thumbnails.firstObject.size.height * cheight), cheight};
		
		for (NSInteger i = 0; i < [thumbnails count]; i++) {
			
			UIImageView *iv = [[UIImageView alloc] init];
			iv.frame = (CGRect){size.width * i, 0, size.width, size.height};
			iv.image = thumbnails[i];
			[_svCont addSubview:iv];
			
			_svCont.contentSize = (CGSize){CGRectGetMaxX(iv.frame), cheight};
		}
	}];
}

// MARK: PRIVATE METHOD

@end
