//
//  ShaidanCommentCell.m
//  yyxb
//
//  Created by lili on 15/12/29.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "ShaidanCommentCell.h"

@implementation ShaidanCommentCell
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
    
    self.iamgefound=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10,40, 40)];
    
    self.iamgefound.backgroundColor=[UIColor clearColor];
    self.iamgefound.layer.masksToBounds = YES;
    self.iamgefound.layer.cornerRadius =20;
    
    
    [self addSubview:self.iamgefound];
    
    self.lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, MSW-180, 20)];
    self.lbtitle.text=@"YZ 代投扣234567890";
    self.lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    self.lbtitle.textColor = FontBlue;
    [self addSubview:self.lbtitle];
    
    self.lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(70, 30, MSW-80, 50)];
    self.lbdetail.text=@"想中手机以及电脑的找我［看我名字］加QQ";
    self.lbdetail. font=[UIFont systemFontOfSize:MiddleFont];
    _lbdetail.baselineAdjustment = 0;
 
//    _lbdetail.backgroundColor=[UIColor grayColor];
    self.lbdetail.textColor=[UIColor grayColor];
    [self addSubview:self.lbdetail];
    
    self.lbtime=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 10, 90, 20)];
    _lbtime.text=@"36分钟以前";
    _lbtime.textColor=[UIColor grayColor];
    _lbtime.font=[UIFont systemFontOfSize:14];
    
    
    _lbtime.textAlignment=NSTextAlignmentRight;
    [self addSubview:_lbtime];
    _buall=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, MSW, 60)];
    
    _buall.backgroundColor=MainColor;
    [_buall setTitle:@"查看全部评论" forState:UIControlStateNormal];
    
    [self addSubview:_buall];
    _buall.hidden=YES;
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
