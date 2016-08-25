//
//  ExchangeRecordCell.m
//  yyxb
//
//  Created by mac03 on 15/12/2.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ExchangeRecordDto.h"

@implementation ExchangeRecordDto

-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.uid = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
