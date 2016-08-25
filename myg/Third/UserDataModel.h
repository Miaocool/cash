//
//  UserDataModel.h
//  yyxb
//
//  Created by 杨易 on 15/11/23.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface UserDataModel : MBTestMainModel
@property (nonatomic, copy) NSString *img; //头像
@property (nonatomic, copy) NSString *mobile; //手机号
@property (nonatomic, copy) NSString *money; //钱
@property (nonatomic, copy) NSString *uid; //id
@property (nonatomic, copy) NSString *username; //名字
@end
