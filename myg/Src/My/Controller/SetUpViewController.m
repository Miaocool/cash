//
//  SetUpViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/17.
//  Copyright (c) 2015年 杨易. All rights reserved.
//设置

#import "SetUpViewController.h"
#import "ProblemViewController.h"
#import "PWWebViewController.h"
#import "UserDataViewController.h"
#import "MyWishViewController.h"
#import "FeedBackViewController.h"
#import "ServiceViewController.h"

@interface SetUpViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    NSString      *curVersion; //本地版本
    NSString      *_webLink;   //网址
    
    NSMutableArray *array;//设置内容
    NSArray *arrTitles;    //首段
    NSArray *arrImages;
    
    NSArray *arr2Titles;  //尾段
    NSArray *arr2Images;
    
    UIView        *_tablefooterView;
    NSString      *_telephonenumber;   //电话号码

    
}
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,copy) NSString     *url;
@property (nonatomic, strong) UILabel  *editionCode;  //版本号
@property(nonatomic,strong)UIButton *exitBtn; //退出登录

@end

@implementation SetUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    
    
    array=[NSMutableArray array];
    arrTitles = @[@"编辑个人资料",@"心愿单",@"帮助中心",@"意见反馈",@"客服热线",@"清除缓存",@"当前版本",@"关于我们",@"服务协议"];
    arrImages = @[@"icon01_settings",@"icon02_settings",@"icon03_settings",@"icon04_settings",@"icon05_settings",@"icon06_settings",@"icon07_settings",@"icon08_settings",@"icon09_settings"];
    
    arr2Titles = @[@"心愿单",@"帮助中心",@"意见反馈",@"客服热线",@"清除缓存",@"当前版本",@"关于我们",@"服务协议"];
    arr2Images = @[@"icon02_settings",@"icon03_settings",@"icon04_settings",@"icon05_settings",@"icon06_settings",@"icon07_settings",@"icon08_settings",@"icon09_settings"];
    
    [self initTableView];
    [self gettelephonenumber];

    
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=self.tablefooterView;
    self.tableView.backgroundColor = RGBCOLOR(237, 238, 239);
    
