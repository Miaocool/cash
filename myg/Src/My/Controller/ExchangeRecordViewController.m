//
//  ExchangeRecordViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/26.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ExchangeRecordViewController.h"
#import "ExchangeRecordDto.h"
#import "ExchangeRecordCell.h"
#import "LoginViewController.h"
#import "GoodsDetailsViewController.h"
#import "NewGoodsModel.h"
@interface ExchangeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView            *_tableView;
    UIView                 *_bgView;
    NSMutableArray         *_recordList;    //记录数据列表
    NSString    *uid;            //用户id
    NSString    *jifen;          //兑换积分
    NSString    *addtime;        //兑换时间
    NSString    *status;         //兑换状态
    
    
}
@property (nonatomic, strong) NoDataView *nodataView;  //空白显示图

@end

@implementation ExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"兑换记录";
    _recordList=[NSMutableArray array];
    
    [self commonView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(duihuantongzhi:) name:@"duihuan" object:nil];
    
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, MSW, MSH-40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=RGBCOLOR(236, 235, 241);
    //     _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}

-(void)duihuantongzhi:(NSNotification *)model{
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    DebugLog(@"收到通知");
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
    [self getRecoreList];
   
}

-(void)commonView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 40)];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_bgView];
    
    UILabel *lbline=[[UILabel alloc]initWithFrame:CGRectMake(0, 38, MSW, 2)];
    lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_bgView addSubview:lbline];
    
    
    UILabel *dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MSW/4, 30)];
    dateLbl.font = [UIFont systemFontOfSize:BigFont];
    dateLbl.text = @"日期";
    dateLbl.textAlignment=NSTextAlignmentCenter;
    dateLbl.textColor = MainColor;
    [_bgView addSubview:dateLbl];
    
    UILabel *typeLbl = [[UILabel alloc]initWithFrame:CGRectMake(dateLbl.right, 5, MSW/4, 30)];
    typeLbl.font = [UIFont systemFontOfSize:BigFont];
    typeLbl.text = @"种类";
    typeLbl.textAlignment=NSTextAlignmentCenter;
    typeLbl.textColor = MainColor;
    [_bgView addSubview:typeLbl];
    
    UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(typeLbl.right, 5, MSW/4, 30)];
    moneyLbl.font = [UIFont systemFontOfSize:BigFont];
    moneyLbl.text = @"金额";
    moneyLbl.textAlignment=NSTextAlignmentCenter;
    moneyLbl.textColor = MainColor;
    [_bgView addSubview:moneyLbl];
    
    UILabel *stateLbl = [[UILabel alloc]initWithFrame:CGRectMake(moneyLbl.right, 5, MSW/4, 30)];
    stateLbl.font = [UIFont systemFontOfSize:BigFont];
    stateLbl.text = @"状态";
    stateLbl.textAlignment=NSTextAlignmentCenter;
    stateLbl.textColor = MainColor;
    [_bgView addSubview:stateLbl];
    
}
-(void)getRecoreList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];

    [MDYAFHelp AFPostHost:APPHost bindPath:ExchangeRecord postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic[@"msg"]);
        [self refreshSuccessful:responseDic];
        //        DebugLog(@"=====%@",responseDic[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

- (void)refreshSuccessful:(id)data
{
    [_recordList removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ExchangeRecordDto *model = [[ExchangeRecordDto alloc]initWithDictionary:obj];
                DebugLog(@"成功%@===%@",model.addtime,model.money );
                [_recordList addObject:model];
                
                [self createTableView];
            }];
        }
        else if([data[@"code"] isEqualToString:@"302"]){

            LoginViewController *login=[[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
           
        }else{
//             [self noData];
        }
    }
    [_tableView reloadData];
    
}



#pragma mark
#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _recordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableView.tableFooterView = [[UIView alloc] init];
    static NSString *CellIdentifier = @"CellIdentifier";
    ExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[ExchangeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.exchangeRecordModel= _recordList[indexPath.row];
    return cell;
}

#pragma mark - 空白显示
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"您还没有兑换记录哦！";
        _nodataView.textLabel.text=@"";
        _nodataView.type=6;
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


@end
