//
//  DiscountSecondCell.m
//  yyxb
//
//  Created by 杨易 on 15/12/7.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "DiscountSecondCell.h"

@implementation DiscountSecondCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    /*
     @property (nonatomic, strong) UIImageView *imageView; //红包背景
     @property (nonatomic, strong) UILabel *remainingLabel; //剩余
     @property (nonatomic, strong) UILabel *remainingNum; //剩余数量
     @property (nonatomic, strong) UILabel *hongbaoTitleLabel; //红包标题
     @property (nonatomic, strong) UILabel *dedaLabel;  //到期时间
     */
    self.isChoose = NO;
    //图片
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_redbag"]];
    self.imageView.frame = CGRectMake(0, 0, 77, 80);
    [self addSubview:self.imageView];
    
    //selectedImageView 选中图片
    self.selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choose2-2"]];
    self.selectedImageView.frame = CGRectMake(self.imageView.frame.size.width - 27, 0, 27, 27);
    self.selectedImageView.hidden = YES;

    [self.imageView addSubview:self.selectedImageView];
    
    //红包金额
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 77 / 2 - 25, 77, 50)];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.textColor = RGBCOLOR(255, 237, 195);
    self.numLabel.text = @"10";
    self.numLabel.font = [UIFont systemFontOfSize:23];
    [self.imageView addSubview:self.numLabel];
    
    //剩余
    self.remainingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.frame.size.height + 5, 8*3, 8)];
    self.remainingLabel.text = @"剩余：";
    self.remainingLabel.font = [UIFont systemFontOfSize:8];
    [self addSubview:self.remainingLabel];
    
    //剩余数量
    self.remainingNum = [[UILabel alloc]initWithFrame:CGRectMake(self.remainingLabel.frame.size.width, self.imageView.frame.size.height + 5, 77, 8)];
    self.remainingNum.text = @"2米币";
    self.remainingNum.textColor = MainColor;
    self.remainingNum.font = [UIFont systemFontOfSize:8];
    [self addSubview:self.remainingNum];
    
    //红包标题
    self.hongbaoTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.remainingNum.frame.size.height + self.remainingNum.frame.origin.y + 4, 77, 8)];
    self.hongbaoTitleLabel.text = @"微信十减二红包";
    self.hongbaoTitleLabel.font = [UIFont systemFontOfSize:8];
    [self addSubview:self.hongbaoTitleLabel];
    
    
    //日期
    self.dedaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.hongbaoTitleLabel.frame.size.height + self.hongbaoTitleLabel.frame.origin.y + 4, 77, 22)];
    self.dedaLabel.numberOfLines = 2;
    self.dedaLabel.text = @"2015-11-26 13：14：26到期";
    self.dedaLabel.font = [UIFont systemFontOfSize:8];
    [self addSubview:self.dedaLabel];
    
    
}

#pragma mark 更改选中状态
- (void)setIsChoose:(BOOL)isChoose
{
    _isChoose = isChoose;
    self.selectedImageView.hidden = !isChoose;
//    if (_isChoose)
//    {
//        _chooseImageView.image = [UIImage imageNamed:@"choose2-2"];
//        //        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
//    }
//    else
//    {
//        _chooseImageView.image = [UIImage imageNamed:@"choose2-1"];
//        //        self.backgroundView.backgroundColor = [UIColor whiteColor];
//    }
    
    
}


- (void)setHongbaoModel:(HongbaoModel *)hongbaoModel
{
    _hongbaoModel = hongbaoModel;
    self.hongbaoTitleLabel.text = hongbaoModel.type_name;
    self.dedaLabel.text = hongbaoModel.use_end_date;
    self.remainingNum.text = [NSString stringWithFormat:@"%@米币",hongbaoModel.type_money];
    self.numLabel.text = hongbaoModel.type_money;

}

@end
