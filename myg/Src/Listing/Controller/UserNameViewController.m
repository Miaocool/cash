//
//  UserNameViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/13.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "UserNameViewController.h"

@interface UserNameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation UserNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(237, 238, 239);
    self.title = @"修改昵称";
    [self addRiButtonItem];
    [self initTextField];
}

- (void)initTextField
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,10, MSW, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    //用户名
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10,view1.frame.size.height / 2 - 20, MSW - 20, 40)];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.placeholder = @"请输入昵称";
    self.textField.delegate = self;
    [view1 addSubview:self.textField];

}

#pragma mark - 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - 导航按钮 - 确定
- (void)addRiButtonItem
{
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(determine)];
    self.navigationItem.rightBarButtonItem = btn_right;

}

#pragma mark - 点击确定按钮
- (void)determine
{
    if (self.textField.text == nil || self.textField.text.length <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"名字不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.textField.text forKey:@"username"];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        
        [MDYAFHelp AFPostHost:APPHost bindPath:ModifyName postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"======%@",responseDic[@"msg"]);
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    
    return YES;
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
