//
//  PictureDetailController.m
//  yyxb
//
//  Created by lili on 15/12/1.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "PictureDetailController.h"

@interface PictureDetailController ()
@end

@implementation PictureDetailController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_style==1) {
        self.title=@"计算详情";
    }else if(_style==3)  {
        self.title=_fromtitle;

    }else{
      self.title=@"图文详情";
    
    }
    if (_style==222) {
        //        上榜规则
        self.title=@"上榜规则";
        [self createView];
        
    }else{
        
        [self initData];
    }
    
}
#pragma mark - 创建数据
- (void)initData
{
       NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_idd forKey:@"shopid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:PictureDetail postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        DebugLog(@"------%@",responseDic);
        _url=responseDic[@"data"];
        [self createView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
 
}

- (void)createView{
    UIWebView*_webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [self.view addSubview:_webview];
    DebugLog(@"-------%@===",_url);
    if (_style==1) {
        NSURL *url = [[NSURL alloc]initWithString:_fromurl];
        [_webview loadRequest:[NSURLRequest requestWithURL:url]];

    }else if(_style==3){
       
        NSURL *url = [[NSURL alloc]initWithString:_fromurl];
        [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
    
        NSURL *url = [[NSURL alloc]initWithString:_url];
        [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
