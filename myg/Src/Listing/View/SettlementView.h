//
//  SettlementView.h
//  yyxb
//
//  Created by 杨易 on 15/12/4.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettlementView;

@protocol SettlementViewDelegate <NSObject>
-(void)selectdWith:(SettlementView *)view;
@end

@interface SettlementView : UIView
@property (nonatomic, strong) UIButton *jiangpinBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isOpen;  // 是否打开
@property(nonatomic,weak)id<SettlementViewDelegate> delegate;
@end
