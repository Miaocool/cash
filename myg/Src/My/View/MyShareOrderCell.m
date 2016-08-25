//
//  MyShareOrderCell.m
//  yyxb
//
//  Created by lili on 15/11/30.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MyShareOrderCell.h"

@implementation MyShareOrderCell
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
    
    
    _lbsharestatue=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 5, 60, 20)];
    _lbsharestatue.textAlignment=UITextAlignmentCenter;
    _lbsharestatue.textColor=[UIColor whiteColor];
    _lbsharestatue.font = [UIFont systemFontOfSize:BigFont];
    _lbsharestatue.layer.borderWidth = 0.5;
    _lbsharestatue.layer.cornerRadius = 5;
    _lbsharestatue.layer.masksToBounds = YES;
    _lbsharestatue.text=@"审核中";
    [self addSubview:_lbsharestatue];
    
    _lbsharetitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 28, MSW -170, 25)];
    _lbsharetitle.text=@"不错";
    [self addSubview:_lbsharetitle];
    
    _lbsharedate=[[UILabel alloc]initWithFrame:CGRectMake(MSW-160, 30, 150, 20)];
    _lbsharedate.font=[UIFont systemFontOfSize:12];
    _lbsharedate.textAlignment=NSTextAlignmentRight;
    [self addSubview:_lbsharedate];
    
    _imgshare=[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 90, 90)];
    _imgshare.backgroundColor=MainColor;
    [self addSubview:_imgshare];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(15, _imgshare.top -1.5, MSW -30, 0.5)];
    line1.backgroundColor =[ UIColor grayColor];
    [self addSubview:line1];
    
    
    
    
    _lbgoodstitle=[[UILabel alloc]initWithFrame:CGRectMake(_imgshare.right +20, 65, [UIScreen mainScreen].bounds.size.width-135, 40)];
    _lbgoodstitle.text=@"pp;";
    _lbgoodstitle.textColor=[UIColor redColor];
    _lbgoodstitle.numberOfLines = 2;
    _lbgoodstitle.font=[UIFont systemFontOfSize:14];
//        _lbgoodstitle.backgroundColor=[UIColor blueColor];
    
    [self addSubview:_lbgoodstitle];
    _lbshareinfo=[[UILabel alloc]initWithFrame:CGRectMake(_lbgoodstitle.left, _lbgoodstitle.bottom , [UIScreen mainScreen].bounds.size.width-135, 50)];
    _lbshareinfo.numberOfLines=0;
    _lbshareinfo.font=[UIFont systemFontOfSize:13];
    _lbshareinfo.text=@"---------dcfvgbhnjmkcfgvbhnjmkcvgbhnjk---";
//        _lbshareinfo.backgroundColor=[UIColor redColor];
    [self addSubview:_lbshareinfo];
    
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 180 - 0.5, MSW, 0.5)];
    line2.backgroundColor =[ UIColor grayColor];
    [self.contentView addSubview:line2];
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
