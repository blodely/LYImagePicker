//
//	LYImagePicker.m
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

#import "LYImagePicker.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>


NSString *const LIB_IMAGE_PICKER_BUNDLE_ID = @"org.cocoapods.LYImagePicker";

@implementation LYImagePicker

// MARK: - INIT

+ (instancetype)kit {
	static LYImagePicker *sharedLYImagePicker;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedLYImagePicker = [[LYImagePicker alloc] init];
	});
	return sharedLYImagePicker;
}

- (instancetype)init {
	if (self = [super init]) {
		
	}
	return self;
}

// MARK: - METHOD

- (void)authorizationPhotoStatus:(void (^)(PHAuthorizationStatus status))result {
	result([PHPhotoLibrary authorizationStatus]);
}

- (BOOL)authorizationPhotoCheck {
	return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

- (void)authorizationCameraStatus:(void (^)(AVAuthorizationStatus))result {
	result([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]);
}

- (BOOL)authorizationCameraCheck {
	return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized;
}

// MARK: -

- (void)fetchMedia:(void (^)(NSArray<PHAsset *> *))action {
	
	if ([self authorizationPhotoCheck] == NO) {
		return;
	}
	
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.includeHiddenAssets = YES;
//	options.sortDescriptors = @[
//								[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
//								];
	// SORT KEYS: modificationDate creationDate
	
	NSMutableArray<PHAsset *> *assets = [NSMutableArray arrayWithCapacity:1];
	PHFetchResult *result = [PHAsset fetchAssetsWithOptions:options];
	[result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:[PHAsset class]]) {
			[assets addObject:obj];
		}
	}];
	
	if (action != nil) {
		action([assets reversed]);
	} else {
		NSLog(@"BLOCK NOT FOUND");
	}
	
	[assets removeAllObjects];
	assets = nil;
}

- (void)fetchPicture:(void (^)(NSArray<PHAsset *> *))action {
	
	if ([self authorizationPhotoCheck] == NO) {
		return;
	}
	
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.includeHiddenAssets = YES;
//	options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
	
	NSMutableArray<PHAsset *> *assets = [NSMutableArray arrayWithCapacity:1];
	
	PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
	
	[result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:[PHAsset class]]) {
			[assets addObject:obj];
		}
	}];
	
	if (action != nil) {
		action([assets reversed]);
	} else {
		NSLog(@"BLOCK NOT FOUND");
	}
	
	[assets removeAllObjects];
	assets = nil;
}

- (void)fetchVideo:(void (^)(NSArray<PHAsset *> *))action {
	
	if ([self authorizationPhotoCheck] == NO) {
		return;
	}
	
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.includeHiddenAssets = YES;
	options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
	
	NSMutableArray<PHAsset *> *assets = [NSMutableArray arrayWithCapacity:1];
	
	PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
	
	[result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj isKindOfClass:[PHAsset class]]) {
			[assets addObject:obj];
		}
	}];
	
	if (action != nil) {
		action([NSArray arrayWithArray:assets]);
	} else {
		NSLog(@"BLOCK NOT FOUND");
	}
	
	// DO CLEANUP
	[assets removeAllObjects];
	assets = nil;
}

// MARK: - REQUEST

- (void)requestPicture:(PHAsset *)asset targetSize:(CGSize)size complete:(void (^)(UIImage *))complete {
	
	PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
	options.synchronous = YES;
	options.resizeMode = PHImageRequestOptionsResizeModeFast;
	options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
	
	[[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (complete != nil) {
				complete(result);
			} else {
				NSLog(@"BLOCK NOT FOUND");
			}
		});
		
	}];
}

- (void)requestVideo:(PHAsset *)asset complete:(void (^)(NSString *))action {
	
	PHAssetResourceRequestOptions *options = [[PHAssetResourceRequestOptions alloc] init];
	options.networkAccessAllowed = NO; // PULL FROM ICLOUD
	[options setProgressHandler:^(double progress) {
		// PULL FROM NETWORKING PROGRESS
	}];
	
//	NSString *filepath = [[NSHomeDirectory() stringByAppendingString:@"/Documents"] stringByAppendingPathComponent:<#(nonnull NSString *)#>];
	
}

- (void)requestVideoMeta:(PHAsset *)asset targetSize:(CGSize)size complete:(void (^)(UIImage *, NSString *))complete {
	[[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
		
		if (complete != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				complete(result, [NSString stringWithFormat:@"%@.%@",
								  @(floor(asset.duration / 60)),
								  @((NSInteger)(asset.duration) % 60)]);
			});
		}
	}];
}

