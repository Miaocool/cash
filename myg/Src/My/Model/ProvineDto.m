//
//  ProvineDto.m
//  yyxb
//
//  Created by mac03 on 15/11/27.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ProvineDto.h"

@implementation ProvineDto

-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.Id = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
