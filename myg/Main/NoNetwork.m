//
//  NoNetwork.m
//  myg
//
//  Created by lili on 16/4/18.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import "NoNetwork.h"

@implementation NoNetwork
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

    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MSW / 2 - 85, MSH / 2 - IPhone4_5_6_6P(225, 225, 225, 225),190, 175)];
    _imageView.backgroundColor=[UIColor clearColor];
    
    _imageView.image=[UIImage imageNamed:@"提示图片"];
    [self addSubview:_imageView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2 - 100, _imageView.bottom , 200, 30)];
    _titleLabel.text=@"数据加载失败";
    _titleLabel.font=[UIFont systemFontOfSize:BigFont];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    
    _textLabel=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2 - 120, _titleLabel.bottom, 240, 30)];
    _textLabel.text=@"请确保网络正常，下拉重新加载";
    _textLabel.textColor=[UIColor grayColor];
    _textLabel.font=[UIFont systemFontOfSize:MiddleFont];
    _textLabel.textAlignment=NSTextAlignmentCenter;
    self.backgroundColor=[UIColor whiteColor];
    [self addSubview:_textLabel];
    
    _btrefresh=[[UIButton alloc]initWithFrame:CGRectMake(MSW/2 -70, _textLabel.bottom +10, 140, 35)];
    _btrefresh.layer.masksToBounds=YES;
    _btrefresh.layer.cornerRadius = 3;
    [_btrefresh setTitle:@"重新加载" forState:UIControlStateNormal];
    [_btrefresh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btrefresh.backgroundColor=RGBCOLOR(217, 23, 58);
    [self addSubview:_btrefresh];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
