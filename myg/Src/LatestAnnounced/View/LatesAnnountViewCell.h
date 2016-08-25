//
//  LatesAnnountViewCell.h
//  yydg
//
//  Created by lili on 16/1/4.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LatestAnnouncedModel.h"
@class LatestAnnouncedModel;
@interface LatesAnnountViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgProduct; //图片
@property (nonatomic, strong) UILabel *lblTitle; //标题
@property (nonatomic, strong) UILabel *lblPrice; //描述

@property (nonatomic, strong) UIImageView *imgTimeBG; //图片

@property (nonatomic, strong) UILabel *lblTime; //标题
@property (nonatomic, strong) UIImageView * timeImg;//"正在揭晓中"图片


@property (nonatomic, strong) LatestAnnouncedModel *latestModel;

@property (nonatomic,assign) int ms;
@property (nonatomic,assign) int minutes;
@property (nonatomic,assign) int seconds;
@property (nonatomic,weak) NSTimer *timer;

@property (nonatomic, strong)  UIImageView *imgxiangou;//限购



@property (nonatomic, strong) UILabel *lbguzhang; //标题
@end
