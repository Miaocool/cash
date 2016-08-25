//
//  ListingCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/12.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListingModel.h"
/**
 * @brief 商品的类型
 * Added by Winzlee
 */
typedef NS_ENUM(NSInteger, ProductType){
    ProductTypeNormal, // 普通商品
    ProductTypeLimit1, // 限购商品1
    ProductTypeLimit2, // 限购商品2
};
@class ListingCell;
@protocol ListingCellDelegate <NSObject>//协议
- (void)addBtn:(ListingCell *)cell;//代理方法

//- (void)setbaowei:(ListingCell *)cell;//代理方法
@end

@interface ListingCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *headIamgeView; //图片
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *needLabel; //总需人数
@property (nonatomic, strong) UILabel *numLabel; //参与人次
@property (nonatomic, strong) UILabel *beishuLabel; //倍数
@property (nonatomic, strong) UIButton *addBtn; //添加
@property (nonatomic, strong) UIButton *reductionBtn; //减少
@property (nonatomic, strong) UITextField *textField; //记录寻宝次数
@property (nonatomic,weak)id<ListingCellDelegate>delegate;//代理
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) ListingModel *listingModel;



@property (nonatomic, strong) UIImageView *shiyuan;//十元
@property (nonatomic, strong) UIButton *btbaowei;//包尾

@property (nonatomic, assign) int  isbaowei;//包尾

@property (nonatomic, strong) UILabel *lbbaowei; //倍数
/** 商品类型 */
@property (nonatomic, assign) ProductType productType;

@end
