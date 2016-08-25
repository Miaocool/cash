//
//  MBTestMainModel.h
//  农业银行
//
//  Created by 杨易 on 15/5/27.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBTestMainModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, copy) NSString *status;
@end
