//
//  GroupRedViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "GroupRedViewController.h"
#import "GroupRedCell.h"
#import "GroupRedDto.h"
#import "MJRefresh.h"

@interface GroupRedViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_tableView;
    UIView      *_headView;
    NSMutableArray *_imageArray;
    UILabel *_lab;
}

@end

@implementation GroupRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"中奖群红包";
    
    [self headView];
    
    //创建表
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, MSW, MSH)];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableHeaderView=_headView;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_tableView];
    [self addPullRefreshToTableView:_tableView];
}
#pragma mark   添加 下拉刷新 和 上拉 加载
-(void)addPullRefreshToTableView:(UITableView *)tableView
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    [tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    // 默认先隐藏footer
    _tableView.mj_footer.hidden = YES;
    
}

-(void)refreshData
{
    [MDYAFHelp AFPostHost:APPHost bindPath:Announced postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"~~~~~~%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
    [_imageArray removeAllObjects];
    
    [_tableView reloadData];
    
    // 结束刷新
    [_tableView.mj_header endRefreshing];
    
    
}

#pragma mark 加载数据的方法
-(void)loadMoreData
{
    // 结束刷新
    [_tableView.mj_footer endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor=[UIColor clearColor];
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
}

-(void)headView
{
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 290)];
    _headView.backgroundColor=RGBCOLOR(234,229,225);
    [self.view addSubview:_headView];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((MSW-60)/2, 20, 60, 60)];
    img.image=[UIImage imageNamed:@"5-10"];
    [_headView addSubview:img];
    
    UILabel *redLab=[[UILabel alloc]initWithFrame:CGRectMake((MSW-100)/2+10, img.bottom+10, 100, 20)];
    redLab.text=@"中奖群红包";
    redLab.textColor=[UIColor blackColor];
    redLab.font=[UIFont systemFontOfSize:BigFont];
    redLab.backgroundColor=[UIColor clearColor];
    [_headView addSubview:redLab];
    
    UILabel *receLab=[[UILabel alloc]initWithFrame:CGRectMake((MSW-200)/2, redLab.bottom+10, 200, 20)];
    receLab.text=@"我还未领取红包，分享红包可领取";
    receLab.textColor=[UIColor blackColor];
    receLab.font=[UIFont systemFontOfSize:MiddleFont];
    receLab.backgroundColor=[UIColor clearColor];
    [_headView addSubview:receLab];
    
    UIButton *receiveBtn=[[UIButton alloc]initWithFrame:CGRectMake((MSW-150)/2, receLab.bottom+10, 150, 30)];
    [receiveBtn setTitle:@"查看已领取红包" forState:UIControlStateNormal];
    [receiveBtn setBackgroundColor:[UIColor clearColor]];
    [receiveBtn setTitleColor:NavColor forState:UIControlStateNormal];
    receiveBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
    receiveBtn.layer.borderWidth = 0.5;
    receiveBtn.layer.cornerRadius=5;
    receiveBtn.layer.borderColor = NavColor.CGColor;
//    [receiveBtn addTarget:self action:@selector(seeBtn) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:receiveBtn];
    
    UILabel *sendLab=[[UILabel alloc]initWithFrame:CGRectMake(30, receiveBtn.bottom+10, 250, 20)];
    sendLab.text=@"点击图标发给好友，自己也能拿一个";
    sendLab.textColor=[UIColor colorWithHex:@"#888888"];
    sendLab.font=[UIFont systemFontOfSize:MiddleFont];
    sendLab.backgroundColor=[UIColor clearColor];
    [_headView addSubview:sendLab];
    
    for (NSInteger k = 0; k < 4; k ++) {
        UIButton *picBtn = [[UIButton alloc] initWithFrame:CGRectMake( k % 4 * 80 , sendLab.bottom, 80, 80)];
        picBtn.backgroundColor = [UIColor clearColor];
//        [picBtn addTarget:self action:@selector(picAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *picImg = [[UIImageView alloc] initWithFrame:CGRectMake((MSW/4 - 40)/2, 10, 40, 40)];
        picImg.contentMode = UIViewContentModeScaleToFill;
        picImg.backgroundColor = [UIColor clearColor];
        picImg.image=[UIImage imageNamed:@"8-3"];
        [picBtn addSubview:picImg];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((MSW/4 - 65)/2, picImg.bottom + 5, 65, 15)];
        label.text = @"好友圈";
        label.font = [UIFont systemFontOfSize:MiddleFont];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [picBtn addSubview:label];
        
        [_headView addSubview:picBtn];
    }
    
}

#pragma mark - tableViewDelegeta
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 3;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 ) {
               return 30;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellIndentifier = @"cellIndentifierIconImage";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            
        }
        if (!_lab) {
            _lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 20)];
            _lab.text=@"共有37位小伙伴领取了100元红包";
            _lab.textColor=[UIColor blackColor];
            _lab.font=[UIFont systemFontOfSize:MiddleFont];
            [cell addSubview:_lab];
        }
 
        return cell;
    }
 
     else{
        static   NSString *cellIndentifer =@"cellIndenfier1";
        GroupRedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (!cell)
        {
            cell = [[GroupRedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        if (_imageArray.count > 0) {
            GroupRedDto *dto=_imageArray[indexPath.row];
            [cell setGroupRedDto:dto];
        }
         return cell;
    }
    
       return nil;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
