//
//  postBLL.m
//  就医助手_患者端
//
//  Created by 杨易 on 15/9/8.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "postBLL.h"

@implementation postBLL

+(void)imagePoseWhitUrl:(NSString *)urlString andData:(NSData*)data andName:(NSString*)nameStr
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //改url
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:nameStr mimeType:@"image/jpg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"tupian chuan cheng gong ");
        //成功的方法
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error--------------: %@", error);
    }];
}


@end
