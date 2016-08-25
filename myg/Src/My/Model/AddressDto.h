//
//  AddressDto.h
//  yyxb
//
//  Created by mac03 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface AddressDto : MBTestMainModel


@property (nonatomic, strong)       NSString *shouhuoren;    //姓名
@property (nonatomic, strong)       NSString *sheng; //住址
@property (nonatomic, strong)       NSString *shi; //市
@property (nonatomic, strong)       NSString *xian; //线
@property (nonatomic, strong)       NSString *jiedao; //街道
@property (nonatomic, strong)       NSString *idd;    //id
@property (nonatomic, strong)       NSString *mobile;   //电话
@property (nonatomic, strong)       NSString *moren;   // 状态
@property (nonatomic, copy)         NSString *game_name;//游戏名字
@property (nonatomic, copy)         NSString *game_nickname;//游戏昵称
@property (nonatomic, copy)         NSString *game_number;//游戏账号
@property (nonatomic, copy)         NSString *game_zone;//游戏区
@property (nonatomic, copy)         NSString *qq;//QQ号码
@property (nonatomic, copy)         NSString *remark;
@property (nonatomic, copy)         NSString *ad_remark;

@end
