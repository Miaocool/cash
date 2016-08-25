//
//  TextFieldCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell
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
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 50 / 2 - 15, 18 * 4, 30)];
    self.titleLabel.text = @"收 件 人";
    self.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(15, 15, 18, 18)];
    [self addSubview:self.titleLabel];
    
    //textField
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(self.titleLabel.right +35, self.titleLabel.frame.origin.y, MSW - (40 + self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 10), 30)];
    self.textField.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(15, 15, 18, 18)];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"请输入收件人";
    [self addSubview:self.textField];


}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
