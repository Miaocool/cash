//
//  MyBuyListModel.h
//  yyxb
//
//  Created by lili on 15/12/3.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface MyBuyListModel : MBTestMainModel

@property (nonatomic, copy) NSString *shopid; //商品id
@property (nonatomic, copy) NSString *canyurenshu; //参与人数
@property (nonatomic, copy) NSString *gonumber; //购买次数
@property (nonatomic, copy) NSString *number;//中奖人购买次数
@property (nonatomic, copy) NSString *q_end_time; //揭晓时间
@property (nonatomic, copy) NSString *q_uid;//用户id
@property (nonatomic, copy) NSString *q_user_code; // 中奖号吗

@property (nonatomic, copy) NSString *qishu;//期数

@property (nonatomic, copy) NSString *shopname; //商品标题
@property (nonatomic, copy) NSString *thumb; //商品图片
@property (nonatomic, copy) NSString *type;//商品状态 1已经揭晓 2未揭晓 
@property (nonatomic, copy) NSString *uid; //----
@property (nonatomic, copy) NSString *username;//中奖人名字
@property (nonatomic, copy) NSString *img;//中奖人头像
@property (nonatomic, copy) NSString *zongrenshu; // 总人数
@property (nonatomic, copy) NSString *jiexiao_time; // 揭晓时间
@property (nonatomic, copy) NSString *yunjiage; //云价格


@property (nonatomic, copy) NSString *xiangou; //限购
@property (nonatomic, copy) NSString *xg_number; //限购

@end
