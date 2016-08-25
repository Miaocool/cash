//
//  LatestAnnouncedModel.m
//  yyxb
//
//  Created by 杨易 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "LatestAnnouncedModel.h"

@implementation LatestAnnouncedModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.idd = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
