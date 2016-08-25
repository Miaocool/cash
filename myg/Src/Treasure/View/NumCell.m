//
//  NumCell.m
//  yyxb
//
//  Created by 杨易 on 15/12/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "NumCell.h"

@implementation NumCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //属性的初始化
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        //Cell的设置
//        self.layer.cornerRadius = 10.0f;
//        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 3.5f;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //加载到俯视图
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}
@end
