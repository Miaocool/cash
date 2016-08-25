//
//  MyEarningViewCell.m
//  yyxb
//
//  Created by lili on 15/12/5.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MyEarningViewCell.h"

@implementation MyEarningViewCell
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
    _lbqiandao=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, MSW/3, 30)];
    _lbqiandao.text=@"签到";
    _lbqiandao.textAlignment=NSTextAlignmentCenter ;
    
    _lbqiandao.font=[UIFont systemFontOfSize:BigFont];
    [self addSubview:_lbqiandao];
    
    _lbtime=[[UILabel alloc]initWithFrame:CGRectMake(_lbqiandao.right-20, 5, MSW/3+40, 30)];
    _lbtime.text=@"2015-10-24 10:20";
    _lbtime.textAlignment=NSTextAlignmentCenter ;
    
     _lbtime.font=[UIFont systemFontOfSize:BigFont];
    [self addSubview:_lbtime];
    _lbjifen=[[UILabel alloc]initWithFrame:CGRectMake(_lbtime.right, 5, MSW/3, 30)];
    _lbjifen.text=@"100";
    
       _lbjifen.font=[UIFont systemFontOfSize:BigFont];
    
    _lbjifen.textAlignment=NSTextAlignmentCenter ;
    [self addSubview:_lbjifen];
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
