//
//  LYICameraViewController.m
//	LYImagePicker
//
//	CREATED BY LUO YU ON 2019-01-02.
//	COPYRIGHT © 2017-2019 LUO YU <indie.luo@gmail.com>. ALL RIGHTS RESERVED.
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

#import "LYICameraViewController.h"
#import <GPUImage/GPUImage.h>
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>


@interface LYICameraViewController () {
	
	GPUImageVideoCamera *camera;
	__weak GPUImageView *vVideo;
	
	__weak LYView *barCamera;
	
	BOOL front;
	BOOL torch;
}
@end

@implementation LYICameraViewController

// MARK: - ACTION

- (void)backButtonPressed:(id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

// MARK: CAMERA BAR

- (void)cameraBarTimerTapped:(id)sender {
	
}

- (void)cameraBarFlashTapped:(id)sender {
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (front == NO && [device hasTorch] && [device isTorchModeSupported:torch ? AVCaptureTorchModeOff : AVCaptureTorchModeOn]) {
		[device lockForConfiguration:nil];
		[device setTorchMode:torch ? AVCaptureTorchModeOff : AVCaptureTorchModeOn];
		[device unlockForConfiguration];
		
		torch = !torch;
	}
}

- (void)cameraBarFlipTapped:(id)sender {
	
	[camera stopCameraCapture];
	[camera removeTarget:vVideo];
	
	if (front) {
		// USE BACK
		camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
		front = NO;
	} else {
		// USE FRONT
		camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
		front = YES;
	}
	
	camera.outputImageOrientation = UIInterfaceOrientationPortrait;
	[camera addTarget:vVideo];
	[camera startCameraCapture];
}

// MARK: - INIT

- (void)initial {
	[super initial];
	
	front = NO;
}

+ (UINavigationController *)cameraNav {
	LYICameraViewController *cameraVC = [[LYICameraViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraVC];
	[nav setNavigationBarHidden:YES];
	return nav;
}

// MARK: VIEW LIFE CYCLE

- (void)loadView {
	[super loadView];
	
	{
		camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
		front = NO;
		camera.outputImageOrientation = UIInterfaceOrientationPortrait;
	}
	
	{
		GPUImageView *videoview = [[GPUImageView alloc] initWithFrame:(CGRect){0, 0, WIDTH, HEIGHT}];
		[self.view addSubview:videoview];
		vVideo = videoview;
		
		[camera addTarget:vVideo];
	}
	
	{
		// MARK: NAV BACK BUTTON
		UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
		[button border1Px];
		[self.view addSubview:button];
		_btnBack = button;
		
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			if (@available(iOS 11.0, *)) {
				make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(6);
			} else {
				make.top.equalTo(self.view).offset(20 + 6);
			}
			make.left.equalTo(self.view);
			make.width.height.mas_equalTo(50);
		}];
		
		[_btnBack addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	{
		// MARK: CAMERA BAR
		
		{
			LYView *view = [LYView view];
			[self.view addSubview:view];
			barCamera = view;
			
			[view mas_makeConstraints:^(MASConstraintMaker *make) {
				if (@available(iOS 11.0, *)) {
					make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(6);
				} else {
					make.top.equalTo(self.view).offset(20 + 6);
				}
				make.right.equalTo(self.view);
				make.height.mas_equalTo(50);
			}];
		}
		
		{
			UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
			[button border1Px];
			[barCamera addSubview:button];
			_btnFlip = button;
			
			[button mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.bottom.equalTo(self->barCamera);
				make.right.equalTo(self->barCamera).offset(-6);
				make.width.mas_equalTo(50);
			}];
			
			[_btnFlip addTarget:self action:@selector(cameraBarFlipTapped:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		{
			UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
			[button border1Px];
			[barCamera addSubview:button];
			_btnFlash = button;
			
			[button mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.bottom.equalTo(self->barCamera);
				make.trailing.equalTo(self->_btnFlip.mas_leading).offset(-6);
				make.width.equalTo(self->_btnFlip);
			}];
			
			[_btnFlash addTarget:self action:@selector(cameraBarFlashTapped:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		{
			UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
			[button border1Px];
			[barCamera addSubview:button];
			_btnTimer = button;
			
			[button mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.bottom.equalTo(self->barCamera);
				make.trailing.equalTo(self->_btnFlash.mas_leading).offset(-6);
				make.width.equalTo(self->_btnFlip);
				
				make.left.equalTo(self->barCamera);
			}];
		}
	}
	
	{
		// MARK:
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[camera startCameraCapture];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[camera stopCameraCapture];
}

// MARK: MEMORY MANAGEMENT

// MARK: - METHOD

// MARK: PRIVATE METHOD

// MARK: NETWORKING

// MARK: - DELEGATE

// MARK:

// MARK: - NOTIFICATION

@end
