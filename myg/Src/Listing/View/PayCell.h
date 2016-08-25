//
//  PayCell.h
//  yyxb
//
//  Created by 杨易 on 15/12/5.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayCell : UITableViewCell
@property (nonatomic, strong) UIImageView *chooseImageView; // 选择
@property (nonatomic, strong) UIImageView *iconImg; // 图标
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *littleTitleLabel; //标题
@property (nonatomic, assign) BOOL isChoose; //选中
@end
