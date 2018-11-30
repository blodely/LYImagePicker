//
//  LYImagePicker.h
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2017-06-14.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <LYImagePicker/LYMediaGridPickerViewController.h>
#import <LYImagePicker/LYMediaGridCell.h>
#import <LYImagePicker/LYMediaCandidateCell.h>


typedef void(^LYMediaPickerDone)(NSArray *results);

@interface LYImagePicker : NSObject

+ (instancetype)kit;

/**
 authorization status check

 @param result result block
 */
- (void)authorizationStatus:(void (^)(PHAuthorizationStatus status))result;

- (BOOL)authorizationCheck;

// MARK: - FETCH RESOURCES

//- (void)fetchMedia;

/**
 fetch pictures

 @param action complete
 */
- (void)fetchPicture:(void (^)(NSArray<PHAsset *> *result))action;

- (void)fetchVideo:(void (^)(NSArray<PHAsset *> *result))action;

// MARK: - REQUEST ASSET

- (void)requestPicture:(PHAsset *)asset targetSize:(CGSize)size complete:(void (^)(UIImage *image))complete;

- (void)requestVideo:(PHAsset *)asset complete:(void (^)(NSString *videopath))action;

/**
 REQUEST ASSET OBJECT FOR SPECIFIED VIDEO,
 WITH COMPLETION BLOCK GIVEN COVER IMAGE AND DURATION STRING.

 @param asset VIDEO ASSET
 @param size THUMBNAIL SIZE
 @param complete COMPLETION BLOCK
 */
- (void)requestVideoMeta:(PHAsset *)asset targetSize:(CGSize)size complete:(void (^)(UIImage *image, NSString *duration))complete;

/**
 REQUEST THE LATEST VIDEO'S COVER IMAGE.

 @param complete COMPLETION BLOCK
 */
- (void)requestLatestVideoCoverComplete:(void (^)(UIImage *image))complete;

@end
