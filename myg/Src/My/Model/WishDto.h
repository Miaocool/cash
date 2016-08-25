//
//  WishDto.h
//  myg
//
//  Created by mac03 on 16/3/30.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface WishDto : MBTestMainModel

@property (nonatomic, copy) NSString             *content;    //标题
@property (nonatomic, copy) NSString             *wishId;
@property (nonatomic, copy) NSString             *time;       //红包余额
@property (nonatomic, copy) NSString             *title;  //红包开始使用日期
@property (nonatomic, copy) NSString             *uid;    //过期时间


@end
