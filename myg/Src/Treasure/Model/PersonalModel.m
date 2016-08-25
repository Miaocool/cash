//
//  PersonalModel.m
//  yyxb
//
//  Created by lili on 15/12/1.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "PersonalModel.h"

@implementation PersonalModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.uid = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
