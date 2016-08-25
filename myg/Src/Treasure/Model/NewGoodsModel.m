//
//  NewGoodsModel.m
//  kl1g
//
//  Created by lili on 16/2/19.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "NewGoodsModel.h"

@implementation NewGoodsModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.idd = value;
    }else
        
        [super setValue:value forKey:key];
}

@end
