//
//  TextViewCell.h
//  myg
//
//  Created by lidan on 16/4/29.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TextViewCell;

@protocol TextViewCellDelegate <NSObject>

- (void)textViewCell:(TextViewCell *)cell didChangeText:(NSString *)text;

@end

@interface TextViewCell : UITableViewCell<UITextViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) NSString * type ; //1为实物收货地址和游戏充值 2为充值账号

@property (assign, nonatomic) id<TextViewCellDelegate> delegate;
@end



