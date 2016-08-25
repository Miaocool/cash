//
//  AdCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/12.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

#import "MyLable.h"
@interface AdCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *stateLabel;  //状态
@property (nonatomic, strong) MyLable *titleLabel; //标题
@property (nonatomic, strong) UIProgressView *progressView; //进度
@property (nonatomic, strong) UILabel *totalLabel; //总需人数
@property (nonatomic, strong) UILabel *remainingLabel;//剩余人数
@property (nonatomic, strong) UIButton *lookBtn; //检查是否登陆的按钮


//@property (nonatomic, strong) UIView * whiteView;  //揭晓倒计时view
@property (nonatomic, strong) UIView * redViewBg;
@property (nonatomic, strong) UIView * redView;
@property (nonatomic, strong) UIView * whiteView1;//揭晓倒计时view
@property (nonatomic, strong) UILabel * guzhangLabel;

@property (nonatomic, strong) UILabel*timecount;//揭晓倒计时
@property (nonatomic ,strong) UIButton * countDetailBtn;//计算详情倒计时

@property (nonatomic, strong) UILabel*time;//显示时间
@property (nonatomic, strong) UIButton *countdetail;//计算详情


@property (nonatomic, strong) GoodsModel *goodsModel;
@property (nonatomic,assign) int ms;
@property (nonatomic,assign) int minutes;
@property (nonatomic,assign) int seconds;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic, strong) UILabel *goumaiLabel;






@property (nonatomic, strong)UILabel *lbqihao;//期号



@property (nonatomic, strong) UILabel *guzhang;//故障提示


//---------------------

@property (nonatomic, strong)UIButton *btjiexiao;//已揭晓


@property (nonatomic, strong) UIView *jiexiao;//已揭晓view
@property (nonatomic, strong) UIView * jiexiaoBgView;
@property (nonatomic, strong) UIImageView *imgerweima;//获奖者二维码
@property (nonatomic, strong) UILabel *lbhjz;//获奖者
@property (nonatomic, strong) UIButton *buzjname;//中奖姓名
@property (nonatomic, strong) UILabel *lbzjaddress;//获奖者地址

@property (nonatomic, strong) UILabel *lbzjid;//获奖者id
@property (nonatomic, strong) UILabel *lbzjcanyu;//参与人数

@property (nonatomic, strong) UILabel *lbzjtime;//获奖时间

@property (nonatomic, strong) UIButton *clickButton;//已揭晓中奖者点击


@property (nonatomic, strong) UILabel *lbred;//背景
@property (nonatomic, strong) UILabel *lbluck;//幸运号码

@property (nonatomic, strong) UILabel *lbzjluckno;//幸运号码
@property (nonatomic, strong) UIButton *bujisuan;//计算详情
//-----------------------

@property (nonatomic, strong) UIView *canyuview;//参与
@property (nonatomic, strong) UILabel *lbcanyucount;//参与次数

@property (nonatomic, strong) UILabel *lbduobaono;//寻宝号码

@property (nonatomic, strong) UIButton *bumore;//更多


@property (nonatomic, strong) UIButton *btlooktuwen;//查看图文详情

@property (nonatomic, strong) UIButton *btshare;//分享


@property (nonatomic, strong) UIImageView *shiyuan;//十元


@end
