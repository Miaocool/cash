//
//  MyShareOrderController.m
//  yyxb
//
//  Created by lili on 15/11/25.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MyShareOrderController.h"
#import "OrdershareViewCell.h"
#import "PersonalcenterController.h"
#import "SharedetailController.h"
#import "ListingViewController.h"
#import "OrdershareViewCell.h"
#import "SharedetailController.h"
#import "DateHelper.h"
#import "UIImageView+WebCache.h"
#import "OrdershareModel.h"
#import "MyShareOrderCell.h"
#import "MyshareModel.h"
#import "GoodsDetailsViewController.h"
#import "NewGoodsModel.h"

@interface MyShareOrderController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
{
    UIImageView*img;
    
    
    
}

@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic, strong) NoDataView *nodataView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MyShareOrderController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的晒单";
    [self initData];
    [self refreshData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaidantongzhi:) name:@"shaidantongzhi" object:nil];
}
-(void)shaidantongzhi:(NSNotification *)model{
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    [self.navigationController pushViewController:goods animated:YES];
}
#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
}
#pragma mark - 下拉刷新
- (void)refreshData
{
    self.num = 1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [MDYAFHelp AFPostHost:APPHost bindPath:MyShaidan postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
        
    }];
}

- (void)refreshSuccessful:(id)data
{
    
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
                        self.tableView.footerView.state = kPRStatePulling;
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                MyshareModel  *model = [[MyshareModel alloc]initWithDictionary:obj];
            [self.dataArray addObject:model];
                
            }];
        }
                if([data[@"code"] isEqualToString:@"400"])
        {
           
        }
    }
   
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
   
   //        修改的－－－判断有无数据
    if (_dataArray.count==0) {
        [self noData];
    }else{
        if (!self.tableView) {
            [self createTableView];
            
        }
   
    }
    
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    
        self.num = self.num +1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
        [MDYAFHelp AFPostHost:APPHost bindPath:MyShaidan postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"---%@==－－%@",responseDic,responseDic[@"msg"]);
            [self loadingSuccessful:responseDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DebugLog(@"失败:%@",error);
            [self loadingFailure:error];
        }];
}

- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"400"])
        {
            DebugLog(@"%@",data[@"msg"]);
            
                [UIView animateWithDuration:2 animations:^{
                    
                } completion:^(BOOL finished) {
                    self.tableView.footerView.state = kPRStateHitTheEnd;
                }];
        }
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                MyshareModel  *model = [[MyshareModel alloc]initWithDictionary:obj];
                DebugLog(@"----%@",data);
                if([[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count] isEqualToString:data[@"count"]])
                {
                    [UIView animateWithDuration:2 animations:^{
                        
                    } completion:^(BOOL finished) {
                        self.tableView.footerView.state = kPRStateHitTheEnd;
                    }];
                }
                [self.dataArray addObject:model];
                
            }];
        }
    }
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)loadingFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];;
    self.num = self.num -1;
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - tableview继承滚动试图的协议
//滚动视图已经滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果滚动视图是Tableview的话 就执行方法
    if ([scrollView isEqual:self.tableView])
    {
        //tab已经滚动的时候调用
        [self.tableView tableViewDidScroll:self.tableView];
        
    }
    
}

//已经结束拖拽 将要减速
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.tableView])
    {
        //停止拖拽调用
        [self.tableView tableViewDidEndDragging:self.tableView];
    }
    
}
#pragma mark - 继承刷新的tableview方法
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
        
    });
    
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadingData];
        
    });
}
#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, MSW,MSH-64  ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
}
#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyshareModel*model = [self.dataArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SharedetailController *classVC = [[SharedetailController alloc]init];
    classVC.sid=model.sd_id;
    [self.navigationController pushViewController:classVC animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableView.tableFooterView = [[UIView alloc] init];
    static NSString *cellName = @"MyShareOrderCell.h";
    MyShareOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[MyShareOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    MyshareModel*model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.status isEqualToString:@"0"]) {
        cell.lbsharestatue.text=@"审核中";
        cell.lbsharestatue.layer.borderColor = [UIColor redColor].CGColor;
        cell.lbsharestatue.textColor = [UIColor redColor];
    }else{
    
    cell.lbsharestatue.text=@"审核通过";
        cell.lbsharestatue.layer.borderColor = [UIColor colorWithRed:108.0/255.0 green:149.0/255.0 blue:24.0/255.0 alpha:1].CGColor;
        cell.lbsharestatue.textColor = [UIColor colorWithRed:108.0/255.0 green:149.0/255.0 blue:24.0/255.0 alpha:1];
    }
    cell.lbgoodstitle.text=model.title;
    cell.lbsharetitle.text=model.sd_title;
    NSString *str=model.sd_time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.lbsharedate.text=[dateFormatter stringFromDate: detaildate];
    cell.imgshare.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imgshare sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    cell.lbshareinfo.text=model.sd_content;
    cell.imgshare.backgroundColor=[UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 180;
    
}

//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"您还没有晒单哦！";
        
        _nodataView.type=4;
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.nodataView];
}

-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
