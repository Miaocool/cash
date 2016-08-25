//
//  AdScrollView.h
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@interface AdScrollView : UIScrollView<UIScrollViewDelegate>

@property (retain,nonatomic,readonly) UIPageControl * pageControl;
@property (retain,nonatomic,readwrite) NSArray * imageNameArray;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;
@property (assign,nonatomic,readwrite) UIPageControlShowStyle  PageControlShowStyle;
@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;

//图片
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *rightImageView;

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
@end


