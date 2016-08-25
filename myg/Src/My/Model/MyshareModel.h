//
//  MyshareModel.h
//  yyxb
//
//  Created by lili on 15/11/30.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MBTestMainModel.h"

@interface MyshareModel : MBTestMainModel



@property (nonatomic, copy) NSString *sd_id; //晒单id
@property (nonatomic, copy) NSString *sd_title; //标题
@property (nonatomic, copy) NSString *sd_content; //内容
@property (nonatomic, copy) NSString *sd_time;//晒单时间
@property (nonatomic, copy) NSString *sd_thumbs; //晒单图片

@property (nonatomic, copy) NSString *thumbs; //晒单图片

@property (nonatomic, copy) NSString *thumb; //晒单图片

@property (nonatomic, copy) NSString *sd_qishu;//期数
@property (nonatomic, copy) NSString *sd_shopid; // 晒单人id

@property (nonatomic, copy) NSString *title;//晒单详情标题
@property (nonatomic, copy) NSString *sd_ip;//用户ip

@end


@interface shareDto : MBTestMainModel

@property (nonatomic, copy) NSString     *title;  //推广标题
@property (nonatomic, copy) NSString     *Content; //推广内容
@property (nonatomic, copy) NSString     *url;   //下载的url
@property (nonatomic, copy) NSString     *shouyi;    //推广收益

@end
