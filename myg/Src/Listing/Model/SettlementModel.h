//
//  SettlementModel.h
//  yyxb
//
//  Created by 杨易 on 15/12/5.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface SettlementModel : MBTestMainModel
@property (nonatomic, strong) NSArray *hongbao; //红包
@property (nonatomic, copy) NSString *jiage;  //价格
@property (nonatomic, copy) NSString *money; //金额
@property (nonatomic, strong) NSArray *shop; //购物数组
@property (nonatomic, copy) NSString *totalPrice; // 总价格
@property (nonatomic, copy) NSString *zhifu;

@property(nonatomic,strong)NSMutableArray *pay_type;   //支付数组
@property (nonatomic, copy) NSString *pay_class;  //支付方式
@property (nonatomic, copy) NSString *pay_name;  //支付名称
@property(nonatomic,copy)NSString *isopen;
@property(nonatomic,copy)NSString *type;

@end
