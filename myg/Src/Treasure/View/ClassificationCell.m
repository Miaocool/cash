//
//  ClassificationCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/10.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ClassificationCell.h"

@implementation ClassificationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

#pragma mark - 创建UI
- (void)createUI
{
    
   
    
    //图
    self.headPortrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的消息"]];
    self.headPortrait.frame = CGRectMake(10, 60 / 2 - 20, 30, 30);
    [self addSubview:self.headPortrait];
    
    //title
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headPortrait.frame.origin.x + self.headPortrait.frame.size.width + 5, 50 / 2 - 7 , 150, 14)];
    self.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.titleLabel.text = @"1";
    [self addSubview:self.titleLabel];
    
//    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, 50, MSW, 0.5)];
//    self.lineView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:self.lineView];

    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
//    //上分割线，
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGContextStrokeRect(context, CGRectMake(self.titleLabel.frame.origin.y, -0.5, rect.size.width - 10, 0.5));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(self.titleLabel.frame.origin.x, rect.size.height, rect.size.width - 10, 0.5));
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
