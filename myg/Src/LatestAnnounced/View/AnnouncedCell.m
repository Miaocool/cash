//
//  AnnouncedCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AnnouncedCell.h"

#import "GoodsCollectionViewCell.h"

#import "GoodsDetailsViewController.h" //商品详情

#import "UIImageView+WebCache.h"
#import "DateHelper.h"

@implementation AnnouncedCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isCountdown = YES;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBCOLOR(241, 241, 241).CGColor;
    self.goodsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我-头像"]];
    self.goodsImageView.frame = CGRectMake(30, 0, self.frame.size.width-60, 110);
    [self addSubview:self.goodsImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.goodsImageView.frame.size.height + 5, self.frame.size.width - 10, 12)];
    self.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.titleLabel.text = @"（第211092369期）Apple iphone6s";
//    self.titleLabel.backgroundColor=[UIColor greenColor];
    [self addSubview:self.titleLabel];
    
    //中奖View
    self.zhongjiangView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5, MSW, 70)];
    // self.zhongjiangView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.zhongjiangView];
    
    self.obtainTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 4*12, 12)];
    self.obtainTitle.textColor = [UIColor lightGrayColor];
    self.obtainTitle.font = [UIFont systemFontOfSize:MiddleFont];
    self.obtainTitle.text = @"获得者：";
    [self.zhongjiangView addSubview:self.obtainTitle];
    
    self.obtainName = [[UILabel alloc]initWithFrame:CGRectMake(self.obtainTitle.frame.size.width + self.obtainTitle.frame.origin.x,self.obtainTitle.frame.origin.y, 100, 12)];
    self.obtainName.font = [UIFont systemFontOfSize:MiddleFont];
    self.obtainName.textColor = [UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1];
    self.obtainName.text = @"柔情初夏";
    
    
    [self.zhongjiangView addSubview:self.obtainName];
    
    self.participate = [[UILabel alloc]initWithFrame:CGRectMake(5 , self.obtainName.frame.size.height + self.obtainName.frame.origin.y + 5, 150, 12)];
    
    self.participate.font = [UIFont systemFontOfSize:MiddleFont];
    self.participate.textColor = [UIColor lightGrayColor];
    self.participate.text = @"参与人数：102";
    [self.zhongjiangView addSubview:self.participate];
    
    self.luckyTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, self.participate.frame.size.height + self.participate.frame.origin.y + 5, 12 * 5, 12)];
    self.luckyTitle.font = [UIFont systemFontOfSize:MiddleFont];
    self.luckyTitle.textColor = [UIColor lightGrayColor];
    self.luckyTitle.text = @"幸运号码：";
    [self.zhongjiangView addSubview:self.luckyTitle];
    
    self.luckyNum = [[UILabel alloc]initWithFrame:CGRectMake(self.luckyTitle.frame.size.width + 5 , self.participate.frame.size.height + self.participate.frame.origin.y + 5, 100, 12)];
    self.luckyNum.font = [UIFont systemFontOfSize:MiddleFont];
    self.luckyNum.textColor = MainColor;
    self.luckyNum.text = @"1232381";
    [self.zhongjiangView addSubview:self.luckyNum];
    
    self.lab=[[UILabel alloc]initWithFrame:CGRectMake(5,self.luckyNum.bottom+5, 12 * 5, 12)];
    self.lab.font = [UIFont systemFontOfSize:MiddleFont];
    self.lab.textColor = [UIColor lightGrayColor];
    self.lab.text = @"揭晓日期：";
    [self.zhongjiangView addSubview:self.lab];
    
    self.timeDate=[[UILabel alloc]initWithFrame:CGRectMake(self.lab.right, self.luckyNum.bottom+5, 150, 12)];
    self.timeDate.font = [UIFont systemFontOfSize:MiddleFont];
//    self.timeDate.textColor = [UIColor blackColor];
    self.timeDate.text = @"jint";
    [self.zhongjiangView addSubview:self.timeDate];
    
    
    
//    self.announcedDate = [[UILabel alloc]initWithFrame:CGRectMake(self.timeDate.right, self.luckyNum.frame.size.height + self.luckyNum.frame.origin.y + 5, 150, 12)];
//    self.announcedDate.font = [UIFont systemFontOfSize:12];
//    self.announcedDate.textColor = [UIColor lightGrayColor];
//    self.announcedDate.text = @"揭晓日期：今天 17：55";
    
    //    _zhongjiangView.backgroundColor=[UIColor grayColor];
    _zhongjiangView.userInteractionEnabled = YES;
    _zhongjiangView.layer.masksToBounds = YES;
    
