//
//  LatestAnnouncedModel.h
//  yyxb
//
//  Created by 杨易 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface LatestAnnouncedModel : MBTestMainModel
@property (nonatomic, copy) NSString *canyurenshu; //参与人数
@property (nonatomic, copy) NSString *idd; //商品id
@property (nonatomic, copy) NSString *q_end_time; //揭晓时间
@property (nonatomic, copy) NSString *q_user_code; //中奖号码
@property (nonatomic, copy) NSString *qishu; //期数
@property (nonatomic, copy) NSString *thumb; //商品图片url
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *uid; //用户id
@property (nonatomic, copy) NSString *gonumber; //
@property (nonatomic, copy) NSString *username; //昵称
@property (nonatomic, copy) NSString *type;//商品状态
@property (nonatomic, strong) NSDictionary *q_user; //中奖人信息

@property (nonatomic, copy) NSString *waittime;//倒计时等待时间

@property (nonatomic, copy) NSString *jiexiao_time;//揭晓时间

@property (nonatomic, copy) NSString *tishi;//提示

@property (nonatomic, copy) NSString *yunjiage; //云价格  1元 或 10元
@property (nonatomic, copy) NSString *xiangou; //限购

@property (nonatomic, copy) NSString *img; //限购

/*
 email = "52jscn@163.com"; 
 img = "http://yyxb.maipiaoqu.com/statics/uploads/photo/member.jpg";
 mobile = 15588000000;
 uid = 21710;
 username = 52jscn;
 */

@end
