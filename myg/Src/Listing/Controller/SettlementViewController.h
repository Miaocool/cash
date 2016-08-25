//
//  SettlementViewController.h
//  yyxb
//
//  Created by 杨易 on 15/12/4.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"

#import "SettlementModel.h"

@interface SettlementViewController : MaiViewController
@property (nonatomic, strong) SettlementModel *settModel;
@property (nonatomic, copy) NSString *goods; //商品

/** 是否显示余额支付 [0:不显示 1:显示] */
@property(nonatomic,copy)NSString *totalYue;

@property(nonatomic,strong)NSMutableArray *classArray;  //支付方式
@property(nonatomic,strong)NSMutableArray *zhifuNameArray; //支付名
@property(nonatomic,strong)NSMutableArray *zhifuTishiArray; //支付小标题
@property(nonatomic,strong)NSMutableArray *zhifuColorArray; //支付颜色
@property(nonatomic,strong)NSMutableArray *zhifuImgArray; //支付图片

@property(nonatomic,copy)NSString *type;
@end
