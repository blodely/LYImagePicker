//
//  LYMediaGridCell.m
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2018-11-28.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYMediaGridCell.h"
#import <Masonry/Masonry.h>


NSString *const LYMediaGridCellIdentifier = @"LYMediaGridCellIdentifier";


@interface LYMediaGridCell () {
	__weak UIControl *cSelIdx;
}
@end

@implementation LYMediaGridCell

- (void)initial {
	[super initial];
	
	self.backgroundColor = [UIColor whiteColor];
	
	{
		// MARK: PICTURE
		UIImageView *imageview = [[UIImageView alloc] init];
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
