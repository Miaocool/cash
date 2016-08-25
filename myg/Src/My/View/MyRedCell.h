//
//  MyRedCell.h
//  yyxb
//
//  Created by mac03 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedBoxDto.h"

@interface MyRedCell : UITableViewCell

@property(nonatomic ,strong)RedBoxDto *redModel;

@property (nonatomic, strong) UIImageView   *statusImg;  //状态
@end
