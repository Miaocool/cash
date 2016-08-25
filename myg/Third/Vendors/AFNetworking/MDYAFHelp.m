//
//  MDYAFHelp.m
//  MDYNews
//
//  Created by Medalands on 15/2/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//


#define NetTimeOutInterval 15.f


#import "MDYAFHelp.h"



@implementation MDYAFHelp

/**
 * 给每次的请求加上 默认必须添加的参数 比如版本号（版本升级时 不同的版本分别处理） 渠道号 (Appstore 和越狱的一些渠道如：91手机助手、同步推)
 
  手机型号（区分安卓和iPhone 在需要的时候做不同的处理）
 */
+(void)setDefaultParamToDic:(NSMutableDictionary *)dic
{
    if (dic)
    {
        // 版本号 参数
        NSString * versionParam = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        // 渠道号 参数
        NSString * unionIdParam = @"000"; // 和后台约定的任意字符 120 或 182 或 123
        
        // 手机型号 参数
        NSString * osParam = @"iphone"; // iphone android
        
        
        // 添加参数
        [dic setObject:versionParam forKey:@"versionParam"];
        
        [dic setObject:unionIdParam forKey:@"unionIdParam"];
        
        [dic setObject:osParam forKey:@"osParam"];

    }
    
    
}


+(MDYAFHelp *)AFGetHost:(NSString *)hostString bindPath:(NSString *)bindPath param:(NSMutableDictionary *)dic success:(void (^)(AFHTTPRequestOperation *, NSDictionary *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    
//    [MBSingleton shareInstance].dateNum = hour * 60 * 60 + minute *60  + second;
//    DebugLog(@"%lu秒！！！！！！~",[MBSingleton shareInstance].dateNum);
    
    ///////////////////////////////////
    
    ///////////////////////////////////
    
    [MDYAFHelp setDefaultParamToDic:dic];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",hostString,bindPath];
    
    
    MDYAFHelp *afH = [[MDYAFHelp alloc] init];
    afH.callBackSuccess = success;
    afH.callBackFailure = failure;
    
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] init];
    
    operation.requestSerializer.timeoutInterval = NetTimeOutInterval;
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", nil];
    //申明请求的数据是json类型
    operation.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    afH.operation = [operation GET:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error = nil;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            
            afH.callBackFailure(operation,error);
            
            
            afH.callBackSuccess = nil;
            afH.callBackFailure = nil;
            
        }else{
            
            afH.callBackSuccess(operation,resultDic);
            
            afH.callBackSuccess = nil;
            afH.callBackFailure = nil;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        afH.callBackFailure(operation,error);
        
        afH.callBackSuccess = nil;
        afH.callBackFailure = nil;
        
        
    }];
    
    
    NSLog(@"AFGet--URl--:%@",afH.operation.request.URL);
    
    
    return afH;
}



+(MDYAFHelp *)AFPostHost:(NSString *)hostString bindPath:(NSString *)bindPath postParam:(NSMutableDictionary *)postParam getParam:(NSMutableDictionary *)getParam success:(void (^)(AFHTTPRequestOperation *, NSDictionary *))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    
    //    [MBSingleton shareInstance].dateNum = hour * 60 * 60 + minute *60  + second;
    //    DebugLog(@"%lu秒！！！！！！~",[MBSingleton shareInstance].dateNum);
    
    NSString* url = [NSString stringWithFormat:@"%@%@",hostString,bindPath];
    
    //   [MDYAFHelp setDefaultParamToDic:getParam]; // 必填参数 添加到 get参数中
    //   [MDYAFHelp setDefaultParamToDic:postParam]; // 必填参数 添加到 post参数中 //  可以只填写一个
    
    // get参数 拼接 到url 上
    //    url = [MDYAFHelp setParamDIc:getParam toUrlString:url];
    
    MDYAFHelp *AFH = [[MDYAFHelp alloc] init];
    AFH.callBackSuccess = success;
    AFH.callBackFailure = failure;
    
    AFHTTPRequestOperationManager *operation = [[AFHTTPRequestOperationManager alloc] init];
    operation.requestSerializer.timeoutInterval = 15.0f;
    /////////////////////////////////////////////////////////////////
    //发送请求
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    operation.securityPolicy = securityPolicy;
    
    
//    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/vnd.wap.wml",@"text/html", nil];
    //申明请求的数据是json类型
    operation.requestSerializer=[AFHTTPRequestSerializer serializer];
    //////////////////////////////////////////////////////////////////
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFH.operation = [operation POST:url parameters:postParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSError *error = nil;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        if (error) {
            
            AFH.callBackFailure(operation,error);
            
            AFH.callBackSuccess = nil;
            AFH.callBackFailure = nil;
        }else{
            
            AFH.callBackSuccess(operation,resultDic);
            
            AFH.callBackSuccess = nil;
            AFH.callBackFailure = nil;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        AFH.callBackFailure(operation,error);
        
        AFH.callBackSuccess = nil;
        AFH.callBackFailure = nil;
    }];
    
    NSLog(@"AFPost:%@",AFH.operation.request.URL);
    NSLog(@"AFPostDic:%@",postParam);
    
    return AFH;
    
    
}




+(NSString *)setParamDIc:(NSMutableDictionary *)paramDic toUrlString:(NSString *)url
{
    //选填get参数
    if (paramDic) {
        
        NSRange range = [url rangeOfString:@"?"];
        
        if (range.location != NSNotFound) // 有 ？ 问好 表示 就有 参数 可以直接 用 & 添加
        {
            NSArray *arrK = [paramDic allKeys];
            for (int i = 0; i<[arrK count]; i++) {
                url = [NSString stringWithFormat:@"%@&%@=%@",url,[arrK objectAtIndex:i],[paramDic objectForKey:[arrK objectAtIndex:i]]];
            }
            
        }else // 没有问号 表示没有参数 第一个参数 要用？value= 添加 从第二个 开始 用 & 添加
        {
            NSArray *arrK = [paramDic allKeys];
            for (int i = 0; i<[arrK count]; i++) {
                
                if (i == 0)
                {
                    url = [NSString stringWithFormat:@"%@?%@=%@",url,[arrK objectAtIndex:i],[paramDic objectForKey:[arrK objectAtIndex:i]]];
                }else
                {
                    url = [NSString stringWithFormat:@"%@&%@=%@",url,[arrK objectAtIndex:i],[paramDic objectForKey:[arrK objectAtIndex:i]]];
                }
            }
        }
    }
    return url;
}

@end
