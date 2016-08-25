//
//  ClassifyViewCell.m
//  myg
//
//  Created by lidan on 16/4/7.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "ClassifyViewCell.h"

@implementation ClassifyViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, IPhone4_5_6_6P(40, 50, 60, 60), IPhone4_5_6_6P(40, 50, 60, 60))];
    [self addSubview:_img];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.img.right + 10, IPhone4_5_6_6P(10, 15, 20, 20), 100, 30)];
    self.lbTitle.textAlignment = NSTextAlignmentLeft;
    self.lbTitle.textColor = [UIColor blackColor];
    self.lbTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.lbTitle];
    
}


@end
