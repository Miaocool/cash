//
//  AdCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/12.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AdCell.h"

#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

#import "UIImageView+WebCache.h"
@implementation AdCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
//        self.minutes = 0;
//        self.seconds = 5;
//        self.ms = 0;
    }
    return self;
    
}



- (void)createUI
{
    
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MSW, 180) ];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH/4) ];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(MSW * 5, MSH/4-30);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    
//状态
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.scrollView.frame.size.height +self.scrollView.frame.origin.y + 5, 12 * 3 + 6, 16)];
//    self.stateLabel.layer.borderWidth = 1;
//    self.stateLabel.layer.borderColor = MainColor.CGColor;
    self.stateLabel.layer.cornerRadius = 3;
    self.stateLabel.layer.masksToBounds = YES;
    self.stateLabel.textColor = [UIColor whiteColor];
    self.stateLabel.text = @"进行中";
//    self.stateLabel.textColor = MainColor;
    self.stateLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.stateLabel];
//标题
    
    self.titleLabel = [[MyLable alloc]initWithFrame:CGRectMake(self.stateLabel.frame.origin.x + self.stateLabel.frame.size.width + 5, self.scrollView.frame.size.height +self.scrollView.frame.origin.y + 5, MSW - self.stateLabel.frame.size.width - 25-40, 30)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
//    self.titleLabel.text = @"（第21312312期）实打实大师的考核科技的回复设计费华盛顿分红和技能cure";
    [_titleLabel setVerticalAlignment:VerticalAlignmentTop];
    _titleLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.titleLabel];
    
//    －－－－－－－－－－－－－－期号
    _lbqihao=[[UILabel alloc]initWithFrame:CGRectMake(10, self.scrollView.frame.size.height +self.scrollView.frame.origin.y + 30, 200, 20)];
    _lbqihao.backgroundColor=[UIColor clearColor];
    
    _lbqihao.textColor=[UIColor grayColor];
    
//    _lbqihao.text=@"期号：23456789";
    _lbqihao.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_lbqihao];

    UILabel*lbline=[[UILabel alloc]initWithFrame:CGRectMake(MSW-40, _titleLabel.frame.origin.y+5, 1, 50)];
    lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:lbline];
    
//    --------------------------------------------------------------------
    //进度
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressView.frame=CGRectMake(5, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, MSW - 50, 20);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.progressView.layer.cornerRadius = 5;
    self.progressView.userInteractionEnabled = YES;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.transform = transform;
    //设置进度条颜色
    self.progressView.trackTintColor=[UIColor lightGrayColor];
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    self.progressView.progress=0.7;
    //设置进度条上进度的颜色
    self.progressView.trackTintColor=RGBCOLOR(254, 224, 181);
    self.progressView.progressTintColor=RGBCOLOR(253, 177, 9);;

    //设置进度值并动画显示
    [self.progressView setProgress:0.7 animated:YES];
    [self addSubview:self.progressView];
    
    //总需人数
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y + self.progressView.frame.size.height + 5, 120, 14)];
    self.totalLabel.text = @"总需1233人次";
    self.totalLabel.textColor = [UIColor grayColor];
    self.totalLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [self addSubview:self.totalLabel];
    
    
    //剩余人数
NSDictionary* style = @{@"body" :
                                @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                  [UIColor grayColor]],
                            @"u": @[MainColor,
                                    
                                    ]};
    
    self.remainingLabel = [[UILabel alloc]initWithFrame:CGRectMake(MSW - 120 -10-40, self.progressView.frame.origin.y + self.progressView.frame.size.height + 5, 120, 14)];
    self.remainingLabel.attributedText =  [@"剩余<u>100</u>" attributedStringWithStyleBook:style];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.progressView.frame.origin.y + self.progressView.frame.size.height + 5+25 , MSW, 0.8)];
    lineLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1];
    [self addSubview:lineLabel];

    self.remainingLabel.textAlignment = NSTextAlignmentRight;
    //    self.remainingLabel.textColor = [UIColor grayColor];
    self.remainingLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [self addSubview:self.remainingLabel];
    
    
    //    ------------------------
