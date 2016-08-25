//
//  PayCell.m
//  yyxb
//
//  Created by 杨易 on 15/12/5.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "PayCell.h"

@implementation PayCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    self.isChoose = NO;
    //图片
    self.chooseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choose2-1"]];
    self.chooseImageView.frame =  CGRectMake(MSW - 22 -10, 50 / 2 - 11, 22, 22);
    [self addSubview:self.chooseImageView];
    
    //图标
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    [self addSubview:self.iconImg];
    
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.right + 10, 5, 100, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize: BigFont];
    self.titleLabel.text = @"支付宝";
    [self addSubview:self.titleLabel];
    
    //小标题
    self.littleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImg.right + 10, self.titleLabel.bottom, 200, 20)];
    self.littleTitleLabel.font = [UIFont systemFontOfSize: 12];
    self.littleTitleLabel.text = @"支付宝";
    [self addSubview:self.littleTitleLabel];
    
}

#pragma mark 更改选中状态
- (void)setIsChoose:(BOOL)isChoose
{
    _isChoose = isChoose;
    if (_isChoose)
    {
        _chooseImageView.image = [UIImage imageNamed:@"choose02"];
        //        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        _chooseImageView.image = [UIImage imageNamed:@"choose01"];
        //        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }


}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
