//
//	LYMediaGridPickerViewController.m
//	LYImagePicker
//
//	CREATED BY LUO YU ON 2018-11-28.
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

#import "LYMediaGridPickerViewController.h"
#import "LYMediaGridCell.h"
#import <LYCategory/LYCategory.h>
#import <LYCore/LYCore.h>
#import <Photos/Photos.h>
#import <LYImagePicker/LYImagePicker.h>
#import <Masonry/Masonry.h>


@interface LYMediaGridPickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LYMediaCandidateCellDelegate> {
	
	__weak UISegmentedControl *seg;
	__weak UICollectionView *cvGrid;
	__weak UICollectionView *cvCandidate;
	
	NSMutableArray<PHAsset *> *dsVideo;
	NSMutableArray<PHAsset *> *dsPic;
	
	NSMutableArray *dsSelIdx;
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
	
	[dsSelIdx removeAllObjects];
	
	[cvGrid reloadData];
	[cvCandidate reloadData];
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
	dsVideo = [NSMutableArray arrayWithCapacity:1];
	dsPic = [NSMutableArray arrayWithCapacity:1];
	dsSelIdx = [NSMutableArray arrayWithCapacity:1];
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
		
		[seg addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
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
		layout.minimumLineSpacing = 10;
		layout.minimumInteritemSpacing = 0;
		layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
		
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
		
		[cvCandidate registerClass:[LYMediaCandidateCell class] forCellWithReuseIdentifier:LYMediaCandidateCellIdentifier];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	seg.selectedSegmentIndex = 0;
	
	for (id one in self.view.subviews) {
		[(UIView *)one border1Px];
	}
	
	[[LYImagePicker kit] fetchVideo:^(NSArray<PHAsset *> *result) {
		
		[self->dsVideo removeAllObjects];
		[self->dsVideo addObjectsFromArray:result];
//		[self->cvGrid reloadData];
		
	}];
	
	[[LYImagePicker kit] fetchPicture:^(NSArray<PHAsset *> *result) {
		[self->dsPic removeAllObjects];
		[self->dsPic addObjectsFromArray:result];
	}];
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
	
	if (collectionView == cvGrid) {
		
		// GONNA SELECT
		[dsSelIdx addObject:@(idp.item)];
		
		__weak LYMediaGridCell *cell = (LYMediaGridCell *)[collectionView cellForItemAtIndexPath:idp];
		cell.lblSelIdx.text = [@([dsSelIdx indexOfObject:@(idp.item)] + 1) string];
		
		[cvCandidate reloadData];
	}
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)idp {
	
	if (collectionView == cvGrid) {
		// GONNA DESELECT
		[dsSelIdx removeObject:@(idp.item)];
		
		__weak LYMediaGridCell *cell = (LYMediaGridCell *)[collectionView cellForItemAtIndexPath:idp];
		cell.lblSelIdx.text = @"";
		
		[cvCandidate reloadData];
	}
}

// MARK: UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger items = 0;
	
	if (collectionView == cvGrid) {
		items = seg.selectedSegmentIndex == 0 ? [dsVideo count] : [dsPic count];
		return items;
	}
	
	if (collectionView == cvCandidate) {
		items = [dsSelIdx count];
		return items;
	}
	
	return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)idp {
	
	if (collectionView == cvGrid) {
		LYMediaGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYMediaGridCellIdentifier forIndexPath:idp];
		cell.tintColor = [UIColor coreThemeColor];
		if (cell.selected) {
			cell.lblSelIdx.text = [@([dsSelIdx indexOfObject:@(idp.item)] + 1) string];
		} else {
			cell.lblSelIdx.text = @"";
		}
		
		if (seg.selectedSegmentIndex == 0) {
			[[LYImagePicker kit] requestVideoMeta:dsVideo[idp.item] targetSize:(CGSize){100, 100} complete:^(UIImage *image, NSString *duration) {
				cell.ivPic.image = image;
				cell.lblDuration.text = duration;
			}];
		} else if (seg.selectedSegmentIndex == 1) {
			[[LYImagePicker kit] requestPicture:dsPic[idp.item] targetSize:(CGSize){100, 100} complete:^(UIImage *image) {
				cell.ivPic.image = image;
				cell.lblDuration.text = @"";
			}];
		}
		
		return cell;
	}
	
	if (collectionView == cvCandidate) {
		LYMediaCandidateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYMediaCandidateCellIdentifier forIndexPath:idp];
		cell.delegate = self;
		
		if (seg.selectedSegmentIndex == 0) {
			[[LYImagePicker kit] requestVideoMeta:dsVideo[[dsSelIdx[idp.item] integerValue]] targetSize:(CGSize){100, 100} complete:^(UIImage *image, NSString *duration) {
				cell.ivPic.image = image;
				cell.lblDuration.text = duration;
			}];
		} else if (seg.selectedSegmentIndex == 1) {
			[[LYImagePicker kit] requestPicture:dsPic[[dsSelIdx[idp.item] integerValue]] targetSize:(CGSize){100, 100} complete:^(UIImage *image) {
				cell.ivPic.image = image;
				cell.lblDuration.text = @"";
			}];
		}
		
		return cell;
	}
	
	return nil;
}

// MARK: UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)idp {
	CGSize size = CGSizeZero;
	
	if (collectionView == cvGrid) {
		size.width = floorf((WIDTH - ((_gridNumber - 1) * 2)) / _gridNumber);
		size.height = size.width;
		return size;
	}
	
	if (collectionView == cvCandidate) {
		size.width = floorf((WIDTH - 50) / 4);
		size.height = size.width;
	}
	
	return size;
}

// MARK: LYMediaCandidateCellDelegate

- (void)deleteActionInMediaCandidateCell:(LYMediaCandidateCell *)cell {
	
	[dsSelIdx removeObjectAtIndex:[cvCandidate indexPathForCell:cell].item];
	
	[UIView performWithoutAnimation:^{
		[cvCandidate reloadData];
		[cvGrid reloadData];
	}];
	
	// RESELECT
	for (NSNumber *one in dsSelIdx) {
		[cvGrid selectItemAtIndexPath:[NSIndexPath indexPathForItem:one.integerValue inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionRight];
	}
}

@end
