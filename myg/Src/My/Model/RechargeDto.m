//
//  RechargeDto.m
//  yyxb
//
//  Created by mac03 on 15/12/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "RechargeDto.h"

@implementation RechargeDto

-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
//        self.pay_id=value;
    }
    else
        [super setValue:value forKey:key];
}


@end
