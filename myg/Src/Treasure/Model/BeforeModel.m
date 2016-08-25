//
//  BeforeModel.m
//  yyxb
//
//  Created by lili on 15/11/27.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "BeforeModel.h"

@implementation BeforeModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.idd = value;
    }else
        
        [super setValue:value forKey:key];
}
@end
