//
//  LogisticInfoVC.m
//  myg
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import "LogisticInfoVC.h"


@interface LogisticInfoVC ()
@property (nonatomic,strong)UIWebView *logInfoWebView;
@end


@implementation LogisticInfoVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.logInfoWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.logInfoWebView];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.kuaidi100.com/index_all.html?type=全峰&postid=12345"]];
    
    [self.logInfoWebView loadRequest:request];
    
    
    
}

@end
