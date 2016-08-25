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
    
    _lbsharetitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 250, 25)];
    _lbsharetitle.text=@"不错";
    [self addSubview:_lbsharetitle];
    _lbsharestatue=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 5, 60, 25)];
    _lbsharestatue.textAlignment=UITextAlignmentCenter;
    _lbsharestatue.backgroundColor=[UIColor greenColor];
    _lbsharestatue.textColor=[UIColor whiteColor];
    _lbsharestatue.text=@"审核中";
    [self addSubview:_lbsharestatue];
    
    _imgshare=[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 120, 100)];
    _imgshare.backgroundColor=[UIColor orangeColor];
    [self addSubview:_imgshare];
    
    _lbgoodstitle=[[UILabel alloc]initWithFrame:CGRectMake(140, 70, [UIScreen mainScreen].bounds.size.width-150, 25)];
    _lbgoodstitle.text=@"xdcfvguhijokplmgvhbjnkml;";
    _lbgoodstitle.textColor=[UIColor redColor];
//    _lbgoodstitle.backgroundColor=[UIColor blueColor];
    [self addSubview:_lbgoodstitle];
    _lbshareinfo=[[UILabel alloc]initWithFrame:CGRectMake(140, 100, [UIScreen mainScreen].bounds.size.width-150, 50)];
    _lbshareinfo.numberOfLines=0;
    _lbshareinfo.font=[UIFont systemFontOfSize:14];
    _lbshareinfo.text=@"---------dcfvgbhnjmkcfgvbhnjmkcvgbhnjk---";
//    _lbshareinfo.backgroundColor=[UIColor redColor];
    [self addSubview:_lbshareinfo];
    
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
