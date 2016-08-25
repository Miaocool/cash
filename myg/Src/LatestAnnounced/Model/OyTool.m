//
//  OyTool.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "OyTool.h"
#import "AppDelegate.h"
//#import "OYDownLibVC.h"
#define UMOnlineConfigDidFinishedNotification @"OnlineConfigDidFinishedNotification"
static OyTool* oyTool = nil;

@interface OyTool()
{
    BOOL    bIsForReview;
}
@end

@implementation OyTool
@synthesize bIsForReview;

+ (instancetype)ShardInstance
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        oyTool = [[OyTool alloc] init];
    });
    return oyTool;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        bIsForReview = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUmengParam) name:UMOnlineConfigDidFinishedNotification object:nil];
    }
    return self;
}

- (void)showNotice:(NSString*)text
{
    [[[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
}

@end
