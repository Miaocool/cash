//
//  ExtensionViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/25.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ExtensionViewController.h"
#import "ExtenShareViewController.h"
#import "MyEarningViewController.h"
#import "ExchangeViewController.h"
#import "ExchangeRecordViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "UIImageView+WebCache.h"
#import "InviteFriendsViewController.h"

@interface ExtensionViewController ()<UITableViewDataSource,UITableViewDelegate>{
//    UIScrollView      *_scrollView;
    UITableView       *_tableView;
    NSMutableArray    *_titleArray;      //标题列表
    NSString          *value;      //兑换比例 1：10000

}
@property(nonatomic,copy)NSString *username;
@end

@implementation ExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"推广";
//    self.view.backgroundColor=RGBCOLOR(236, 235, 241);
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=RGBCOLOR(236, 235, 241);
    [self.view addSubview:_tableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
//    [self getInfomation];
}
-(void)getInfomation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.username forKey:@"mobile"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Login postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"!!!!!!!!!!!!!%@",responseDic);
    if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dict = responseDic[@"data"];
            NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
            [userDefauts  setObject:dict[@"uid"] forKey:@"uid"];
            [userDefauts setObject:dict[@"code"] forKey:@"code"];
            [UserDataSingleton userInformation].isLogin = YES;
            [UserDataSingleton userInformation].code = dict[@"code"];
            [UserDataSingleton userInformation].uid = dict[@"uid"];
            self.username=dict[@"mobile"];
            
            DebugLog(@"!!!!!!%@",dict[@"mobile"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"网络不给力"];
     }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
        return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }
    else if (indexPath.section==1){
        if (indexPath.row==0) {
            return 40;
        }
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    if (section == 1) {
        return (MSW / 2) + 200;
    }
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 5, (MSW / 3), (MSW / 3) + 50)];
        view1.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *erWeiImage = [[UIImageView alloc] initWithFrame:CGRectMake((MSW - (MSW / 2)) / 2, 50, (MSW / 2), (MSW / 2))];
        [erWeiImage sd_setImageWithURL:[NSURL URLWithString:_share_img] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [view1 addSubview:erWeiImage];
        return view1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font=[UIFont systemFontOfSize:BigFont];
    if (indexPath.section == 0)
    {
        DebugLog(@"==%@==%@",_model.img,_model.username);
        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 50)];
        [Img sd_setImageWithURL:[NSURL URLWithString:_model.img ] placeholderImage:[UIImage imageNamed:@"head"]];
        Img.layer.masksToBounds = YES;
        Img.layer.cornerRadius =25;
        Img.backgroundColor=[UIColor clearColor];
        [cell addSubview:Img];
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(Img.right+20, 10, 160, 20)];
        nameLab.text=_model.username;
        nameLab.textColor=[UIColor blackColor];
        nameLab.font=[UIFont systemFontOfSize:BigFont];
        nameLab.backgroundColor=[UIColor clearColor];
        [cell  addSubview:nameLab];
        
        UILabel *numberLab=[[UILabel alloc]initWithFrame:CGRectMake(Img.right+20, nameLab.bottom, 160, 20)];
        numberLab.text=[NSString stringWithFormat:@"推广ID：%@",[UserDataSingleton userInformation].uid];
        numberLab.textColor=[UIColor blackColor];
        numberLab.font=[UIFont systemFontOfSize:MiddleFont];
        numberLab.backgroundColor=[UIColor clearColor];
        [cell  addSubview:numberLab];
        
        
        NSDictionary* style3 = @{@"body" :
                                     @[[UIFont systemFontOfSize:MiddleFont],
                                       [UIColor blackColor]],
                                 @"u": @[MainColor,
                                         
                                         ]};
        
        UILabel *scoreLab=[[UILabel alloc]initWithFrame:CGRectMake(Img.right+20, numberLab.bottom, 160, 20)];
        scoreLab.attributedText=[[NSString stringWithFormat:@"积   分：<u>%@</u>",_model.score] attributedStringWithStyleBook:style3];
        scoreLab.backgroundColor=[UIColor clearColor];
        [cell  addSubview:scoreLab];
        
        
        UILabel *lbyue=[[UILabel alloc]initWithFrame:CGRectMake(Img.right+20, scoreLab.bottom, 160, 20)];
        lbyue.attributedText=[[NSString stringWithFormat:@"余   额：<u>%@</u>",_model.money] attributedStringWithStyleBook:style3];
   
//        lbyue.font=[UIFont systemFontOfSize:BigFont];
        lbyue.backgroundColor=[UIColor clearColor];
        [cell  addSubview:lbyue];
        

        
        UIButton *exchangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(MSW-100, 30, 80, 40)];
        [exchangeBtn setBackgroundColor:MainColor];
        exchangeBtn.layer.cornerRadius=3.0;
        [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
        exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
        [cell addSubview:exchangeBtn];

        return cell;
     }
    
    else{
        switch (indexPath.row) {
            case 0:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"邀请好友";
            }
                break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"积分兑换";
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"兑换记录";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
                break;
           
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            //邀请好友
            InviteFriendsViewController *share=[[InviteFriendsViewController alloc]init];
            [self.navigationController pushViewController:share animated:YES];
        }
        else if (indexPath.row==1){
            MyEarningViewController *earn=[[MyEarningViewController alloc]init];
            [self.navigationController pushViewController:earn animated:YES];
        }
        else if (indexPath.row==2){
            ExchangeViewController *exchange=[[ExchangeViewController alloc]init];
            [self.navigationController pushViewController:exchange animated:YES];
        }
        else if (indexPath.row==3){
            ExchangeRecordViewController *record=[[ExchangeRecordViewController alloc]init];
            [self.navigationController pushViewController:record animated:YES];
        }
    }
    
}

-(void)exchange
{
    ExchangeViewController *exchange=[[ExchangeViewController alloc]init];
    [self.navigationController pushViewController:exchange animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
