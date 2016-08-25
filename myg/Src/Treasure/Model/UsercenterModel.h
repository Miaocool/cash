//
//  UsercenterModel.h
//  yyxb
//
//  Created by lili on 15/12/2.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface UsercenterModel : MBTestMainModel

@property (nonatomic, copy) NSString   *img;        //用户头像



@property (nonatomic, copy) NSString   *mobile;        //手机号
@property (nonatomic, copy) NSString   *money;        //余额
@property (nonatomic, copy) NSString   *uid;        //用户id
@property (nonatomic, copy) NSArray   *user_ip;        //用户ip
@property (nonatomic, copy) NSString   *username;        //用户姓名


@end
