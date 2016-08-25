//
//  UITabBar+badge.m
//  mydb
//
//  Created by lidan on 16/4/11.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "UITabBar+badge.h"

@implementation UITabBar (badge)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index withNum:(NSString *)num{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 9;//圆形
    badgeView.backgroundColor = MainColor;//颜色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / 5;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.05 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 18, 18);//圆形大小为10
    [self addSubview:badgeView];
    
    //显示数字
    UILabel * lbNum = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 18, 18)];
    lbNum.text = num;
    lbNum.font = [UIFont systemFontOfSize:10];
    lbNum.textAlignment = NSTextAlignmentCenter;
    lbNum.textColor = [UIColor whiteColor];
    [self addSubview:lbNum];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
