//
//  LoginViewController.h
//  yyxb
//
//  Created by 杨易 on 15/11/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"
#import "UserDataModel.h"

@interface LoginViewController : MaiViewController

@property(nonatomic ,strong)UserDataModel *dataModel;
@property (nonatomic, copy) NSString *zhanghao;
@end
