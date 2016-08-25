//
//  LatesAnnViewCell.m
//  kl1g
//
//  Created by lili on 16/2/26.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "LatesAnnViewCell.h"

#import "UIImageView+WebCache.h"
@implementation LatesAnnViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}


- (void)createUI
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBCOLOR(241, 241, 241).CGColor;
    self.backgroundColor=[UIColor whiteColor];
    self.goodsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.goodsImageView.frame = CGRectMake(20, 50, MSW/3-40 , MSW/3-40);
    //    改变图片尺寸   等比例缩放
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
      _goodsImageView.backgroundColor=[UIColor clearColor];
    [self addSubview:self.goodsImageView];
    
    _lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(10, _goodsImageView.frame.origin.y+_goodsImageView.frame.size.height+5, MSW/3-20, 30)];
    //        lblook.text=model.title;
    _lbtitle.numberOfLines=0;
    _lbtitle.backgroundColor=[UIColor whiteColor];
//    _lbtitle.text=@"";
//    _lbtitle.textAlignment=UITextAlignmentCenter;
    _lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtitle.textColor=[UIColor blackColor];
    [self addSubview:_lbtitle];
    
    _lbtime=[[UILabel alloc]initWithFrame:CGRectMake(10, _lbtitle.frame.origin.y+_lbtitle.frame.size.height+10, MSW/3-20,20)];
    _lbtime.backgroundColor=MainColor;
    _lbtime.text=@"";
    _lbtime.textAlignment=UITextAlignmentCenter;
    _lbtime.font=[UIFont systemFontOfSize:SmallFont];
    _lbtime.textColor=[UIColor whiteColor];
  _lbtime.font=[UIFont fontWithName:@"Helvetica-Bold" size:SmallFont];
    _lbtime.layer.cornerRadius = 10;
    _lbtime.layer.masksToBounds = YES;
    [self addSubview:_lbtime];
    
    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 34, 26)];
    
//    _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [self.goodsImageView addSubview:_shiyuan];

}

- (void)setLatestModel:(LatestAnnouncedModel *)latestModel
{
    _latestModel = latestModel;
    
    _lbtitle.text=_latestModel.title;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_latestModel.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];

    
    if([_latestModel.xiangou isEqualToString:@"1"]||[_latestModel.xiangou isEqualToString:@"2"])
    {
        _shiyuan.hidden = NO;
        _shiyuan.image = [UIImage imageNamed:@"xiangou"];
    }
    else
    {
        _shiyuan.hidden=YES;
    }

    if (self.timer) {
        //取消定时器
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_latestModel.type isEqualToString:@"1"]){
                
                self.lbtime.text=_latestModel.username;
                
                
               
                
                
                
            }else if ([_latestModel.type isEqualToString:@"2"]){
                
                self.lbtime.text=_latestModel.tishi;
            }
        });
        
    }
    
    if ([_latestModel.type isEqualToString:@"0"]) {
    
        self.minutes =[_latestModel.waittime intValue] / 60;
        self.seconds = [_latestModel.waittime intValue] % 60;
        self.ms = 0;
        
        
        if (self.seconds == 0 || self.ms == 0 || self.minutes == 0)
        {
            if(!self.timer)
            {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //        dispatch_queue_t queue = dispatch_get_main_queue();
                
                
                //1.先创建一个定时器对象
                self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                
                //2.设置定时器的各种属性
                //(1)什么时候开始定时器
                dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC));
                
                //(2)隔多长时间执行一次
                uint64_t interval = (int64_t)(0.08 * NSEC_PER_SEC);
                //(3)设置定时器
                dispatch_source_set_timer(self.timer, startTime, interval, 0);
                
                //3.设置回调
                dispatch_source_set_event_handler(self.timer, ^{
//                            DebugLog(@"当前线程--%@",[NSThread currentThread]);
                    
                    
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
                    self.ms-=8;
                    
                    if (self.ms <= 0 ) {
                        self.ms = 0;
                    }
                    
                    if (self.seconds == 0 && self.ms == 0 && self.minutes == 0) {
                        //取消定时器
                        dispatch_source_cancel(self.timer);
                        self.timer = nil;
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.lbtime.text = @"正在揭晓...";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"jiexiaoResult" object:nil];
                        });
                    }else{
                        
                        NSString *minuteStr = self.minutes < 10 ? [NSString stringWithFormat:@"0%d",self.minutes] : [NSString stringWithFormat:@"%d",self.minutes];
                        NSString *secondStr = self.seconds < 10 ? [NSString stringWithFormat:@"0%d",self.seconds] : [NSString stringWithFormat:@"%d",self.seconds];
                        NSString *msStr = self.ms < 10 ? [NSString stringWithFormat:@"0%d",self.ms] : [NSString stringWithFormat:@"%d",self.ms];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.lbtime.text = [NSString stringWithFormat:@"%@:%@:%@",minuteStr,secondStr,msStr];
                        });
                    }
                });
                
                //4.启动定时器
                dispatch_resume(self.timer);
            }
        }
        
    }else if ([_latestModel.type isEqualToString:@"1"]){
        
        self.lbtime.text=_latestModel.username;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"homeOpenJiang" object:nil];
        
    }else{
        
        self.lbtime.text=_latestModel.tishi;
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
    self.ms-=4;
  
    self.lbtime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",self.minutes,self.seconds,self.ms];
    if (self.seconds == 0 && self.ms == 0 && self.minutes == 0)
    {
//        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
