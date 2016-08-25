//
//  WinningRecordViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "WinningRecordViewController.h"
#import "RecordCell.h"
#import "RecordDto.h"
#import "ConfirmedWinController.h"
#import "GoodsDetailsViewController.h"
#import "NewGoodsModel.h"
@interface WinningRecordViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    
    PullingRefreshTableView      *_tableView;
    NSMutableArray   *_dataArray;
     NSString             *_shopid;           //商品id
    
     NSString             *_shopname;       //商品名字
    
     NSString             *_Uphoto;            //用户头像
     NSString             *_Huode;             //中奖吗
    
     NSString             *_Shopqishu;   //期数
     NSString             *_Gonumber;   //参加次数
     NSString             *_Time;       //参加时间
     NSString             *_Zongrenshu; //总人数
     NSString             *isget;      //状态
    
     NSString             *company;    //快递物流
     NSString             *company_code;//快递单号
     NSString             *dizhi_time;   //确定地址时间
     NSString             *piafa_time;   //派发时间
     NSString             *wancheng_time;   //完成订单时间
     NSString             *shouhuoren;   //收货人
     NSString             *mobile;    //收货人手机号
     NSString             *dizhi;    //收货地址
     NSString             *idD;  //记录id
}

@property (nonatomic, strong) NoDataView *nodataView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger num;
@end

@implementation WinningRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"中奖记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray=[NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhongjiangtongzhi:) name:@"zhongjiangjilu" object:nil];
    
}
-(void)zhongjiangtongzhi:(NSNotification *)model{
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    [self.navigationController pushViewController:goods animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self refreshData];
}

- (void)createTableView
{
    //创建表
    _tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0,0, MSW, MSH-64)];
    _tableView.backgroundColor=RGBCOLOR(236, 235, 241);
    _tableView.dataSource= self;
    _tableView.delegate= self;
    _tableView.pullingDelegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];

}

#pragma mark - 下拉刷新
- (void)refreshData
{
    
    self.num = 1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];

    [MDYAFHelp AFPostHost:APPHost bindPath:RecordList postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"---%@-----%@－－－－",responseDic,responseDic[@"msg"]);
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        DebugLog(@"失败:%@",error);
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
            _tableView.footerView.state = kPRStatePulling;
            NSDictionary *dict = data[@"data"];
            NSArray *array = dict[@"list"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                RecordDto *model = [[RecordDto alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
        }
        
        if([data[@"code"] isEqualToString:@"400"])
        {
            
        }
}
    [_tableView reloadData];
    [_tableView tableViewDidFinishedLoading];
    //        修改的－－－判断有无数据
    if (_dataArray.count==0) {
        [self noData];
    }else{
        if (!_tableView) {
            [self createTableView];
        }
        
    }
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    DebugLog(@"失败");
    [_tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    self.num = self.num +1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    [MDYAFHelp AFPostHost:APPHost bindPath:RecordList postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [self loadingSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self loadingFailure:error];
    }];
    
    
}

- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"400"])
        {
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                _tableView.footerView.state = kPRStateHitTheEnd;
            }];
            
        }
        if([data[@"code"] isEqualToString:@"200"])
        {
            _tableView.footerView.state = kPRStatePulling;
            NSDictionary *dict = data[@"data"];
            NSArray *array = dict[@"list"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                RecordDto *model = [[RecordDto alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            if([[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count] isEqualToString:data[@"count"]])
            {
                [UIView animateWithDuration:2 animations:^{
                    
                } completion:^(BOOL finished) {
                    _tableView.footerView.state = kPRStateHitTheEnd;
                }];
            }
        }
        
     
    }
    
    [_tableView reloadData];
    [_tableView tableViewDidFinishedLoading];
}

- (void)loadingFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    self.num = self.num -1;
    [_tableView tableViewDidFinishedLoading];
}




#pragma mark - tableview继承滚动试图的协议
//滚动视图已经滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果滚动视图是Tableview的话 就执行方法
    if ([scrollView isEqual:_tableView])
    {
        //tab已经滚动的时候调用
        [_tableView tableViewDidScroll:_tableView];
        
    }
    
}

//已经结束拖拽 将要减速
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:_tableView])
    {
        //停止拖拽调用
        [_tableView tableViewDidEndDragging:_tableView];
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
#pragma mark - tableViewDelegeta
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        _tableView.tableFooterView = [[UIView alloc] init];
        static   NSString *cellIndentifer =@"cellIndenfier";
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (!cell)
        {
            cell = [[RecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
         cell.recordModel = _dataArray[indexPath.row];
    return cell;
    
}
//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"您还没有中奖哦！";
        _nodataView.type=3;
       [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.nodataView];
}


-(void)gotoxunbao{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ConfirmedWinController *con=[[ConfirmedWinController alloc]init];
    con.model=(RecordDto *)_dataArray[indexPath.row];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
