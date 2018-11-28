//
//  LYMediaGridPickerViewController.m
//  LYImagePicker
//
//  CREATED BY LUO YU ON 2018-11-28.
//  COPYRIGHT © 2017 LUO YU. ALL RIGHTS RESERVED.
//

#import "LYMediaGridPickerViewController.h"
#import "LYMediaGridCell.h"
#import <LYCategory/LYCategory.h>
#import <LYCore/LYCore.h>
#import <Photos/Photos.h>
#import <LYImagePicker/LYImagePicker.h>
#import <Masonry/Masonry.h>


@interface LYMediaGridPickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
	
	__weak UISegmentedControl *seg;
	__weak UICollectionView *cvGrid;
	__weak UICollectionView *cvCandidate;
	
	LYMediaPickerDone blockDonePick;
}
@end

@implementation LYMediaGridPickerViewController

// MARK: - ACTION

- (void)barCancelTapped:(id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)barDoneTapped:(id)sender {
	
	if (blockDonePick != nil) {
		blockDonePick(nil);
	} else {
		NSLog(@"BLOCK NOT FOUND");
	}
	
	[self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)segmentedChanged:(id)sender {
	
}

// MARK: - INIT

+ (UINavigationController *)nav {
	return [[UINavigationController alloc] initWithRootViewController:[[[self class] alloc] init]];
}

+ (UINavigationController *)navWithDonePickAction:(void (^)(NSArray *))action {
	id selfvc = [[[self class] alloc] init];
	[(LYMediaGridPickerViewController *)selfvc donePickAction:action];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selfvc];
	return nav;
}

- (void)initial {
	[super initial];
	
	_gridNumber = 5;
}

// MARK: VIEW LIFE CYCLE

- (void)loadView {
	[super loadView];
	
	{
		self.view.backgroundColor = [UIColor blackColor];
		self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
		self.navigationController.navigationBar;
	}
	
	{
		// MARK: NAV BAR
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barCancelTapped:)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barDoneTapped:)];
		self.navigationItem.title = @"";
	}
	
	{
		// MARK: SEGMENTED
		UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"视频", @"照片",]];
		[self.view addSubview:segment];
		seg = segment;
		
		[segment mas_makeConstraints:^(MASConstraintMaker *make) {
			if (@available(iOS 11.0, *)) {
				make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
			} else {
				make.top.equalTo(self.view);
			}
			make.centerX.equalTo(self.view);
			make.height.mas_equalTo(44);
		}];
		
		[seg setTitleTextAttributes:@{
									  NSForegroundColorAttributeName:[UIColor lightGrayColor],
									  NSFontAttributeName:[UIFont systemFontOfSize:15],
									  }
						   forState:UIControlStateNormal];
		[seg setTitleTextAttributes:@{
									  NSForegroundColorAttributeName:[UIColor whiteColor],
									  }
						   forState:UIControlStateSelected];
		[seg addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	{
		// MARK: COLLECTION VIEW : GRID
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		layout.minimumLineSpacing = 2;
		layout.minimumInteritemSpacing = 2;
		
		UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
		
		[self.view addSubview:collectionview];
		cvGrid = collectionview;
		
		[collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self->seg.mas_bottom);
			make.left.right.equalTo(self.view);
			make.height.equalTo(collectionview.mas_width);
		}];
		
		cvGrid.allowsMultipleSelection = YES;
		cvGrid.backgroundColor = [UIColor clearColor];
		cvGrid.delegate = self;
		cvGrid.dataSource = self;
		
		[cvGrid registerClass:[LYMediaGridCell class] forCellWithReuseIdentifier:LYMediaGridCellIdentifier];
	}
	
	{
		// MARK: COLLECTION VIEW : CANDIDATE
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
		
		[self.view addSubview:collectionview];
		cvCandidate = collectionview;
		
		[collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self.view);
			make.height.equalTo(collectionview.mas_width).multipliedBy(0.4);
			if (@available(iOS 11.0, *)) {
				make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
			} else {
				make.bottom.equalTo(self.view);
			}
		}];
		
		cvCandidate.backgroundColor = [UIColor clearColor];
		cvCandidate.delegate = self;
		cvCandidate.dataSource = self;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	for (id one in self.view.subviews) {
		[(UIView *)one border1Px];
	}
}

// MARK: - METHOD

- (void)donePickAction:(void (^)(NSArray *))action {
	if (action != nil) {
		blockDonePick = action;
	}
}

// MARK: PROPERTY

- (void)setGridNumber:(NSUInteger)gridNumber {
	_gridNumber = MAX(MIN(gridNumber, 8), 2);
}

// MARK: PRIVATE METHOD

// MARK: NETWORKING

// MARK: - DELEGATE

// MARK: UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)idp {
	
}

// MARK: UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger items = 0;
	
	if (collectionView == cvGrid) {
		items = 10;
		return items;
	}
	
	if (collectionView == cvCandidate) {
		items = 0;
		return items;
	}
	
	return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)idp {
	
	if (collectionView == cvGrid) {
		LYMediaGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYMediaGridCellIdentifier forIndexPath:idp];
		
		return cell;
	}
	
	if (collectionView == cvCandidate) {
		
		return nil;
	}
	
	return nil;
}

// MARK: UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)idp {
	CGSize size = CGSizeZero;
	size.width = floorf((WIDTH - ((_gridNumber - 1) * 2)) / _gridNumber);
	size.height = size.width;
	return size;
}

@end