//
//  ForgetPasswordController.m
//  yyxb
//
//  Created by lili on 15/12/2.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "ForgetPasswordController.h"

@interface ForgetPasswordController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *phoneno;

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    [self createUI];
}
#pragma mark - 创建UI
- (void)createUI
{
    //滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(0, MSH +1);
    //    self.scrollView.delegate = self;
    //  self.scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    //    ////    添加手势隐藏键盘
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.scrollView addGestureRecognizer:singleRecognizer];
    UIImageView*imgforget=[[UIImageView alloc]initWithFrame:CGRectMake(20,30, [UIScreen mainScreen].bounds.size.width-40, 50)];
    if (_stuta==1) {
        imgforget.image=[UIImage imageNamed:@"find the password 1"];
    }else if (_stuta==2){
        imgforget.image=[UIImage imageNamed:@"find the password 2"];
    }else{
        imgforget.image=[UIImage imageNamed:@"find the password 3"];
    }
    [self.scrollView addSubview:imgforget];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 50)];
    view.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:view];
    
    UIView*line=[[UIView alloc]initWithFrame:CGRectMake(55, 5, 2, 40)];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    //密码图片/Users/lili/Desktop/project2/yyxb/Src/My/Controller/ForgetPasswordController.m
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
    
    if (_stuta==3) {
        imageView2.image = [UIImage imageNamed:@"8-5"];
    }else{
    imageView2.image = [UIImage imageNamed:@"8-6"];
    }
    [view addSubview:imageView2];
    
    //用户名
    self.phoneno = [[UITextField alloc]initWithFrame:CGRectMake(20 + imageView2.frame.size.width + 10, imageView2.frame.origin.y,[UIScreen mainScreen].bounds.size.width-40-imageView2.frame.size.width, 30)];
    self.phoneno.layer.cornerRadius = 5;
    
    self.phoneno.clearButtonMode = UITextFieldViewModeAlways;
    if (_stuta==1) {
        self.phoneno.secureTextEntry = NO;
       self.phoneno.placeholder = @"输入手机号";
        
        _phoneno.keyboardType=UIKeyboardTypeNumberPad;
    }else if (_stuta==2){
        self.phoneno.secureTextEntry = NO;
        
        _phoneno.keyboardType=UIKeyboardTypeDefault;
        
    self.phoneno.placeholder = @"输入验证码";
    }else{
        self.phoneno.secureTextEntry = YES;
    self.phoneno.placeholder = @"设置密码";
        
        
        _phoneno.keyboardType=UIKeyboardTypeDefault;
    }
   
   self.phoneno.delegate = self;
    _phoneno.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:self.phoneno];
    //忘记密码按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, 250 + 1 + 30, MSW - 20, 40);
    
    if (_stuta==1) {
        [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
      [loginBtn addTarget:self action:@selector(next1) forControlEvents:UIControlEventTouchDown];
    }else if (_stuta==2){
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(next2) forControlEvents:UIControlEventTouchDown];
    }else{
    
      [loginBtn setTitle:@"确认" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchDown];
    }
    
    loginBtn.backgroundColor = MainColor;
    loginBtn.layer.cornerRadius = 10;
    [self.scrollView addSubview:loginBtn];
    
}

-(void)next1{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_phoneno.text forKey:@"mobile"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Findpass postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            
            ForgetPasswordController *registerdVC = [[ForgetPasswordController alloc]init];
          registerdVC.stuta=2;
            registerdVC.fromphoneno=_phoneno.text;
           [self.navigationController pushViewController:registerdVC animated:YES];
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseDic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                      [alert show];
        }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}


-(void)next2{
    DebugLog(@"%@",_fromphoneno);
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_fromphoneno forKey:@"mobile"];
    [dict1 setValue:_phoneno.text forKey:@"yzm"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Checkcode postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseDic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            ForgetPasswordController *registerdVC = [[ForgetPasswordController alloc]init];
            registerdVC.stuta=3;
            registerdVC.codeStr = _phoneno.text;
            registerdVC.fromphoneno=_fromphoneno;
            [self.navigationController pushViewController:registerdVC animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
    
}
-(void)finish{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_fromphoneno forKey:@"mobile"];
    [dict1 setValue:_phoneno.text forKey:@"pass"];
    [dict1 setValue:_codeStr forKey:@"yzm"];
    DebugLog(@"---%@",_fromphoneno);
    [MDYAFHelp AFPostHost:APPHost bindPath:Editpass postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseDic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
     [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    if (_stuta==2) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:_fromphoneno forKey:@"mobile"];
        
        [MDYAFHelp AFPostHost:APPHost bindPath:Send_code postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
          [SVProgressHUD showErrorWithStatus:@"网络不给力"];            
            
        }];

    }
    
}
//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom{
    
    [_phoneno resignFirstResponder];
//

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
