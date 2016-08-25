//
//  GoodsDetailsViewController.h
//  yyxb
//
//  Created by 杨易 on 15/11/12.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"

@interface GoodsDetailsViewController : MaiViewController

{
    
    UITapGestureRecognizer *singleRecognizer;
}
@property (nonatomic, copy) NSString *idd; //商品id
@property (nonatomic, copy) NSString *zhongjiangID; //中奖人
@property (nonatomic, copy) NSString *username;
@property(nonatomic,assign)int tiaozhuantype;//跳转类型
@property (nonatomic, strong) UIImageView *shiyuan;//十元

@property (nonatomic, copy) NSString *fromminutes;//分中

@property (nonatomic, copy) NSString *frommseconds;//秒


@property (nonatomic, copy) NSString *sid; //商品id

@property (nonatomic, copy) NSString *qishu; //商品id
@end
