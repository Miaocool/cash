//
//  ExchangeViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/26.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView * _tableView;
    
    NSMutableArray * proportionArray;  //需要兑换的米币数组

    long value;  //兑换比例
    
    NSString * jifen;  //要兑换的积分
}


@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"积分兑换";
    
    proportionArray = [NSMutableArray array];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self getData];
}
#pragma mark  获取兑换比例
-(void)getData
{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
        //    DebugLog(@"==========%@",dict[@"code"]);
        [MDYAFHelp AFPostHost:APPHost bindPath:duihuan postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"===================%@",responseDic);
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                NSDictionary *data=responseDic[@"data"];
                value=[data[@"value"] longLongValue];
                NSArray * array = data[@"proportion"];
                proportionArray = [NSMutableArray arrayWithArray:array];
                DebugLog(@"value===%ld",value);

            }
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.backgroundColor=RGBCOLOR(236, 235, 241);
            _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
            [self.view addSubview:_tableView];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];

}
#pragma mark
#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return proportionArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     _tableView.tableFooterView = [[UIView alloc] init];
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"兑换米币";
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@米币",[proportionArray objectAtIndex:indexPath.row - 1]];
        cell.detailTextLabel.textColor = MainColor;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lld积分",[proportionArray[indexPath.row - 1] longLongValue] * value];
        
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认兑换" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 12345;
        [alert show];
        jifen = [NSString stringWithFormat:@"%lld",[proportionArray[indexPath.row - 1] longLongValue] * value];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==12345)
    {
        // buttonIndex ==1 用户选择
        if (buttonIndex ==1)
        {
            [self getExchange];
        }
    }
}

#pragma mark - 积分兑换
-(void)getExchange{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:jifen forKey:@"jifen"];

    [MDYAFHelp AFPostHost:APPHost bindPath:ExchangeScore postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([responseDic[@"code"] isEqualToString:@"201"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
//          [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"积分不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

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
