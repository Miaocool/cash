//
//  MyEarningViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/26.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MyEarningViewController.h"
#import "ExchangeRecordDto.h"
#import "ExchangeRecordCell.h"
#import "MyEarnModel.h"
#import "DateHelper.h"
#import "MyEarningViewCell.h"
@interface MyEarningViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView            *_tableView;
    UIView                 *_bgView;
    NSMutableArray         *_recordList;    //记录数据列表
    NSString    *uid;            //用户id
    NSString    *jifen;          //兑换积分
    NSString    *addtime;        //兑换时间
    NSString    *status;         //兑换状态
    
    
}
@property (nonatomic, strong) NoDataView *nodataView;
@end

@implementation MyEarningViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的收益";
    _recordList=[NSMutableArray array];
    
     [self getRecoreList];
    
    
    [self commonView];
}



#pragma mark - 创建tableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, MSW, MSH-100)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=RGBCOLOR(236, 235, 241);
    //     _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
}

-(void)commonView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 40)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    UILabel*lbline=[[UILabel alloc]initWithFrame:CGRectMake(5, 39, MSW-10, 2)];
    lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_bgView addSubview:lbline];
    
        
    UILabel *dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MSW/3, 30)];
    dateLbl.font = [UIFont systemFontOfSize:BigFont];
    dateLbl.text = @"ID";
    dateLbl.textAlignment=NSTextAlignmentCenter;
    dateLbl.textColor = MainColor;
    [_bgView addSubview:dateLbl];
    
    UILabel *typeLbl = [[UILabel alloc]initWithFrame:CGRectMake(dateLbl.right, 5, MSW/3, 30)];
    typeLbl.font = [UIFont systemFontOfSize:BigFont];
    typeLbl.text = @"时间";
    typeLbl.textAlignment=NSTextAlignmentCenter;
    typeLbl.textColor = MainColor;
    [_bgView addSubview:typeLbl];
    
    UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(typeLbl.right, 5, MSW/3, 30)];
    moneyLbl.font = [UIFont systemFontOfSize:BigFont];
    moneyLbl.text = @"积分";
    moneyLbl.textAlignment=NSTextAlignmentCenter;
    moneyLbl.textColor = MainColor;
    [_bgView addSubview:moneyLbl];

    
}
-(void)getRecoreList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];

    
    //    DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:ShareList postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
       
        DebugLog(@"======%@======%@",responseDic,responseDic[@"msg"]);
        
        [self refreshSuccessful:responseDic];
        
        
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        DebugLog(@"%@",error);
//        NSString *str = [[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding];
//        DebugLog(@"str:===========%@",str);
        [self refreshFailure:error];
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
                MyEarnModel *model = [[MyEarnModel alloc]initWithDictionary:obj];
          
                
                DebugLog(@"成功%@",model.time );
                [_recordList addObject:model];
                
                 [self createTableView];
                
                
            }];
        }
        else if([data[@"code"] isEqualToString:@"400"])
        {
            NSLog(@"没有数据");
//           [self noData];
        }

     }
    [_tableView reloadData];
    
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    
}

#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return _recordList.count;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     return _recordList.count;
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableView.tableFooterView = [[UIView alloc] init];
    static NSString *CellIdentifier = @"MyEarningViewCell";
    MyEarningViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[MyEarningViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //    cell.exchangeRecordModel= _recordList[indexPath.row];
    MyEarnModel *model =[_recordList objectAtIndex:indexPath.row];
    cell.lbqiandao.text=model.uid;
    
//    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[model.time floatValue]];
//    NSString *str1 = [DateHelper formatDate:date1];
//    
    
    NSString *str=model.time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    
    cell.lbtime.text=[dateFormatter stringFromDate: detaildate];
    cell.lbjifen.text=model.score;
    
    return cell;
}






//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"您还没有任何收益哦！";
        _nodataView.textLabel.text=@"";
   [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    
        
        
        _nodataView.scrolike.hidden=YES;
        
        _nodataView.lblike.hidden=YES;
        
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
