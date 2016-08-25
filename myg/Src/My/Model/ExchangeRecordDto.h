//
//  ExchangeRecordCell.h
//  yyxb
//
//  Created by mac03 on 15/12/2.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface ExchangeRecordDto : MBTestMainModel

@property (nonatomic, strong) NSString             *uid;           //商品id

@property (nonatomic, strong) NSString             *money;       //积分

@property (nonatomic, strong) NSString             *addtime;            //时间

@property (nonatomic, strong) NSString             *status;             //状态

@property (nonatomic, strong) NSString             *statesText;    //状态显示文字
@property (nonatomic, strong) NSString             *statesTextColor;//状态显示文字颜色
@property (nonatomic, strong) NSString             *statesColor;   //状态显示颜色


@end