//    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    exitBtn.backgroundColor = MainColor;
//    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    exitBtn.frame = CGRectMake(10, 44 * 4 + 30 + 15, MSW - 20, 45);
//    exitBtn.layer.cornerRadius = 5;
//    [exitBtn addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.tableView addSubview:exitBtn];
    [self.view addSubview:self.tableView];


}
- (UIView *)tablefooterView
{
    if (!_tablefooterView) {
        _tablefooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 80)];
        _tablefooterView.backgroundColor = [UIColor clearColor];
        _tablefooterView.tag = 1;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, MSW, 50)];
        bgView.backgroundColor = [UIColor clearColor];
        [_tablefooterView addSubview:bgView];
        
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exitBtn.backgroundColor = [UIColor whiteColor];
        [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [exitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        exitBtn.frame = CGRectMake(10, 30, MSW - 20, 45);
        exitBtn.layer.cornerRadius = 5;
        [exitBtn addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
        [_tablefooterView addSubview:exitBtn];
        
    }
    
    return _tablefooterView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        if ([UserDataSingleton userInformation].isLogin==YES)
        {
            return arrTitles.count;
        }
        else
        {
            return arr2Titles.count;
        }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UserDataSingleton userInformation].isLogin==YES) {
     
        self.tableView.tableFooterView.hidden=NO;

    }
    else
    {
        self.tableView.tableFooterView.hidden=YES;
    }

    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:BigFont];
    
    UIImageView *imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    
        switch (indexPath.row) {
            case 0:
            {
                if([UserDataSingleton userInformation].isLogin==YES)
                {
                    imageView2.image=[UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                }
                else{
                  imageView2.image=[UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                    
                    
                }
                 [cell addSubview:imageView2];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                if([UserDataSingleton userInformation].isLogin==YES)
                {
                     imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                }
                else{
                      imageView2.image = [UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                }
                
                  [cell addSubview:imageView2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
                break;
            case 2:
            {
                if([UserDataSingleton userInformation].isLogin==YES)
                {
                     imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                }
                else{
                    imageView2.image = [UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                   
                }
                
                  [cell addSubview:imageView2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
                break;
            case 3:
            {
                if([UserDataSingleton userInformation].isLogin==YES)
                {
                      imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                else{
                      imageView2.image = [UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                    
                    cell.detailTextLabel.text=_telephonenumber;
                    cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                 [cell addSubview:imageView2];
                
            }
                break;
            case 4:
            {
                if([UserDataSingleton userInformation].isLogin==YES)
                {
                      imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                    
                    cell.detailTextLabel.text=_telephonenumber;
                    cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else{
                    //清除缓存
                    imageView2.image = [UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                    
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(MSW - 150 -35, 0, 150, 40)];
                    label.backgroundColor=[UIColor whiteColor];
                    
                    label.text=[NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font=[UIFont systemFontOfSize:BigFont];
                    [cell addSubview:label];
                }
                
                 [cell addSubview:imageView2];
                
            }
                break;
            case 5:
            {
                if([UserDataSingleton userInformation].isLogin==YES)
                {
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(MSW - 150 -35, 0, 150, 40)];
                    
                    label.text=[NSString stringWithFormat:@"%.2fM",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
                    label.textColor = [UIColor grayColor];
                    label.backgroundColor=[UIColor whiteColor];
                    label.textAlignment = NSTextAlignmentRight;
                    label.font=[UIFont systemFontOfSize:BigFont];
                    [cell addSubview:label];
                    
                      imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                                   }
                else{
                     imageView2.image = [UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                    
                    //添加当前版本
                    [cell addSubview:self.editionCode];
                    cell.selectionStyle=UITableViewCellAccessoryNone;
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                   [cell addSubview:imageView2];
                
            }
                break;
            case 6:
            {

                if([UserDataSingleton userInformation].isLogin==YES)
                {
                     imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                    //添加当前版本
                    cell.selectionStyle=UITableViewCellAccessoryNone;
                    [cell addSubview:self.editionCode];

                }
                else{
                        imageView2.image = [UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                  [cell addSubview:imageView2];

            }
                break;
            case 7:
            {
                if ([UserDataSingleton userInformation].isLogin==YES) {
                    imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                    
                }else{
                    imageView2.image = [UIImage imageNamed:[arr2Images objectAtIndex:indexPath.row]];
                    
                }
                [cell addSubview:imageView2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
                break;
            case 8:
            {
                imageView2.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
                [cell addSubview:imageView2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
        }
        
        if ([UserDataSingleton userInformation].isLogin==YES) {
            cell.textLabel.text = [NSString stringWithFormat:@"     %@",arrTitles[indexPath.row]];
        }
        else{
            cell.textLabel.text = [NSString stringWithFormat:@"     %@",arr2Titles[indexPath.row]];
        }
        cell.textLabel.font=[UIFont systemFontOfSize:BigFont];
    
    return cell;

}
#pragma  添加版本更新label
-(UILabel *)editionCode{
    if (!_editionCode) {
        _editionCode = [[UILabel alloc] initWithFrame:CGRectMake(MSW - 150 -35 , 5, 150 , 35)];
        _editionCode.textAlignment = NSTextAlignmentRight;
        _editionCode.font = [UIFont systemFontOfSize:BigFont];
        _editionCode.backgroundColor = [UIColor clearColor];
        _editionCode.textColor = [UIColor grayColor];
        curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _editionCode.text = [NSString stringWithFormat:@"v%@",curVersion];
    }
    return _editionCode;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";

}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                //编辑个人资料
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    UserDataViewController *problemVC = [[UserDataViewController alloc]init];
                    problemVC.hidesBottomBarWhenPushed=YES;
                    problemVC.share_img = _share_img;
                    [self.navigationController pushViewController:problemVC animated:YES];
                }
                else
                {
                    //心愿单
//                    MyWishViewController *wish = [[MyWishViewController alloc]init];
//                    wish.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:wish animated:YES];
                    
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    loginVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:loginVC animated:YES];
                    
                }

            }
                break;
            case 1:
            {
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    //心愿单
                    MyWishViewController *wish = [[MyWishViewController alloc]init];
                    wish.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:wish animated:YES];
                }
                else
                {
                    [self problem];
                }
                
            }
                break;
            case 2:
            {
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    [self problem];
                }
                else
                {
                    FeedBackViewController *wish = [[FeedBackViewController alloc]init];
                    wish.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:wish animated:YES];
                }

            }
                break;
            case 3:
            {
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    //意见反馈
                    FeedBackViewController *wish = [[FeedBackViewController alloc]init];
                    wish.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:wish animated:YES];
                }
                else
                {
                     [self telephoneTouch];
                }

            }
                break;
            case 4:
            {
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    [self telephoneTouch];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清理缓存吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag=100;
                    alert.delegate=self;
                    [alert show];

                }

            }
                break;
            case 5:
            {
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清理缓存吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alert.tag=100;
                    alert.delegate=self;
                    [alert show];

                }
                else
                {
                    
                }
            }
                break;
            case 6:
            {
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    
                }
                else
                {
                  [self aboutus];
                }
            }
                break;
            case 7:
            {
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    [self aboutus];
                }
                else
                {
                    ServiceViewController *wish = [[ServiceViewController alloc]init];
                    wish.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:wish animated:YES];
                }
            }
                break;
            case 8:
            {
                
                if ([UserDataSingleton userInformation].isLogin==YES)
                {
                    //服务协议
                    ServiceViewController *wish = [[ServiceViewController alloc]init];
                    wish.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:wish animated:YES];
                }
                else
                {
                    
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 退出登陆
- (void)exitLogin
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要退出登录？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
        }else{
             [[SDImageCache sharedImageCache] clearDisk];
            [_tableView reloadData];
        }
    }
    else{
        if (buttonIndex == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
            [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [MDYAFHelp AFPostHost:APPHost bindPath:ExitLogin postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                if ([responseDic[@"code"] isEqualToString:@"200"])
                {
                    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                    [userDefaultes  setObject:@"" forKey:@"uid"];
                    [userDefaultes setObject:@"" forKey:@"code"];
                    [UserDataSingleton userInformation].isLogin = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD dismiss];
                    
                    [[UserDataSingleton userInformation].shoppingArray removeAllObjects];
                        //通知 改变徽标个数
                        NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }];
        }
        else
        {
        
        }
  
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self gettelephonenumber];

}

#pragma  mark - 常见问题
-(void)problem
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_url forKey:@"url"];
    
    //    DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:changjian postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            PWWebViewController *web = [[PWWebViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]]];
            web.showToolBar = NO;
            web.hidesBottomBarWhenPushed = YES;
            //  常见问题
            web.navtitle = @"帮助中心";
            [self.navigationController pushViewController:web animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];

}
#pragma  mark - 热线电话
-(void)telephoneTouch
{
    UIWebView*callWebview =[[UIWebView alloc] init] ;
    // tel:
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_telephonenumber]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark-  关于
-(void)aboutus
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
//    [dict setValue:_url forKey:@"url"];
//     DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:AboutUs postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            PWWebViewController *web = [[PWWebViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]]];
            web.showToolBar = NO;
            web.hidesBottomBarWhenPushed = YES;
            //  关于我们
            web.navtitle = @"关于我们";
            [self.navigationController pushViewController:web animated:YES];

        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];

    }];

}


-(void)gettelephonenumber{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"2" forKey:@"type"];
    [dict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"ver"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Prompt postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"res = %@",responseDic);
        if ([EncodeFormDic(responseDic, @"code") isEqualToString:@"200"]) {
            
            NSDictionary *dataDic = responseDic[@"data"];
            _telephonenumber=dataDic[@"helpline"];
            
            DebugLog(@"==-%@",_telephonenumber);
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
