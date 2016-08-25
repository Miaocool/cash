//
//  MyEarnModel.m
//  yyxb
//
//  Created by lili on 15/12/22.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MyEarnModel.h"

@implementation MyEarnModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"uid"])
    {
        self.uid = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
