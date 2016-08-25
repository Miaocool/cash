//
//  RadioCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "RadioCell.h"

@implementation RadioCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    self.userInteractionEnabled = NO;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1-15"]];
    imageView.frame = CGRectMake(10, 5, 25, 17);
    [self addSubview:imageView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 2 , 0, MSW - (imageView.frame.size.width + imageView.frame.origin.x), imageView.frame.size.height + 10)];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(MSW - (imageView.frame.origin.y + imageView.frame.size.width + 10), self.scrollView.frame.size.height * 3);
        [self addSubview:self.scrollView];
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height, MSW, 10)];
    myView.backgroundColor = RGBCOLOR(234, 235, 236);
    [self addSubview:myView];

}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
