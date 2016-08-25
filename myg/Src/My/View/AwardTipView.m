//
//  AwardTipView.m
//  hlyyg
//
//  Created by liwenzhi on 16/6/12.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "AwardTipView.h"
#import "AppDelegate.h"

@interface AwardTipView ()
{
    UIView      *_bgView;
}
@end

@implementation AwardTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


#pragma mark - 创建视图
- (void)createUI
{
    self.frame = CGRectMake(0, 0, MSW, MSH);
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.8;
    [self addSubview:_bgView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(MSW - 60, 20, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"award_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, closeBtn.bottom - 10, MSW - 20, MSW - 20)];
    topImg.image = [UIImage imageNamed:@"award_img"];
    [self addSubview:topImg];
    
    UILabel *tipLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, topImg.bottom - 40, MSW - 20, 30)];
    tipLbl.text = @"恭喜您获得";
    tipLbl.textColor = [UIColor whiteColor];
    tipLbl.textAlignment = NSTextAlignmentCenter;
    tipLbl.font = [UIFont boldSystemFontOfSize:18];
    tipLbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:tipLbl];
    
    _periodLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, tipLbl.bottom, MSW - 20, 30)];
    _periodLbl.text = @"第10130期";
    _periodLbl.textColor = RGBCOLOR(255, 200, 50);
    _periodLbl.textAlignment = NSTextAlignmentCenter;
    _periodLbl.font = [UIFont boldSystemFontOfSize:18];
    _periodLbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_periodLbl];
    
    _awardLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, _periodLbl.bottom, MSW - 20, 40)];
    _awardLbl.text = @"iPhone6s Plus64G";
    _awardLbl.textColor = RGBCOLOR(255, 200, 50);
    _awardLbl.textAlignment = NSTextAlignmentCenter;
    _awardLbl.font = [UIFont boldSystemFontOfSize:22];
    _awardLbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_awardLbl];
    
    _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookBtn.frame = CGRectMake((MSW - 250)/2, _awardLbl.bottom + 10, 120, 40);
    _lookBtn.backgroundColor = RGBCOLOR(255, 200, 50);
    _lookBtn.layer.cornerRadius = 4;
    _lookBtn.layer.masksToBounds = YES;
    _lookBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_lookBtn setTitle:@"查 看" forState:UIControlStateNormal];
    [_lookBtn setTitleColor:RGBCOLOR(190, 123, 39) forState:UIControlStateNormal];
    [self addSubview:_lookBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(_lookBtn.right + 10, _awardLbl.bottom + 10, 120, 40);
    _shareBtn.backgroundColor = NavColor;
    _shareBtn.layer.cornerRadius = 4;
    _shareBtn.layer.masksToBounds = YES;
    _shareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_shareBtn setTitle:@"分 享" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_shareBtn];
}


#pragma mark - 按钮响应事件

- (void)closeBtnTouched
{
    [self hidden];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTipView)]) {
        [self.delegate showTipView];
    }
}

#pragma mark - public

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)hidden
{
    [self removeFromSuperview];
}



@end
