//
//  Winning ViewCell.h
//  yyxb
//
//  Created by lili on 15/11/24.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Winning_ViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *imgegood; //图片
@property (nonatomic, strong) UILabel *lbtitle; //标题
@property (nonatomic, strong) UILabel *lbshengyu; //剩余
@property (nonatomic, strong) UILabel *lbline; //分割线
@property (nonatomic, strong) UIButton *btadd; //追加图片
@property (nonatomic, strong) UILabel *lbcount; //总需
@property (nonatomic, strong) UILabel *lbplay; //本期参与
@property (nonatomic, strong) UIButton *btlook; //查看我的


@property (nonatomic, strong)UIProgressView* progressView;


@property (nonatomic, strong) UIView *blackview; //背景view

@property (nonatomic, strong) UIButton *btname; //获奖者
@property (nonatomic, strong) UILabel *lbplaycount; //本期参与
@property (nonatomic, strong) UILabel *lbluckno; //幸运号码

@property (nonatomic, strong) UILabel *lbtime; //时间










@end
