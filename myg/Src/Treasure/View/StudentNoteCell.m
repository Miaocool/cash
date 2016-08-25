//
//  StudentNoteCell.m
//  kl1g
//
//  Created by lili on 16/2/18.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "StudentNoteCell.h"

@implementation StudentNoteCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

#pragma mark - 创建UI
- (void)createUI
{
//    _imguser=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
//    _imguser.backgroundColor=MainColor;
//    [self addSubview:_imguser];
//    
    _lbname=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    _lbname.text=@"夺宝达人";
    _lbname.font=[UIFont systemFontOfSize:MiddleFont];
    _lbname.textColor=[UIColor grayColor];
    [self addSubview:_lbname];
    _lbtime=[[UILabel alloc]initWithFrame:CGRectMake(MSW-220, 10, 200, 20)];
    _lbtime.text=@"2015-11-09 12:00:00";
    _lbtime.textAlignment=UITextAlignmentRight;
    _lbtime.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtime.textColor=[UIColor grayColor];
    [self addSubview:_lbtime];
    
    
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(130, 30, 100, 20)];
//    _progressView.progress=0.7;
//    _progressView.progressTintColor = MainColor;
//    _progressView.trackTintColor = [UIColor groupTableViewBackgroundColor];
//    _progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
//    _progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.progressView.layer.cornerRadius = 5;
//    self.progressView.userInteractionEnabled = YES;
//    self.progressView.layer.masksToBounds = YES;
//    
//    
//    [self addSubview:_progressView];
//    
//    
//    _lbstatu=[[UILabel alloc]initWithFrame:CGRectMake(MSW-90, 10, 80, 40)];
//    _lbstatu.text=@"进行中";
//    _lbstatu.textColor=[UIColor whiteColor];
//    _lbstatu.layer.cornerRadius = 10;
//    _lbstatu.layer.masksToBounds=YES;
//    _lbstatu.textAlignment=UITextAlignmentCenter;
//    _lbstatu.backgroundColor=MainColor;
//    [self addSubview:_lbstatu];
//    
    
    
    

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
