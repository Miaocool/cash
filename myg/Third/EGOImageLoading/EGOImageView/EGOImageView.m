//
//  EGOImageView.m
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

#import "EGOImageView.h"
#import "EGOImageLoader.h"
#import "ImageManipulator.h"

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)


@implementation EGOImageView
@synthesize imageURL, placeholderImage, delegate;
@synthesize hasAnimateType;
@synthesize shouldAdjustPlaceholder = _shouldAdjustPlaceholder;

- (void)commonSetUp
{
    self.placeholderImage = [UIImage imageNamed:@"defaultImage"];
    self.hasAnimateType = ImageAnimationNone;
    self.shouldAdjustPlaceholder = YES;
    
    self.cacheType = EGOCacheTypeDefault;
    self.nameSpace = kEGOCacheNameSpaceDefault;
    self.cacheAge = KEGOCacheAgeDefault;
}

- (void)awakeFromNib
{
    [self commonSetUp];
}

- (id)initWithPlaceholderImage:(UIImage*)anImage
{
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageViewDelegate>)aDelegate
{
	if((self = [super initWithImage:anImage]))
    {
        [self commonSetUp];
		self.placeholderImage = anImage;
        self.delegate = aDelegate;
	}
	
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonSetUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetUp];
    }
    return self;
}

- (void)setImageURL:(NSURL *)aURL
{
	if(imageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		imageURL = nil;
	}
	
    self.image = self.placeholderImage;
    if (!aURL)  return;
    imageURL = aURL;

    NSDictionary *userInfo = @{@"cacheType":@(self.cacheType),
                               @"nameSpace":self.nameSpace,
                               @"cacheAge":@(self.cacheAge)};
	UIImage* image = [[EGOImageLoader sharedImageLoader] imageForURL:aURL
                                              shouldLoadWithObserver:self
                                                          attributes:userInfo];
	
	if(image)
    {
        self.image = image;
		// trigger the delegate callback if the image was found in the cache
        if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)]) 
        {
            [self.delegate imageViewLoadedImage:self];
        }
	}
}

- (void)setImage:(UIImage *)image
{
    //根据图片大小自适应placeholder
    if (image == self.placeholderImage && self.shouldAdjustPlaceholder)
    {
        image = [self adjustPlaceholderImage:self.placeholderImage];
    }
    
    if (_isRoundCorner) {
        UIImage *roundImage = [ImageManipulator makeRoundCornerImage:image :_imageCornerRadis :_imageCornerRadis];
        [super setImage:roundImage];
    }else{
        [super setImage:image];
    }
}

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad
{
	[[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification
{
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;

	UIImage *image = [[notification userInfo] objectForKey:@"image"];
    
    if ([image isKindOfClass:[UIImage class]])
    {
        self.image = image;
    }
    
	[self setNeedsDisplay];
    
    //animation
    switch (self.hasAnimateType) {
        case ImageAnimationSmallToBig:
        {    
            CGRect firstFrame = self.frame;
            CGRect frame = self.frame;
            frame.origin.x = firstFrame.size.width/2;
            frame.origin.y = firstFrame.size.height/2;
            frame.size.width = 1;
            frame.size.height = 1;
            self.frame = frame;
            [self.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            
            [UIView beginAnimations:@"show" context:NULL];
            //[UIView setAnimationCurve:UIViewAnimationCurveLinear];
            //  [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.4f];
           // [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
            
            self.frame = firstFrame;
            
            [UIView commitAnimations];
            
            break;
        }  
            
        case ImageAnimationFlip:
        {    
            
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:0.4f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationRepeatAutoreverses:NO];
            //UIButton *theButton = (UIButton *)sender;
            
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.superview cache:NO];
            
            [self.superview exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
            [UIView commitAnimations];
            
            break;
        }  
            
        case ImageAnimation3DMakeRotate:
        {
            CABasicAnimation *origeScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            origeScaleAnimation.fromValue = [NSNumber numberWithDouble:0.3];
            origeScaleAnimation.toValue = [NSNumber numberWithDouble:1.0];
            origeScaleAnimation.duration = 0.4f;
            //    origeScaleAnimation.autoreverses			= NO;
            origeScaleAnimation.repeatCount			= 1;  //"forever"
            origeScaleAnimation.removedOnCompletion	= YES;
            
            CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(150), 0.7, 0.3, 0.4)];
            transformAnimation.duration = 0.4;
            transformAnimation.autoreverses = NO;
            transformAnimation.repeatCount = 1;
            transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            
            CAAnimationGroup *animGroup = [CAAnimationGroup animation];
            animGroup.animations = [NSArray arrayWithObjects:
                                    transformAnimation,
                                    origeScaleAnimation,
                                    nil];
            animGroup.duration = 0.4;
            // animGroup.delegate = self;
            //    animGroup.autoreverses = NO;
            //  animGroup.removedOnCompletion = YES;
            animGroup.repeatCount = 1;
            
            [self.layer addAnimation:animGroup forKey:@"ANimiad"];
        }    
            
        default:
            break;
    }

	
	if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
    {
		[self.delegate imageViewLoadedImage:self];
	}	
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification
{
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
	if([self.delegate respondsToSelector:@selector(imageViewFailedToLoadImage:error:)])
    {
		[self.delegate imageViewFailedToLoadImage:self
                                            error:[[notification userInfo] objectForKey:@"error"]];
	}
}

#pragma mark -
- (void)dealloc
{
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	self.imageURL = nil;
    
}

//根据imageView的大小自适应图片
- (UIImage *)adjustPlaceholderImage:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    CGFloat maxWidth = image.size.width;
    
    CGFloat width = self.bounds.size.width*2;
    CGFloat height = self.bounds.size.height*2;
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    
    CGRect imageRect = CGRectZero;
    if (width > height) {
        CGFloat s = MIN(maxWidth, height);
        imageRect = CGRectMake((width-s)/2, (height-s)/2, s, s);
    }else{
        CGFloat s = MIN(maxWidth, width);
        imageRect = CGRectMake((width-s)/2, (height-s)/2, s, s);
    }
    
    //设置背景色，透明时注释掉
//    CGRect bounds = CGRectMake(0, 0, width, height);
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetFillColorWithColor(context, RGBCOLOR(250, 246, 237).CGColor);
//	CGContextFillRect(context, bounds);
    
    [image drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:1.0];
	
	UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return testImg;
}

@end
