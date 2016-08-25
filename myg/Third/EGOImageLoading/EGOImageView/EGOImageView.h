//
//  EGOImageView.h
//  EGOImageLoading
//
//  Created by Shaun Harrison on 9/15/09.
//  Copyright (c) 2009-2010 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader.h"
#import "EGOCache.h"

typedef enum
{
    ImageAnimationNone = 0,
    ImageAnimationSmallToBig,
    ImageAnimationFlip,
    ImageAnimation3DMakeRotate
}EGOImageAnimation;

@protocol EGOImageViewDelegate;
@interface EGOImageView : UIImageView <EGOImageLoaderObserver>
{
	NSURL* imageURL;
	UIImage* placeholderImage;
	id<EGOImageViewDelegate> __unsafe_unretained delegate;
}

- (id)initWithPlaceholderImage:(UIImage*)anImage; // delegate:nil
- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageViewDelegate>)aDelegate;

- (void)cancelImageLoad;

@property(nonatomic,strong) NSURL* imageURL;
@property(nonatomic,strong) UIImage* placeholderImage;
@property(nonatomic,unsafe_unretained) id<EGOImageViewDelegate> delegate;

@property(nonatomic,assign) EGOImageAnimation hasAnimateType;
@property(nonatomic,assign) BOOL isRoundCorner;
@property(nonatomic,assign) NSInteger imageCornerRadis;
@property(nonatomic,assign) BOOL shouldAdjustPlaceholder;   //是否自适应placeholder, 默认yes

//add by liukun
@property(nonatomic,assign) EGOCacheType    cacheType;  //缓存类型, defaultis: EGOCacheTypeDefault
@property(nonatomic,copy  ) NSString       *nameSpace;  //命名空间，即缓存路径，默认"EGOImage"
@property(nonatomic,assign) NSTimeInterval  cacheAge;   //文件缓存寿命，只有在有文件缓存时有效


@end

@protocol EGOImageViewDelegate<NSObject>
@optional
- (void)imageViewLoadedImage:(EGOImageView*)imageView;
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error;
@end