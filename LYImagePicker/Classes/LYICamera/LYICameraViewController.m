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


@interface LYICameraViewController () {
	
	GPUImageVideoCamera *camera;
	__weak GPUImageView *vVideo;
}
@end

@implementation LYICameraViewController

// MARK: - ACTION

// MARK: - INIT

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
		camera.outputImageOrientation = UIInterfaceOrientationPortrait;
	}
	
	{
		GPUImageView *videoview = [[GPUImageView alloc] initWithFrame:(CGRect){0, 0, WIDTH, HEIGHT}];
		[self.view addSubview:videoview];
		vVideo = videoview;
		
		[camera addTarget:vVideo];
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
