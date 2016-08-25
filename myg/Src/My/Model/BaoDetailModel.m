//
//  BaoDetailModel.m
//  yyxb
//
//  Created by lili on 15/12/15.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "BaoDetailModel.h"

@implementation BaoDetailModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.idd = value;
    }else
        
        [super setValue:value forKey:key];
}


@end
