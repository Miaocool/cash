//
//  RecordDto.m
//  yyxb
//
//  Created by mac03 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "RecordDto.h"

@implementation RecordDto


-(void)setValue:(id)value forKey:(NSString *)key
{
     if([key isEqualToString:@"id"])
    {
        self.idD=value;
    }else if ([key isEqualToString:@"id"]){
        self.siteid=value;
    }
    else
        [super setValue:value forKey:key];
}

@end
