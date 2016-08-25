//
//  DidJiexiaoViewCell.m
//  yydg
//
//  Created by lili on 16/1/5.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "DidJiexiaoViewCell.h"
#import "LatestAnnouncedModel.h"
@implementation DidJiexiaoViewCell
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


//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = [[UIColor grayColor] CGColor];

    _imgProduct = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
//    _imgProduct.image = [UIImage imageNamed:@"noimage"];
//    _imgProduct.layer.borderWidth = 0.5;
//    _imgProduct.layer.borderColor = [[UIColor grayColor] CGColor];
//    _imgProduct.layer.cornerRadius = 10;
    _imgProduct.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgProduct];
    
    
    _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(IPhone4_5_6_6P(MSW-40, MSW-40, MSW-50, MSW-50), 60, IPhone4_5_6_6P(30, 30, 40, 40), IPhone4_5_6_6P(30, 30, 40, 40))];

    _imgHead.backgroundColor=[UIColor clearColor];
    _imgHead.layer.cornerRadius = IPhone4_5_6_6P(15, 15, 20, 20);
    _imgHead.layer.masksToBounds = YES;
    [self addSubview:_imgHead];
    
    _bthead = [[UIButton alloc] initWithFrame:CGRectMake(IPhone4_5_6_6P(MSW-40, MSW-40, MSW-50, MSW-50), 60, IPhone4_5_6_6P(30, 30, 40, 40), IPhone4_5_6_6P(30, 30, 40, 40))];
    [self addSubview:_bthead];
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 10,[UIScreen mainScreen].bounds.size.width-110, 30)];
    _lblTitle.font = [UIFont systemFontOfSize:12];
    _lblTitle.textColor = [UIColor blackColor];
    _lblTitle.numberOfLines = 2;
    _lblTitle.text=@"sdrftgyhjkl";
    _lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_lblTitle];
    
    UILabel* lblName1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 30+15+12, 40, 15)];
    lblName1.text = @"获得者:";
    lblName1.textColor = [UIColor lightGrayColor];
    lblName1.font = [UIFont systemFontOfSize:12];
    [self addSubview:lblName1];
    
    _lblName = [[UILabel alloc] initWithFrame:CGRectMake(143, 30+15+12, MSW - 200, 15)];
    _lblName.textColor = [UIColor colorWithRed:97/255.0 green:186/255.0 blue:255/255.0 alpha:1];
    _lblName.font = [UIFont systemFontOfSize:12];
    
    _lblName.text=@"王尼玛";
    [self addSubview:_lblName];
    
    UILabel* lblCode1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 50+15+10, 100, 15)];
    lblCode1.text = @"本期参与: ";
    lblCode1.textColor = [UIColor lightGrayColor];
    lblCode1.font = [UIFont systemFontOfSize:12];
    [self addSubview:lblCode1];
    
    _lblCode = [[UILabel alloc] initWithFrame:CGRectMake(155, 50+15+10, MSW - 200, 15)];
    _lblCode.textColor = MainColor;
    
    _lblCode.text = [NSString stringWithFormat:@"33 人次"];
    _lblCode.font = [UIFont systemFontOfSize:12];
    [self addSubview:_lblCode];
    
    _lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(100, 25+10+5, MSW - 200, 15)];
    _lblPrice.textColor = [UIColor lightGrayColor];
    
    _lblPrice.text = [NSString stringWithFormat:@"价值：￥111"];
    _lblPrice.font = [UIFont systemFontOfSize:12];
    [self addSubview:_lblPrice];
    
    _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(100, 65+15+10, IPhone4_5_6_6P(MSW - 120, MSW - 120, MSW - 100, MSW - 100), 15)];
    
    
    _lblTime.text = [NSString stringWithFormat:@"揭晓时间：2896677"];
    _lblTime.textColor = [UIColor lightGrayColor];
    _lblTime.font = [UIFont systemFontOfSize:12];
    _lblTime.numberOfLines = 0;
    _lblTime.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_lblTime];
    
    _imgxiangou=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    _imgxiangou.backgroundColor=[UIColor clearColor];
    _imgxiangou.image=[UIImage imageNamed:@"label_03"];
   
    [self addSubview:_imgxiangou];
    
    
    
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 109+3+0.5, MSW, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineLabel];

}

- (void)setLatestModel:(LatestAnnouncedModel *)latestModel
{
    _latestModel = latestModel;
    
#warning 提示通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidJiexiaoViewCellJieXiao" object:nil];
    
    NSDictionary* style1 = @{@"body" :
                                 @[
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};

    [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:latestModel.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    
    
    
        [self.imgHead sd_setImageWithURL:[NSURL URLWithString:latestModel.img] placeholderImage:[UIImage imageNamed:DefaultImage]];
    
    _lblTitle.text=_latestModel.title;

    _lblPrice.text=[NSString stringWithFormat:@"价值:￥%@",_latestModel.canyurenshu];
    _lblName.text = _latestModel.username;
//    NSString * string = [NSString stringWithFormat:@"获得者:%@",_latestModel.username];
//    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:string];
//    NSString * string2 = _latestModel.username;
//    [string1 addAttribute:NSForegroundColorAttributeName
//     
//                    value:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]
//     
//                    range:NSMakeRange(4, string2.length)];
////    _lblName.text=[NSString stringWithFormat:@"获得者:%@",_latestModel.username];
//    _lblTime.attributedText = string1;
    
    
    NSString *str=_latestModel.jiexiao_time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _lblTime.text=[NSString stringWithFormat:@"揭晓时间: %@",[dateFormatter stringFromDate: detaildate]];
    _lblCode.text=[NSString stringWithFormat:@"%@人次",_latestModel.gonumber];
    
    _lblCode.attributedText=[[NSString stringWithFormat:@"<u>%@</u>人次",_latestModel.gonumber] attributedStringWithStyleBook:style1];

    
    
    
    
    if ([_latestModel.xiangou isEqualToString:@"0"]) {
        _imgxiangou.image=[UIImage imageNamed:@""];
    }else{
    
     _imgxiangou.image=[UIImage imageNamed:@"label_03"];
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
