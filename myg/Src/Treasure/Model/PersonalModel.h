//
//  PersonalModel.h
//  yyxb
//
//  Created by lili on 15/12/1.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface PersonalModel : MBTestMainModel
@property (nonatomic, copy) NSString   *uid;        //用户id
@property (nonatomic, copy) NSString   *canyurenshu;        //参与人数
@property (nonatomic, copy) NSString   *gonumber;        //购买次数
@property (nonatomic, copy) NSString   *number;        //商品数量
@property (nonatomic, copy) NSString   *q_end_time;        //揭晓时间
@property (nonatomic, copy) NSString   *q_uid;        //中奖者id
@property (nonatomic, copy) NSString   *q_user_code;        //中奖者号码
@property (nonatomic, copy) NSString   *qishu;        //期数
@property (nonatomic, copy) NSString   *shopid;        //商品id
@property (nonatomic, copy) NSString   *jiexiao_time;        //揭晓时间
@property (nonatomic, copy) NSString   *shopname;        //商品名字
@property (nonatomic, copy) NSString   *thumb;        //商品头像
@property (nonatomic, copy) NSString   *type;        //商品揭晓状态
@property (nonatomic, copy) NSString   *username;        //用户姓名
@property (nonatomic, copy) NSString   *zongrenshu;        //总人数

//--------------中奖纪录
@property (nonatomic, copy) NSString   *huode;        //总人数
@property (nonatomic, copy) NSString   *shopqishu;        //总人数
@property (nonatomic, copy) NSString   *time;        //总人数
@property (nonatomic, copy) NSString   *uphoto;        //总人数
//-------------晒单分享－－－－

@property (nonatomic, copy) NSString   *img;        //用户头像
@property (nonatomic, copy) NSString   *sd_content;        //晒单内容
@property (nonatomic, copy) NSString   *sd_id;        //晒单id
@property (nonatomic, copy) NSString   *sd_ip;        //晒单ip
@property (nonatomic, copy) NSArray   *sd_photolist;        //晒单图片
@property (nonatomic, copy) NSString   *sd_time;        //晒单时间
@property (nonatomic, copy) NSString   *sd_title;        //晒单标题
@property (nonatomic, copy) NSString   *sd_userid;        //
@property (nonatomic, copy) NSString   *title;        //总人数
@property (nonatomic, copy) NSString *yunjiage; //云价格



@property (nonatomic, copy) NSString *xg_number; //限购




@property (nonatomic, copy) NSString *zan_number;//赞
@property (nonatomic, copy) NSString *pinglun_number;//评论


@property (nonatomic, copy) NSString *sd_type;//查看用户是否点赞0 没有点赞   1已经点过赞
@property (nonatomic, copy) NSString *xiangou; //限购

@end
