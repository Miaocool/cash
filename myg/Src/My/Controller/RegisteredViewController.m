//
//  RegisteredViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//注册

#import "RegisteredViewController.h"

#import "LastStepViewController.h"

@interface RegisteredViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation RegisteredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(237, 238, 239);
    self.title = @"注册";
    [self createUI];
}

- (void)createUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MSW, 40)];
    label.font = [UIFont systemFontOfSize:BigFont];
    label.text = @"请输入手机号码进行注册";
    [self.view addSubview:label];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,55, MSW, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    //用户名
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10,view1.frame.size.height / 2 - 20, MSW - 20, 40)];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"请输入手机号码";
    self.textField.delegate = self;
    [view1 addSubview:self.textField];
    
    UIButton *nextstepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextstepBtn.backgroundColor = MainColor;
    nextstepBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [nextstepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextstepBtn.frame = CGRectMake(5, view1.frame.origin.y + view1.frame.size.height + 30, MSW - 10, 40);
    nextstepBtn.layer.cornerRadius = 5;
    [nextstepBtn addTarget:self action:@selector(nextstep) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:nextstepBtn];
    
}

#pragma mark - 下一步
- (void)nextstep
{
    [self checkTel:self.textField.text];
    
}

#pragma mark - 手机号是否合法
- (BOOL)checkTel:(NSString *)str

{
    
    if ([str length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((d{3,4})|d{3,4}-)?d{7,8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    //    if (!isMatch) {
    //
    //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //
    //        [alert show];
    //
    //
    //        return NO;
    //
    //    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.textField.text forKey:@"mobile"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Registered postParam:dic getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"!!!!!!!!!!!!%@",responseDic);
        DebugLog(@"%@－－－－%@",responseDic,responseDic[@"msg"]);
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            
            LastStepViewController *lastVC = [[LastStepViewController alloc]init];
            lastVC.phoneNum = self.textField.text;
            
             [self.navigationController pushViewController:lastVC  animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"请求下来的数据%@",str);
        DebugLog(@"sssssss%@",error);
        if (str.length && str != nil)
        {
            DebugLog(@"请求下来的数据%@",str);
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
        
    }];
    
    
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    [dic setValue:self.textField.text forKey:@"mobile"];
    //    DebugLog(@"!!!!!!!!!!!%@",self.textField.text);
    //            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //            //申明返回的结果是json类型
    //            manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //            //申明请求的数据是json类型
    //            manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //            //如果报接受类型不一致请替换一致text/html或别的
    //            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //            //传入的参数
    //
    //            //发送请求
    //            [manager POST:[NSString stringWithFormat:@"%@%@",APPHost,Registered] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //                DebugLog(@"JSON: %@", responseObject);
    //                if ([responseObject[@"code"] isEqualToString:@"201"])
    //                {
    //                    LastStepViewController *lastStepVC = [[LastStepViewController alloc]init];
    //                    lastStepVC.phoneNum = self.textField.text;
    //                    [self.navigationController pushViewController:lastStepVC  animated:YES];
    //                }
    //            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //                [alert show];
    //            }];
    
    return YES;
    
}


#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
