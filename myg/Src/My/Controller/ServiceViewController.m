//
//  ServiceViewController.m
//  yydg
//
//  Created by mac03 on 16/1/20.
//  Copyright (c) 2016年 杨易. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()
@property(nonatomic ,strong) UIWebView * webView;  //网页
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"服务协议";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,MSW,MSH-64)];
    _webView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_webView];

    [self getNoticeList];
}

-(void)getNoticeList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    //    [dict setValue:_url forKey:@"url"];
    //     DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:serviceAgreement postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            //            PWWebViewController *web = [[PWWebViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]]];
            //            web.showToolBar = NO;
            //            web.hidesBottomBarWhenPushed = YES;
            //            //  关于我们
            //            web.navtitle = @"服务协议";
            //            [self.navigationController pushViewController:web animated:YES];
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]];
            [_webView loadRequest:request];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",dict[@"msg"]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];

}











- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
