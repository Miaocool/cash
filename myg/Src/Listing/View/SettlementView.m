//
//  SettlementView.m
//  yyxb
//
//  Created by 杨易 on 15/12/4.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "SettlementView.h"

@implementation SettlementView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.isOpen = NO;
        self.jiangpinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.jiangpinBtn.frame = self.bounds;
        self.jiangpinBtn.layer.borderWidth = 0.5;
        self.jiangpinBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.jiangpinBtn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.jiangpinBtn];
        
        //标题
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.jiangpinBtn.frame.size.height / 2 - 10, 100, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize: BigFont];
        self.titleLabel.text = @"商品合计";
        [self.jiangpinBtn addSubview:self.titleLabel];
        
        //图片
        self.imageView = [[UIImageView alloc]init];
        self.imageView.image = [UIImage imageNamed:@"arrow_down"];
        self.imageView.frame = CGRectMake(MSW - 10 - 19 ,self.jiangpinBtn.frame.size.height / 2  , 20, 9);
        [self.jiangpinBtn addSubview:self.imageView];
        
        //副标题
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(MSW - 10 - 15 - 10 - 100, self.jiangpinBtn.frame.size.height / 2 - 10, 100, 20)];
        self.textLabel.font = [UIFont systemFontOfSize:MiddleFont];
        self.textLabel.text = @"";
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.textLabel.textColor =MainColor;
        [self.jiangpinBtn addSubview:self.textLabel];
        
        
    }
    return self;
}

- (void)open
{
    [self.delegate selectdWith:self];

}

@end
