//
//  ExtensionViewController.h
//  yyxb
//
//  Created by mac03 on 15/11/25.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"
#import "UserDataModel.h"
@class UserDataModel;
@interface ExtensionViewController : MaiViewController
@property(nonatomic, strong)UserDataModel *model;
@property(nonatomic, strong)NSString *share_img;  //三级分销二维码
@end
