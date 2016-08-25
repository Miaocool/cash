//
//  WinningViewCell.m
//  yyxb
//
//  Created by lili on 15/11/24.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "WinningViewCell.h"


#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
@implementation WinningViewCell
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
    
    
    self.imgegood=[[UIImageView alloc]initWithFrame:CGRectMake(0,10, 90, 90)];
    self.imgegood.backgroundColor=[UIColor clearColor];
    [self addSubview:self.imgegood];
    self.lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, [UIScreen mainScreen].bounds.size.width-120, 30)];
    
    self.lbtitle.text=@"(第2112期）海购商品一箱20盒五木姜油挂面90克";
    _lbtitle.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(15, 15, 17, 17)];
    _lbtitle.numberOfLines=2;
    _lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:self.lbtitle ];
    
    
    
    self.lbcount=[[UILabel alloc]initWithFrame:CGRectMake(110, 40+5, 160, 15)];
    _lbcount.text=@"总需69";
    _lbcount.font=[UIFont systemFontOfSize:MiddleFont];
    _lbcount.textColor=[UIColor grayColor];
    [self addSubview:_lbcount];
    NSDictionary* style = @{@"body" :
                                @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                  [UIColor grayColor]],
                            @"u": @[MainColor,
                                    
                                    ]};
    self.lbluckno=[[UILabel alloc]initWithFrame:CGRectMake(110, 55+5, 260, 15)];
    
    
    _lbluckno.attributedText =  [@"幸运号码：<u>23456789</u>" attributedStringWithStyleBook:style];
    
    _lbluckno.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbluckno];
    
    self.lbplay=[[UILabel alloc]initWithFrame:CGRectMake(110,70 +5, 150, 15)];
//    _lbplay.text=@"本期参与：1人次";
    _lbtitle.attributedText = [@"本期参与：<u>1</u>人次" attributedStringWithStyleBook:style];
    _lbplay.font=[UIFont systemFontOfSize:MiddleFont];
    _lbplay.textColor=[UIColor grayColor];
    [self addSubview:_lbplay];
    
    
    self.lbtime=[[UILabel alloc]initWithFrame:CGRectMake(110, 85+5, 250, 15)];
    _lbtime.text=@"揭晓时间:2016-10-29 12:10";
    //    _lbtime.textAlignment=UITextAlignmentLeft;
    _lbtime.textColor=[UIColor grayColor];
    _lbtime.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbtime];
    
    
    
    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [self.imgegood addSubview:_shiyuan];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, MSW, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLabel];
    
    _checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(MSW - 100, MSW - 100, MSW - 100, MSW - 100), 110, IPhone4_5_6_6P(80, 80, 80, 80), 20)];
    [_checkBtn setTitle:@"查看夺宝号>" forState:UIControlStateNormal];
    [_checkBtn setTitleColor:FontBlue forState:UIControlStateNormal];
    _checkBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
    [self addSubview:_checkBtn];
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
