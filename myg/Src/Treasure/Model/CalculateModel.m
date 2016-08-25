//
//  CalculateModel.m
//  yyxb
//
//  Created by lili on 15/12/9.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "CalculateModel.h"

@implementation CalculateModel


-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"q_content"])
    {
        self.q_content = value;
    }else
        
        [super setValue:value forKey:key];

}
@end
