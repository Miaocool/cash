//
//  DateHelper.h
//  Cookies
//
//  Created by hehe on 5/29/15.
//  Copyright (c) 2015 you. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @brief 对时间的处理
 */

@interface DateHelper : NSObject

+ (NSString *)formatDate:(NSDate *)date;


+ (NSString *)formatDateTime:(NSDate *)date;


+ (NSString *)formatDateSeconds:(NSDate *)date;


+ (NSString *)formatDateMinutes:(NSDate *)date;

@end
