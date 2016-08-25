//
//  EGOImageViewEx.m
//  RabbitTiger
//
//  Created by Chenxi Cai on 14-10-29.
//  Copyright (c) 2014年 RabbitTiger. All rights reserved.
//

#import "EGOImageViewEx.h"


@implementation EGOImageViewEx

@synthesize exDelegate = exDelegate_;

@synthesize activityView = _activityView;


- (void)dealloc
{
}

- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{	
	
}
//捕获手指拖拽消息
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
}

//捕获手指拿开消息
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
	UITouch *touch = [touches anyObject];
    
    if (touch)
    {
        CGPoint location = [touch locationInView:self];
        if (location.x < self.width && location.x > 0 &&
            location.y < self.height && location.y > 0)
        {
            [self callEvent];
        }
    }
}


- (void)callEvent
{
    if ([exDelegate_ conformsToProtocol:@protocol(EGOImageViewExDelegate)])
    {
		if ([exDelegate_ respondsToSelector:@selector(imageExViewDidOk:)])
        {
			[exDelegate_ imageExViewDidOk:self];
		}
	}
}

- (void)setImageURL:(NSURL *)aURL
{
    if(imageURL)
    {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		imageURL = nil;
	}
    
    self.image = self.placeholderImage;
    if (!aURL) return;
    imageURL = aURL;
    
    NSDictionary *userInfo = @{@"cacheType":@(self.cacheType),
    @"nameSpace":self.nameSpace,
    @"cacheAge":@(self.cacheAge)};
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL
                                                shouldLoadWithObserver:self
                                                            attributes:userInfo];
	if(anImage)
    {
        self.image = anImage;
        
        // trigger the delegate callback if the image was found in the cache
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
        {
			[self.delegate imageViewLoadedImage:self];
		}
	}
    else
    {
        [self.activityView startAnimating];
    }
}


- (void)imageLoaderDidLoad:(NSNotification *)notification
{
    [self.activityView stopAnimating];
    
    [super imageLoaderDidLoad:notification];
}

- (void)imageLoaderDidFailToLoad:(NSNotification *)notification
{
    [self.activityView stopAnimating];
    
    [super imageLoaderDidFailToLoad:notification];
}

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



@end
