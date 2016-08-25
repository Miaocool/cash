//
//  EGOImageButton.m
//  EGOImageLoading
//
//  Created by Shaun Harrison on 9/30/09.
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

#import "EGOImageButton.h"
#import "EGOImageLoader.h"

@implementation EGOImageButton
@synthesize imageURL, placeholderImage, delegate;

- (void)commonSetUp
{
    self.placeholderImage = [UIImage imageNamed:@"ebuy_default_image_placeholder.png"];
    self.shouldAdjustPlaceholder = YES;
    
    self.cacheType = EGOCacheTypeDefault;
    self.nameSpace = kEGOCacheNameSpaceDefault;
    self.cacheAge = KEGOCacheAgeDefault;
    
    [self setExclusiveTouch:YES];
}

- (void)awakeFromNib
{
    [self commonSetUp];
}

- (id)initWithPlaceholderImage:(UIImage*)anImage
{
	return [self initWithPlaceholderImage:anImage delegate:nil];	
}

- (id)initWithPlaceholderImage:(UIImage*)anImage delegate:(id<EGOImageButtonDelegate>)aDelegate
{
	if((self = [super initWithFrame:CGRectZero])) {
        [self commonSetUp];
		self.placeholderImage = anImage;
		self.delegate = aDelegate;
		[self setImage:self.placeholderImage forState:UIControlStateNormal];
	}
	
	return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self commonSetUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetUp];
    }
    return self;
}

+ (id)buttonWithType:(UIButtonType)buttonType
{
    EGOImageButton *btn = [super buttonWithType:buttonType];
    [btn commonSetUp];
    return btn;
}

- (void)setImageURL:(NSURL *)aURL
{
    if(imageURL) {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		imageURL = nil;
	}
	
    [self setImage:self.placeholderImage forState:UIControlStateNormal];
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
        [self setImage:image forState:UIControlStateNormal];
		// trigger the delegate callback if the image was found in the cache
        if([self.delegate respondsToSelector:@selector(imageButtonLoadedImage:)])
        {
            [self.delegate imageButtonLoadedImage:self];
        }
	}
    else
    {
        [self.activityView startAnimating];
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    //根据图片大小自适应placeholder
    if (image == self.placeholderImage && self.shouldAdjustPlaceholder)
    {
        image = [self adjustPlaceholderImage:self.placeholderImage];
    }
    
    [super setImage:image forState:state];
}

#pragma mark -
#pragma mark Image loading

- (void)cancelImageLoad {
	[[EGOImageLoader sharedImageLoader] cancelLoadForURL:self.imageURL];
	[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:self.imageURL];
}

- (void)imageLoaderDidLoad:(NSNotification*)notification
{
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
    
    [self.activityView stopAnimating];
	
    UIImage *anImage = [[notification userInfo] objectForKey:@"image"];
	
	if ([anImage isKindOfClass:[UIImage class]])
    {
        [self setImage:anImage forState:UIControlStateNormal];
    }
	
	if([self.delegate respondsToSelector:@selector(imageButtonLoadedImage:)])
    {
		[self.delegate imageButtonLoadedImage:self];
	}	
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification
{
	if(![[[notification userInfo] objectForKey:@"imageURL"] isEqual:self.imageURL]) return;
	
    [self.activityView stopAnimating];

    [self setImage:self.placeholderImage forState:UIControlStateNormal];
    
	if([self.delegate respondsToSelector:@selector(imageButtonFailedToLoadImage:error:)])
    {
		[self.delegate imageButtonFailedToLoadImage:self
                                              error:[[notification userInfo] objectForKey:@"error"]];
	}
}

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

#pragma mark -
#pragma mark activity

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        _activityView.hidesWhenStopped = YES;
        
        _activityView.frame = CGRectMake(self.width/2-10, self.height/2-10, 20, 20);
        
        [self addSubview:_activityView];
    }
    return _activityView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.activityView.frame = CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 20, 20);
}

#pragma mark -
- (void)dealloc
{
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	
	self.imageURL = nil;
}

@end
