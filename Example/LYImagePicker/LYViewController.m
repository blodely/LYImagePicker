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


@interface LYViewController ()

@end

@implementation LYViewController

- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"Image Picker Test App";
	
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
		[button setTitle:@"Grid Picker" forState:UIControlStateNormal];
		[self.view addSubview:button];
		[button bk_addEventHandler:^(id sender) {
			[self presentViewController:[LYMediaGridPickerViewController navWithDonePickAction:^(NSArray *result) {
				NSLog(@"RESULT %@", result);
			}] animated:YES completion:nil];
		} forControlEvents:UIControlEventTouchUpInside];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view).offset(100);
			make.left.equalTo(self.view).offset(15);
			make.right.equalTo(self.view).offset(-15);
			make.height.mas_equalTo(44);
		}];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// DO ANY ADDITIONAL SETUP AFTER LOADING THE VIEW, TYPICALLY FROM A NIB.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// DISPOSE OF ANY RESOURCES THAT CAN BE RECREATED.
}

@end
