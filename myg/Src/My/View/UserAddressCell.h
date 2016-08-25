//
//  UserAddressCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressDto.h"
@class MyLable;
@class UserAddressCell;
@protocol UserAddressCellDelegate <NSObject>

- (void)changController:(UserAddressCell *)userAddressCell;

@end
@interface UserAddressCell : UITableViewCell

@property (nonatomic, strong)       UIImageView * iconImg; //小图片
@property (nonatomic, strong)       UILabel *lbTitle;    //标题
@property (nonatomic, strong)       UILabel *lbDefault;  //默认
@property (nonatomic, strong)       UIButton *editButton;  // 编辑

@property (nonatomic, strong)       UILabel *nameLabel;    //姓名
@property (nonatomic, strong)       UILabel *phoneLabel;   //电话
@property (nonatomic, strong)       MyLable *proviceLabel; //住址
@property (nonatomic, strong)       UILabel *cityLabel;
@property (nonatomic, strong)       UILabel *townLabel;
@property (nonatomic, strong)       UILabel *streetLabel;

@property (nonatomic, strong)       MyLable *remarkLabel; // 备注


@property (nonatomic, strong)       UIButton *stateButton;   // 状态
@property (nonatomic, strong)       UIButton * edit;
@property (nonatomic, strong)       UIButton * nameBtn;


@property (nonatomic, strong) AddressDto *addressModel;

@property (nonatomic, weak) id<UserAddressCellDelegate> delegate;



@end
