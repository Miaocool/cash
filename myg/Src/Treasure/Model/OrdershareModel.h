//
//  OrdershareModel.h
//  yyxb
//
//  Created by lili on 15/11/26.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface OrdershareModel : MBTestMainModel
@property (nonatomic, copy) NSString *sd_id; //晒单id
@property (nonatomic, copy) NSArray *sd_photolist; //晒单图片

@property (nonatomic, copy) NSString *sd_title; //标题
@property (nonatomic, copy) NSString *sd_content; //内容
@property (nonatomic, copy) NSString *sd_userid; // 晒单人id
@property (nonatomic, copy) NSString *qishu;//期数
@property (nonatomic, copy) NSString *sd_ip;//用户ip
@property (nonatomic, copy) NSString *sd_time;//晒单时间


@property (nonatomic, copy) NSString *img;//用户头像
@property (nonatomic, copy) NSString *username;//用户昵称


@property (nonatomic, copy) NSString *shaidan;//晒单信息
@property (nonatomic, copy) NSString *goods;//对应的商品
@property (nonatomic, copy) NSString *title;//晒单详情标题
@property (nonatomic, copy) NSString *q_user_code;//中奖号码
@property (nonatomic, copy) NSString *statu;//晒单状态

@property (nonatomic, copy) NSString *q_end_time;//结束时间
@property (nonatomic, copy) NSString *gonumber;//数量

@property (nonatomic, copy) NSString *fxurl;//分享网址
@property (nonatomic, copy) NSString *thumb;//头像网址

@property (nonatomic, copy) NSString *sd_shopid;//头像网址

@property (nonatomic, copy) NSString *shopid;//下一期







@property (nonatomic, copy) NSString *zan_number;//赞
@property (nonatomic, copy) NSString *pinglun_number;//评论


@property (nonatomic, copy) NSString *sd_type;//查看用户是否点赞0 没有点赞   1已经点过赞


@property (nonatomic, copy) NSArray *huifu;//评论


@property (nonatomic, copy) NSString *sd_zhan;//评论



@end
