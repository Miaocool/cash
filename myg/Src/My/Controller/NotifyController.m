//
//  NotifyController.m
//  yyxb
//
//  Created by lili on 15/11/18.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "NotifyController.h"
#import "NoticeDto.h"
#import "NotifyViewCell.h"
#import "PWWebViewController.h"

@interface NotifyController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    NSString *ssid;   //
    NSString *title;  //标题
    NSString *Posttime;  //时间
    NSString *Aid;   //通知列表id
}


@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property(nonatomic ,strong) UIWebView * webView;  //网页

@end

@implementation NotifyController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"通知";
    
    UIButton *callBtn = [[UIButton alloc]init];
    callBtn.frame = CGRectMake(0, 0, 25,25);
    [callBtn setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:callBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,MSW,MSH-64)];
    _webView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_webView];
    
    [self getNoticeList];
}


//刷新按钮
-(void)refreshAction
{
 [self getNoticeList];
}

//获取数据
-(void)getNoticeList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
  
    [MDYAFHelp AFPostHost:APPHost bindPath:tongzhi postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===通知==%@======%@",responseDic,responseDic[@"msg"]);
//        [self refreshSuccessful:responseDic];
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]];
            [_webView loadRequest:request];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self refreshFailure:error];
    }];
    
}


- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];    //
    [MDYAFHelp AFPostHost:APPHost bindPath:tongzhi postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"---%@-----%@－－－－",responseDic,responseDic[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
    }];

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
