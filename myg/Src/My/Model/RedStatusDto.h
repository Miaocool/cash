//
//  RedStatusDto.h
//  yyxb
//
//  Created by mac03 on 15/12/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface RedStatusDto : MBTestMainModel

@property (nonatomic, copy) NSString             *siteid;        //地址id
@property (nonatomic, copy) NSString             *idD;          //记录id

@property (nonatomic, copy) NSString             *company;    //快递物流
@property (nonatomic, copy) NSString             *company_code;//快递单号
@property (nonatomic, copy) NSString             *dizhi_time;   //确定地址时间
@property (nonatomic, copy) NSString             *piafa_time;   //派发时间
@property (nonatomic, copy) NSString             *wancheng_time;   //完成订单时间
@property (nonatomic, copy) NSString             *shouhuoren;   //收货人
@property (nonatomic, copy) NSString             *mobile;    //收货人手机号
@property (nonatomic, copy) NSString             *dizhi;    //收货地址
@property (nonatomic, copy) NSString             *shopname;//商品名称

@property (nonatomic, copy) NSString *huode; //获得
@property (nonatomic, copy) NSString *uphoto; // 照片
@property (nonatomic, copy) NSString *sdwc_time; //晒单完成时间sdwc_time
@property (nonatomic, copy) NSString *Time; //时间
@property (nonatomic, copy) NSString *shopid; //商品id
@property (nonatomic, copy) NSString *zongrenshu;//总人数
@property (nonatomic, copy) NSString *gonumber;//人次
@property (nonatomic, copy) NSString *shopqishu;//期数
@property (nonatomic, copy) NSString *paifa_time;//派发时间

@property (nonatomic, copy) NSString             *game_name;//游戏名字
@property (nonatomic, copy) NSString             *game_nickname;//游戏昵称
@property (nonatomic, copy) NSString             *game_number;//游戏账号
@property (nonatomic, copy) NSString             *game_zone;//游戏区域
@property (nonatomic, copy) NSString             *qq;   //QQ账号
@property (nonatomic, copy) NSString             *remark;//备注
@property (nonatomic, copy) NSString *xiangou;
@property (nonatomic, copy) NSString *yunjiage;
@property (nonatomic, copy) NSString *ad_remark;//商家留言


@end
