//
//  LYMediaCandidateCell.h
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2018-11-28.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import <LYCore/LYCore.h>


FOUNDATION_EXPORT NSString *const LYMediaCandidateCellIdentifier;

@class LYMediaCandidateCell;

@protocol LYMediaCandidateCellDelegate <NSObject>

@optional
- (void)deleteActionInMediaCandidateCell:(LYMediaCandidateCell *)cell;

@end

@interface LYMediaCandidateCell : LYCollectionCell

@property (weak, nonatomic) UIImageView *ivPic;
@property (weak, nonatomic) UIButton *btnDel;
@property (weak, nonatomic) UILabel *lblDuration;

@property (weak, nonatomic) id<LYMediaCandidateCellDelegate> delegate;

@end