//    UIView*daojishi=[[UIView alloc]initWithFrame:CGRectMake(5,  self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 15, MSW-10, 90)];
//    daojishi.backgroundColor=[UIColor greenColor];
//    
//    
//    [self addSubview:daojishi];
    
//    self.whiteView = [[UIView alloc]init];
//    self.whiteView.backgroundColor = [UIColor orangeColor];
//    [self.contentView addSubview:self.whiteView];
    
    
    
    
    if (self.seconds == 0 || self.ms == 0 || self.minutes == 0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showCount:) userInfo:nil repeats:YES];
        //把定时器放到子线程
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    }
    

    self.countdetail=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-110, 5, 70, 30)];
    
    [self.countdetail setTitle:@"计算详情" forState:UIControlStateNormal];
    //    [self.countdetail setBackgroundColor:[UIColor greenColor]];
    [self.countdetail.layer setBorderWidth:1.5];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    [self.countdetail.layer setCornerRadius:10.0];
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){255,255,255,1});
    [self.countdetail.layer setBorderColor:color];
    [_redView addSubview:self.countdetail];
    
    
//    故障－－－－－－－
    
//    _guzhang=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSW - 10,38)];
//    _guzhang.backgroundColor=MainColor;
//    _guzhang.text=@"彩票故障中!";
//    _guzhang.textColor=[UIColor whiteColor];
//    _guzhang.font=[UIFont systemFontOfSize:18];
//    _guzhang.textAlignment=NSTextAlignmentCenter;
//    [self.redView addSubview:_guzhang];

    //按钮
    self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.lookBtn.frame = CGRectMake(self.progressView.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 15+38+10 , MSW, 30);
    self.lookBtn.frame = CGRectMake(self.progressView.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 15+38+10 , MSW, 30);
    
//    self.lookBtn.backgroundColor = RGBCOLOR(237, 238, 239);
    _lookBtn.backgroundColor=[UIColor clearColor];
    [self addSubview:self.lookBtn];
    
//    UILabel*lbline1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSW, 1)];
//    lbline1.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [_lookBtn addSubview:lbline1];
    
    //如果没有登陆 创建登陆提示lable
    
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                   [UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1]],
                             @"u": @[[UIColor grayColor],
                                     
                                     ]};
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _lookBtn.frame.size.width, 20)];
//    promptLabel.attributedText =  [@"登录<u>以查看我的夺宝号码</u>" attributedStringWithStyleBook:style1];
    promptLabel.text=@"您还没有注册登录，登录参加吧";
    promptLabel.font=[UIFont systemFontOfSize:MiddleFont];
    promptLabel.backgroundColor=[UIColor clearColor];
    promptLabel.textColor=[UIColor grayColor];
    promptLabel.textAlignment = UITextAlignmentCenter;
    [self.lookBtn addSubview:promptLabel];

    //判断参与没参与该商品
//    self.goumaiLabel = [[UILabel alloc]initWithFrame:self.lookBtn.frame];
    self.goumaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lookBtn.frame.origin.x, _lookBtn.frame.origin.y-5, _lookBtn.frame.size.width, 20)];
//    self.goumaiLabel.backgroundColor = RGBCOLOR(237, 238, 239);
    self.goumaiLabel.backgroundColor = [UIColor whiteColor];
    self.goumaiLabel.textColor = [UIColor grayColor];
    self.goumaiLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.goumaiLabel.textAlignment = NSTextAlignmentCenter;
