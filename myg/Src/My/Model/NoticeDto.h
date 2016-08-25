//
//  NoticeDto.h
//  yyxb
//
//  Created by mac03 on 15/12/2.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface NoticeDto : MBTestMainModel

@property (nonatomic, copy) NSString             *Aid;           //通知列表id
@property (nonatomic, copy) NSString             *ssid;           //商品id
@property (nonatomic, copy) NSString             *title;       //商品名字
@property (nonatomic, copy) NSString             *Posttime;    //时间

@end
