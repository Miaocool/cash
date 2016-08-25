//
//  NoDataView.m
//  yyxb
//
//  Created by 杨易 on 15/11/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "NoDataView.h"
#import "NewGoodsModel.h"
@implementation NoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.frame = CGRectMake(0, 0, MSW, MSH);
    
    _mainScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, MSH)];
    _mainScrollView.backgroundColor = RGBCOLOR(238, 238, 238);
    _mainScrollView.showsHorizontalScrollIndicator=NO;
    _mainScrollView.showsVerticalScrollIndicator=NO;
    
    _mainScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, IPhone4_5_6_6P(568, 580, 620, 590));
    [self addSubview:_mainScrollView];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(MSW / 2 - 55, MSW / 2 - 55, MSW / 2 - 65, MSW / 2 - 65), IPhone4_5_6_6P(MSH / 2 - 220, MSH / 2 - 255, MSH / 2 - 255, MSH / 2 - 255), IPhone4_5_6_6P(100, 110, 130, 130), IPhone4_5_6_6P(110, 110, 130, 130))];
    _imageView.backgroundColor=[UIColor clearColor];
    
    _imageView.image=[UIImage imageNamed:@"pic_empty_me_win"];
    [_mainScrollView addSubview:_imageView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2-100, _imageView.bottom +15, 200, 30)];
    _titleLabel.text=@"你还没有中奖记录";
    _titleLabel.font=[UIFont systemFontOfSize:BigFont];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    [_mainScrollView addSubview:_titleLabel];
    _textLabel=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2-100, _imageView.bottom+40,200, 30)];
    _textLabel.text=@"继续加油夺宝啊！";
    _textLabel.textColor=[UIColor grayColor];
    _textLabel.font=[UIFont systemFontOfSize:MiddleFont];
    _textLabel.textAlignment=NSTextAlignmentCenter;
    self.backgroundColor=[UIColor whiteColor];
    [_mainScrollView addSubview:_textLabel];
    
    _btgoto=[[UIButton alloc]initWithFrame:CGRectMake(MSW/2-75, _imageView.bottom+70,150, 40)];
    _btgoto.layer.masksToBounds=YES;
    _btgoto.layer.cornerRadius = 3;
    [_btgoto setTitle:@"马上夺宝" forState:UIControlStateNormal];
    [_btgoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btgoto.backgroundColor=RGBCOLOR(29, 146, 255);
    [_mainScrollView addSubview:_btgoto];

    _likeView = [[UIView alloc] initWithFrame:CGRectMake(0, IPhone4_5_6_6P(MSH - 200 - 40 - 58, MSH - 200 - 40 - 58, MSH - 200 - 40 - 75, MSH - 200 - 40 - 90)  , MSW, 340)];
    _likeView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_likeView];
    _lblike=[[UILabel alloc]initWithFrame:CGRectMake(10,  5, 100, 30)];
    _lblike.text=@"猜你喜欢";
    _lblike.font=[UIFont systemFontOfSize:BigFont];
    _lblike.textColor=[UIColor blackColor];
    [_likeView addSubview:_lblike];
    _scrolike=[[UIScrollView alloc]initWithFrame:CGRectMake(0, _likeView.frame.origin.y+40, MSW, 200)];
    _scrolike.showsVerticalScrollIndicator = FALSE;
    _scrolike.showsHorizontalScrollIndicator = FALSE;
    
    _scrolike.backgroundColor=[UIColor whiteColor];
    _scrolike.contentSize = CGSizeMake(MSW*2, 140);
    [_mainScrollView addSubview:_scrolike];
        [self getuserlike];
}
-(void)Lasetesannaction:(UIButton *)sender{
    int index=(int)sender.tag;
    DebugLog(@"-----点击了第%li个======type=%i",sender.tag,_type);
    NewGoodsModel*like1=[_likeArray objectAtIndex:index];
       NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:like1,@"model", nil];
    if (_type==1) {
        //清单通知
        NSNotification *qingdan =[NSNotification notificationWithName:@"qingdan" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:qingdan];
    }
    else if (_type==2){
        //寻宝纪录
        NSNotification *xunbaojilu =[NSNotification notificationWithName:@"xunbaojilu" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:xunbaojilu];
    }
    else if (_type==3){
//    中奖纪录
    
        NSNotification *zhongjiangjilu =[NSNotification notificationWithName:@"zhongjiangjilu" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:zhongjiangjilu];
    
    }
 
    else if (_type==4){
        //    我的晒单
        
        NSNotification *shaidantongzhi =[NSNotification notificationWithName:@"shaidantongzhi" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:shaidantongzhi];
        
    }
    else if (_type==5){
        //    充值记录
        
        NSNotification *chongzhi =[NSNotification notificationWithName:@"chongzhi" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:chongzhi];
        
    }else if (_type==6){
        //   兑换
        
        NSNotification *duihuantz =[NSNotification notificationWithName:@"duihuan" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:duihuantz];
        
    }
    else if (_type==7){
        //   搜索
        
        NSNotification *search =[NSNotification notificationWithName:@"search" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:search];
        
    }

}

