//
//  FindDetailViewCell.m
//  yyxb
//
//  Created by lili on 15/12/15.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "FindDetailViewCell.h"

@implementation FindDetailViewCell
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
    _lbdata=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 20)];
    _lbdata.text=@"2015-11-08";
    _lbdata.font=[UIFont systemFontOfSize:BigFont];
    _lbdata.textColor=[UIColor grayColor];
    [self addSubview:_lbdata];
    
    _lbtime=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 90, 20)];
    _lbtime.text=@"2015-11-08";
    _lbtime.font=[UIFont systemFontOfSize:BigFont];
    _lbtime.textColor=[UIColor grayColor];
    [self addSubview:_lbtime];
    
    _lbcount=[[UILabel alloc]initWithFrame:CGRectMake(MSW-130, 10, 120, 20)];
    _lbcount.text=@"888人次";
    _lbcount.textAlignment=NSTextAlignmentRight;
    _lbcount.font=[UIFont systemFontOfSize:BigFont];
    _lbcount.textColor=[UIColor grayColor];
    [self addSubview:_lbcount];
    
    _btlook=[[UIButton alloc]initWithFrame:CGRectMake(MSW-90, 30, 90, 20)];
    [_btlook setTitle:@"查看夺宝号>" forState:UIControlStateNormal];
    _btlook.titleLabel.textAlignment = NSTextAlignmentRight;
    _btlook.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
    [_btlook setTitleColor:FontBlue forState:UIControlStateNormal];
    [self addSubview:_btlook];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
