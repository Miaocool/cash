//
//  LatesAnnountViewCell.m
//  yydg
//
//  Created by lili on 16/1/4.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "LatesAnnountViewCell.h"
#define imgHeight   80
#import "UIImageView+WebCache.h"
#import "LatestAnnouncedModel.h"
@interface LatesAnnountViewCell ()
{

    NSTimer     *timer;
   NSInteger    nowSeconds;
}

@end
@implementation LatesAnnountViewCell


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

//    self.layer.frame=CGRectMake(10, 0, MSW-2, self.frame.size.height-2);
//    self.layer.borderWidth = 1;
//    
//   self.layer.borderColor = MainColor.CGColor;
//
//    
    _imgProduct = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imgHeight, imgHeight)];
    _imgProduct.image = [UIImage imageNamed:@"noimage"];
//    _imgProduct.layer.borderWidth = 0.5;
    //        imgProduct.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
//    _imgProduct.layer.cornerRadius = 10;
    _imgProduct.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgProduct];
    
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 10,[UIScreen mainScreen].bounds.size.width-110, 30)];
    _lblTitle.font = [UIFont systemFontOfSize:12];
    _lblTitle.textColor = [UIColor blackColor];
    _lblTitle.numberOfLines = 2;
    _lblTitle.text=@"sdrftgyhjkl";
    _lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_lblTitle];
    
    
    _lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(100, 40,[UIScreen mainScreen].bounds.size.width-110, 30)];
    _lblPrice.font = [UIFont systemFontOfSize:12];
    
    _lblPrice.text=@"90000";
    _lblPrice.textColor = [UIColor grayColor];
    [self addSubview:_lblPrice];
    
    _imgTimeBG = [[UIImageView alloc] initWithFrame:CGRectMake(imgHeight + 20, 80, 20, 20)];
//           _imgTimeBG.backgroundColor =MainColor;
    _imgTimeBG.image = [UIImage imageNamed:@"clock1"];
    _imgTimeBG.hidden = NO;
//    _imgTimeBG.layer.cornerRadius = 5;
    [self.contentView addSubview:_imgTimeBG];
    
    
    
    _lblTime = [[UILabel alloc] initWithFrame:CGRectMake(imgHeight + 20+20+10, 72,[UIScreen mainScreen].bounds.size.width - imgHeight - 30,30)];
    _lblTime.font = [UIFont systemFontOfSize:30];
    _lblTime.textColor = MainColor;
//    _lblTime.text = @"揭晓倒计时  00:00:00";
    [self.contentView addSubview:_lblTime];
    
    _imgxiangou=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
    _imgxiangou.backgroundColor=[UIColor clearColor];
    _imgxiangou.image=[UIImage imageNamed:@"label_03"];
    
    [self addSubview:_imgxiangou];
    
    _timeImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
    _timeImg.image = [UIImage imageNamed:@"label"];
    [_imgxiangou addSubview:_timeImg];
    
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 109+3+0.5, MSW, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineLabel];

