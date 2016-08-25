//
//  MyshareModel.m
//  yyxb
//
//  Created by lili on 15/11/30.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MyshareModel.h"

@implementation MyshareModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.sd_id = value;
    }else
        
        [super setValue:value forKey:key];
}
@end
