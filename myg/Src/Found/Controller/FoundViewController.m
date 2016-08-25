//
//  FoundViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "FoundViewController.h"
#import "ListingCell.h"
#import "FoundModel.h"
#import "FoundViewCell.h"
#import "OrdershareController.h"
#import "UIImageView+WebCache.h"


#import "PictureDetailController.h"
@interface FoundViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSArray*titlearray;
    NSArray*detailarray;
    
}

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) NSMutableArray *titleArray; //标题
@property (nonatomic, strong) NSMutableArray *imgArray; //图片
@property (nonatomic, strong) NoNetwork *nonetwork;

@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    titlearray=@[@"中奖还有红包收",@"日韩泡面那家强",@"［魅族 破峰］",@"送礼秘籍第一期"];
    detailarray=@[@"你若中奖，我帮你请客发红包！",@"一元就有全试光",@"一元接力，传递梦想",@"甜蜜小礼，陪她温暖入秋"];
    
    //修改的－－－发现
}

#pragma mark - 创建tableView
- (void)createTableView
{
    if (!self.tableView) {
        
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    
    [self.view addSubview:self.tableView];
}
}

#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return _dataArray.count-1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 15;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        OrdershareController *classVC = [[OrdershareController alloc]init];
        classVC.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:classVC animated:YES];
        
    }else{
         FoundModel  *model =[_dataArray objectAtIndex:indexPath.row+1];
        PictureDetailController *classVC = [[PictureDetailController alloc]init];
        classVC.style=3;
        classVC.fromtitle=model.title;
        classVC.hidesBottomBarWhenPushed = YES;

        classVC.fromurl=model.url;
        [self.navigationController pushViewController:classVC animated:YES];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *ListingCellName = @"FoundViewCell.h";
    FoundViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!cell)
    {
        cell = [[FoundViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section==0) {
        FoundModel  *model =[_dataArray objectAtIndex:0];
        
        cell.iamgefound.layer.masksToBounds = YES;
        cell.iamgefound.layer.cornerRadius =25;
        cell.lbtitle.text=model.title;
        
        
        cell.lbdetail.text=model.erji_title;
        [cell.iamgefound sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
        
    }
    else{
        FoundModel  *model =[_dataArray objectAtIndex:indexPath.row+1];
        cell.lbtitle.text=model.title;
        //        cell.lbdetail.text=[detailarray objectAtIndex:indexPath.row];
        [cell.iamgefound sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
        
         cell.lbdetail.text=model.erji_title;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    _titleArray=[NSMutableArray array];
    _imgArray=[NSMutableArray array];
    
    [self refreshData];
}
#pragma mark - 下拉刷新
- (void)refreshData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [_imgArray removeAllObjects];
    [_titleArray removeAllObjects];
    [self.dataArray  removeAllObjects];
    //    self.num = 1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:find postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
        NSArray*arr=responseDic[@"data"];
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            
            NSArray *array = responseDic[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                FoundModel  *model = [[FoundModel alloc]initWithDictionary:obj];
                
                DebugLog(@"---%@",model.title);
                
                if ([model.title isEqualToString:@"晒单分享"]) {
                    [self.dataArray insertObject:model atIndex:0];
                    
                }else{
                    [self.dataArray addObject:model];
                }
                
            }];
        }

        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
        
    }];
}

- (void)refreshSuccessful:(id)data
{
    [self.nonetwork removeFromSuperview];
    if ([data isKindOfClass:[NSDictionary class]])
    {
    }
    [SVProgressHUD dismiss];
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    [self createTableView];
}

- (void)refreshFailure:(NSError *)error
{
    [self nonetworking];
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    [UIView animateWithDuration:2 animations:^{
        
    } completion:^(BOOL finished) {
        self.tableView.footerView.state = kPRStateHitTheEnd;
    }];
    [self.tableView tableViewDidFinishedLoading];

}

- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        
    }
    [self.nonetwork removeFromSuperview];
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)loadingFailure:(NSError *)error
{
    [self nonetworking];
    [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
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
- (void)nonetworking
{
    if (!self.nonetwork)
    {
        self.nonetwork = [[NoNetwork alloc]init];
        
        [self.nonetwork.btrefresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.nonetwork];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.left.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
