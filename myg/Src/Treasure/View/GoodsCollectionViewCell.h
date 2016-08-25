//
//  GoodsCollectionViewCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsModel.h"

@class GoodsCollectionViewCell;

@protocol GoodsCollectionViewCellDelegate <NSObject>//协议

- (void)clickCell:(GoodsCollectionViewCell *)cell;//代理方法

@end


@interface GoodsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsTieleLabel;
@property (nonatomic, strong) UIButton *goodsButton;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) GoodsModel *goodsModel;
@property (nonatomic, strong) UILabel *lotteryLabel; //开奖

@property (nonatomic, strong) UIImageView *shiyuan;//十元


@property (nonatomic, strong) UILabel *lbzong;

@property (nonatomic, strong) UILabel *lbsheng;




@property (nonatomic , weak)id<GoodsCollectionViewCellDelegate>delegate;//代理
@end
