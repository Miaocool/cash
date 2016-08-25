//
//  ListingModel.h
//  yyxb
//
//  Created by 杨易 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface ListingModel : MBTestMainModel
@property (nonatomic, copy) NSString *zongrenshu; //总人数
@property (nonatomic, copy) NSString *shengyurenshu; //剩余人数
@property (nonatomic, copy) NSString *shopid; //商品id
@property (nonatomic, copy) NSString *thumb; //图片
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *yunjiage; //云价格 判断1元 10元 商品
@property (nonatomic, copy) NSString *xiangou; //限购
@property (nonatomic, copy) NSString *xg_number; //限购类型

@property (nonatomic, assign) int  isbaowei; //限购类型
//@property (nonatomic, copy) int  isbaowei; //包尾

@end
