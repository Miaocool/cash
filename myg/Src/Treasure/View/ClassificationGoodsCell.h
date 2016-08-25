//
//  ClassificationGoodsCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/10.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsModel.h"
@class ClassificationGoodsCell;

@protocol ClassificationGoodsCellDelegate <NSObject>//协议

- (void)clickCell:(ClassificationGoodsCell *)cell;//代理方法

@end


@interface ClassificationGoodsCell : UITableViewCell
@property (nonatomic, strong) UIImageView *pictureImageView; //图
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UIProgressView *progressView; //进图
@property (nonatomic, strong) UILabel *needLabel; //需要
@property (nonatomic, strong) UILabel *remainingLabel; //剩余
@property (nonatomic, strong) UIButton *addButton; //加入购物车



@property (nonatomic, strong) UIImageView *shiyuan;//十元


@property (nonatomic, strong) GoodsModel *goodsModel;
@property (nonatomic , weak)id<ClassificationGoodsCellDelegate>delegate;//代理

@end
