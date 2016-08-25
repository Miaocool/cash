//
//  NoDataView.h
//  yyxb
//
//  Created by 杨易 on 15/11/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataView : UIView
@property (nonatomic, strong) UIImageView *imageView; //图片
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *textLabel; //内容

@property (nonatomic, strong) UIButton *btgoto; //内容
@property (nonatomic, strong) UIView * likeView; //猜你喜欢


@property (nonatomic, strong) UIScrollView *scrolike; //选择


@property (nonatomic)UIScrollView    *mainScrollView;

@property (nonatomic, strong)NSArray    *goodsarray;


@property (nonatomic, strong)UIProgressView* progressView;


@property (nonatomic, strong)UIButton*btdetai;

@property (nonatomic, assign)int type;
@property (nonatomic, strong)NSMutableArray* likeArray;


@property (nonatomic, strong)UILabel*lbline2;
@property (nonatomic, strong)UILabel*lblike;

@property (nonatomic, strong)UIImageView*imgxiangou;

@end
