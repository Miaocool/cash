//
//  DoingViewCell.m
//  yyxb
//
//  Created by lili on 15/11/20.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "DoingViewCell.h"

#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "TreasureNoController.h"
#import "PersonalcenterController.h"
#import "DateHelper.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageCompat.h"





@implementation DoingViewCell
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

    self.imgegood=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
    self.imgegood.backgroundColor=[UIColor clearColor];
    //    改变图片尺寸   等比例缩放
    _imgegood.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:self.imgegood];
    
    
    self.lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(90, 5,[UIScreen mainScreen].bounds.size.width-110, 30)];
    self.lbtitle.text=@"（第2112期）小米插线板";
    _lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtitle.numberOfLines = 2;
    _lbtitle.textAlignment= NSTextAlignmentLeft;
    [self addSubview:self.lbtitle ];
    
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(90, 50, MSW - 190, 20)];
    _progressView.progress=0.7;
    _progressView.progressTintColor = MainColor;
    _progressView.trackTintColor = [UIColor groupTableViewBackgroundColor];
    _progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    _progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.progressView.layer.cornerRadius = 5;
    self.progressView.userInteractionEnabled = YES;
    self.progressView.layer.masksToBounds = YES;
    //设置进度条上进度的颜色
    self.progressView.progressTintColor=RGBCOLOR(247, 148, 40);
    self.progressView.trackTintColor=RGBCOLOR(253, 224, 202);
    [self addSubview:_progressView];
    self.lbcount=[[UILabel alloc]initWithFrame:CGRectMake(90, 55, 150, 20)];
    _lbcount.text=@"总需69";
    _lbcount.font=[UIFont systemFontOfSize:MiddleFont];
    _lbcount.textColor=[UIColor grayColor];
    [self addSubview:_lbcount];
    NSDictionary* style1 = @{@"body" :
                                @[[UIFont systemFontOfSize:MiddleFont],
                                  [UIColor grayColor]],
                            @"u": @[[UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1],
                                    
                                    ]};

    self.lbshengyu=[[UILabel alloc]initWithFrame:CGRectMake(self.progressView.right - 100, 55, 100, 20)];
    _lbshengyu.text=@"剩余44";
    _lbshengyu.textAlignment = NSTextAlignmentRight;
    _lbshengyu.font=[UIFont systemFontOfSize:MiddleFont];
    _lbshengyu.attributedText =  [@"剩余<u>22</u>" attributedStringWithStyleBook:style1];
    [self addSubview:_lbshengyu];
    NSDictionary* style = @{@"body" :
                                @[[UIFont systemFontOfSize:MiddleFont],
                                  [UIColor grayColor]],
                            @"u": @[FontBlue,
                                    
                                    ]};

    self.lbplay=[[UILabel alloc]initWithFrame:CGRectMake(90,90 , 150, 30)];
    _lbplay.text=@"本期参与：1";
    _lbplay.attributedText =  [@"本期参与：<u>2</u>人次" attributedStringWithStyleBook:style];
    _lbplay.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbplay];
    self.btlook=[[UIButton alloc]initWithFrame:CGRectMake(MSW-120, 90, 130, 30)];
    _btlook.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [_btlook setTitle:@"查看夺宝号>" forState:UIControlStateNormal ];
    [_btlook setTitleColor:FontBlue forState:UIControlStateNormal];
    [self addSubview:_btlook];
    self.lbline=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-65, 30, 1.5, 50)];
    _lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:_lbline];
    self.btadd=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 40,40, 30)];
    [_btadd setTitle:@"追加" forState:UIControlStateNormal];
    
    _btadd.layer.cornerRadius = 5;
    _btadd.backgroundColor=MainColor;
    [self addSubview:_btadd];
    self.blackview=[[UIView alloc]initWithFrame:CGRectMake(10, 140, MSW - 20, 75)];
    _blackview.backgroundColor=[UIColor groupTableViewBackgroundColor];

    [self addSubview:_blackview];
    
    _lbname1=[[UILabel alloc]initWithFrame:CGRectMake(5, 7, 65, 15)];
    _lbname1.text=@"中  奖  者：";
    _lbname1.textColor = [UIColor grayColor];
    _lbname1.font=[UIFont systemFontOfSize:MiddleFont];
    _lbname1.textAlignment= NSTextAlignmentLeft;
     [_blackview addSubview:_lbname1 ];
    
    
    self.btname=[[UIButton alloc]initWithFrame:CGRectMake(65, 2, MSW - 70-60-10, 25)];
    _btname.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _btname.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
    [_btname setTitle:@"在下叶良辰" forState:UIControlStateNormal];
     [_btname setTitleColor:FontBlue forState:UIControlStateNormal];
    _btname.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
    [_blackview addSubview:_btname ];
    
    NSDictionary* style5 = @{@"body" :
                                @[[UIFont systemFontOfSize:MiddleFont],
                                  [UIColor grayColor]],
                            @"u": @[MainColor,
                                    
                                    ]};
    self.lbplaycount=[[UILabel alloc]initWithFrame:CGRectMake(5, _lbname1.bottom, 260, 15)];
    _lbplaycount.text=@"本期参与：10人次";
    _lbplaycount.attributedText=  [@"本期参与：<u>2</u>人次" attributedStringWithStyleBook:style5];
    _lbplaycount.font=[UIFont systemFontOfSize:MiddleFont];
    [_blackview addSubview:_lbplaycount];
    self.lbluckno=[[UILabel alloc]initWithFrame:CGRectMake(5, self.lbplaycount.bottom, 260, 15)];
    _lbluckno.text=@"中奖号码：23456789";
    _lbluckno.font=[UIFont systemFontOfSize:MiddleFont];
    _lbluckno.attributedText=  [@"中奖号码：<u>2456789</u>" attributedStringWithStyleBook:style5];
    [_blackview addSubview:_lbluckno];
    self.lbtime=[[UILabel alloc]initWithFrame:CGRectMake(5, self.lbluckno.bottom, _blackview.frame.size.width-10, 15)];
    _lbtime.text=@"揭晓时间:2016-10-29 12:10:00";
    _lbtime.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtime.textColor=[UIColor grayColor];
    [_blackview addSubview:_lbtime];
    
    self.headImg = [[UIImageView alloc] init];
    _headImg.frame = CGRectMake(self.blackview.right - 20 -40, 7, 40, 40);
    _headImg.image = [UIImage imageNamed:@""];
    _headImg.layer.cornerRadius= 20;
    _headImg.layer.masksToBounds = YES;
    [_blackview addSubview:_headImg];
    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 34, 15)];
    _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [self addSubview:_shiyuan];
}
-(void)setModel:(MyBuyListModel *)model{
    _model=model;
if ([model.xiangou isEqualToString:@"1"]||[model.xiangou isEqualToString:@"2"])
    {
        _shiyuan.hidden = NO;
        _shiyuan.image = [UIImage imageNamed:@"xiangou"];
    }
    else
    {
        if ([model.yunjiage isEqualToString:@"10"]) {
            _shiyuan.hidden = NO;
            _shiyuan.image = [UIImage imageNamed:@"3-1"];
        }
        else
        {
            _shiyuan.hidden = YES;
        }
    }
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[FontBlue,
                                     
                                     ]};
    
    NSDictionary* style2 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    
    NSDictionary* style3 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[FontBlue,
                                     
                                     ]};
    
    NSDictionary* style5 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    _lbtitle.text=_model.shopname;
    
    [_imgegood sd_setImageWithURL:[NSURL URLWithString:_model.thumb ] placeholderImage:[UIImage imageNamed:DefaultImage]];
    _lbplay.attributedText=[ [NSString stringWithFormat:@"本期参与：<u>%@</u>人次",_model.gonumber] attributedStringWithStyleBook:style3];
    _lbcount.text=[NSString stringWithFormat:@"总需%@",_model.zongrenshu];
    int a;
    a=[_model.zongrenshu intValue]-[_model.canyurenshu intValue];
    _lbshengyu.attributedText=[[NSString stringWithFormat:@"剩余<u>%i</u>",a]attributedStringWithStyleBook:style2];
    float b;
    b=[_model.canyurenshu floatValue]/[_model.zongrenshu floatValue];
    _progressView.progress=b;

    NSString *str1=_model.jiexiao_time  ;//时间戳
    NSTimeInterval time=[str1 doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _lbtime.text=[NSString stringWithFormat:@"揭晓时间：%@",[dateFormatter stringFromDate: detaildate]];
    _lbluckno.attributedText=  [[NSString stringWithFormat:@"中奖号码：<u>%@</u>",_model.q_user_code] attributedStringWithStyleBook:style5];
    _lbplaycount.attributedText=  [[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",_model.number]  attributedStringWithStyleBook:style5];
    
     [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.img ] placeholderImage:[UIImage imageNamed:@"head"]];

    [_btname setTitle:_model.username forState:UIControlStateNormal];
    [_btname addTarget:self action:@selector(gerenzhongxin) forControlEvents:UIControlEventTouchUpInside];
    [_btlook setTitle:@"查看夺宝号>" forState:UIControlStateNormal];
    [_btlook addTarget:self action:@selector(looktreasureno) forControlEvents:UIControlEventTouchUpInside];

    [_btadd addTarget:self action:@selector(addgoods) forControlEvents:UIControlEventTouchUpInside];
}
-(void)gerenzhongxin
{
      NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_model,@"model", nil];
    NSNotification *geren =[NSNotification notificationWithName:@"gerenzhongxin" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:geren];
}
//查看他的号码
-(void)looktreasureno{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_model,@"model", nil];
    NSNotification *shaidan =[NSNotification notificationWithName:@"lookno" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:shaidan];
}
-(void)addgoods{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_model,@"model", nil];
NSNotification *zhuijia =[NSNotification notificationWithName:@"zhuijia" object:nil userInfo:dict];
[[NSNotificationCenter defaultCenter] postNotification:zhuijia];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
