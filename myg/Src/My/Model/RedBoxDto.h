//
//  RedBoxDto.h
//  yyxb
//
//  Created by mac03 on 15/12/2.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface RedBoxDto : MBTestMainModel

@property (nonatomic, copy) NSString             *type_name;    //标题

@property (nonatomic, copy) NSString             *type_money;       //红包余额
@property (nonatomic, copy) NSString             *use_start_date;  //红包开始使用日期
@property (nonatomic, copy) NSString             *use_end_date;    //过期时间
@property (nonatomic, copy) NSString             *type;     //红包是否过期
@property (nonatomic, copy) NSString             *isuse;  //红包是否使用
@property (nonatomic, copy) NSString             *desc;  //红包说明
@property (nonatomic, copy) NSString             *min_goods_amount;//满多少可以使用

@end
