//
//  PictureDetailController.h
//  yyxb
//
//  Created by lili on 15/12/1.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"

@interface PictureDetailController : MaiViewController





@property (nonatomic, copy)  NSString*url; //链接




@property (nonatomic, copy) NSString *idd; //商品id
@property (nonatomic, assign) int style; //跳转类型

@property (nonatomic, copy) NSString *fromurl; //跳转类型

@property (nonatomic, copy) NSString *fromtitle; //跳转类型
@end
