//
//  DiscountSecondCell.h
//  yyxb
//
//  Created by 杨易 on 15/12/7.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HongbaoModel.h"

@interface DiscountSecondCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView; //红包背景
@property (nonatomic, strong) UILabel *remainingLabel; //剩余
@property (nonatomic, strong) UILabel *remainingNum; //剩余数量
@property (nonatomic, strong) UILabel *hongbaoTitleLabel; //红包标题
@property (nonatomic, strong) UILabel *dedaLabel;  //到期时间
@property (nonatomic, strong) UILabel *numLabel;  //红包金额
@property (nonatomic, strong) UIImageView *selectedImageView; // 选中状态
@property (nonatomic, strong) HongbaoModel *hongbaoModel;
@property (nonatomic, assign) BOOL isChoose; 
@end
