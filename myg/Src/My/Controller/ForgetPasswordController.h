//
//  ForgetPasswordController.h
//  yyxb
//
//  Created by lili on 15/12/2.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"

@interface ForgetPasswordController : MaiViewController



{
    
    UITapGestureRecognizer *singleRecognizer;
}


@property (nonatomic, assign) int stuta;//进行的状态
@property (nonatomic, copy) NSString* fromphoneno;//电话号码
@property (nonatomic,copy)NSString * codeStr;


@end
