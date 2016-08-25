//
//  AddressDto.m
//  yyxb
//
//  Created by mac03 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AddressDto.h"

@implementation AddressDto

-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.idd = value;
        
    }
    else if ([key isEqualToString:@"default"])
    {
        self.moren = value;
    }
    else
        
        [super setValue:value forKey:key];
}

@end
