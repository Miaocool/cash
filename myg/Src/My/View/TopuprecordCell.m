//
//  TopuprecordCell.m
//  yyxb
//
//  Created by lili on 15/11/24.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "TopuprecordCell.h"

@implementation TopuprecordCell
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
    _lbzhifu=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 30)];
    _lbzhifu.text=@"支付宝APP";
    _lbzhifu.textAlignment=UITextAlignmentLeft;
    _lbzhifu.font = [UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbzhifu];
    
    
    _lbtime=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 240, 25)];
    _lbtime.text=@"2015-11-03 23:59:22";
    _lbtime.textAlignment=UITextAlignmentLeft;
    _lbtime.textColor=[UIColor grayColor];
    _lbtime.font = [UIFont systemFontOfSize:MiddleFont];

    [self addSubview:_lbtime];
    _lbstate=[[UILabel alloc]initWithFrame:CGRectMake(10, 65,90, 30)];
    _lbstate.text=@"未付款";
    _lbstate.textAlignment=UITextAlignmentLeft;
    _lbstate.textColor=MainColor;
    _lbstate.font = [UIFont systemFontOfSize:MiddleFont];

    [self addSubview:_lbstate];

    _lbmoney=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, 40,100, 30)];
    _lbmoney.font = [UIFont systemFontOfSize:MiddleFont];

//    _lbmoney.backgroundColor=MainColor;
    _lbmoney.numberOfLines=0;
    _lbmoney.text=@"￥444433";
    _lbmoney.textColor=MainColor;
//     _lbmoney.textAlignment=UITextAlignmentRight;
    CGSize size = CGSizeMake(_lbmoney.frame.size.width,10000);
    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
    CGSize labelsize = [_lbmoney.text sizeWithFont:_lbmoney.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    //最后根据这个大小设置label的frame即可
    [_lbmoney setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-labelsize.width-20,_lbmoney.frame.origin.y,labelsize.width,labelsize.height)];
  

    [self addSubview:_lbmoney];
    _lbline=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-labelsize.width-20, _lbmoney.frame.origin.y+labelsize.height/2+1,labelsize.width, 1.5)];
    
    _lbline.backgroundColor=MainColor;
    [self addSubview:_lbline];


    
    
    
    


}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
