//
//  ClassificationGoodsCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/10.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ClassificationGoodsCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "UIImageView+WebCache.h"

@implementation ClassificationGoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

#pragma mark - 创建UI
- (void)createUI
{
    /*
     @property (nonatomic, strong) UIImageView *pictureImageView; //图
     @property (nonatomic, strong) UILabel *titleLabel; //标题
     @property (nonatomic, strong) UIProgressView *progressView; //进图
     @property (nonatomic, strong) UILabel *needLabel; //需要
     @property (nonatomic, strong) UILabel *remainingLabel; //剩余
     @property (nonatomic, strong) UIButton *addButton; //加入购物车
     */
    
    
    
    
   
    
    
    
    
    
    self.pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    self.pictureImageView.backgroundColor = [UIColor clearColor];
    self.pictureImageView.contentMode =UIViewContentModeScaleAspectFit;
    [self addSubview:self.pictureImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.pictureImageView.frame.origin.x + self.pictureImageView.frame.size.width + 20, self.pictureImageView.frame.origin.y, MSW -160 , 34)];
    self.titleLabel.text = @"Apple iphone6G 颜色随机11111111111";
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [self addSubview:self.titleLabel];
    
   self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
    self.progressView.frame=CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, self.titleLabel.frame.size.width, 20);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    self.progressView.layer.cornerRadius = 10;
    self.progressView.userInteractionEnabled = YES;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.transform = transform;
    //设置进度条颜色
    self.progressView.trackTintColor=RGBCOLOR(253, 224, 202);
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    self.progressView.progress=0.7;
    //设置进度条上进度的颜色
    self.progressView.progressTintColor=RGBCOLOR(247, 148, 40);
 
    //设置进度值并动画显示
    [self.progressView setProgress:0.7 animated:YES];
    [self addSubview:self.progressView];

    
    self.needLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y + self.progressView.frame.size.height + 10, 80, 14)];
    self.needLabel.text = @"总需15000";
    self.needLabel.textColor = [UIColor lightGrayColor];
    self.needLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [self addSubview:self.needLabel];
    
    
    self.remainingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.progressView.frame.size.width + self.progressView.frame.origin.x - 80, self.progressView.frame.origin.y + self.progressView.frame.size.height + 10, 80, 14)];
    self.remainingLabel.text = @"剩余15000";
    self.remainingLabel.textAlignment = NSTextAlignmentRight;
    self.remainingLabel.textColor = [UIColor lightGrayColor];
    self.remainingLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [self addSubview:self.remainingLabel];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(MSW - IPhone4_5_6_6P(25, 25, 45, 45) , 20, IPhone4_5_6_6P(25, 25, 45, 45), 50);
//    [self.addButton setTitle:@"加入清单" forState:UIControlStateNormal];
    [self.addButton setTitleColor:MainColor forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addShopping) forControlEvents:UIControlEventTouchUpInside];
    
//    self.addButton.layer.borderWidth = 1;
//    self.addButton.layer.borderColor = MainColor.CGColor;
//    self.addButton.layer.cornerRadius = 5;
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(12, 12, 14, 14)];
    [self addSubview:self.addButton];
    
    UIImageView * _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MSW - IPhone4_5_6_6P(20, 20, 35, 35) - 10, 25, 25, 26)];
    _imageView.image = [UIImage imageNamed:@"btn_shopping_cart_add_red"];
    [self addSubview:_imageView];
    
    
    
    
    
    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 34, 26)];
    
    _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [self addSubview:_shiyuan];
    
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
            else
            {
                
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = self.goodsModel.idd;
                model.num = [self.goodsModel.xg_number integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
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
                else
                {
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = self.goodsModel.idd;
                    model.num = [self.goodsModel.xg_number integerValue];
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
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    
   
    
    self.titleLabel.text = goodsModel.title;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    self.needLabel.text = [NSString stringWithFormat:@"总需%@",goodsModel.zongrenshu];
    
    
    self.remainingLabel.attributedText=[[NSString stringWithFormat:@"剩余<u>%ld</u>",(long)[goodsModel.zongrenshu integerValue] - [goodsModel.canyurenshu integerValue]]attributedStringWithStyleBook:style1];
    
    
    
//    self.remainingLabel.text = [NSString stringWithFormat:@"剩余%ld",(long)[goodsModel.zongrenshu integerValue] - [goodsModel.canyurenshu integerValue]];
    
    
    double a=[goodsModel.zongrenshu doubleValue];
    double b=[goodsModel.canyurenshu doubleValue];
    self.progressView.progress=b/a;

    
    
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
        }
        else
        {
            _shiyuan.hidden = YES;
        }
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
