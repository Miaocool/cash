//
//  TakepateNoteModel.h
//  yyxb
//
//  Created by lili on 15/11/23.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface TakepateNoteModel : MBTestMainModel
@property (nonatomic, copy) NSString *idd; //商品id

@property (nonatomic, copy) NSString *username; //用户姓名

@property (nonatomic, copy) NSString *uid; //参与者id
@property (nonatomic, copy) NSString *uphoto; //用户头像
@property (nonatomic, copy) NSString *time; //购买时间
@property (nonatomic, copy) NSString* gonumber; //参与人数
@property (nonatomic, copy) NSString *ip; //参与人的ip地址

@property (nonatomic, copy) NSString *ip1;



@end
