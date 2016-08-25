//
//  ConfirmedWinController.h
//  yyxb
//
//  Created by mac03 on 15/11/25.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"
#import "RecordDto.h"
#import "PassValueDelegate.h"
#import "RedStatusDto.h"

@interface ConfirmedWinController : MaiViewController<PassValueDelegate>

@property(nonatomic,strong)RecordDto *model;     //中奖纪录model
@property(nonatomic,strong)RedStatusDto *redModel; //确定地址中奖纪录model

@property (nonatomic, copy) NSString *idD; //记录id

@end
