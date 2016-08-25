//
//  GoodsCollectionViewCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "GoodsCollectionViewCell.h"

#import "UIImageView+WebCache.h"


@implementation GoodsCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBCOLOR(241, 241, 241).CGColor;
    self.goodsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.goodsImageView.frame = CGRectMake(20, 10, MSW/2-40, MSW/2-40);
  //    改变图片尺寸   等比例缩放
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    //  UIViewContentModeScaleAspectFill   横向填充
    
    
    [self addSubview:self.goodsImageView];
   
    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 26)];

     _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [_goodsImageView addSubview:_shiyuan];
    
    
    
    
    
    
    
    
    self.goodsTieleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsImageView.frame.size.height + 25, self.frame.size.width - 20, 30)];
    self.goodsTieleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.goodsTieleLabel.numberOfLines = 0;
//    _goodsTieleLabel.backgroundColor=[UIColor greenColor];
    self.goodsTieleLabel.text = @"小米（MI）小钢炮蓝牙音箱 经典款！";
    self.goodsTieleLabel.textColor=RGBCOLOR(8, 8, 10);
    [self addSubview:self.goodsTieleLabel];
    
    self.lotteryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsTieleLabel.frame.origin.y + self.goodsTieleLabel.frame.size.height + 5, 8*12, 12)];
    self.lotteryLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.lotteryLabel.text = @"开奖进度：";
    self.lotteryLabel.textColor=RGBCOLOR(153, 154, 155);
//    [self addSubview:self.lotteryLabel];
//
    self.lbzong = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsTieleLabel.frame.origin.y + self.goodsTieleLabel.frame.size.height +5 , 8*12-5, 12)];
    self.lbzong.font = [UIFont systemFontOfSize:MiddleFont];
    self.lbzong.text = @"总需：";
    self.lbzong.textColor=RGBCOLOR(153, 154, 155);
    [self addSubview:self.lbzong];
    
    
    
    self.lbsheng = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsTieleLabel.frame.origin.y + self.goodsTieleLabel.frame.size.height + 30, MSW/2-40-5, 12)];
    self.lbsheng.font = [UIFont systemFontOfSize:MiddleFont];
    self.lbsheng.text = @"开奖进度：";
    self.lbsheng.textColor=RGBCOLOR(153, 154, 155);
    [self addSubview:self.lbsheng];
    
    
    
    
    
    
    
    self.progressView =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
    self.progressView.frame=CGRectMake(10, self.lotteryLabel.frame.size.height + self.lotteryLabel.frame.origin.y + 5, self.frame.size.width - 50-5, 20);
    //设置进度条颜色
    
    self.progressView.trackTintColor= RGBCOLOR(154, 155, 156);
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    self.progressView.progress = 0.7;
    //设置进度条上进度的颜色
//    self.progressView.progressTintColor=MainColor;
    self.progressView.layer.cornerRadius = 5;
    self.progressView.userInteractionEnabled = YES;
    self.progressView.layer.masksToBounds = YES;
    _progressView.transform = CGAffineTransformMakeScale(1.0f,2.0f);

    //设置进度条颜色
    self.progressView.trackTintColor=RGBCOLOR(253, 224, 202);
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
//    self.progressView.progress=0.7;
    //设置进度条上进度的颜色
    self.progressView.progressTintColor=RGBCOLOR(247, 148, 40);
    
    //设置进度值并动画显示
    [self.progressView setProgress:0.7 animated:YES];
    //设置进度值并动画显示
    [self.progressView setProgress:0.7 animated:YES];
    [self addSubview:self.progressView];

    self.goodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsButton.frame = CGRectMake(self.frame.size.width - 40, self.lotteryLabel.frame.origin.y,35 , 35);
    self.goodsButton.titleLabel.font = [UIFont systemFontOfSize:BigFont];
//    self.goodsButton.layer.cornerRadius = 6;
//    self.goodsButton.layer.borderWidth = 0.5;
//    self.goodsButton.layer.borderColor = MainColor.CGColor;
    [self.goodsButton setBackgroundImage:[UIImage imageNamed:@"icon_addcart"] forState:UIControlStateNormal];
    [self.goodsButton setTitleColor:MainColor forState:UIControlStateNormal];
    [self.goodsButton addTarget:self action:@selector(addShopping) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.goodsButton];
}

