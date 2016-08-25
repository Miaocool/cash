//
//  AddWishViewController.m
//  myg
//
//  Created by mac03 on 16/3/30.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "AddWishViewController.h"
#import "LoginViewController.h"

@interface AddWishViewController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField             *_phoneFiled;    //联系方式
    UITextView              *_feedBackView;   //意见textView
    UITapGestureRecognizer *singleRecognizer;
    
}

@end

@implementation AddWishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加心愿清单";
    self.view.backgroundColor=RGBCOLOR(242, 242, 242);
    
    [self initialize];
    
    //    添加手势隐藏键盘
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
}

- (void)initialize
{
    
    //UITextField背景

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20, 20, MSW-40, 40)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    
    _phoneFiled=[[UITextField alloc]initWithFrame:CGRectMake(5, 0, view.width-10, 40)];
    _phoneFiled.clearButtonMode = UITextFieldViewModeAlways;
    _phoneFiled.delegate=self;
    _phoneFiled.borderStyle=UITextAutocorrectionTypeDefault;
    _phoneFiled.placeholder = @"输入任何您希望上架的奖品";
    [view addSubview:_phoneFiled];
    
    
    UILabel *tishiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, view.bottom+10, view.width, 40)];
    tishiLab.text=@"如:Nike背包、格力牙刷、牙膏";
    tishiLab.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tishiLab];
    
    //意见UITextView
    _feedBackView = [[UITextView alloc] initWithFrame:CGRectMake(20,  tishiLab.bottom+10, MSW-40, IPhone4_5_6_6P(80,100,130,130))];
    _feedBackView.delegate = self;
    _feedBackView.text=@"您还可以附上商品链接(可不填)";
    _feedBackView.textColor=RGBCOLOR(218, 218, 218);
    _feedBackView.font=[UIFont systemFontOfSize:15];
    _feedBackView.textColor=[UIColor lightGrayColor];
    _feedBackView.returnKeyType = UIReturnKeyDone;
    _feedBackView.layer.borderWidth = 1.0;
    _feedBackView.backgroundColor = [UIColor whiteColor];
    _feedBackView.layer.borderColor = RGBCOLOR(206,207,208).CGColor;
    [self.view addSubview:_feedBackView];
    
    //提交button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, _feedBackView.bottom + 20, MSW-40, 35);
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    btn.backgroundColor = MainColor;
    btn.layer.borderColor = MainColor.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 5;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

#pragma arguments -提交
- (void)commitAction
{

    if (IsStrEmpty(_phoneFiled.text)) {
        //  反馈不能为空
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        //return;
    }else if ([UserDataSingleton userInformation].isLogin==NO){
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        
    
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict setValue:_phoneFiled.text forKey:@"title"];
            
        [dict setValue:_feedBackView.text forKey:@"content"];
            
        [MDYAFHelp AFPostHost:APPHost bindPath:tianjiaWish postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"======%@",responseDic[@"msg"]);
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
//                [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
        
    }
    
    
}

//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom{
    [_feedBackView resignFirstResponder];
}

#pragma  mark -UITextView的编辑
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:_feedBackView.text]) {
        textView.text = @"";
        textView.textColor=[UIColor blackColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_feedBackView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"";
    }
    [_feedBackView resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_phoneFiled)
    {
        [textField resignFirstResponder];
    }
    return YES;
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
