//
//  TextViewCell.m
//  myg
//
//  Created by lidan on 16/4/29.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import "TextViewCell.h"

@implementation TextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

-(void)createUI{
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 50 / 2 - 15, 18 * 4, 30)];
    self.titleLabel.text = @"备注";
    self.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(15, 15, 18, 18)];
    [self addSubview:self.titleLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(_titleLabel.right +35, 5,  MSW - (40 + _titleLabel.frame.origin.x + _titleLabel.frame.size.width + 10), 30)];
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(15, 15, 18, 18)];
    [self addSubview:self.textView];
    
    
}

#pragma mark  UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    
    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.delegate textViewCell:self didChangeText:textView.text];
    }
//    CGRect bounds = textView.bounds;
//    // 计算 text view 的高度
//    CGSize maxSize = CGSizeMake(MSW - (40 + _titleLabel.frame.origin.x + _titleLabel.frame.size.width + 10), CGFLOAT_MAX);
//    CGSize newSize = [textView sizeThatFits:maxSize];
//    bounds.size = newSize;
//    textView.bounds = bounds;
    
    CGRect frame = textView.frame;
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    frame.size.height = size.height;
    textView.frame = frame;
    
    UITableView *tableView = [self tableView];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

//输入字数的限制
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    int a=  [textView.text length];
//    if ([textView.text length] > 150 || [textView.text length] == 150) {
//        return NO;
//    }else{
//        return YES;
//    }

    if (range.location >= 150)
    {
        return NO;
    }
    else
    {

        return YES;
    }
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *tableView = self.superview;
    if ([_type isEqualToString:@"1"]) {
        if(![tableView isKindOfClass:[UITableView class]] && tableView) {
            tableView = tableView.superview;
            tableView.frame = CGRectMake(0, IPhone4_5_6_6P(-170, -150, 0, 0), MSW,MSH - 64);
        }
    }
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
