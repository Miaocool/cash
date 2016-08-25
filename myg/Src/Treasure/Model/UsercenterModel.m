//
//  UsercenterModel.m
//  yyxb
//
//  Created by lili on 15/12/2.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "UsercenterModel.h"

@implementation UsercenterModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.uid = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