//    [self.zhongjiangView addSubview:self.announcedDate];
    //即将揭晓
    //    self.jiexiaoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 5, MSW, 70)];
    //    self.jiexiaoView.backgroundColor = [UIColor whiteColor];
    //
    //
    //
    //      [self addSubview:self.jiexiaoView];
    
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clock"]];
    _imageView.frame = CGRectMake(5, 0, 20, 20);
    [self.zhongjiangView addSubview:_imageView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.frame.size.width + 10, _imageView.frame.origin.y, 80, 20)];
    _label.text = @"即将揭晓";
    _label.textColor = MainColor;
    _label.font = [UIFont systemFontOfSize:BigFont];
    [self.zhongjiangView addSubview:_label];
    
    self.dateLable = [[UILabel alloc]initWithFrame:CGRectMake(5, _imageView.frame.size.height + _imageView.frame.origin.y + 10, 4 * 25+10, 20)];
    self.dateLable.font = [UIFont systemFontOfSize:25];
    self.dateLable.textColor = MainColor;
    self.dateLable.text = @"00:00:00";
    
    //    _jiexiaoView.backgroundColor=[UIColor greenColor];
    
    
    [self.zhongjiangView addSubview:self.dateLable];
    
    
    _guzhang=[[UILabel alloc]initWithFrame:CGRectMake(5, _imageView.frame.size.height + _imageView.frame.origin.y + 10, MSW/2-10, 20)];
    _guzhang.backgroundColor=[UIColor whiteColor];
    _guzhang.text=@"彩票中心故障!";
    _guzhang.font = [UIFont systemFontOfSize:10];
    _guzhang.textColor=MainColor;
    [self.zhongjiangView addSubview:_guzhang];
        _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 34, 26)];
    
        _shiyuan.image=[UIImage imageNamed:@"3-1"];
        [self addSubview:_shiyuan];
    
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
    self.dateLable.text = [NSString stringWithFormat:@"%d:%d:%d",self.minutes,self.seconds,self.ms];
    if (self.seconds == 0 && self.ms == 0 && self.minutes == 0)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setLatestModel:(LatestAnnouncedModel *)latestModel
{
    _latestModel = latestModel;
    
    //    没有字段
    if ([_latestModel.xiangou isEqualToString:@"1"]||[_latestModel.xiangou isEqualToString:@"2"])
    {
        _shiyuan.hidden = NO;
        _shiyuan.image = [UIImage imageNamed:@"xiangou"];
    }
    else
    {
        if ([_latestModel.yunjiage isEqualToString:@"10"]) {
            _shiyuan.hidden = NO;
            _shiyuan.image = [UIImage imageNamed:@"3-1"];
        }else{
            _shiyuan.hidden = YES;
        }
    }

    //    //    给时间赋值－－－－－－
    self.minutes =[_latestModel.waittime intValue] / 60;
    self.seconds = [_latestModel.waittime intValue] % 60;
    self.ms = 0;
    if (self.seconds == 0 || self.ms == 0 || self.minutes == 0)
    {
        if(!self.timer)
        {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(showCount:) userInfo:nil repeats:YES];
            //把定时器放到子线程
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
        }
    }
    
    //    改变图片尺寸   等比例缩放
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    //  UIViewContentModeScaleAspectFill   横向填充
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:latestModel.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    self.titleLabel.text = latestModel.title;
    self.obtainName.text = latestModel.username;
    self.participate.text = [NSString stringWithFormat:@"参与人数：%@",latestModel.gonumber];
    
//    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[_latestModel.jiexiao_time floatValue]];
//    NSString *str1 = [DateHelper formatDate:date1];
    
    NSString *str1=_latestModel.jiexiao_time ;//时间戳
    NSTimeInterval time=[str1 doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];

    
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - time;
//        NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        self.timeDate.text = @"刚刚";
    }
    else if (distanceTime < 60*60) {//时间小于一个小时
        self.timeDate.text = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime < 24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        self.timeDate.text = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            self.timeDate.text = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            self.timeDate.text = [df stringFromDate:beDate];
        }
    }
    else if(distanceTime < 24*60*60*365){
        [df setDateFormat:@"MM-dd HH:mm"];
        self.timeDate.text = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.timeDate.text = [df stringFromDate:beDate];
    }

    self.luckyNum.text = latestModel.q_user_code;
    self.dateLable.text =[NSString stringWithFormat:@"%d:%d:%d",self.minutes,self.seconds,self.ms];;
    
    
    //    DebugLog(@"揭晓时间是：%@＝＝----%@-----%@－－",_latestModel.jiexiao_time,_latestModel.type,_latestModel.username);
    //    _guzhang.hidden=YES;
    //    1已揭晓  0 进行中  2 彩票故障
    
    if ([_latestModel.type isEqualToString:@"0"]) {
        
        _jiexiaoView.hidden=NO;
        _label.hidden=NO;
        _imageView.hidden=NO;
        _dateLable.hidden=NO;
        
        _obtainTitle.hidden=YES;
        _luckyTitle.hidden=YES;
        _lab.hidden=YES;
        _timeDate.hidden=YES;
        _announcedDate.hidden=YES;
        _obtainName.hidden=YES;
        _participate.hidden=YES;
        
        _guzhang.hidden=YES;
        
    }
    else if([_latestModel.type isEqualToString:@"1"])
         {
            _jiexiaoView.hidden=YES;
            
            _label.hidden=YES;
            _imageView.hidden=YES;
            _dateLable.hidden=YES;
            
             _obtainTitle.hidden=NO;
            _luckyTitle.hidden=NO;
            _lab.hidden=NO;
            _timeDate.hidden=NO;
            _announcedDate.hidden=NO;
            _obtainName.hidden=NO;
            _participate.hidden=NO;
            
            _guzhang.hidden=YES;
            
        }
        else{
             self.dateLable.text=@"彩票故障中！";
            _guzhang.text=_latestModel.tishi;
            _jiexiaoView.hidden=NO;
            _label.hidden=NO;
            _imageView.hidden=NO;
            _dateLable.hidden=NO;
            
            _obtainTitle.hidden=YES;
            _luckyTitle.hidden=YES;
            _lab.hidden=YES;
            _timeDate.hidden=YES;
            _announcedDate.hidden=YES;
            _obtainName.hidden=YES;
            _participate.hidden=YES;
            
             _guzhang.hidden=NO;
            
        }
    
}

@end
