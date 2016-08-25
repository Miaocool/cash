//
//  CommentViewCell.h
//  yyxb
//
//  Created by lili on 15/11/17.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakepateNoteModel.h"

@interface CommentViewCell : UITableViewCell


@property (nonatomic, strong) UIImageView *imghead; //用户头像

@property (nonatomic, strong) UILabel *lbtime; //获奖时间

@property (nonatomic, strong) UILabel *lbname; //用户姓名

@property (nonatomic, strong) UILabel *lbuserip; //用户ip

@property (nonatomic, strong) UILabel *lbcount; //参与人次
@property (nonatomic, strong) TakepateNoteModel *model; //




@end