//    [self.lookBtn addSubview:self.goumaiLabel];
    [self addSubview:self.goumaiLabel];
    
    
    
    self.canyuview=[[UIView alloc]initWithFrame:CGRectMake(_goumaiLabel.frame.origin.x, _goumaiLabel.frame.origin.y, MSW-10, 30)];
    _canyuview.backgroundColor=[UIColor whiteColor];
    [self addSubview:_canyuview];
    _lbcanyucount=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
    _lbcanyucount.text=@"已购买1人次";
    _lbcanyucount.font=[UIFont systemFontOfSize:MiddleFont];
    _lbcanyucount.textColor=[UIColor grayColor];
    [_canyuview addSubview:_lbcanyucount];
    
//    self.lbduobaono=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, _canyuview.frame.size.width-60,20 )];
//    _lbduobaono.font=[UIFont systemFontOfSize:MiddleFont];
//    _lbduobaono.textColor=[UIColor grayColor];
//    _lbduobaono.text=@"寻宝号码：12345466";
//    [_canyuview addSubview:_lbduobaono];
    
    _bumore=[[UIButton alloc]initWithFrame:CGRectMake(_canyuview.frame.size.width-100,5, 100, 20)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"查看夺宝号>"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName
     
                    value:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]
     
                    range:NSMakeRange(0, str.length)];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_bumore setAttributedTitle:str forState:UIControlStateNormal];
    _bumore.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
//    [_bumore setTitleColor:[UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_canyuview addSubview:_bumore];
    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 34, 26)];
    
    _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [self addSubview:_shiyuan];
    
    
    _btshare=[[UIButton alloc]initWithFrame:CGRectMake(MSW-35,  _titleLabel.frame.origin.y+15, 25,25)];
    [_btshare setBackgroundImage:[UIImage imageNamed:@"sharered"] forState:UIControlStateNormal];
    _btshare.userInteractionEnabled=YES;
    
    [self addSubview:_btshare];
    
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

    self.time.text = [NSString stringWithFormat:@"即将揭晓 %02d:%02d:%02d",self.minutes,self.seconds,self.ms];
    if (self.seconds == 0 && self.ms == 0 && self.minutes == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openJiang" object:nil];
        
        [self.timer invalidate];
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage =  scrollView.contentOffset.x / MSW;
    
}


-(void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    _guzhangLabel.text = _goodsModel.tishi;
    
    self.minutes =[_goodsModel.waittime intValue] / 60;
    self.seconds = [_goodsModel.waittime intValue] % 60;
    self.ms = 0;

    if ([_goodsModel.xiangou isEqualToString:@"1"]||[_goodsModel.xiangou isEqualToString:@"2"])
    {
        _shiyuan.hidden = NO;
        _shiyuan.image = [UIImage imageNamed:@"xiangou"];
    }
    else
    {
        if ([_goodsModel.yunjiage isEqualToString:@"10"]) {
            _shiyuan.hidden = NO;
            _shiyuan.image = [UIImage imageNamed:@"3-1"];
        }
        else
        {
            _shiyuan.hidden = YES;
        }
    }
   NSString * string = [NSString stringWithFormat:@"已购买%@人次",_goodsModel.gonumber];
    NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:string];
    NSString * string2 = _goodsModel.gonumber;
    [string1 addAttribute:NSFontAttributeName
     
                    value:[UIFont systemFontOfSize:MiddleFont]
     
                    range:NSMakeRange(3, string2.length)];
    [string1 addAttribute:NSForegroundColorAttributeName
     
                    value:MainColor
     
                    range:NSMakeRange(3, string2.length)];
    
    _lbcanyucount.attributedText = string1;
//    [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 3)];
     _lbduobaono.text=[NSString stringWithFormat:@"夺宝号码%@",_goodsModel.goucode];
    
    
    self.titleLabel.text=[NSString stringWithFormat:@"(第%@期)%@",_goodsModel.qishu,_goodsModel.title];
    self.stateLabel.text=goodsModel.goodstype;
    self.totalLabel.text=[NSString stringWithFormat:@"总需：%@",goodsModel.zongrenshu];
