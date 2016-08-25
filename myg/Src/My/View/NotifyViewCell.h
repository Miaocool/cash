//
//  NotifyViewCell.h
//  yyxb
//
//  Created by lili on 15/11/18.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDto.h"

@interface NotifyViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iamgefound; //图片
@property (nonatomic, strong) UILabel *lbtitle; //标题
@property (nonatomic, strong) UILabel *lbdetail; //描述

@property (nonatomic, strong) UIImageView *NewIamgeView; //图片
@property (nonatomic ,strong) NoticeDto *noticeModel;

@end
