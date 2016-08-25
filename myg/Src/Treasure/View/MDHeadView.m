//
//  MDHeadView.m
//  QQ分组抽屉效果
//
//  Created by Medalands on 15/1/28.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDHeadView.h"

@implementation MDHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //第一步 设置
        self.isOpen = NO;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120);
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView*_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 110)];
        _view.backgroundColor=[UIColor whiteColor];
        
//       UILabel*numA=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
//                numA.text=@"数值A";
//                numA.textColor=[UIColor blackColor];
//                numA.font=[UIFont systemFontOfSize:BigFont];
//                [_view addSubview:numA];
        
        UIImageView * imgA = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 21, 21)];
        imgA.image = [UIImage imageNamed:@"a"];
        [_view addSubview:imgA];
        
                UILabel*lbcountstyle=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,[UIScreen mainScreen].bounds.size.width-30, 40)];
                lbcountstyle.text=@"=截止该商品开奖时间点前最后50条全站参与记录的时间取值之和";
                lbcountstyle.textColor=[UIColor grayColor];
                lbcountstyle.numberOfLines = 0;
                lbcountstyle.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(12, 12, 13, 13)];
                [_view addSubview:lbcountstyle];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, MSW, 1)];
        lineLabel.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        [_view addSubview:lineLabel];
        
                _lbcount=[[UILabel alloc]initWithFrame:CGRectMake(40, 65,[UIScreen mainScreen].bounds.size.width-120, 20)];
                _lbcount.text=@"=2345679";
                _lbcount.textColor=[UIColor grayColor];
                _lbcount.font=[UIFont systemFontOfSize:16];
                [_view addSubview:_lbcount];
        
        _zhankai=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40, 70, 25, 9)];
//        [_zhankai setTitle:@"展开↓" forState:0];
//        _zhankai.titleLabel.font=[UIFont systemFontOfSize:BigFont];
        [_zhankai setTitleColor:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1] forState:0];
        [_zhankai setBackgroundImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal] ;
        [_zhankai setBackgroundImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateSelected];
        [_view addSubview:_zhankai];
        UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(0, 98, [UIScreen mainScreen].bounds.size.width, 12)];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [_view addSubview:line];
        [self addSubview:_view];
           [self addSubview:button];
        
        self.backButton = button;
    }
    return self;
}

-(void)buttonClick
{
    
    if (_zhankai.selected) {
//       [_zhankai setTitle:@"收起↑" forState:0];
        _zhankai.selected = NO;
    }else{
    
//    [_zhankai setTitle:@"展开↓" forState:0];
        _zhankai.selected = YES;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectdWith:)])
    {
        [self.delegate selectdWith:self];
        
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
