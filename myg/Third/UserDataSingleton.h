//
//  UserDataSingleton.h
//  yyxb
//
//  Created by 杨易 on 15/11/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataSingleton : NSObject
+(UserDataSingleton *)userInformation;

@property (nonatomic, assign)    BOOL isSwitch; //记录用户是否把当前地址设为默认
@property (nonatomic, copy)      NSString *uid; // 用户id
@property (nonatomic, copy)      NSString *code; //安全码
@property (nonatomic, assign)    BOOL isLogin;  //判断用户是否登陆
@property (nonatomic, copy)      NSString *img;     //用户头像
@property (nonatomic, strong) NSMutableArray *shoppingArray; //购物车商品
//推送Channal Id
@property (nonatomic, readwrite, retain) NSString               *channelId;
@property (nonatomic, readwrite, retain) NSString               *username;  //用户名
@property (nonatomic, readwrite, retain) NSString               *password;  //密码
@property (nonatomic, readwrite, retain) NSString               *nickname;  //昵称

@property (nonatomic, copy) NSString * is_qq;         //是否开启一键加群 0代表关闭  1 开启
@property (nonatomic, copy) NSString * qq_groupkey;   //一键加群的key
@property (nonatomic, copy) NSString * qq_uin;       //一键加群的uin
@property (nonatomic, copy) NSString * is_push;    //是否开启推送   0代表关闭  1 开启



@end
