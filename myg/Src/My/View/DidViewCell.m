//
//  DidViewCell.m
//  yyxb
//
//  Created by lili on 15/12/3.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "DidViewCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

#import "TreasureNoController.h"
#import "PersonalcenterController.h"

@implementation DidViewCell
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
    self.lbtitle.numberOfLines = 2;
    _lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtitle.textAlignment= NSTextAlignmentLeft;
    [self addSubview:self.lbtitle ];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(90, 50, MSW - 190, 20)];
    _progressView.progress=0.7;
    //    _progressView.trackTintColor = [UIColor groupTableViewBackgroundColor];
    //    _progressView.transform = CGAffineTransformMakeScale(0.1f,3.0f);
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
                             @"u": @[MainColor,
                                     
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
                            @"u": @[MainColor,
                                    
                                    ]};
    self.lbplay=[[UILabel alloc]initWithFrame:CGRectMake(90,90 , 150, 30)];
    _lbplay.text=@"本期参与：1";
    
    _lbplay.attributedText =  [@"本期参与：<u>2</u>人次" attributedStringWithStyleBook:style];
    _lbplay.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbplay];
    self.btlook=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 90, 130, 30)];
    [_btlook setTitle:@"查看夺宝号>" forState:UIControlStateNormal ];
    _btlook.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [_btlook setTitleColor:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]
 forState:UIControlStateNormal];
    [self addSubview:_btlook];
    self.lbline=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-65, 32, 1.5, 50)];
    _lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:_lbline];
    self.btadd=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 40,40, 30)];
    [_btadd setTitle:@"追加" forState:UIControlStateNormal];
    _btadd.layer.cornerRadius = 5;
    _btadd.backgroundColor=MainColor;
    [self addSubview:_btadd];
    
    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 34, 26)];
    _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [self addSubview:_shiyuan];
    
}
-(void)setModel:(MyBuyListModel *)model{
    _model=model;
    DebugLog(@"%@",_model.shopname);
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
    
    _lbtitle.text=_model.shopname;
    //        _imgegood
    [_imgegood sd_setImageWithURL:[NSURL URLWithString:_model.thumb ] placeholderImage:[UIImage imageNamed:DefaultImage]];
    //
    _lbplay.attributedText=[ [NSString stringWithFormat:@"本期参与：<u>%@</u>人次",_model.gonumber] attributedStringWithStyleBook:style1];
    _lbcount.text=[NSString stringWithFormat:@"总需%@",_model.zongrenshu];
    int a;
    a=[_model.zongrenshu intValue]-[_model.canyurenshu intValue];
    _lbshengyu.text=[NSString stringWithFormat:@"剩余%i",a];
    
    _lbshengyu.attributedText=[[NSString stringWithFormat:@"剩余<u>%i</u>",a]attributedStringWithStyleBook:style2];
    float b;
    b=[_model.canyurenshu floatValue]/[_model.zongrenshu floatValue];
    _progressView.progress=b;
    [_btname addTarget:self action:@selector(gerenzhongxin:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btlook addTarget:self action:@selector(looktreasureno) forControlEvents:UIControlEventTouchUpInside];
    
    [_btadd addTarget:self action:@selector(addgoods) forControlEvents:UIControlEventTouchUpInside];

}

-(void)gerenzhongxin:(UIButton *)button
{
        NSNotification *geren =[NSNotification notificationWithName:@"gerenzhongxin" object:_model userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:geren];
    
    
}
//查看他的号码
-(void)looktreasureno{
    DebugLog(@"-===tx%@",_model.shopname);
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
