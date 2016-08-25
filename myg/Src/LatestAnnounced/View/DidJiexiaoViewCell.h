//
//  DidJiexiaoViewCell.h
//  yydg
//
//  Created by lili on 16/1/5.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatestAnnouncedModel.h"
@class LatestAnnouncedModel;
@interface DidJiexiaoViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *imgProduct; //图片
@property (nonatomic, strong)  UIImageView *imgHead;//标题
@property (nonatomic, strong) UILabel *lblName; //描述

@property (nonatomic, strong) UILabel*lblCode;

@property (nonatomic, strong) UILabel *lblTime; //标题

@property (nonatomic, strong) UILabel *lblTitle; //商品标题


@property (nonatomic, strong) UILabel     *lblPrice;


@property (nonatomic, strong)  UIButton *bthead;//标题

@property (nonatomic, strong)  UIImageView *imgxiangou;//限购
@property (nonatomic, strong) LatestAnnouncedModel *latestModel;

@end
