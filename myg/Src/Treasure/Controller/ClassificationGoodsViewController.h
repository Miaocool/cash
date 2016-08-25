//
//  ClassificationGoodsViewController.h
//  yyxb
//
//  Created by 杨易 on 15/11/10.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"

@interface ClassificationGoodsViewController : MaiViewController
@property (nonatomic, copy) NSString *dataString;
@property (nonatomic, copy) NSString *fromcateid; //分类id
@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, assign) BOOL isSection;


@property (nonatomic, assign) BOOL isSarch;//从搜索跳过来的

@property (nonatomic, copy) NSString *titlestr;

@property (nonatomic,assign) int isVIP;//从VIP跳过来的

@end
