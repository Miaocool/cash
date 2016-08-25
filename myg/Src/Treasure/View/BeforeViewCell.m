//
//  BeforeViewCell.m
//  yyxb
//
//  Created by lili on 15/11/16.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "BeforeViewCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

@implementation BeforeViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

- (void)createUI{
    self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.background=[[UIView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 150)];
    
    self.background.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.background];
    self.userhead=[[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 50, 50)];
    _userhead.backgroundColor=[UIColor clearColor];
    
    self.userhead.layer.masksToBounds = YES;
    self.userhead.layer.cornerRadius =25;

    [self.background addSubview:_userhead];

    self.jxdate=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width, 30)];
    
    self.jxdate.text=@"第3308期|揭晓时间:2015-11-03 19:08:00";
    
     _jxdate.font=[UIFont systemFontOfSize:BigFont];
    _jxdate.textColor=[UIColor grayColor];
    
    
    [self.background addSubview:self.jxdate];
    self.more=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-30, 6, 15, 25)];
    self.more.image=[UIImage imageNamed:@"goto"];
    [self.background addSubview:self.more];
    
//    self.lbusername=[[UIButton alloc]initWithFrame:CGRectMake(75, 60, 200, 30)];
    
    
    
    
    self.lbline=[[UILabel alloc]initWithFrame:CGRectMake(5, 35.2,  [UIScreen mainScreen].bounds.size.width-5, 0.8)];
    self.lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.background addSubview:self.lbline];
    
    
    _lbnameip=[[UILabel alloc]initWithFrame:CGRectMake(75, 60, MSW - 80, 30)];
    
    
    [self addSubview:_lbnameip];
    
    
    
    
    
    
    self.username=[[UIButton alloc]initWithFrame:CGRectMake(75, 60, MSW-80, 30)];
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:BigFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ],
                             @"v": @[[UIColor colorWithRed:43.0/255.0 green:133.0/255.0 blue:216/255.0 alpha:1],
                                     
                                     ] };
    _username.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    self.username.backgroundColor=[UIColor clearColor];
    _username.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _username.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
    
    
    [self addSubview:_username];
    
   
    
    
    
    
    self.userid=[[UILabel alloc]initWithFrame:CGRectMake(75,80, 250, 30)];
    _userid.textColor=[UIColor grayColor];
    _userid.font=[UIFont systemFontOfSize:MiddleFont];
    _userid.text=@"用户ID：23456745(唯一不变的标识)";
    [self addSubview:self.userid];
    self.luckno=[[UILabel alloc]initWithFrame:CGRectMake(75, 100, 250, 30)];
    self.luckno.textColor=[UIColor grayColor];
    self.luckno.font=[UIFont systemFontOfSize:MiddleFont];
    self.luckno.attributedText=[@"中奖号码：<u>111111</u>"attributedStringWithStyleBook:style1];
    [self addSubview:self.luckno];
   self.takecount=[[UILabel alloc]initWithFrame:CGRectMake(75,120, 250, 30)];
    self.takecount.textColor=[UIColor grayColor];
    self.takecount.font=[UIFont systemFontOfSize:MiddleFont];
    self.takecount.attributedText=[@"本期参与：<u>12</u>人次"attributedStringWithStyleBook:style1];
    [self addSubview:self.takecount];

    
    
    
    
    



}













- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