- (void)requestLatestVideoCoverComplete:(void (^)(UIImage *))complete {
	
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
	PHFetchResult *videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
	
	if ([videos count] <= 0) {
		return;
	}
	
	PHAsset *asset = [videos firstObject];
	
	[[PHImageManager defaultManager] requestImageForAsset:asset targetSize:(CGSize){80, 80} contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
		
		if (complete != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				complete(result);
			});
		}
	}];
}

- (void)requestLatestMediaComplete:(void (^)(UIImage *))complete {
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
	PHFetchResult *media = [PHAsset fetchAssetsWithOptions:options];
	
	if ([media count] <= 0) {
		if (complete != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				complete(nil);
			});
		}
		return;
	}
	
	PHAsset *asset = [media firstObject];
	
	[[PHImageManager defaultManager] requestImageForAsset:asset targetSize:(CGSize){80, 80} contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
		if (complete != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				complete(result);
			});
		}
	}];
}

// MARK: - GENERATOR

- (void)generateThumbnailsForAsset:(AVAsset *)asset bound:(CGSize)size numbers:(NSUInteger)count completed:(void (^)(NSArray<UIImage *> *))completion {
	
	float seconds = CMTimeGetSeconds(asset.duration);
	
	AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
	generator.appliesPreferredTrackTransform = YES;
	
	NSMutableArray<UIImage *> *result = [NSMutableArray arrayWithCapacity:1];
	
	for (NSInteger i = 0; i < count; i++) {
		CMTime time = CMTimeMakeWithSeconds((seconds * ((float)i / count)), 24);
		UIImage *image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:time actualTime:nil error:NULL]];
		[result addObject:[image resize:size]];
	}
	
	if (completion != nil) {
		completion([NSArray arrayWithArray:result]);
	} else {
		NSLog(@"BLOCK NOT FOUND");
	}
	
	[result removeAllObjects];
	result = nil;
}

- (void)composeGifAnimationWithImages:(NSArray<UIImage *> *)images
					   delayEachFrame:(CGFloat)delayparam
					  destinationPath:(NSString *)filepathparam
							completed:(void (^)(void))completion {
	
	if (images == nil) {
		if (completion != nil) {
			completion();
		}
		return;
	}
	
	NSString *filepath;
	if (filepathparam == nil || [filepathparam isKindOfClass:[NSString class]] == NO) {
		// FILEPATH ERROR
		// SET DEFAULT
		filepath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/animated.gif"];
	} else {
		filepath = filepathparam;
	}
	
	CGFloat delay;
	if (delayparam > 0) {
		delay = delayparam;
	} else {
		// DELAY PARAMETER ERROR
		// SET DEFAULT
		delay = ANIMATE;
	}
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		
		NSDictionary *propertiesFile = @{
										 (__bridge id)kCGImagePropertyGIFDictionary:@{
												 (__bridge id)kCGImagePropertyGIFLoopCount:@(0),
												 // 0 = LOOP FOREVER
												 },
										 };
		NSDictionary *propertiesFrame = @{
										  (__bridge id)kCGImagePropertyGIFDictionary:@{
												  (__bridge id)kCGImagePropertyGIFDelayTime:@(delay),
												  },
										  };
		
		CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filepath], kUTTypeGIF, [images count], NULL);
		CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)propertiesFile);
		
		for (UIImage *image in images) {
			@autoreleasepool {
				CGImageRef imgref = image.CGImage;
				CGImageDestinationAddImage(destination, imgref, (__bridge CFDictionaryRef)propertiesFrame);
			}
		}
		
		if (!CGImageDestinationFinalize(destination)) {
			NSLog(@"LYImagePicker - COMPOSE GIF - DESTINATION FAILED");
		} else {
			NSLog(@"LYImagePicker - COMPOSE GIF - DONE");
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			// CALL COMPLETION BLOCK
			if (completion != nil) {
				completion();
			}
		});
		
		// RELEASE DESTINATION
		CFRelease(destination);
	});
}

@end

@implementation NSBundle (LYImagePicker)
+ (NSBundle *)imgpickResBundle {
	return [NSBundle bundleWithURL:[[NSBundle bundleForClass:[LYImagePicker class]] URLForResource:@"LYImagePicker" withExtension:@"bundle"]];
}
@end
