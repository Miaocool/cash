//
//  UITabBar+badge.h
//  mydb
//
//  Created by lidan on 16/4/11.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index withNum:(NSString *)num;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
