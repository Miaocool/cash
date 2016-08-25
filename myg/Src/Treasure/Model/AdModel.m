//
//  adModel.m
//  yyxb
//
//  Created by 杨易 on 15/11/18.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AdModel.h"

@implementation AdModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.idd = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
