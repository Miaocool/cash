//
//  ProblemViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//常见问题

#import "ProblemViewController.h"
#import "PWWebViewController.h"
#import "MDHeadView.h"

@interface ProblemViewController ()<UITableViewDataSource,UITableViewDelegate,MDHeadViewDelegate,UIWebViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
//当前的分段
@property(nonatomic,assign)NSUInteger currentSection;
//当前的行数
@property(nonatomic,assign)NSUInteger currentRow;
//数组分段头视图
@property(nonatomic,strong)NSMutableArray *headViewArr;


@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,copy) NSString  *url;
@property(nonatomic ,strong) UIWebView * webView;

@end

@implementation ProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,MSW,MSH-64)];
    _webView.backgroundColor=[UIColor redColor];
    _webView.scalesPageToFit = YES;
    _webView.delegate =self;
    [self.view addSubview:_webView];
//    [self createData];
    [self getData];
    
}

-(void)getData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_url forKey:@"url"];
    [MDYAFHelp AFPostHost:APPHost bindPath:changjian postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]];
            [_webView loadRequest:request];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
       
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