-(void)getuserlike{
    
    _likeArray=[NSMutableArray array];
    [MDYAFHelp AFPostHost:APPHost bindPath:Userlike postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"猜你喜欢：%@－－－－－－%@",responseDic,responseDic[@"msg"]);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = responseDic[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NewGoodsModel *model = [[NewGoodsModel alloc]initWithDictionary:obj];
                [_likeArray addObject:model];
                
                DebugLog(@"===--%li",_likeArray.count);
            }];
        }
        _likeView.hidden=NO;
        _lbline2.hidden=NO;
        _scrolike.hidden=NO;
        
        [self initData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
        _likeView.hidden=YES;
        _lbline2.hidden=YES;
        _scrolike.hidden=YES;
        
        
    }];    DebugLog(@"==---%li",_likeArray.count);
}
-(void)initData{
    
    if (_likeArray.count>0) {
        
    }else{
        _likeView.hidden=YES;
        _lbline2.hidden=YES;
        _scrolike.hidden=YES;
    }
    
    _scrolike.contentSize = CGSizeMake( MSW / 3*_likeArray.count, 140);
    for (int i = 0; i < _likeArray.count; i ++)
    {
        NewGoodsModel*like1=[_likeArray objectAtIndex:i];
        UIView *LatestView = [[UIView alloc]initWithFrame:CGRectMake(MSW / 3 * i,0, MSW / 3, MSW/3+40)];
        LatestView.backgroundColor=[UIColor whiteColor];
        [_scrolike addSubview:LatestView];
        
        UIImageView*imggood=[[UIImageView alloc]initWithFrame:CGRectMake(20, IPhone4_5_6_6P(15, 15, 15, 5), MSW/3-40 , MSW/3-40)];
        imggood.backgroundColor=[UIColor clearColor];
        
        [imggood sd_setImageWithURL:[NSURL URLWithString:like1.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [LatestView addSubview:imggood];
        
        UILabel*lblook=[[UILabel alloc]initWithFrame:CGRectMake(10, imggood.frame.origin.y+imggood.frame.size.height+IPhone4_5_6_6P(5, 5, 5, 0), MSW/3-20, 40)];
        lblook.numberOfLines=2;
        lblook.text=like1.title;
        //        lblook.textAlignment=UITextAlignmentCenter;
        lblook.font=[UIFont systemFontOfSize:MiddleFont];
        lblook.textColor=[UIColor grayColor];
        [LatestView addSubview:lblook];
        UIButton*btdetai=[[UIButton alloc]initWithFrame:CGRectMake(0, 30, MSW/3, MSW/3)];
        btdetai.backgroundColor=[UIColor clearColor];
        btdetai.tag=i;
        [btdetai addTarget:self action:@selector(Lasetesannaction:) forControlEvents:UIControlEventTouchUpInside];
        [LatestView addSubview:btdetai];
        _imgxiangou=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 34, 26)];
        
        if ([like1.xiangou isEqualToString:@"1"]) {
            _imgxiangou.image=[UIImage imageNamed:@"xiangou"];
        }else{
            _imgxiangou.image=[UIImage imageNamed:@""];
        }
        
        [LatestView addSubview:_imgxiangou];
        
        float a;
        a=[like1.zongrenshu floatValue];
        float b;
        b=[like1.canyurenshu floatValue];
        UIProgressView* progress =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
        //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
        progress.frame=CGRectMake(10, lblook.frame.size.height +lblook.frame.origin.y + 5, MSW/3-20, 15);
        progress.layer.cornerRadius = 5;
        progress.userInteractionEnabled = YES;
        progress.layer.masksToBounds = YES;
        progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
        //设置进度条颜色
        progress.trackTintColor=RGBCOLOR(253, 224, 202);
        //设置进度条上进度的颜色
        progress.progressTintColor=RGBCOLOR(247, 148, 40);
        [LatestView addSubview:progress];
        progress.progress = b/a;
        
    }
    if (_type==1||_type==2||_type==3||_type==4||_type==5||_type==6) {
        
    }else{
        
        _likeView.hidden=YES;
        _lbline2.hidden=YES;
        _scrolike.hidden=YES;
    }
    

}
-(void)setGoodsarray:(NSArray *)goodsarray{
    
    _goodsarray=goodsarray;
    for (int i = 0; i < _goodsarray.count; i ++)
    {
        UIView *LatestView = [[UIView alloc]initWithFrame:CGRectMake(MSW / 3 * i,0, MSW / 3, MSW/3+30)];
        LatestView.backgroundColor=[UIColor whiteColor];
        [_scrolike addSubview:LatestView];
        
        UIImageView*imggood=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, MSW/3-20 , MSW/3-40)];
        imggood.backgroundColor=[UIColor greenColor];
        [LatestView addSubview:imggood];
        
        UILabel*lblook=[[UILabel alloc]initWithFrame:CGRectMake(10, imggood.frame.origin.y+imggood.frame.size.height+5, MSW/3-20, 20)];
        lblook.text=[_goodsarray objectAtIndex:i];
        lblook.font=[UIFont systemFontOfSize:BigFont];
        lblook.textColor=[UIColor grayColor];
        [LatestView addSubview:lblook];
        _btdetai=[[UIButton alloc]initWithFrame:CGRectMake(0, 30, MSW/3, MSW/3)];
        _btdetai.backgroundColor=[UIColor clearColor];
        _btdetai.tag=i;
        [_btdetai addTarget:self action:@selector(Lasetesannaction:) forControlEvents:UIControlEventTouchUpInside];
        [LatestView addSubview:_btdetai];
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, imggood.frame.origin.y+imggood.frame.size.height+5+25, MSW/3-20, 20)];
        _progressView.progress=0.7;
        _progressView.progressTintColor = MainColor;
        _progressView.trackTintColor = [UIColor groupTableViewBackgroundColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);
        _progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.progressView.layer.cornerRadius = 5;
        self.progressView.userInteractionEnabled = YES;
        self.progressView.layer.masksToBounds = YES;
        self.progressView.progressTintColor=RGBCOLOR(247, 148, 40);
        self.progressView.trackTintColor=RGBCOLOR(253, 224, 202);
        
        [LatestView addSubview:_progressView];
    }
    
    
}

@end
