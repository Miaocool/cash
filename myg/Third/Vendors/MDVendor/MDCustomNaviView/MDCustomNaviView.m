//
//  MDCustomNaviView.m
//  MDYNews
//
//  Created by Medalands on 15/3/3.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDCustomNaviView.h"

#define LessIos7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7? NO :YES)

@interface MDCustomNaviView ()

@property(nonatomic,assign)CGFloat XX;

@end

@implementation MDCustomNaviView



+(instancetype)creatWithDefaultFrame
{
    CGRect frame;
    
    if (LessIos7)
    {
        frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44);
    }else
    {
       frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    
    MDCustomNaviView * naviView = [[MDCustomNaviView alloc] initWithFrame:frame];
    

    return naviView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        if (LessIos7) {
            _XX = 20;
            
        }else
        {
            _XX = 0;
        }
        
    }
    return self;
}


-(void)setTitleView:(UIView *)titleView
{
    
    if (![titleView isEqual:_titleView])
    {
        
        if (_titleView)
        {
            [_titleView removeFromSuperview];
        }
        
        titleView.center = CGPointMake(self.center.x, self.center.y + (20 -_XX) / 2.);
        _titleView = titleView;
        
        [self addSubview:titleView];
    }
}


-(UIButton *)setCustomNaviLeftBarButtonItemImageWithController:(UIViewController *)controller action:(SEL)sel tag:(NSInteger)tag imageName:(NSString *)imageName
{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(5, 20 - _XX, 44, 44);
    
    UIImage *backImage=[UIImage imageNamed:imageName];
    
    button.tag = tag;
    
    [button setImage:backImage forState:UIControlStateNormal];
    
    [button addTarget:controller action:sel forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:button];
    
    return button;

    
}

-(UIButton *)setCustomNaviRightBarButtonItemImageWithController:(UIViewController *)controller action:(SEL)sel tag:(NSInteger)tag imageName:(NSString *)imageName
{
    UIImage *backImage=[UIImage imageNamed:imageName];
    
    UIButton * _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _backButton.frame = CGRectMake(self.frame.size.width - 49, 20 - _XX,44, 44);
    
    _backButton.tag = tag;
    
    [_backButton setImage:backImage forState:UIControlStateNormal];
    
    [_backButton addTarget:controller action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_backButton];
    
    return _backButton;

}


@end
