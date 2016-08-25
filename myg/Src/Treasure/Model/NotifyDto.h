//
//  NoticeDto.h
//  yyxb
//
//  Created by mac03 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface NotifyDto : MBTestMainModel

@property (nonatomic, copy) NSString   *title;      //商品标题
@property (nonatomic, copy) NSString   *sid;        //商品id
@property (nonatomic, copy) NSString   *username;  //用户昵称
@property (nonatomic, copy) NSString   *qishu;   //期数
@end
