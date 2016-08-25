//
//  UserDataView.h
//  zrdb
//
//  Created by mac03 on 16/1/27.
//  Copyright (c) 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDataView : UIView
@property (nonatomic, strong) UIImageView *bgImageView; //背景图片
@property (nonatomic, strong) UIButton *leBtn;//左按钮
@property (nonatomic, strong) UIButton *riBtn;//右按钮
//@property (nonatomic, strong) UIImageView *roundImageView; //头像背景
@property (nonatomic, strong) UIImageView *imgheadview; //用户头像
@property (nonatomic, strong) UIButton *haedBtn; //头像点击
@property (nonatomic, strong) UIButton *topUpBtn; //充值
@property (nonatomic, strong) UIButton *loginBtn; //登录
@property (nonatomic, strong) UILabel *nameLabel; //名字
@property (nonatomic, strong) UILabel *yueLabel; //余额
@end
