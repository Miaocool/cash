//
//  BaoDetailModel.h
//  yyxb
//
//  Created by lili on 15/12/15.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface BaoDetailModel : MBTestMainModel

@property (nonatomic, copy) NSString *idd; //云id
@property (nonatomic, copy) NSString *shopname; //参与人数
@property (nonatomic, copy) NSString *gonumber; //购买次数


@property (nonatomic, copy) NSString *shopqishu; //期数
@property (nonatomic, copy) NSString *time;//时间

@end
