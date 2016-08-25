//
//  RechargeDto.h
//  yyxb
//
//  Created by mac03 on 15/12/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface RechargeDto : MBTestMainModel


@property(nonatomic,copy)NSString *pay_class;  //支付方式的id

@property(nonatomic,copy)NSString *pay_name;  //支付方式的名字

@property(nonatomic,copy)NSString *img;  //支付图片

@property(nonatomic,copy)NSString *color;  //支付颜色

@property(nonatomic,copy)NSString *tishi;  //支付小标题

@end
