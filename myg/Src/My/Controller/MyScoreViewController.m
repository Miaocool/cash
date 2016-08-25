//
//  MyScoreViewController.m
//  zrdb
//
//  Created by mac03 on 16/1/23.
//  Copyright (c) 2016年 杨易. All rights reserved.
//

#import "MyScoreViewController.h"
#import "ExchangeViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

@interface MyScoreViewController ()
{
    
    UIScrollView      *_scrollView;
    
    NSString *integral;  //总积分
    NSString *proportion; //签到天数
    NSString *text;  //提示语
    NSString *status; //签到状态
    NSString *number; //夺宝比个数
    NSString *continuous;   //连续签到
    
}
@property(nonatomic,strong)UILabel *scoreLab;
@property(nonatomic,strong)UILabel *numberLab;
@property(nonatomic,strong)UIImageView *Img;
@property(nonatomic,strong)UIButton *exchangeBtn; //兑换
@property(nonatomic,strong)UIButton *SignBtn;  //签到
@property(nonatomic,strong)UILabel *contueLab;  //连续签到
@property(nonatomic,strong)UILabel *tishiLab;  //描述label
@property(nonatomic,strong)UILabel *describeLab;  //描述
@end

@implementation MyScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的积分";
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    _scrollView.contentSize=CGSizeMake(MSW, IPhone4_5_6_6P(MSH+30, MSH+50, MSH+50, MSH+50));
    _scrollView.showsHorizontalScrollIndicator=false;
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_scrollView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self getSignInfo];
    [self getTishi];
    
    [_scrollView reloadInputViews];
}
#pragma mark-请求数据
-(void)getSignInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Signin postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"====%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *data=responseDic[@"data"];
            integral=data[@"integral"];
            proportion=data[@"proportion"];
            continuous=data[@"continuous"];
            status=[NSString stringWithFormat:@"%@",data[@"status"]]   ;
            DebugLog(@"==%@==%@==%@==%@",integral,proportion,status,continuous);
            
            int s=[integral intValue];
            int t=[proportion intValue];
            
            int p =s/t;
            number=[NSString stringWithFormat:@"%d",p];
            DebugLog(@"===%@",continuous);
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:nil message:@"签到失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert1 show];
        }
        [self createUI];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}
