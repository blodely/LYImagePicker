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
#import <LYImagePicker/LYMediaGridPickerViewController.h>
#import <LYImagePicker/LYMediaGridCell.h>
#import <LYImagePicker/LYMediaCandidateCell.h>
#import <LYImagePicker/LYVideoRange.h>


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

// MARK: - GENERATOR

- (void)generateThumbnailsForAsset:(AVAsset *)asset bound:(CGSize)size numbers:(NSUInteger)count completed:(void (^)(NSArray<UIImage *> *thumbnails))completion;

@end
