//
//  LYImagePicker.m
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2017-06-14.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYImagePicker.h"

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

- (void)authorizationStatus:(void (^)(PHAuthorizationStatus status))result {
	result([PHPhotoLibrary authorizationStatus]);
}

- (BOOL)authorizationCheck {
	return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

- (void)fetchPicture:(void (^)(NSArray<PHAsset *> *))action {
	
	if ([self authorizationCheck] == NO) {
		return;
	}
	
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.includeHiddenAssets = YES;
	
	NSMutableArray<PHAsset *> *assets = [NSMutableArray arrayWithCapacity:1];
	
	PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
	
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
	
	[assets removeAllObjects];
	assets = nil;
}

- (void)fetchVideo:(void (^)(NSArray<PHAsset *> *))action {
	
	if ([self authorizationCheck] == NO) {
		return;
	}
	
	PHFetchOptions *options = [[PHFetchOptions alloc] init];
	options.includeHiddenAssets = YES;
	
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

@end
