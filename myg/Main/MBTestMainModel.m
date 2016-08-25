//
//  MBTestMainModel.m
//  农业银行
//
//  Created by 杨易 on 15/5/27.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@implementation MBTestMainModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    
        [super setValue:value forKey:key];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@---------%@",key,value);
    
}

@end
