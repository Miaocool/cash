//
//  NodataViewCell.h
//  yyxb
//
//  Created by lili on 15/12/7.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NodataViewCell;

//@protocol NodataViewCellDelegate <NSObject>//协议
//
//- (void)clickCell:(NodataViewCell *)cell;//代理方法
//
//@end
@interface NodataViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageView1; //图片
@property (nonatomic, strong) UILabel *titleLabel1; //标题
@property (nonatomic, strong) UILabel *textLabel1; //内容


@property (nonatomic, strong) UIButton *btgoto; //内容



@property (nonatomic, strong) UIScrollView *scrolike; //选择


@property (nonatomic, strong)UIScrollView    *mainScrollView;


@property (nonatomic, strong)NSArray    *goodsarray;
@property (nonatomic, strong)UILabel*lbline2;


@property (nonatomic, strong)UIProgressView* progressView;

@property (nonatomic, assign)int type;

@property (nonatomic, strong)NSMutableArray* likeArray;
//@property (nonatomic , weak)id<NodataViewCellDelegate>delegate;//代理

@property (nonatomic, strong)UIImageView*imgxiangou;
@property (nonatomic, strong) UIView * likeView; //猜你喜欢

@property (nonatomic, strong)UILabel*lblike;

@end
