//
//  RecordDto.h
//  yyxb
//
//  Created by mac03 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface RecordDto : MBTestMainModel
@property (nonatomic, copy) NSString             *siteid;        //地址id
@property (nonatomic, copy) NSString             *idD;           //记录id
@property (nonatomic, copy) NSString             *shopid;          //商品id
@property (nonatomic, copy) NSString             *shopname;       //商品名字

@property (nonatomic, copy) NSString             *Uphoto;            //用户头像
@property (nonatomic, copy) NSString             *Huode;             //中奖吗

@property (nonatomic, copy) NSString             *Shopqishu;          //期数
@property (nonatomic, copy) NSString             *Gonumber;   //参加次数
@property (nonatomic ,copy) NSString             *Time;       //参加时间
@property (nonatomic, copy) NSString             *Zongrenshu; //总人数

@property (nonatomic, copy) NSString             *isget;    //状态 1 已签收   0 未签收

@property (nonatomic, copy) NSString             *company;    //快递物流
@property (nonatomic, copy) NSString             *company_code;//快递单号
@property (nonatomic, copy) NSString             *dizhi_time;   //确定地址时间

@property (nonatomic, copy) NSString             *piafa_time;   //派发时间
@property (nonatomic, copy) NSString             *wancheng_time;   //完成订单时间
@property (nonatomic, copy) NSString             *shouhuoren;   //收货人
@property (nonatomic, copy) NSString             *mobile;    //收货人手机号
@property (nonatomic, copy) NSString             *dizhi;    //收货地址

@property(nonatomic,copy)NSString                *count;    //总数
@end