//    for (int i = 0; i < goodsModel.picarr.count; i ++)
//    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MSW, self.scrollView.frame.size.height)];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",(int)i]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[goodsModel.picarr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        
        //    改变图片尺寸   等比例缩放
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        imageView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:imageView];
//    }
    
    UILabel*lblookdetail=[[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height-30, MSW, 30)];
    lblookdetail.textColor=[UIColor whiteColor];
    lblookdetail.backgroundColor=[UIColor grayColor];
    lblookdetail.backgroundColor = [UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:0.8];
//    lblookdetail.alpha=0.8;
    lblookdetail.text=@"点击查看图文详情";
    lblookdetail.font=[UIFont systemFontOfSize:BigFont];
    lblookdetail.textAlignment=UITextAlignmentCenter;
    [imageView addSubview:lblookdetail];
    _btlooktuwen=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, MSW, imageView.frame.size.height)];
    _btlooktuwen.userInteractionEnabled=YES;
    _btlooktuwen.backgroundColor=[UIColor clearColor];
    [self addSubview:_btlooktuwen];

    self.scrollView.contentSize = CGSizeMake(MSW * goodsModel.picarr.count, MSH/4-30);
    self.pageControl.numberOfPages = goodsModel.picarr.count;
    self.stateLabel.text = goodsModel.type;
if ([UserDataSingleton userInformation].isLogin == YES)
    {
        self.lookBtn.hidden = YES;
          self.goumaiLabel.hidden = NO;
        _canyuview.hidden=NO;
    }
    else
    {
        self.lookBtn.hidden = NO;
        self.goumaiLabel.hidden = YES;//修改
        _canyuview.hidden=YES;
    }
    if ([goodsModel.type isEqualToString:@"进行中"])
    {
        _stateLabel.backgroundColor=RGBCOLOR(59, 164, 250) ;
        _stateLabel.textColor=[UIColor whiteColor];
        self.stateLabel.layer.borderWidth = 0;
        self.stateLabel.layer.borderColor = RGBCOLOR(59, 164, 250).CGColor;

        
        
    }
    else
    {
        
#warning 揭晓提示
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adcellJieXiao" object:nil];
        
//    修改的－－－－已揭晓
    
//        _pageControl.hidden=YES;
//      _totalLabel.hidden=YES;
//        _remainingLabel.hidden=YES;
//        _progressView.hidden=YES;
//        self.lookBtn.frame=CGRectMake(_lookBtn.frame.origin.x, _lookBtn.frame.origin.y+120, _lookBtn.frame.size.width, _lookBtn.frame.size.height);
        _canyuview.hidden = NO;
        NSString * string = [NSString stringWithFormat:@"已购买%@人次",_goodsModel.gonumber];
        //    size = [self stringSizeString:string andFont:22];
        NSMutableAttributedString * string1 = [[NSMutableAttributedString alloc]initWithString:string];
        NSString * string2 = _goodsModel.gonumber;
        [string1 addAttribute:NSFontAttributeName
         
                        value:[UIFont systemFontOfSize:MiddleFont]
         
                        range:NSMakeRange(3, string2.length)];
        [string1 addAttribute:NSForegroundColorAttributeName
         
                        value:MainColor
         
                        range:NSMakeRange(3, string2.length)];
        
        _lbcanyucount.attributedText = string1;
        
        _redViewBg = [[UIView alloc]initWithFrame:CGRectMake(0, _goumaiLabel.frame.origin.y-10+40, MSW, 90)];
        _redViewBg.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        [self addSubview:_redViewBg];
        
        
        _whiteView1=[[UIView alloc]init];
        _whiteView1.frame=CGRectMake(10, 8, MSW-20, 80);
        _whiteView1.backgroundColor=[UIColor whiteColor];
        _whiteView1.hidden = NO;
        [_redViewBg addSubview:_whiteView1];
        
        _guzhangLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,15, self.whiteView1.frame.size.width-20, 50)];
        _guzhangLabel.backgroundColor = MainColor;
        _guzhangLabel.textColor = [UIColor whiteColor];
        _guzhangLabel.hidden = YES;
        _guzhangLabel.text = _goodsModel.tishi;
        _guzhangLabel.textAlignment = NSTextAlignmentCenter;
        [_whiteView1 addSubview:_guzhangLabel];

        
        _redView = [[UIView alloc]initWithFrame:CGRectMake(15, 40, self.whiteView1.frame.size.width-30, 30)];
        _redView.backgroundColor = MainColor;
        [_whiteView1 addSubview:_redView];
        
        _timecount=[[UILabel alloc]initWithFrame:CGRectMake(15, 10,300, 20)];
        _timecount.text=@"揭晓倒计时";
        _timecount.textAlignment = NSTextAlignmentLeft;
        _timecount.backgroundColor = [UIColor clearColor];
        _timecount.textColor = [UIColor blackColor];
        _timecount.font = [UIFont systemFontOfSize:15];
        [_whiteView1 addSubview:_timecount];
        
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 300, 20)];
//        label.text = @"揭晓倒计时:";
//        label.font = [UIFont systemFontOfSize:BigFont];
//        label.textColor = [UIColor blackColor];
//        [_whiteView1 addSubview:label];
        
        _time=[[UILabel alloc]initWithFrame:CGRectMake(5, 5,150, 20)];
        _time.text=@"03:44:33";
        _time.textColor=[UIColor whiteColor];
        _time.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        //        self.time.backgroundColor=[UIColor greenColor];
        [_redView addSubview: _time];
        
        _countDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSW - 200, 5, 150, 20)];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"查看计算详情>"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSForegroundColorAttributeName
         
                    value:[UIColor whiteColor]
         
                    range:NSMakeRange(0, str.length)];
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [_countDetailBtn setAttributedTitle:str forState:UIControlStateNormal];
        _countDetailBtn.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
        [_countDetailBtn setUserInteractionEnabled:YES];
        [_countDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_redView addSubview:_countDetailBtn];
        
        
        _jiexiaoBgView = [[UIView alloc]initWithFrame:CGRectMake(0,IPhone4_5_6_6P(230, 250, 280, 295), MSW, 160)];
        _jiexiaoBgView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        [self addSubview:_jiexiaoBgView];
        
        _jiexiao=[[UIView alloc]initWithFrame:CGRectMake(10, 15, MSW - 20, 140)];
