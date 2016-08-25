//
//  UserPhoneViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/13.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "UserPhoneViewController.h"

#import "JKCountDownButton.h"

@interface UserPhoneViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSTimer            *_timer;
    int                _times;
}
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, assign) BOOL isPhone; //手机号是否合法
@property (nonatomic, strong) JKCountDownButton  *verificationBtn;
@property (nonatomic, strong)UIButton *getCode;

@end

@implementation UserPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(237, 238, 239);
    self.title = @"修改手机号码";
    self.isPhone = NO;
    [self addRiButtonItem];
    [self initTextField];

}

-(void)starrTimer{
    _times = 60;
    [self.getCode setTitle:@"60秒后重发" forState:UIControlStateNormal];
    [self.getCode removeTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
}

-(void)onTimer{
    _times --;
    //  多少秒后重发
    [self.getCode setTitle:[NSString stringWithFormat:@"%d秒后重发",_times] forState:UIControlStateNormal];
    [self.getCode removeTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    if (_times == 0) {
        [self stopTimer];
        // 重新发送
        [self.getCode setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.getCode addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)initTextField
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,10, MSW, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,view1.frame.size.height / 2 - 20, 16 *4, 40)];
    label.text = @"手机号码";
    label.font = [UIFont systemFontOfSize:BigFont];
    [view1 addSubview:label];
    //用户名
    self.phoneField = [[UITextField alloc]initWithFrame:CGRectMake(label.frame.size.width + 20,view1.frame.size.height / 2 - 20, MSW - label.frame.size.width - 20, 40)];
    self.phoneField.clearButtonMode = UITextFieldViewModeAlways;
    self.phoneField.placeholder = @"请输入手机号";
    self.phoneField.delegate = self;
    [view1 addSubview:self.phoneField];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, MSW , 1)];
    view2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view2];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.frame.origin.y + 10, MSW, 50)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    //验证码
    self.codeField = [[UITextField alloc]initWithFrame:CGRectMake(10,view1.frame.size.height / 2 - 20, MSW - 10 - 120, 40)];
    self.codeField.clearButtonMode = UITextFieldViewModeAlways;
    self.codeField.placeholder = @"输入验证码";
    self.codeField.delegate = self;
    [view3 addSubview:self.codeField];
    
    //验证码按钮
//    self.verficatiionBtn= [JKCountDownButton buttonWithType:UIButtonTypeCustom];
//    self.verificationBtn.frame = CGRectMake(MSW - 30 - 100 , view3.frame.size.height / 2 - 20, 100, 40);
//    self.verificationBtn.layer.cornerRadius = 5;
//    self.verificationBtn.backgroundColor = MainColor;
//    [self.verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [self.verificationBtn setTintColor:[UIColor blackColor]];
//    [self.verificationBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    self.verificationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [view3 addSubview:self.verificationBtn];
//    __weak typeof(self) weakself = self;
//
//    [weakself.verificationBtn addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
//             [weakself checkTel:self.phoneField.text];
//    }];
    
    self.getCode=[UIButton buttonWithType:UIButtonTypeCustom];
    self.getCode.frame = CGRectMake(MSW - 15 - 100 , view3.frame.size.height / 2 - 20, 100, 40);
    self.getCode.layer.cornerRadius = 5;
    self.getCode.backgroundColor =MainColor;
    [self.getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCode setTintColor:[UIColor blackColor]];
    self.getCode.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.getCode addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:self.getCode];
    
}
-(void)click
{
    
     if (IsStrEmpty(_phoneField.text) || _phoneField.text.length != 11) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        
        //   ---------------------------发送验证码－－－
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:_phoneField.text forKey:@"mobile"];
        [MDYAFHelp AFPostHost:APPHost bindPath:Sendphoneyzm postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                [self starrTimer];
            }
           else  if ([responseDic[@"code"] isEqualToString:@"400"])
           {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
                alert.delegate = self;
                [alert show];
           }else{
               [self stopTimer];
           }

            //[self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
           [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
    }

    
    
}
#pragma mark - 手机号是否合法
- (BOOL)checkTel:(NSString *)str
{
    DebugLog(@"---%@====%@",_phoneField.text,_model.mobile);
   
    if ((self.phoneField.text=self.model.mobile)) {
        
          UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号尚未修改，无需获取验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if ([str length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
         return NO;
    }
    
       else{
        
//        ---------------------------发送验证码－－－
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:_phoneField.text forKey:@"mobile"];
        
        DebugLog(@"----%@",_phoneField.text);
        
        [MDYAFHelp AFPostHost:APPHost bindPath:Sendphoneyzm postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
//        [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
           [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
         }
        self.verificationBtn.enabled = NO;
        [self.verificationBtn startWithSecond:60];
        
        [self.verificationBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
            return title;
        }];
        [self.verificationBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            return @"重新获取";
        }];
       return YES;
}


#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneField resignFirstResponder];
    [self.codeField resignFirstResponder];
    return YES;
}

#pragma mark - 导航按钮 - 确定
- (void)addRiButtonItem
{
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(determine)];
    self.navigationItem.rightBarButtonItem = btn_right;
    
}

#pragma mark - 点击确定按钮
- (void)determine
{
   
    if (self.phoneField.text == nil || self.codeField.text.length <= 0||self.codeField.text==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:_phoneField.text forKey:@"mobile"];
        [dict1 setValue:_codeField.text forKey:@"yzm"];
        
        [MDYAFHelp AFPostHost:APPHost bindPath:EditPhone postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
             DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
            
            if ([responseDic[@"code"] isEqualToString:@"200"]) {
                
                    [SVProgressHUD dismiss];
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert2 show];
                
                
                  [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
            
                DebugLog(@"修改失败");
                [SVProgressHUD showErrorWithStatus:@"修改失败"];

            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
           [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
        }];
        
    }
    
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
