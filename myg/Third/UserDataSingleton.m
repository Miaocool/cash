//
//  UserDataSingleton.m
//  yyxb
//
//  Created by 杨易 on 15/11/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "UserDataSingleton.h"

@implementation UserDataSingleton
static UserDataSingleton *userData = nil;
+(UserDataSingleton *)userInformation
{
    if (!userData)
    {
        userData = [[UserDataSingleton alloc]init];
        userData.shoppingArray = [NSMutableArray array];
    }
    
    return userData;
}


@end
