//
//  MyWishViewController.m
//  myg
//
//  Created by mac03 on 16/3/30.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "MyWishViewController.h"
#import "AddWishViewController.h"
#import "WishDto.h"

@interface MyWishViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
{
    
    PullingRefreshTableView      *_tableView;
    
}
@property (nonatomic, strong) NoDataView *nodataView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger num;

@end

@implementation MyWishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"心愿清单";
    [self setNav];
    self.dataArray=[NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    //  [self getRecordList];
    [self refreshData];
}
-(void)setNav
{
    //右导航
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    message.frame = CGRectMake(MSW-50, 20, 50, 29);
    [message setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [message setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [message setTitle:@"添加" forState:UIControlStateNormal];
    message.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    message.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [message addTarget:self action:@selector(addMess) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
-(void)addMess
{
    AddWishViewController *add=[[AddWishViewController alloc]init];
    add.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:add animated:YES];
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
    
    [MDYAFHelp AFPostHost:APPHost bindPath:myWishList postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"---%@-----",responseDic);
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
           NSArray *array = data[@"data"];
//             = dict[@"list"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                _model = [[WishDto alloc]initWithDictionary:obj];
                [self.dataArray addObject:_model];
            }];
        }
        
        if([data[@"code"] isEqualToString:@"400"])
        {
            [self noData];
        }
    }
    
    [_tableView reloadData];
    [_tableView tableViewDidFinishedLoading];
    
    // 修改的－－－判断有无数据
    if (_dataArray.count==0)
    {
        [self noData];
    }
    else{
        [self createTableView];
        
    }
    
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
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
        //        DebugLog(@"%@",responseDic);
        [self loadingSuccessful:responseDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"失败:%@",error);
        [self loadingFailure:error];
    }];
    
    
}

- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"400"])
        {
            //            DebugLog(@"%@",data[@"msg"]);
            
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                _tableView.footerView.state = kPRStateHitTheEnd;
            }];
            
        }
        if([data[@"code"] isEqualToString:@"200"])
        {
            _tableView.footerView.state = kPRStatePulling;
           NSArray *array = data[@"data"];
//             = dict[@"list"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                _model = [[WishDto alloc]initWithDictionary:obj];
                [self.dataArray addObject:_model];
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

#pragma mark - 创建表
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 60;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView*_headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width-40, 60)];
    lbtitle.text=@"心愿单是您希望夺宝上架的商品清单,您的小小建议使我们前进的动力。";
    lbtitle.numberOfLines=0;
    lbtitle.font=[UIFont systemFontOfSize:BigFont];
    [_headview addSubview:lbtitle];
    
    return _headview;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableView.tableFooterView = [[UIView alloc] init];
    static   NSString *cellIndentifer =@"cellIndenfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    _model = self.dataArray [indexPath.row];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 10, MSW-50, 20)];
    titleLabel.font = [UIFont systemFontOfSize:BigFont];
    titleLabel.text = _model.title;
    [cell.contentView addSubview:titleLabel];
    
    UIImageView * heartImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
    heartImg.image = [UIImage imageNamed:@"icon_heart"];
    [cell.contentView addSubview:heartImg];
//        cell.textLabel.text=_model.title;
//    cell.recordModel = _dataArray[indexPath.row];
    
    
    return cell;
    
}




//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"您还没有心愿单哦！";
//        _nodataView.type=1;
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self.view addSubview:self.nodataView];
}
-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//-(void)gotoxunbao
//{
//    
//    self.tabBarController.selectedIndex = 0;
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}






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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
