//
//  CalculateViewCell.m
//  自定义分组抽屉效果
//
//  Created by lili on 15/12/9.
//  Copyright © 2015年 王可伟. All rights reserved.
//

#import "CalculateViewCell.h"

@implementation CalculateViewCell
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
    self.lbdate=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, IPhone4_5_6_6P([UIScreen mainScreen].bounds.size.width-90, [UIScreen mainScreen].bounds.size.width-90, [UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.width-100), 30)];
    _lbdate.text=@"2015-12-09 09:15:43.678";
    _lbdate.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(12, 12, 14, 15)];
    _lbdate.textColor=[UIColor grayColor];
    [self addSubview:_lbdate];
    
    self.lbno=[[UILabel alloc]initWithFrame:CGRectMake(_lbdate.frame.size.width+5, 10, IPhone4_5_6_6P(90, 90, 90, 120), 30)];
//    _lbno.text=@"->0912333";
    _lbno.textColor=[UIColor redColor];
    
    _lbno.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(12, 12, 14, 15)];
    [self addSubview:_lbno];
    
    _lbname=[[UILabel alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P([UIScreen mainScreen].bounds.size.width-75, [UIScreen mainScreen].bounds.size.width-75, [UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.width-100), 0, IPhone4_5_6_6P(65, 65, 90, 90), 40)];
    _lbname.text=@"用生命给你们填坑";
    _lbname.numberOfLines=0;
    _lbname.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(12, 12, 14, 15)];
    _lbname.textColor=[UIColor grayColor];
    [self addSubview:_lbname];
    
    
    
    _lbline1=[[UILabel alloc]initWithFrame:CGRectMake(0,1, [UIScreen mainScreen].bounds.size.width, 1)];
    _lbline1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:_lbline1];

//    _lbline2=[[UILabel alloc]initWithFrame:CGRectMake(0,59, [UIScreen mainScreen].bounds.size.width, 1)];
//    _lbline2.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [self addSubview:_lbline2];




}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
