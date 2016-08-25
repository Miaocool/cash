//
//  TakepateNoteModel.m
//  yyxb
//
//  Created by lili on 15/11/23.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "TakepateNoteModel.h"

@implementation TakepateNoteModel



-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
    {
        self.idd = value;
    }else
        
        [super setValue:value forKey:key];
}






@end
