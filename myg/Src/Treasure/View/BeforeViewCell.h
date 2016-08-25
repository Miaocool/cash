//
//  BeforeViewCell.h
//  yyxb
//
//  Created by lili on 15/11/16.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeforeViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *userhead; //用户头像

@property (nonatomic, strong) UILabel *jxdate; //揭晓时间
@property (nonatomic, strong) UILabel *lbusername; //用户姓名
@property (nonatomic, strong) UIButton *username; //用户姓名

@property (nonatomic, strong) UIView *background; //背景
@property (nonatomic, strong) UILabel *userid; //用户id
@property (nonatomic, strong) UILabel *luckno; //幸运号码
@property (nonatomic, strong) UILabel *takecount; //参与人次

@property (nonatomic, strong) UILabel *lbline; //线

@property (nonatomic, strong) UIImageView *more; //


@property (nonatomic, strong) UILabel *lbnameip; //xingming

@end
