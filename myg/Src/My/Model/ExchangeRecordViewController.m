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

@interface ExchangeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView            *_tableView;
    UIView                 *_bgView;
    NSMutableArray         *_recordList;    //记录数据列表
    NSString    *uid;            //用户id
    NSString    *jifen;          //兑换积分
    NSString    *addtime;        //兑换时间
    NSString    *status;         //兑换状态
    
    
}

@end

@implementation ExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"兑换记录";
    _recordList=[NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, MSW, MSH-40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=RGBCOLOR(236, 235, 241);
//     _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self commonView];
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
    _bgView.backgroundColor = RGBCOLOR(255, 81, 15);
    [self.view addSubview:_bgView];
    
    UILabel *dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MSW/4, 30)];
    dateLbl.font = [UIFont systemFontOfSize:16];
    dateLbl.text = @"日期";
    dateLbl.textAlignment=NSTextAlignmentCenter;
    dateLbl.textColor = [UIColor whiteColor];
    [_bgView addSubview:dateLbl];
    
    UILabel *typeLbl = [[UILabel alloc]initWithFrame:CGRectMake(dateLbl.right, 5, MSW/4, 30)];
    typeLbl.font = [UIFont systemFontOfSize:16];
    typeLbl.text = @"种类";
    typeLbl.textAlignment=NSTextAlignmentCenter;
    typeLbl.textColor = [UIColor whiteColor];
    [_bgView addSubview:typeLbl];
    
    UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(typeLbl.right, 5, MSW/4, 30)];
    moneyLbl.font = [UIFont systemFontOfSize:16];
    moneyLbl.text = @"金额（元）";
    moneyLbl.textAlignment=NSTextAlignmentCenter;
    moneyLbl.textColor = [UIColor whiteColor];
    [_bgView addSubview:moneyLbl];
    
    UILabel *stateLbl = [[UILabel alloc]initWithFrame:CGRectMake(moneyLbl.right, 5, MSW/4, 30)];
    stateLbl.font = [UIFont systemFontOfSize:16];
    stateLbl.text = @"状态";
    stateLbl.textAlignment=NSTextAlignmentCenter;
    stateLbl.textColor = [UIColor whiteColor];
    [_bgView addSubview:stateLbl];
    
}
-(void)getRecoreList{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:uid forKey:@"shopid"];
    [dict setValue:jifen forKey:@"shopname"];
    [dict setValue:addtime forKey:@"Uphoto"];
    [dict setValue:status forKey:@"Huode"];
        
    //    DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:ExchangeRecord postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        [self refreshSuccessful:responseDic];
        //        DebugLog(@"=====%@",responseDic[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        NSString *str = [[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding];
        DebugLog(@"str:===========%@",str);
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
                ExchangeRecordDto *model = [[ExchangeRecordDto alloc]initWithDictionary:obj];
                DebugLog(@"成功%@",model.jifen );
                [_recordList addObject:model];
                //DebugLog(@"str:====%@",self.dataArray);
                
            }];
        }
    }
    [_tableView reloadData];
    
}

- (void)refreshFailure:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    //    DebugLog(@"!!!!!!!!!!!!!!!!%@",error);
    
}

    
    
    


#pragma mark
#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    return _recordList.count;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    ExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[ExchangeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.exchangeRecordModel= _recordList[indexPath.row];
    return cell;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
