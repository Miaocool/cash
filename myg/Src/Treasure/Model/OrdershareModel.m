//
//  OrdershareModel.m
//  yyxb
//
//  Created by lili on 15/11/26.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "OrdershareModel.h"

@implementation OrdershareModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.sd_userid = value;
    }else
        
        [super setValue:value forKey:key];
}
@end
