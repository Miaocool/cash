//
//  ClassModel.h
//  yyxb
//
//  Created by 杨易 on 15/12/15.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface ClassModel : MBTestMainModel
@property (nonatomic, copy) NSString *cateid; //商品id
@property (nonatomic, copy) NSString *name; //名字
@property (nonatomic, copy) NSString *thumb; //图片
@property (nonatomic, copy) NSString *type; //状态

@end
