//
//  AdvertisingCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdScrollView.h"

@interface AdvertisingCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic, strong) AdScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageArray; // 轮播图
@end
