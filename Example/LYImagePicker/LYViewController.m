//
//  LYViewController.m
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2017-06-14.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYViewController.h"
#import <LYImagePicker/LYImagePicker.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <Masonry/Masonry.h>
#import <FLAnimatedImage/FLAnimatedImage.h>


@interface LYViewController () {
	
	__weak UIButton *btnGridPick;
	__weak UIImageView *ivLatestVideo;
	__weak LYVideoRange *opRange;
	__weak FLAnimatedImageView *ivGif;
}

@end

@implementation LYViewController

- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"Image Picker Test App";
	
	CGFloat padding = 15;
	
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
		[button setTitle:@"Grid Picker" forState:UIControlStateNormal];
		[self.view addSubview:button];
		btnGridPick = button;
		
		[button bk_addEventHandler:^(id sender) {
			[self presentViewController:[LYMediaGridPickerViewController navWithDonePickAction:^(NSArray *result) {
				NSLog(@"RESULT %@", result);
			}] animated:YES completion:nil];
		} forControlEvents:UIControlEventTouchUpInside];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view).offset(100);
			make.left.equalTo(self.view).offset(padding);
			make.right.equalTo(self.view).offset(-padding);
			make.height.mas_equalTo(44);
		}];
	}
	
	{
		UIImageView *imageview = [[UIImageView alloc] init];
		[self.view addSubview:imageview];
		ivLatestVideo = imageview;
		
		[imageview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->btnGridPick.mas_bottom).offset(padding);
			make.left.equalTo(self.view).offset(padding);
			make.width.height.mas_equalTo(80);
		}];
	}
	
	{
		LYVideoRange *rangeview = [LYVideoRange control];
		[self.view addSubview:rangeview];
		opRange = rangeview;
		[opRange border1Px];
		[rangeview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->ivLatestVideo.mas_bottom).offset(padding);
			make.left.equalTo(self.view).offset(padding);
			make.right.equalTo(self.view).offset(-padding);
			make.height.mas_equalTo(70);
		}];
		
		
		opRange.indicatorBegin.ivBg.image = [UIImage imageNamed:@"indicator-bg"];
//		opRange.indicatorEnd.ivBg.image = [UIImage imageNamed:@"indicator-bg"];
		
		opRange.minDuration = 3;
		opRange.maxDuration = 16;
	}
	
	{
		FLAnimatedImageView *imageview = [[FLAnimatedImageView alloc] init];
		[self.view addSubview:imageview];
		ivGif = imageview;
		
		[imageview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->opRange.mas_bottom).offset(padding);
			make.left.equalTo(self.view).offset(padding);
			make.right.equalTo(self.view).offset(-padding);
			make.height.mas_equalTo(100);
		}];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// DO ANY ADDITIONAL SETUP AFTER LOADING THE VIEW, TYPICALLY FROM A NIB.
	
	[[LYImagePicker kit] authorizationPhotoStatus:^(PHAuthorizationStatus status) {
		switch (status) {
			case PHAuthorizationStatusNotDetermined: {
				// REQUEST
				[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
					
				}];
			} break;
			case PHAuthorizationStatusAuthorized: {
				// ALLOW
				[[LYImagePicker kit] fetchVideo:^(NSArray<PHAsset *> *result) {
					NSLog(@"VIDEO\nCOUNT=%@\n%@", @(result.count), result.firstObject);
				}];
				[[LYImagePicker kit] fetchPicture:^(NSArray<PHAsset *> *result) {
					NSLog(@"PICTURE\nCOUNT=%@\n%@", @(result.count), result.firstObject);
				}];
				
			} break;
			case PHAuthorizationStatusRestricted: {
				
			} break;
			case PHAuthorizationStatusDenied: {
				
			} break;
			default: {
			} break;
		}
	}];
	
	[[LYImagePicker kit] requestLatestVideoCoverComplete:^(UIImage *image) {
		self->ivLatestVideo.image = image;
	}];
	
	{
		PHFetchOptions *options = [[PHFetchOptions alloc] init];
		options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
		PHFetchResult *videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
		
		if ([videos count] <= 0) {
			return;
		}
		
		PHAsset *phasset = [videos firstObject];
		
		dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
		
		PHVideoRequestOptions *voptions = [[PHVideoRequestOptions alloc] init];
		__block AVAsset *asset;
		
		[[PHImageManager defaultManager] requestAVAssetForVideo:phasset options:voptions resultHandler:^(AVAsset * _Nullable assetin, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
			asset = assetin;
			dispatch_semaphore_signal(semaphore);
		}];
		
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
		
//		[opRange.svCont borderWithWidth:2 andColor:[UIColor whiteColor]];
		opRange.asset = asset;
		[opRange updateThumbnails];
		opRange.indicatorBody.bdTop.backgroundColor = [UIColor coreThemeColor];
		
		[[LYImagePicker kit] generateThumbnailsForAsset:asset bound:(CGSize){200, 200} numbers:5 completed:^(NSArray<UIImage *> *thumbnails) {
			NSString *gifpath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/the_animate.gif"];
			[[LYImagePicker kit] composeGifAnimationWithImages:thumbnails delayEachFrame:0.03 destinationPath:gifpath completed:^{
				NSLog(@"\nGIF IMAGE GENERATED\n\t%@", gifpath);
				self->ivGif.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:gifpath]];
			}];
		}];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// DISPOSE OF ANY RESOURCES THAT CAN BE RECREATED.
}

@end
