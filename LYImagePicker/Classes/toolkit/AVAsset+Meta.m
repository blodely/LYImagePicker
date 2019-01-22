//
//  AVAsset+Meta.m
//	LYImagePicker
//
//	CREATED BY LUO YU ON 2019-01-16.
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

#import "AVAsset+Meta.h"
#import <GPUImage/GPUImage.h>


@implementation AVAsset (Meta)

- (NSInteger)rotationDegree {
	
	NSInteger degree = 0;
	
	NSArray *tracks = [self tracksWithMediaType:AVMediaTypeVideo];
	if (tracks != nil && [tracks count] > 0) {
		AVAssetTrack *videotrack = [tracks objectAtIndex:0];
		CGAffineTransform tf = videotrack.preferredTransform;
		
		if (tf.a == 0 && tf.b == 1.0 && tf.c == -1.0 && tf.d == 0){
			// PORTRAIT
			degree = 90;
		} else if (tf.a == 0 && tf.b == -1.0 && tf.c == 1.0 && tf.d == 0){
			// PORTRAIT UPSIDE DOWN
			degree = 270;
		} else if (tf.a == 1.0 && tf.b == 0 && tf.c == 0 && tf.d == 1.0){
			// LANDSCAPE RIGHT
			degree = 0;
		} else if (tf.a == -1.0 && tf.b == 0 && tf.c == 0 && tf.d == -1.0){
			// LANDSCAPE LEFT
			degree = 180;
		}
	}
	
	return degree;
}

- (GPUImageRotationMode)rotationModeInGPUImage {
	
	GPUImageRotationMode mode = kGPUImageNoRotation;
	
	switch ([self rotationDegree]) {
		case 0: {
			
		} break;
		case 90: {
			mode = kGPUImageRotateRight;
		} break;
		case 180: {
			mode = kGPUImageRotate180;
		} break;
		case 270: {
			mode = kGPUImageRotateLeft;
		} break;
		default:
			break;
	}
	
	return mode;
}

- (CGSize)metaSize {
	NSArray *tracks = [self tracksWithMediaType:AVMediaTypeVideo];
	if (tracks == nil || [tracks count] <= 0) {
		return CGSizeZero;
	}
	return [tracks[0] naturalSize];
}

- (CGSize)metaSizeRotationFixed {
	CGSize size = [self metaSize];
	
	NSInteger degree = [self rotationDegree];
	if (degree == 0 || degree == 180) {
		return size;
	}
	
	CGFloat sideW = size.height;
	CGFloat sideH = size.width;
	
	return (CGSize){sideW, sideH};
}

@end
