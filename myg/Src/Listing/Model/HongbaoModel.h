//
//  HongbaoModel.h
//  yyxb
//
//  Created by 杨易 on 15/12/7.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface HongbaoModel : MBTestMainModel
@property (nonatomic, copy) NSString *type_id; //红包id
@property (nonatomic, copy) NSString *type_money; //红包金额
@property (nonatomic, copy) NSString *type_name; //红包名字
@property (nonatomic, copy) NSString *use_end_date; //到期时间
@end
