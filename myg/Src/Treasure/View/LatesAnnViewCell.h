//
//  LatesAnnViewCell.h
//  kl1g
//
//  Created by lili on 16/2/26.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatestAnnouncedModel.h"
@interface LatesAnnViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *lbtitle;
@property (nonatomic, strong) UILabel *lbtime;
@property (nonatomic,assign) int ms;
@property (nonatomic,assign) int minutes;
@property (nonatomic,assign) int seconds;
//@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic, strong) dispatch_source_t timer;  //定时器
@property (nonatomic, strong) UIImageView *shiyuan;//十元

@property (nonatomic, strong) LatestAnnouncedModel *latestModel;
@end