#pragma mark - 加入购物车
- (void)addShopping
{
    [self.delegate clickCell:self];
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        
        if ([self.goodsModel.zongrenshu integerValue] == [self.goodsModel.canyurenshu integerValue] )
        {
            [SVProgressHUD showErrorWithStatus:@"该商品已没有剩余数量！"];
            return;
        }
        else
        {
            
            if ([self.goodsModel.xiangou isEqualToString:@"0"])
            {
                //普通
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = self.goodsModel.idd;
                model.num = [self.goodsModel.minNumber integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
            else if ([self.goodsModel.xiangou isEqualToString:@"1"])
            {
                //垄断  限购次数
                
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = self.goodsModel.idd;
                model.num = [self.goodsModel.zongrenshu integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
                
            }
            else if ([self.goodsModel.xiangou isEqualToString:@"2"])
            {
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = self.goodsModel.idd;
                //                model.num = [self.goodsModel.minNumber integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
                if ([self.goodsModel.xg_number isEqualToString:@"0"])
                {
                    model.num = 0;
                }
                else
                {
                    model.num = [self.goodsModel.xg_number integerValue];
                    
                }
            }

        }
    }
    else
    {
        __block  BOOL isHaveId = NO;
        __block BOOL isAdd = NO;
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            if (obj.num == ([self.goodsModel.zongrenshu integerValue] - [self.goodsModel.canyurenshu integerValue]))
            {

                [SVProgressHUD showErrorWithStatus:@"参与人数不能大于剩余人数"];
                isAdd = YES;
                *stop = YES;
            }
            else
            {
                if ([obj.goodsId isEqualToString:self.goodsModel.idd])
                {
                    if ([self.goodsModel.xiangou isEqualToString:@"1"])
                    {
                        [SVProgressHUD showErrorWithStatus:@"参与人数不能大于剩余人数"];
                        
                        isAdd = YES;
                        *stop = YES;
                        
                    }
                    else
                    {
                        obj.num = obj.num + [self.goodsModel.minNumber integerValue];
                        isAdd = NO;
                        isHaveId = YES;
                        *stop = YES;
                    }
                }
                
            }
        }];
        
        if (isHaveId == NO)
        {
            if (isAdd == YES)
            {
                
            }
            else
            {
                
                if ([self.goodsModel.xiangou isEqualToString:@"0"])
                {
                    //普通
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = self.goodsModel.idd;
                    model.num = [self.goodsModel.minNumber integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
                else if ([self.goodsModel.xiangou isEqualToString:@"1"])
                {
                    //垄断  限购次数
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = self.goodsModel.idd;
                    model.num = [self.goodsModel.zongrenshu integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                    
                }
                else if ([self.goodsModel.xiangou isEqualToString:@"2"])
                {
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = self.goodsModel.idd;
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                    if ([self.goodsModel.xg_number isEqualToString:@"0"])
                    {
                        model.num = 0;
                    }
                    else
                    {
                        model.num = [self.goodsModel.minNumber integerValue];
                        
                    }
                    
                }
                else
                {
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = self.goodsModel.idd;
                    model.num = [self.goodsModel.minNumber integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                    
                }

                
            }
        }
    }
    

    
    //通知 改变徽标个数
    NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    NSDictionary* style1 = @{@"body" :
                                 @[
                                     [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};

    
    _lbzong.text=[NSString stringWithFormat:@"总需：%@",_goodsModel.zongrenshu];
    
    int zongshu=[_goodsModel.zongrenshu intValue];
    int canyu=[_goodsModel.canyurenshu intValue];
    
    
    _lbsheng.attributedText=[[NSString stringWithFormat:@"剩余：<u>%i</u>",zongshu-canyu]attributedStringWithStyleBook:style1];
    
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    _goodsTieleLabel.text = goodsModel.title;
    NSInteger baifenbi = [goodsModel.canyurenshu floatValue] * 100 / [goodsModel.zongrenshu floatValue];
    _lotteryLabel.text = [NSString stringWithFormat:@"开奖进度：%ld%%",(long)baifenbi];
    
    float a = [goodsModel.canyurenshu floatValue]  / [goodsModel.zongrenshu floatValue];
    _progressView.progress = a;
    
    
    if ([_goodsModel.xiangou isEqualToString:@"1"]||[_goodsModel.xiangou isEqualToString:@"2"])
    {
        _shiyuan.hidden = NO;
        _shiyuan.image = [UIImage imageNamed:@"xiangou"];
    }
    else
    {
        if ([_goodsModel.yunjiage isEqualToString:@"10"]) {
            _shiyuan.hidden = NO;
            _shiyuan.image = [UIImage imageNamed:@"3-1"];
        }else{
            _shiyuan.hidden = YES;
        }
    }
    
}


@end
