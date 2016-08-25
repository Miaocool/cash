//
//  AnnouncedCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatestAnnouncedModel.h"

@interface AnnouncedCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UIImageView *goodsImageView; //头像
@property (nonatomic, strong) UILabel *obtainTitle; //获得者标题
@property (nonatomic, strong) UILabel *obtainName; //获得者名字
@property (nonatomic, strong) UILabel *participate; //参与
@property (nonatomic, strong) UILabel *luckyTitle;
@property (nonatomic, strong) UILabel *luckyNum; //幸运号
@property (nonatomic, strong)UILabel  *lab; //揭晓
@property (nonatomic, strong) UILabel *timeDate;   //今天 昨天
@property (nonatomic, strong) UILabel *announcedDate; //揭晓时间
@property (nonatomic, assign) BOOL isCountdown;  //判断是否倒计时
@property (nonatomic, strong) UILabel *dateLable; // 揭晓倒计时
@property (nonatomic, strong) UIView *jiexiaoView; // 揭晓view 必要时隐藏
@property (nonatomic, strong) UIView *zhongjiangView; //中奖信息view

@property (nonatomic,assign) int ms;
@property (nonatomic,assign) int minutes;
@property (nonatomic,assign) int seconds;
@property (nonatomic,weak) NSTimer *timer;

@property (nonatomic, strong) UILabel *label;//参与
@property (nonatomic, strong) UIImageView *imageView;


@property (nonatomic, strong) UILabel *guzhang;//故障

@property (nonatomic, strong) LatestAnnouncedModel *latestModel;

@property (nonatomic, copy) NSString *nowtime; //揭晓时间



@property (nonatomic, strong) UIImageView *shiyuan;//十元



@property (nonatomic, strong) UILabel *lbtitle;//故障
@property (nonatomic, strong) UILabel *lbtime;//故障








@end
