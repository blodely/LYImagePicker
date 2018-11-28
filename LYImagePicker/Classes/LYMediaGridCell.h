//
//  LYMediaGridCell.h
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2018-11-28.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import <LYCore/LYCore.h>


FOUNDATION_EXPORT NSString *const LYMediaGridCellIdentifier;

@interface LYMediaGridCell : LYCollectionCell

@property (weak, nonatomic) UIImageView *ivPic;
@property (weak, nonatomic) UILabel *lblSelIdx;
@property (weak, nonatomic) UILabel *lblDuration;

@end
