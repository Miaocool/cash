//
//  Winning ViewCell.m
//  yyxb
//
//  Created by lili on 15/11/24.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "Winning ViewCell.h"

@implementation Winning_ViewCell
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
    
    self.imgegood=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
    self.imgegood.backgroundColor=[UIColor greenColor];
    [self addSubview:self.imgegood];
    self.lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(90, 5, 250, 30)];
    self.lbtitle.text=@"（第2112期）小米插线板";
    _lbtitle.font=[UIFont systemFontOfSize:14];
    _lbtitle.textAlignment=UITextAlignmentLeft;
    [self addSubview:self.lbtitle ];
    
    
    
    self.lbcount=[[UILabel alloc]initWithFrame:CGRectMake(90, 60, 60, 20)];
    _lbcount.text=@"总需69";
    _lbcount.textColor=[UIColor grayColor];
    [self addSubview:_lbcount];
    
    
    self.lbshengyu=[[UILabel alloc]initWithFrame:CGRectMake(185, 60, 60, 20)];
    _lbshengyu.text=@"剩余44";
    _lbshengyu.textColor=[UIColor grayColor];
    [self addSubview:_lbshengyu];
    
    self.lbplay=[[UILabel alloc]initWithFrame:CGRectMake(90,100 , 150, 30)];
    _lbplay.text=@"本期参与：1人次";
    _lbplay.font=[UIFont systemFontOfSize:14];
    [self addSubview:_lbplay];
    
    self.btlook=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, 100, 150, 30)];
    _btlook.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [_btlook setTitle:@"查看我的号码" forState:UIControlStateNormal ];
    [_btlook setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self addSubview:_btlook];
    self.lbline=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-65, 5, 1.5, 90)];
    _lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:_lbline];
    self.btadd=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 30, 50, 40)];
    [_btadd setTitle:@"追加" forState:UIControlStateNormal];
    
    _btadd.layer.cornerRadius = 5;
    _btadd.backgroundColor=[UIColor orangeColor];
    [self addSubview:_btadd];
    
    self. progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(90, 40, 160, 20)];
    _progressView.progress=0.7;
    _progressView.progressTintColor = [UIColor greenColor];
    _progressView.trackTintColor = [UIColor redColor];
    _progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    _progressView.backgroundColor = [UIColor orangeColor];
    
    
    
    [self addSubview:_progressView];
    
    self.blackview=[[UIView alloc]initWithFrame:CGRectMake(90, 140, [UIScreen mainScreen].bounds.size.width-100, 100)];
    _blackview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:_blackview];
    self.btname=[[UIButton alloc]initWithFrame:CGRectMake(5, 0, 260, 25)];
    //    _btname.contentHorizontalAlignment = UIControlContentHorizonAlignmentLeft;
    _btname.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _btname.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
    [_btname setTitle:@"获得者：就给我中一次吧" forState:UIControlStateNormal];
    [_btname setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btname setFont:[UIFont systemFontOfSize:14]];
    [_blackview addSubview:_btname ];
    self.lbplaycount=[[UILabel alloc]initWithFrame:CGRectMake(5, 25, 260, 25)];
    _lbplaycount.text=@"本期参与：10人次";
    _lbplaycount.font=[UIFont systemFontOfSize:14];
    [_blackview addSubview:_lbplaycount];
    self.lbluckno=[[UILabel alloc]initWithFrame:CGRectMake(5, 50, 260, 25)];
    _lbluckno.text=@"幸运号码：23456789";
    _lbluckno.font=[UIFont systemFontOfSize:14];
    
    
    [_blackview addSubview:_lbluckno];
    self.lbtime=[[UILabel alloc]initWithFrame:CGRectMake(5, 75, _blackview.frame.size.width-10, 25)];
    _lbtime.text=@"揭晓时间:2016-10-29 12:10:00";
    _lbtime.font=[UIFont systemFontOfSize:14];
    [_blackview addSubview:_lbtime];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
