//
//  LanMuModel.h
//  yyxb
//
//  Created by 杨易 on 15/12/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface LanMuModel : MBTestMainModel
@property (nonatomic, copy) NSString *cateid; //分类的id
@property (nonatomic, copy) NSString *thumb; //栏目图片url
@property (nonatomic, copy) NSString *title; //栏目标题
@property (nonatomic, copy) NSString *type; //栏目类型
@end
