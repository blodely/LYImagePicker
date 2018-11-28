//
//  LYMediaGridPickerViewController.h
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2018-11-28.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import <LYCore/LYBaseViewController.h>


@interface LYMediaGridPickerViewController : LYBaseViewController

@property (nonatomic, assign) NSUInteger gridNumber;

+ (UINavigationController *)nav;
+ (UINavigationController *)navWithDonePickAction:(void (^)(NSArray *result))action;

- (void)donePickAction:(void (^)(NSArray *result))action;

@end
