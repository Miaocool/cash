//
//  RegisteredCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "RegisteredCell.h"

@implementation RegisteredCell
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
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    [self addSubview:view1];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10,view1.frame.size.height / 2 - 20, MSW - 20, 40)];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"请输入验证码";
    self.textField.delegate = self;
    [view1 addSubview:self.textField];
    
    
}

-(void)resendSms
{
    
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
