//
//  CommentModel.m
//  yyxb
//
//  Created by lili on 15/12/30.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"sdhf_content"])
    {
        self.sdhf_content = value;
    }else
        
        [super setValue:value forKey:key];
    
}
@end
