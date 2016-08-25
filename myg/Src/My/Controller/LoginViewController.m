//
//  LoginViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/11.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteredViewController.h"
#import "ForgetPasswordController.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
@interface LoginViewController ()<UITextFieldDelegate>{
     NSMutableDictionary                 *_infoDict;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UITextField *userPassword;
@property (nonatomic, strong) UIButton *forgetPassword;

@property(nonatomic,strong)UIButton *wxbtn;  //WEIX
@property(nonatomic,strong) UILabel *wxlabel; //WEIIXN
@property (nonatomic, strong) UIButton *wbBtn;
@property (nonatomic, strong) UILabel *wbLabel;
@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UILabel *qqLabel;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, copy) NSString *qqcode;
@property (nonatomic, copy) NSString *wbcode;
@property (nonatomic, copy) NSString *wxcode;


@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户登录";
    
}


#pragma mark - 创建UI
- (void)createUI
{
    if (_scrollView == nil) {
        //滚动视图
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        self.scrollView.contentSize = CGSizeMake(0, MSH +1);
        //    self.scrollView.delegate = self;
        //  self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.scrollView];
   
    //登陆图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 24, 23)];
    imageView.image = [UIImage imageNamed:@"8-4"];
    [self.scrollView addSubview:imageView];
    //横线
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 10, MSW - 20, 1)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:view1];
    
    //密码图片
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, view1.frame.origin.y + 1 + 20, 24, 23)];
    imageView2.image = [UIImage imageNamed:@"8-5"];
    [self.scrollView addSubview:imageView2];
    //用户名
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10, imageView.frame.origin.y, MSW-imageView.width-10-20, 30)];
    self.userName.layer.cornerRadius = 5;
    self.userName.clearButtonMode = UITextFieldViewModeAlways;
    self.userName.keyboardType = UIKeyboardTypeNumberPad;
    self.userName.placeholder = @"手机号码";
    self.userName.delegate = self;
    [self.scrollView addSubview:self.userName];
    
    //用户名
    self.userPassword = [[UITextField alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x + imageView2.frame.size.width + 10, imageView2.frame.origin.y, MSW-imageView2.width-120, 30)];
    self.userPassword.layer.cornerRadius = 5;
    self.userPassword.clearButtonMode = UITextFieldViewModeAlways;
    self.userPassword.placeholder = @"密码";
    self.userPassword.delegate = self;
    self.userPassword.secureTextEntry = YES;
    [self.scrollView addSubview:self.userPassword];
    //－－－－－－忘记密码
    _forgetPassword=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100,  imageView2.frame.origin.y, 90, 30)];
    [_forgetPassword setTitle:@"忘记密码?" forState:UIControlStateNormal];
    _forgetPassword.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    [_forgetPassword setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_forgetPassword addTarget:self action:@selector(forgetpassword) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_forgetPassword];
    //横线
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(10, imageView2.frame.origin.y + imageView2.frame.size.height + 10, MSW - 20, 1)];
    view2.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:view2];
    
    //登陆按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(view1.frame.origin.x, view2.frame.origin.y + 1 + 30, MSW - 20, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    loginBtn.backgroundColor = MainColor;
    loginBtn.layer.cornerRadius = 10;
    [self.scrollView addSubview:loginBtn];
    
    //注册按钮
    UIButton *registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registeredBtn.frame = CGRectMake(view1.frame.origin.x, loginBtn.frame.origin.y + loginBtn.frame.size.height  + 20, MSW - 20, 40);
    [registeredBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registeredBtn setTitle:@"通过手机号注册" forState:UIControlStateNormal];
    registeredBtn.backgroundColor = RGBCOLOR(231, 232, 233);
    registeredBtn.layer.cornerRadius = 10;
    [registeredBtn addTarget:self action:@selector(registered) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:registeredBtn];
    
    //声明
    UILabel *shengmingLab=[[UILabel alloc]initWithFrame:CGRectMake(30, registeredBtn.bottom+5, MSW-60, 30)];
    shengmingLab.text=@"苹果手机及其它奖品抽奖活动与苹果公司(Apple.Inc)无关";
    shengmingLab.textColor=[UIColor blackColor];
    shengmingLab.textAlignment=NSTextAlignmentCenter;
    shengmingLab.backgroundColor=[UIColor clearColor];
    shengmingLab.font=[UIFont systemFontOfSize:10];
    [self.scrollView addSubview:shengmingLab];
    
    //第三方登陆
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, registeredBtn.frame.size.height + registeredBtn.frame.origin.y + 50, MSW, 16)];
    self.textLabel.text = @"─────  或用以下方式登录  ─────";
    self.textLabel.textColor = [UIColor grayColor];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.textLabel];
    
    
    //qq
    //    self.qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.qqBtn.frame = CGRectMake(MSW / 2 - 29, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
    //    self.qqBtn.layer.cornerRadius = 29;
    //    [self.qqBtn setBackgroundImage:[UIImage imageNamed:@"8-3"] forState:UIControlStateNormal];
    //    self.qqBtn.tag = 102;
    //    [self.qqBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.scrollView addSubview:self.qqBtn];
    //
    //    self.qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.qqBtn.frame.origin.x, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14)];
    //    self.qqLabel.font = [UIFont systemFontOfSize:14];
    //    self.qqLabel.text = @"QQ登录";
    //    self.qqLabel.textAlignment = NSTextAlignmentCenter;
    //    self.qqLabel.textColor = [UIColor lightGrayColor];
    //    [self.scrollView addSubview:self.qqLabel];
    
    
    //微博
    //    self.wbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.wbBtn.frame = CGRectMake(self.qqBtn.frame.origin.x - 20 - 58, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
    //    self.wbBtn.layer.cornerRadius = 29;
    //    [self.wbBtn setBackgroundImage:[UIImage imageNamed:@"8-1sina"] forState:UIControlStateNormal];
    //    [self.wbBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    self.wbBtn.tag = 101;
    //    [self.scrollView addSubview:self.wbBtn];
    //
    //    self.wbLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.wbBtn.frame.origin.x, self.wbBtn.frame.origin.y + self.wbBtn.frame.size.height + 10, self.wbBtn.frame.size.width, 14)];
    //    self.wbLabel.font = [UIFont systemFontOfSize:14];
    //    self.wbLabel.text = @"微博登录";
    //    self.wbLabel.textAlignment = NSTextAlignmentCenter;
    //    self.wbLabel.textColor = [UIColor lightGrayColor];
    //    [self.scrollView addSubview:self.wbLabel];
    
    self.qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.qqBtn.frame = CGRectMake(MSW / 2 - 29 - 20 - 58, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
    self.qqBtn.layer.cornerRadius = 29;
    [self.qqBtn setBackgroundImage:[UIImage imageNamed:@"8-3"] forState:UIControlStateNormal];
    [self.qqBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    self.qqBtn.tag = 102;
    [self.scrollView addSubview:self.qqBtn];
    
    self.qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.qqBtn.frame.origin.x, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14)];
    self.qqLabel.font = [UIFont systemFontOfSize:14];
    self.qqLabel.text = @"QQ登录";
    self.qqLabel.textAlignment = NSTextAlignmentCenter;
    self.qqLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.qqLabel];
    
    
    
    //微信
    self.wxbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.wxbtn.frame = CGRectMake(self.qqBtn.frame.origin.x + 20 + 58 + 78, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
    self.wxbtn.layer.cornerRadius = 29;
    [self.wxbtn setBackgroundImage:[UIImage imageNamed:@"8-2"] forState:UIControlStateNormal];
    self.wxbtn.tag = 103;
    [self.wxbtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.wxbtn];
    
    self.wxlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.wxbtn.frame.origin.x, self.wxbtn.frame.origin.y + self.wxbtn.frame.size.height + 10, self.wxbtn.frame.size.width, 14)];
    self.wxlabel.font = [UIFont systemFontOfSize:14];
    self.wxlabel.text = @"微信登录";
    self.wxlabel.textAlignment = NSTextAlignmentCenter;
    self.wxlabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.wxlabel];

    
    if ([self.qqcode isEqualToString:@"0"] &&[self.wxcode isEqualToString:@"819c1"])
    { //QQ隐藏
        self.qqBtn.hidden=YES;
        self.qqLabel.hidden=YES;
        
        if ([WXApi isWXAppInstalled]) {
            //判断是有微信
            self.wxbtn.hidden= NO;
            self.wxbtn.hidden = NO;
            
            self.wxbtn.frame = CGRectMake(MSW / 2 - 29, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
            self.wxlabel.frame = CGRectMake(MSW / 2 - 29, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14);
        }
        else
        {
            self.wxbtn.hidden = YES;
            self.wxlabel.hidden = YES;
            self.textLabel.hidden=YES;
            
        }

    }
    
    else   if ([self.wxcode isEqualToString:@"0"]&&[self.qqcode isEqualToString:@"819c1"] ) //wx 隐藏
    {
        self.wxbtn.hidden=YES;
        self.wxlabel.hidden=YES;
        
//        self.qqBtn.frame=self.wxbtn.frame;
//        self.qqLabel.frame=self.wxlabel.frame;
        
        self.qqBtn.frame = CGRectMake(MSW / 2 - 29, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
        self.qqLabel.frame = CGRectMake(self.qqBtn.frame.origin.x, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14);
        
    }
    
    else  if ([self.qqcode isEqualToString:@"0"] && [self.wxcode isEqualToString:@"0"])
    {
        self.qqBtn.hidden=YES;
        self.qqLabel.hidden=YES;
        
        self.wxbtn.hidden=YES;
        self.wxlabel.hidden=YES;
        
        self.textLabel.hidden=YES;
    }
    
    else if ([self.qqcode isEqualToString:@"819c1"] && [self.wxcode isEqualToString:@"819c1"])
    {
        if ([WXApi isWXAppInstalled]) {
            //判断是有微信
            self.wxbtn.hidden= NO;
            self.wxbtn.hidden = NO;
            /*
             self.qqBtn.frame = CGRectMake(MSW / 2 - 29, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
             self.qqLabel.frame =  CGRectMake(self.qqBtn.frame.origin.x, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14);
             */
            
        }
        else
        {
            self.wxbtn.hidden = YES;
            self.wxlabel.hidden = YES;
            /*
             //self.qqBtn.frame = self.wxbtn.frame;
             //self.qqLabel.frame = self.wxlabel.frame;
             */
            self.qqBtn.frame = CGRectMake(MSW / 2 - 29, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
            self.qqLabel.frame = CGRectMake(self.qqBtn.frame.origin.x, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14);
        }

    }
        
 }
    else
    {
        
    }
}


//忘记密码
-(void)forgetpassword{
    
    ForgetPasswordController *registerdVC = [[ForgetPasswordController alloc]init];
    
    registerdVC.stuta=1;
    [self.navigationController pushViewController:registerdVC animated:YES];
    
    
}


#pragma mark - 第三方登陆
- (void)thirdLogin:(UIButton *)button
{
    if (button.tag == 101)  //微博
    {
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
            if (result) {
                //打印输出用户uid：
                //                DebugLog(@"uid = %@",[userInfo uid]);
                //                DebugLog(@"=====%@",[userInfo uid]);
                //打印输出用户昵称：
                //                DebugLog(@"name = %@",[userInfo nickname]);
                //打印输出用户头像地址：
                //                DebugLog(@"icon = %@",[userInfo profileImage]);
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:[userInfo uid] forKey:@"uid"];
                [dict setValue:[userInfo uid] forKey:@"openid"];
                [dict setValue:[userInfo nickname] forKey:@"nickname"];
                [dict setValue:@"3" forKey:@"loginType"];
                [dict setValue:[userInfo profileImage] forKey:@"profileImage"];
                
                [MDYAFHelp AFPostHost:APPHost bindPath:ThirdLogin postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                    DebugLog(@"===================%@",responseDic);
                    DebugLog(@"=====%@",responseDic[@"msg"]);
                    if([responseDic[@"code"] isEqualToString:@"200"])
                    {
                        NSDictionary *data = responseDic[@"data"];
                        
                        [self gotoLogin:data];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                //   DebugLog(@"授权失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
            }
        }];
    }
    else if (button.tag==102){  //QQ
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
        
        [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                          authOptions:nil
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result)
                                   {
                                       //打印输出用户uid：
                                       //                                       DebugLog(@"uid = %@",[userInfo uid]);
                                       //                                       DebugLog(@"=====%@",[userInfo uid]);
                                       //打印输出用户昵称：
                                       //                                       DebugLog(@"name = %@",[userInfo nickname]);
                                       //打印输出用户头像地址：
                                       //                                       DebugLog(@"icon = %@",[userInfo profileImage]);
                                       NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
                                       [dict2 setValue:[userInfo uid] forKey:@"uid"];
                                       [dict2 setValue:[userInfo uid] forKey:@"openid"];
                                       [dict2 setValue:[userInfo nickname] forKey:@"nickname"];
                                       [dict2 setValue:[userInfo profileImage] forKey:@"profileImage"];
                                       [dict2 setValue:@"1" forKey:@"loginType"];
                                       
                                       [MDYAFHelp AFPostHost:APPHost bindPath:ThirdLogin postParam:dict2 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                                           //                                       DebugLog(@"===================%@",responseDic);
                                           //                                       DebugLog(@"=====%@",responseDic[@"msg"]);
                                           if([responseDic[@"code"] isEqualToString:@"200"])
                                           {
                                               NSDictionary *data = responseDic[@"data"];
                                               
                                               [self gotoLogin:data];
                                           }
                                           
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];
                                       
                                   }else{
                                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                       [alert show];
                                       //                                    DebugLog(@"授权失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
                                   }
                               }];
        
    }
    else if (button.tag==103){  //微信
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error){
            if (result) {
                //打印输出用户uid：
                //                DebugLog(@"uid = %@",[userInfo uid]);
                //                DebugLog(@"=====%@",[userInfo uid]);
                //打印输出用户昵称：
                //                DebugLog(@"name = %@",[userInfo nickname]);
                //打印输出用户头像地址：
                //                DebugLog(@"icon = %@",[userInfo profileImage]);
                NSDictionary *dict =[userInfo sourceData];
                NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
                [dict2 setValue:[userInfo uid] forKey:@"uid"];
                [dict2 setValue:dict[@"unionid"] forKey:@"openid"];
                [dict2 setValue:[userInfo nickname] forKey:@"nickname"];
                [dict2 setValue:@"2" forKey:@"loginType"];
                [dict2 setValue:[userInfo profileImage] forKey:@"profileImage"];
                
                [MDYAFHelp AFPostHost:APPHost bindPath:ThirdLogin postParam:dict2 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                    DebugLog(@"===================%@",responseDic);
                    DebugLog(@"=====%@",responseDic[@"msg"]);
                    if([responseDic[@"code"] isEqualToString:@"200"])
                    {
                        NSDictionary *data = responseDic[@"data"];
                        
                        [self gotoLogin:data];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }];
                
            }else{
                if ([WXApi isWXAppInstalled]) {
                    //判断是有微信
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未安装客户端" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                
                //                DebugLog(@"授权失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
            }
            
        }];
    }
    
}
#pragma mark - 第三方登录成功
- (void)gotoLogin:(NSDictionary *)data
{
    [SVProgressHUD dismiss];
    NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
    [userDefauts  setObject:data[@"uid"] forKey:@"uid"];
    [userDefauts setObject:data[@"code"] forKey:@"code"];
    [userDefauts setObject:data[@"img"] forKey:@"profileImage"];
    
    [UserDataSingleton userInformation].uid=EncodeFormDic(data,@"uid");
    [UserDataSingleton userInformation].code=EncodeFormDic(data,@"code");
    [UserDataSingleton userInformation].img=EncodeFormDic(data,@"img");
    [UserDataSingleton userInformation].isLogin=YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 注册
- (void)registered
{
    RegisteredViewController *registerdVC = [[RegisteredViewController alloc]init];
    [self.navigationController pushViewController:registerdVC animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 登陆
- (void)login
{
    if (self.userName.text == nil || [self.userName.text length] == 0 ||self.userPassword.text == nil || [self.userPassword.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"账号或密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.userName.text forKey:@"mobile"];
        [dict setValue:self.userPassword.text forKey:@"password"];
          [MDYAFHelp AFPostHost:APPHost bindPath:Login postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
              DebugLog(@"!!!!!!!!!!!!!%@",responseDic);
              if ([responseDic[@"code"] isEqualToString:@"302"])
              {
                  [SVProgressHUD dismiss];

                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                  [alert show];
              }
              if ([responseDic[@"code"]isEqualToString:@"400"])
              {
                  [SVProgressHUD dismiss];

                  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                  [alert show];

              }
                  if ([responseDic[@"code"] isEqualToString:@"200"])
              {
                  [SVProgressHUD dismiss];

                  NSDictionary *dict = responseDic[@"data"];
                  NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
                  [userDefauts  setObject:dict[@"uid"] forKey:@"uid"];
                  [userDefauts setObject:dict[@"code"] forKey:@"code"];
                  [UserDataSingleton userInformation].isLogin = YES;
                  [UserDataSingleton userInformation].code = dict[@"code"];
                  [UserDataSingleton userInformation].uid = dict[@"uid"];

                  DebugLog(@"!!!!!!!!!!!!!!!!%@,%@",dict[@"uid"],dict[@"code"]);
                  [self.navigationController popViewControllerAnimated:YES];
              }
          
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error)
           {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
          }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [self getKongzhi];
    
//    if ([WXApi isWXAppInstalled]) {
//        //判断是有微信
//        self.wxbtn.hidden= NO;
//        self.wxbtn.hidden = NO;
//        /*
//         self.qqBtn.frame = CGRectMake(MSW / 2 - 29, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
//         self.qqLabel.frame =  CGRectMake(self.qqBtn.frame.origin.x, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14);
//         */
//        
//    }
//    else
//    {
//        self.wxbtn.hidden = YES;
//        self.wxlabel.hidden = YES;
//        /*
//         //self.qqBtn.frame = self.wxbtn.frame;
//         //self.qqLabel.frame = self.wxlabel.frame;
//         */
//        self.qqBtn.frame = CGRectMake(MSW / 2 - 29, _textLabel.frame.size.height + _textLabel.frame.origin.y + 10, 58, 58);
//        self.qqLabel.frame = CGRectMake(self.qqBtn.frame.origin.x, self.qqBtn.frame.origin.y + self.qqBtn.frame.size.height + 10, self.qqBtn.frame.size.width, 14);
//    }
    
}
#pragma mark --  第三方
-(void)getKongzhi
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"ver"];
    [dict setValue:@"2" forKey:@"device"];
    [MDYAFHelp AFPostHost:APPHost bindPath:DisanfangKongzhi postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"!!!!!!!!!!!!!%@",responseDic);
        
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dict = responseDic[@"data"];
            self.qqcode=dict[@"qqcode"];
            self.wbcode=dict[@"wbcode"];
            self.wxcode=dict[@"wxcode"];
            DebugLog(@"----%@--%@---%@",self.qqcode,self.wbcode,self.wxcode);
            
            [self createUI];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         DebugLog(@"==============%@",error);
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