#pragma mark-提示语
-(void)getTishi
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:@"1" forKey:@"type"];
    [MDYAFHelp AFPostHost:APPHost bindPath:SigninInfo postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"====%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *data=responseDic[@"data"];
            text=data[@"value"];
        }
        [self createUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
    
}
#pragma mark-创建UI
-(void)createUI
{
    [self.scoreLab removeFromSuperview];
    [self.numberLab removeFromSuperview];
    [_Img removeFromSuperview];
    [_exchangeBtn removeFromSuperview];
    [_SignBtn removeFromSuperview];
    [self.tishiLab removeFromSuperview];
    [self.describeLab removeFromSuperview];
    [self.contueLab removeFromSuperview];
    
    NSDictionary* style = @{@"body" :
                                @[[UIFont systemFontOfSize:BigFont],
                                  [UIColor blackColor]],
                            @"u": @[[UIFont systemFontOfSize:20],MainColor]};
    
    self.scoreLab=[[UILabel alloc]initWithFrame:CGRectMake(100, 20, MSW-200, 35)];
    self.scoreLab.attributedText=[[NSString stringWithFormat:@"<u>%@</u>积分",integral] attributedStringWithStyleBook:style];
    self.scoreLab.backgroundColor=[UIColor clearColor];
    self.scoreLab.textAlignment=NSTextAlignmentCenter;
    [_scrollView  addSubview:self.scoreLab];
    
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor blackColor]],
                             @"u": @[RGBCOLOR(48, 140, 245),]};
    
    self.numberLab=[[UILabel alloc]initWithFrame:CGRectMake(75, self.scoreLab.bottom, MSW-150, 30)];
    self.numberLab.attributedText=[[NSString stringWithFormat:@"=<u>%@</u>个米币(%@)",number,proportion] attributedStringWithStyleBook:style1];
    self.numberLab.textAlignment=NSTextAlignmentCenter;
    self.numberLab.font=[UIFont systemFontOfSize:MiddleFont];
    self.numberLab.backgroundColor=[UIColor clearColor];
    [_scrollView  addSubview:self.numberLab];
    
    
    _Img=[[UIImageView alloc]initWithFrame:CGRectMake(self.numberLab.right-10, self.scoreLab.bottom, 28, 28)];
    _Img.image=[UIImage imageNamed:@"point"];
    //    _Img.layer.masksToBounds = YES;
    //    _Img.layer.cornerRadius =25;
    _Img.backgroundColor=[UIColor clearColor];
    //    [_scrollView addSubview:_Img];
    
    
    _exchangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, self.numberLab.bottom+20, MSW-200, 30)];
    [_exchangeBtn setTitle:@"兑换米币" forState:UIControlStateNormal];
    [_exchangeBtn setBackgroundColor:[UIColor clearColor]];
    [_exchangeBtn setTitleColor:NavColor forState:UIControlStateNormal];
    _exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    _exchangeBtn.layer.borderWidth = 0.5;
    _exchangeBtn.layer.cornerRadius=5;
    _exchangeBtn.layer.borderColor = MainColor.CGColor;
    [_exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_exchangeBtn];
    
    
    self.contueLab=[[UILabel alloc]initWithFrame:CGRectMake(100, _exchangeBtn.bottom+20, MSW-200, 30)];
    self.contueLab.attributedText=[[NSString stringWithFormat:@"已连续签到</u><u>%@</u>天",continuous]attributedStringWithStyleBook:style1];
    self.contueLab.textAlignment=NSTextAlignmentCenter;
    self.contueLab.backgroundColor=[UIColor clearColor];
    [_scrollView  addSubview:self.contueLab];
    
    
    _SignBtn=[[UIButton alloc]initWithFrame:CGRectMake((MSW-100)/2, self.contueLab.bottom+20, 100, 100)];
    [_SignBtn setBackgroundColor:[UIColor clearColor]];
    
    if ([status isEqualToString:@"0"]) {
        [_SignBtn setImage:[UIImage imageNamed:@"sign-in"] forState:UIControlStateNormal];
    }
    else{
        [_SignBtn setImage:[UIImage imageNamed:@"sign-in_selected"] forState:UIControlStateNormal];
    }
    
    //    _SignBtn.layer.borderWidth = 0.5;
    _SignBtn.layer.cornerRadius=15;
    [_SignBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_SignBtn];
    
    self.tishiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, _SignBtn.bottom+10, MSW-40, 30)];
    self.tishiLab.text=@"详情描述";
    self.tishiLab.textColor=[UIColor blackColor];
    self.tishiLab.font=[UIFont systemFontOfSize:BigFont];
    self.tishiLab.backgroundColor=[UIColor clearColor];
    //    [_scrollView  addSubview:self.tishiLab];
    
    
    self.describeLab=[[UILabel alloc]initWithFrame:CGRectMake(20, _SignBtn.bottom, MSW-40, 100)];
    DebugLog(@"%@",text);
    self.describeLab.text=text;
    self.describeLab.textColor=[UIColor blackColor];
    self.describeLab.numberOfLines=0;
    self.describeLab.lineBreakMode = NSLineBreakByCharWrapping;
    self.describeLab.font=[UIFont systemFontOfSize:BigFont];
    self.describeLab.backgroundColor=[UIColor clearColor];
    [_scrollView  addSubview:self.describeLab];
    
    
}

#pragma mark-兑换米币
-(void)exchange
{
    
    ExchangeViewController *exchange=[[ExchangeViewController alloc]init];
    [self.navigationController pushViewController:exchange animated:YES];
    
    //    int s=[integral intValue];
    //    int t=[proportion intValue];
    //
    //    int p =s/t;
    //    number=[NSString stringWithFormat:@"%d",p];
    //    DebugLog(@"===%@",number);
    //    [self createUI];
}

#pragma mark-点击签到
-(void)Click
{
    [_SignBtn setImage:[UIImage imageNamed:@"sign-in_selected"] forState:UIControlStateNormal];
    _SignBtn.userInteractionEnabled=YES;
    [self sureSign];
}

#pragma mark-确认签到
-(void)sureSign
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:@"1" forKey:@"type"];
    [MDYAFHelp AFPostHost:APPHost bindPath:AlterSign postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"====%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
//            [SVProgressHUD showSuccessWithStatus:@"签到成功"];
//            [self.navigationController popViewControllerAnimated:YES];
            [self getSignInfo];
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"签到成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
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
