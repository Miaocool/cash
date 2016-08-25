//
//  UserNameViewController.h
//  yyxb
//
//  Created by 杨易 on 15/11/13.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"

@interface UserNameViewController : MaiViewController
@property(nonatomic,copy)void(^nameBlock)(NSString * userName);
@end