//        _jiexiao.backgroundColor=RGBCOLOR(242, 247, 235);
        _jiexiao.backgroundColor = [UIColor whiteColor];
        [_jiexiaoBgView addSubview:_jiexiao];
        
        _imgerweima=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 38, 38)];
        _imgerweima.backgroundColor=[UIColor whiteColor];
        _imgerweima.layer.cornerRadius = 19;
        _imgerweima.layer.masksToBounds = YES;
        [_jiexiao addSubview:_imgerweima];
        _lbhjz=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
        _lbhjz.text=@"中  奖  者：";
        _lbhjz.font=[UIFont systemFontOfSize:MiddleFont];
        _lbhjz.textColor = [UIColor grayColor];
        [_jiexiao addSubview:_lbhjz];
        
        UIImageView*imghuojiangzhe=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        imghuojiangzhe.image=[UIImage imageNamed:@"icon_prizewinner"];
        [_jiexiao addSubview:imghuojiangzhe];
        
        _buzjname=[[UIButton alloc]initWithFrame:CGRectMake(120, 10, MSW - 170, 20)];
        [_buzjname setTitle:@"史密斯" forState:(UIControlStateNormal)];
        [_buzjname setTitleColor:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
        _buzjname.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
        _buzjname.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _buzjname.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        [_jiexiao addSubview:_buzjname];
        
//        _lbzjaddress=[[UILabel alloc]initWithFrame:CGRectMake(60, 30, 150, 20)];
//        _lbzjaddress.text=@"手机号码";
//        _lbzjaddress.font=[UIFont systemFontOfSize:MiddleFont];
////        _lbzjaddress.textColor=[UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1];
//        _lbzjaddress.textColor = [UIColor grayColor];
//        [_jiexiao addSubview:_lbzjaddress];
        
        _lbzjid=[[UILabel alloc]initWithFrame:CGRectMake(60, 30,MSW-70, 20)];
//        _lbzjid.text=@"用户ID:345678908(唯一不变的标识)";
        _lbzjid.textColor=[UIColor grayColor];
        _lbzjid.font=[UIFont systemFontOfSize:MiddleFont];
        [_jiexiao addSubview:_lbzjid];
        
        _lbzjcanyu=[[UILabel alloc]initWithFrame:CGRectMake(60, 50,[UIScreen mainScreen].bounds.size.width-70, 20)];
        _lbzjcanyu.text=@"本期参与：";
        _lbzjcanyu.textColor=[UIColor grayColor];
        _lbzjcanyu.font=[UIFont systemFontOfSize:MiddleFont];
        [_jiexiao addSubview:_lbzjcanyu];
        

        _lbzjtime=[[UILabel alloc]initWithFrame:CGRectMake(60, 70,[UIScreen mainScreen].bounds.size.width-70, 20)];
        _lbzjtime.text=@"揭晓时间：2015-11-02 23:22:10:000";
        _lbzjtime.textColor=[UIColor grayColor];
        _lbzjtime.font=[UIFont systemFontOfSize:MiddleFont];
        [_jiexiao addSubview:_lbzjtime];
        
        _lbred=[[UILabel alloc]initWithFrame:CGRectMake(10, 100,_jiexiao.frame.size.width-20, 30)];
        _lbred.backgroundColor=MainColor;
        [_jiexiao addSubview:_lbred];
        _lbluck=[[UILabel alloc]initWithFrame:CGRectMake(20, 105,70, 20)];
        _lbluck.text=@"幸运号码：";
        _lbluck.textColor=[UIColor whiteColor];
        _lbluck.font=[UIFont systemFontOfSize:MiddleFont];
        [_jiexiao addSubview:_lbluck];
        _lbzjluckno=[[UILabel alloc]initWithFrame:CGRectMake(85, 95,120, 40)];
        _lbzjluckno.text=@"12233222";
        _lbzjluckno.textColor=[UIColor whiteColor];
        _lbzjluckno.font=[UIFont systemFontOfSize:BigFont];
        [_jiexiao addSubview:_lbzjluckno];
        _bujisuan=[[UIButton alloc]initWithFrame:CGRectMake(_jiexiao.frame.size.width-115, 100, 95, 30)];
//        [_bujisuan setTitle:@"查看计算详情>" forState:UIControlStateNormal];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"查看计算详情>"];
        NSRange strRange1 = {0,[str1 length]};
        [str1 addAttribute:NSForegroundColorAttributeName
         
                    value:[UIColor whiteColor]
         
                    range:NSMakeRange(0, str1.length)];
        [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
        [_bujisuan setAttributedTitle:str forState:UIControlStateNormal];
        _bujisuan.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    
        [_bujisuan setUserInteractionEnabled:YES];
        [_bujisuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_jiexiao addSubview:_bujisuan];
        _clickButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MSW - 20,100)];
        _clickButton.backgroundColor = [UIColor clearColor];
        [_jiexiao addSubview:_clickButton];
        
    }
    
    if([[NSString stringWithFormat:@"%@",goodsModel.gonumber] isEqualToString:@""])
    {
          self.goumaiLabel.text = @"您还没有参与夺宝哦！";
        self.goumaiLabel.hidden= NO;
        _canyuview.hidden=YES;
    }else{
//        self.goumaiLabel.hidden= YES;
        _canyuview.hidden=NO;
    }
    //判断参与没参与
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
