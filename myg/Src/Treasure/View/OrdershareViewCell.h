//
//  OrdershareViewCell.h
//  yyxb
//
//  Created by lili on 15/11/13.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrdershareModel;
@class OrdershareViewCell;

@protocol OrdershareViewCellDelegate <NSObject>//协议

- (void)clickCell:(OrdershareViewCell *)cell;//代理方法

@end





@interface OrdershareViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userhead; //用户头像
@property (nonatomic, strong) UIButton *username; //用户姓名
@property (nonatomic, strong) UILabel *sharedate; //分享时间
@property (nonatomic, strong) UIImageView *background; //背景

@property (nonatomic, strong) UILabel *sharetitle; //分享标题
@property (nonatomic, strong) UILabel *shareinfo; //分享内容
@property (nonatomic, strong) UILabel *sharegoods; //分享商品
@property (nonatomic, strong) UIImageView *goodsimg1; //商品图片1
@property (nonatomic, strong) UIImageView *goodsimg2; //商品图片2
@property (nonatomic, strong) UIImageView *goodsimg3; //商品图片3



@property (nonatomic, strong) UIImageView *imgzan; //z赞

@property (nonatomic, strong) UIImageView *imgcomment; //评论
@property (nonatomic, strong) UILabel *lbzan; //赞
@property (nonatomic, strong) UILabel *lbcomment; //评论


@property (nonatomic, strong) OrdershareModel *OrderModel;

@property (nonatomic, strong) UIButton *btlook; //查看大图



@property (nonatomic, strong) UIButton *btzan; //点赞

@property (nonatomic, strong) UIButton *btcomment; //评论
@property (nonatomic, strong) UIButton *tryBtn; //试试手气

@property (nonatomic , weak)id<OrdershareViewCellDelegate>delegate;//代理


@end