//    //待赋值
//    nowSeconds = 1800 * 100;
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    

    _lbguzhang = [[UILabel alloc] initWithFrame:CGRectMake(imgHeight + 20+20+10, 82,[UIScreen mainScreen].bounds.size.width - imgHeight - 30,20)];
    _lbguzhang.font = [UIFont systemFontOfSize:15];
    _lbguzhang.textColor = MainColor;
    //    _lblTime.text = @"揭晓倒计时  00:00:00";
    [self.contentView addSubview:_lbguzhang];






}
- (void)setLatestModel:(LatestAnnouncedModel *)latestModel
{
    _latestModel = latestModel;
    
    _lbguzhang.text=_latestModel.tishi;
    
    DebugLog(@"=-----%@=--%@",_latestModel.title,_latestModel.type);
    
    
    _lblTitle.text=_latestModel.title;
    _lblPrice.text=[NSString stringWithFormat:@"价值: ¥%@",_latestModel.canyurenshu];
    
    [self.imgProduct sd_setImageWithURL:[NSURL URLWithString:latestModel.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];


    
    if ([_latestModel.type isEqualToString:@"0"]) {
        
        _lbguzhang.hidden=YES;
        _lblTime.hidden=NO;
    self.minutes =[_latestModel.waittime intValue] / 60;
    self.seconds = [_latestModel.waittime intValue] % 60;
    self.ms = 0;
        
        
    if(!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.009f target:self selector:@selector(showCount:) userInfo:nil repeats:YES];
        //把定时器放到子线程
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    

    }
    else
    {
        _lbguzhang.hidden=NO;
        _lblTime.hidden=YES;
//        self.lblTime.hidden=YES;
        self.lblTime.text=_latestModel.tishi;
        self.lblTime.frame = CGRectMake(imgHeight + 20+20+10, 82,[UIScreen mainScreen].bounds.size.width - imgHeight - 30,20);
        self.lblTime.font = [UIFont systemFontOfSize:15];
        
        
        
        
    }
    
    if ([_latestModel.xiangou isEqualToString:@"0"]) {
        _imgxiangou.image=[UIImage imageNamed:@""];
    }else{
        
        _imgxiangou.image=[UIImage imageNamed:@"label_03"];
    }
    
    
}

#pragma mark - 倒计时
-(void)showCount:(NSTimer *)timer
{
    //minutes 分钟
    //seconds 秒
    //ms 毫秒
    
    
    if (self.ms == 0)
    {
        
        
        if (self.minutes > 0 || self.seconds > 0)
        {
            self.ms = 100;
            if (self.seconds > 0)
            {
                self.seconds =  self.seconds - 1;
            }
            if (self.seconds == 0 && self.minutes > 0)
            {
                self.seconds = 59;
                self.minutes = self.minutes -1;
            }
            
        }
        
    }
    self.ms--;
    
    
//    self.lblTime.text = [NSString stringWithFormat:@"揭晓倒计时：%d:%d:%d",self.minutes,self.seconds,self.ms];
    self.lblTime.frame= CGRectMake(imgHeight + 20+20+10, 72,[UIScreen mainScreen].bounds.size.width - imgHeight - 30,30);
    _lblTime.font = [UIFont systemFontOfSize:30];
     self.lblTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",self.minutes,self.seconds,self.ms];
    if (self.seconds == 0 && self.ms == 0 && self.minutes == 0)
    {
        
        
        
        _lblTime.font = [UIFont systemFontOfSize:15];
#warning 添加通知
        _lblTime.text = @"正在开奖中...";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openPrize" object:_lblTime];
        
//        _lblTime.text = @"彩票中心故障！";
//        _imgTimeBG.hidden = YES;
       
        [self.timer invalidate];
        self.timer = nil;
    }
//    else
//    {
//       
//        _imgTimeBG.hidden = NO;
//    }
    
    
}

//
//- (void)timerAction
//{
//    if(nowSeconds<0)
//    {
//        [timer invalidate];
//        timer = nil;
//        return;
//    }
//    nowSeconds--;
//    if(nowSeconds<=0)
//    {
//        _lblTime.text = @"正在揭晓...";
//
////        CGSize sss = [_lblTime.text textSizeWithFont:_lblTime.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
////        _lblTime.frame = CGRectMake((_imgTimeBG.frame.size.width - sss.width) / 2, (_imgTimeBG.frame.size.height - sss.height) /2, sss.width, sss.height);
//
//        return;
//    }
//
//
//    int m = (int)nowSeconds / 6000;
//    int s = (int)(nowSeconds/100) - m*60;
//    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
//    int ms = nowSeconds % 100;
//    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
//    _lblTime.text = [NSString stringWithFormat:@"揭晓倒计时  0%d:%@:%@",m,f1,f2];
//
////    CGSize sss = [_lblTime.text textSizeWithFont:_lblTime.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
////    _lblTime.frame = CGRectMake((_imgTimeBG.frame.size.width - sss.width) / 2, (_imgTimeBG.frame.size.height - sss.height) /2, sss.width, sss.height);
//}
//
//
//
//
//






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
