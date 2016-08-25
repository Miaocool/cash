//
//  MyRedCell.m
//  yyxb
//
//  Created by mac03 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MyRedCell.h"

#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "MJRefresh.h"
@interface MyRedCell(){
    UIView        *_bgView;
    
    UIImageView   *_LeftImgView;

    UILabel                    *_titleLab;       //订单
    UILabel                    *_BalanceLab;      //余额
    UILabel                    *_timeLab;     //有效期
    UILabel                    *_textLab;       //说明
//    UIImageView                *_statusImg;  //状态
    
    UILabel                *_xunbaobi;  //米币
}



@end
@implementation MyRedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithHex:@"#F8F8F8"];
        
        [self initSta];
        
    }
    return self;
}

-(void)initSta
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];

    _LeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 90)];
    _LeftImgView.backgroundColor = [UIColor clearColor];
    _LeftImgView.contentMode = UIViewContentModeScaleAspectFill;
    _LeftImgView.layer.cornerRadius=5;
    _LeftImgView.image=[UIImage imageNamed:@"bg_redbag"];
    _LeftImgView.clipsToBounds = YES;
    _LeftImgView.userInteractionEnabled=YES;
    [_bgView addSubview:_LeftImgView];
    _xunbaobi=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 60, 45)];
//    _xunbaobi.backgroundColor=[UIColor redColor];
    _xunbaobi.text=@"1";
    [_xunbaobi setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    _xunbaobi.textAlignment=NSTextAlignmentCenter;
    _xunbaobi.textColor=[UIColor yellowColor];
    [_LeftImgView addSubview:_xunbaobi];
    
   //标题
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, 5, 200, 20)];
    _titleLab.text=@"微信海购红包";
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:BigFont];
    [_bgView addSubview:_titleLab];
   //余额
    _BalanceLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5,_titleLab.bottom+5, 200, 20)];
    _BalanceLab.text=@"余额：1元";
    _BalanceLab.backgroundColor = [UIColor clearColor];
    _BalanceLab.textColor = [UIColor blackColor];
    _BalanceLab.font = [UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_BalanceLab];
    //有效期
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _BalanceLab.bottom, 200, 20)];
    _timeLab.text=@"有效期：2015-12-01 09：32：46";
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textColor = [UIColor blackColor];
    _timeLab.font = [UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_timeLab];
    //红包说明
    _textLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _timeLab.bottom, 200, 20)];
    _textLab.text=@"直减1米币";
    _textLab.backgroundColor = [UIColor clearColor];
    _textLab.textColor = [UIColor grayColor];
    _textLab.font = [UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_textLab];
    //状态
    _statusImg=[[UIImageView alloc]initWithFrame:CGRectMake(MSW-50, 0, 50, 50)];
    _statusImg.backgroundColor=[UIColor clearColor];
    [_bgView addSubview:_statusImg];
    
}

-(void)setRedModel:(RedBoxDto *)redModel
{
    _redModel=redModel;
    _titleLab.text=_redModel.type_name;
    
    _textLab.text=[NSString stringWithFormat:@"最小订单金额%@",_redModel.min_goods_amount];

    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
       _BalanceLab.attributedText=  [[NSString stringWithFormat:@"金额:<u>%@米币</u>",_redModel.type_money]  attributedStringWithStyleBook:style1];
    
//    描述－－－－－
    _xunbaobi.text=_redModel.type_money;
    //字符串转换时间
    NSString *str=_redModel.use_end_date;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str2=_redModel.use_start_date;//时间戳
    NSTimeInterval time2=[str2 doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    _timeLab.text =[NSString stringWithFormat:@"%@-%@",[dateFormatter2 stringFromDate: detaildate2],[dateFormatter stringFromDate: detaildate]];
    _timeLab.textColor=[UIColor grayColor];
    _statusImg.image=[UIImage imageNamed:@"use"];
    NSString *str1=[NSString stringWithFormat:@"%@",_redModel.type];
    if ([str1 isEqualToString:@"1"])
    {
       _statusImg.hidden=NO;
    }
    else {
        _statusImg.hidden=YES;
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
