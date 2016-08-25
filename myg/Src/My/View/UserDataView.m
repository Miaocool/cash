//
//  UserDataView.m
//  zrdb
//
//  Created by mac03 on 16/1/27.
//  Copyright (c) 2016年 杨易. All rights reserved.
//

#import "UserDataView.h"

@implementation UserDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    //背景图片
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageNamed:@"bg_user_top"];
    [self addSubview:self.bgImageView];
    
    //导航通知按钮
    self.leBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 50)];
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 25, 25)];
    left.image =[ UIImage imageNamed:@"share"];
    [self addSubview:left];
    self.leBtn.tag = 101;
    [self addSubview:self.leBtn];
    
    //设置按钮
    self.riBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSW - 50, 20, 50 , 50)];
    UIImageView * right = [[UIImageView alloc] initWithFrame:CGRectMake(MSW - 10 - 30, 31, 37, 33)];
    right.image =[ UIImage imageNamed:@"5-2"];
    [self addSubview:right];
    self.riBtn.tag = 102;
    [self addSubview:self.riBtn];
    
    
    //  头像按钮
    self.haedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_haedBtn setBackgroundColor:[UIColor clearColor]];
    [_haedBtn setAlpha:1];
    _haedBtn.frame = CGRectMake((MSW - 72)/2, 68, 72, 72);
    [self addSubview:_haedBtn];
    
    //    用户头像
    _imgheadview=[[UIImageView alloc]initWithFrame:CGRectMake((MSW - 72)/2,68, 72, 72)];
    _imgheadview.contentMode = UIViewContentModeScaleAspectFill;
    _imgheadview.image = [UIImage imageNamed:@"head1"];
    _imgheadview.layer.masksToBounds = YES;
    _imgheadview.layer.cornerRadius =36;
    [self addSubview:_imgheadview];
    
   
    
    //名字label
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(MSW / 2 - 100, 68 + 72+5, 200, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.textColor = [UIColor whiteColor];
//    _nameLabel.backgroundColor=[UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];

    //余额label
    self.yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(MSW / 2 - 80, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height+5, 160, 12)];
    self.yueLabel.textColor = [UIColor whiteColor];
    self.yueLabel.font = [UIFont systemFontOfSize:14];
//    _yueLabel.backgroundColor=[UIColor greenColor];
    self.yueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.yueLabel];

    
    //登陆按钮
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.layer.borderWidth = 0.8;
    self.loginBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.loginBtn.backgroundColor = [UIColor clearColor];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.frame = CGRectMake((MSW - 130)/2, 68+72 +
                                     10 , 130, 30);
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [self addSubview:self.loginBtn];
    
    //充值按钮
    self.topUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topUpBtn.backgroundColor = MainColor;
    self.topUpBtn.layer.cornerRadius = 3;
    self.topUpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.topUpBtn.frame = CGRectMake((MSW - 130)/2, self.yueLabel.bottom + 10, 130, 30);
    [self.topUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.topUpBtn setTitle:@"充值" forState:UIControlStateNormal];
    [self addSubview:self.topUpBtn];
    self.topUpBtn.hidden = YES;

}

@end
