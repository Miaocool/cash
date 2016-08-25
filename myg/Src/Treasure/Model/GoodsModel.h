//
//  GoodsModel.h
//  yyxb
//
//  Created by 杨易 on 15/11/18.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface GoodsModel : MBTestMainModel
@property (nonatomic, copy) NSString *idd; //商品id
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *title2; //小标题
@property (nonatomic, copy) NSString *zongrenshu; //总人数
@property (nonatomic, copy) NSString *canyurenshu; //参与人数
@property (nonatomic, copy) NSString *thumb; //商品图片url
@property (nonatomic, copy) NSString *yunjiage; //云价格  1元 或 10元
@property (nonatomic, copy) NSString *qishu; //商品期数
@property (nonatomic, copy) NSString *goodstype; //商品状态
@property (nonatomic, copy) NSString *ip; //地址 和ip
@property (nonatomic, copy) NSString *xsjx_time; //揭晓时间
@property (nonatomic, copy) NSString *zjgonumber; //zjgonumber
@property (nonatomic, copy) NSString *img; //头像
@property (nonatomic, copy) NSString *sale; //1为上架  2为下架（区分商品上下架）
@property (nonatomic, copy) NSString *gonumber; //用户参与数量
@property (nonatomic, copy) NSString *q_user_code; //商品状态
@property (nonatomic, copy) NSString *sid; //同一个商品的id
@property (nonatomic, copy) NSString *type; //商品状态 进行中  已揭晓  倒计时
@property (nonatomic, copy) NSString *uid; //用户id
@property (nonatomic, copy) NSString *nextqishu; //下一期商品
@property (nonatomic, copy) NSString *goucode; //登录用户的中奖号
@property (nonatomic, copy) NSString *nextid; //下一期商品id
@property (nonatomic, copy) NSString *username; //用户名字

@property (nonatomic, strong) NSArray *picarr; // 商品图

@property (nonatomic, copy) NSString *waittime; //等待时间

@property (nonatomic, copy) NSString *tishi; //等待时间
@property (nonatomic, copy) NSString *minNumber;  //起步价格

@property (nonatomic, copy) NSString *jiexiao_time; //商品揭晓时间
@property (nonatomic, copy) NSString *xiangou; //限购
@property (nonatomic, copy) NSString *xg_number;


@property (nonatomic, copy) NSArray *people;//荣誉榜

@property (nonatomic, copy) NSString *url;//上榜规则

@end
