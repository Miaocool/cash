//
//  DateHelper.m
//  Cookies
//
//  Created by hehe on 5/29/15.
//  Copyright (c) 2015 you. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

//日期
+ (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatUpload = [[NSDateFormatter alloc]init];
    [dateFormatUpload setDateFormat:@"yyyy-MM-dd"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormatUpload stringFromDate:date]];
    return strTime;
}

//日期+ 时分秒
+ (NSString *)formatDateTime:(NSDate *)date
{
    NSDateFormatter *dateFormatUpload = [[NSDateFormatter alloc]init];
    [dateFormatUpload setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormatUpload stringFromDate:date]];
    return strTime;
}

//秒
+ (NSString *)formatDateSeconds:(NSDate *)date
{
    NSDateFormatter *dateFormatUpload = [[NSDateFormatter alloc]init];
    [dateFormatUpload setDateFormat:@"ss"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormatUpload stringFromDate:date]];
    return strTime;
}

//分钟
+ (NSString *)formatDateMinutes:(NSDate *)date
{
    NSDateFormatter *dateFormatUpload = [[NSDateFormatter alloc]init];
    [dateFormatUpload setDateFormat:@"mm"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormatUpload stringFromDate:date]];
    return strTime;
}

@end
