//
//  ExchangeRedViewController.m
//  yyxb
//
//  Created by mac03 on 15/12/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ExchangeRedViewController.h"

@interface ExchangeRedViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *numberFiled;

@end

@implementation ExchangeRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"兑换红包";
    self.view.backgroundColor=RGBCOLOR(245, 246, 247);
    
    //    添加手势隐藏键盘
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
    
    [self createUI];
}

-(void)createUI
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.numberFiled=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, MSW - 30, 50)];
    self.numberFiled.delegate=self;
    self.numberFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.numberFiled.backgroundColor=RGBCOLOR(254, 255, 255);
    self.numberFiled.font=[UIFont systemFontOfSize:BigFont];
    self.numberFiled.placeholder=@"输入兑换码";
    self.numberFiled.textColor=RGBCOLOR(130, 131, 132);
    self.numberFiled.keyboardType=UIKeyboardTypeNumberPad;
    [bgView addSubview:self.numberFiled];
    
    UIButton *exchangeBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, self.numberFiled.bottom+10, MSW-20, 40)];
    [exchangeBtn setBackgroundColor:MainColor];
    exchangeBtn.layer.cornerRadius=5.0;
    [exchangeBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
    [self.view addSubview:exchangeBtn];
    
}

-(void)exchange
{
    if ([self.numberFiled.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"兑换码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:self.numberFiled.text forKey:@"number"];
    // DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:GetRedBao postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
         DebugLog(@"===================%@",responseDic[@"msg"]);
        DebugLog(@"===================%@",responseDic);

        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            [[NSNotificationCenter defaultCenter]  postNotificationName:@"refreshData" object:nil];

            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"兑换成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];

        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //[self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];

}

//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom
{
    [self.numberFiled resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
