//
//  MyStudentCell.m
//  kl1g
//
//  Created by lili on 16/2/18.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "MyStudentCell.h"

@implementation MyStudentCell
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
    _lbpaiming=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 52)];
    _lbpaiming.layer.borderWidth=2;
    _lbpaiming.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    _lbpaiming.textAlignment=UITextAlignmentCenter;
    _lbpaiming.text=@"排名";
    _lbpaiming.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbpaiming];

    _lbname=[[UILabel alloc]initWithFrame:CGRectMake(48, 0, MSW-150, 52)];
    _lbname.layer.borderWidth=2;
    _lbname.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    _lbname.textAlignment=UITextAlignmentCenter;
    _lbname.text=@"用户名";
    _lbname.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbname];
    _lbcount=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100-4, 0, 100+4, 52)];
    _lbcount.layer.borderWidth=2;
    _lbcount.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    _lbcount.textAlignment=UITextAlignmentCenter;
    _lbcount.text=@"徒弟数";
    _lbcount.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbcount];


}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
