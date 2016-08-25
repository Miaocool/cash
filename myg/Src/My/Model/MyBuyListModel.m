//
//  MyBuyListModel.m
//  yyxb
//
//  Created by lili on 15/12/3.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MyBuyListModel.h"

@implementation MyBuyListModel


-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.shopid = value;
    }else
        
        [super setValue:value forKey:key];
}







@end
