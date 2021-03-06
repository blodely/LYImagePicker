//
//	LYImagePicker.h
//	LYImagePicker
//
//	CREATED BY LUO YU ON 2017-06-14.
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

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <LYImagePicker/AVAsset+Meta.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <LYImagePicker/LYMediaGridPickerViewController.h>
#import <LYImagePicker/LYMediaGridCell.h>
#import <LYImagePicker/LYMediaCandidateCell.h>
#import <LYImagePicker/LYVideoSlider.h>
#import <LYImagePicker/LYVideoRange.h>
#import <LYImagePicker/UIImage+LYImagePicker.h>


FOUNDATION_EXPORT NSString *const LIB_IMAGE_PICKER_BUNDLE_ID;

typedef NS_ENUM(NSUInteger, LYImagePickerAspect) {
	LYImagePickerAspectSquare = 0,
	LYImagePickerAspect4w3 = 1,
	LYImagePickerAspect16w9 = 2,
};

typedef void(^LYMediaPickerDone)(NSArray *results);

@interface LYImagePicker : NSObject

+ (instancetype)kit;

/**
 authorization status check

 @param result result block
 */
- (void)authorizationPhotoStatus:(void (^)(PHAuthorizationStatus status))result;

/**
 check photo access authorization status

 @return authorized or not
 */
- (BOOL)authorizationPhotoCheck;

- (void)authorizationCameraStatus:(void (^)(AVAuthorizationStatus status))result;

/**
 check camera authorization status

 @return authorized or not
 */
- (BOOL)authorizationCameraCheck;

// MARK: - FETCH RESOURCES

/**
 fetch media(including photos and videos)

 @param action complete
 */
- (void)fetchMedia:(void (^)(NSArray<PHAsset *> *result))action;

/**
 fetch pictures

 @param action complete
 */
- (void)fetchPicture:(void (^)(NSArray<PHAsset *> *result))action;

/**
 fetch videos

 @param action complete
 */
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

/**
 REQUEST THE LATEST MEDIA THUMBNAIL.

 @param complete COMPLETION BLOCK
 */
- (void)requestLatestMediaComplete:(void (^)(UIImage *image))complete;

// MARK: - GENERATOR

- (void)generateThumbnailsForAsset:(AVAsset *)asset bound:(CGSize)size
						   numbers:(NSUInteger)count
						 completed:(void (^)(NSArray<UIImage *> *thumbnails))completion;

- (void)composeGifAnimationWithImages:(NSArray<UIImage *> *)images
					   delayEachFrame:(CGFloat)delay
					  destinationPath:(NSString *)filepath
							completed:(void (^)(void))completion;

@end

@interface NSBundle (LYImagePicker)
+ (NSBundle *)imgpickResBundle;
@end
