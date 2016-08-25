//
//  LastStepViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//注册最后一步

#import "LastStepViewController.h"

#import "RegisteredCell.h"

@interface LastStepViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    NSTimer            *_timer;
    int                _times;
    UIButton           *_showTimeBtn;
    
    UIView *_wancheng;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *yanzheng;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *tid; //推广人的id
@end

@implementation LastStepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    
    _wancheng=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    _wancheng.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIButton*bt=[[UIButton alloc]initWithFrame:CGRectMake(MSW-70, 0, 70, 40)];
    [bt setTitle:@"完成" forState:UIControlStateNormal];
    bt.titleLabel.font=[UIFont systemFontOfSize:18];
    [bt setTitleColor:MainColor forState:0];
    //    [bt setBackgroundColor:[UIColor redColor]];
    //实现方法
    [bt addTarget:self action:@selector(wancheng) forControlEvents:UIControlEventTouchDown ];
    [_wancheng addSubview:bt];
    
    
    [self initData];
    [self initTableView];
}

- (void)initData
{
    self.dataArray = @[@"头像",@"ID",@"账号",@"昵称",@"手机号码",@"地址管理"];
    
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW,MSH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = RGBCOLOR(237, 238, 239);
    
    [self.view addSubview:self.tableView];
    
}


#pragma mark - 黄金三问  dataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    static NSString *RegisteredCellName = @"RegisteredCell.h";
    RegisteredCell *registeredCell = [tableView dequeueReusableCellWithIdentifier:RegisteredCellName];
    if(!registeredCell)
    {
        registeredCell = [[RegisteredCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegisteredCellName];
    }
    
    if (indexPath.row % 2 == 0)
    {
        static NSString *cellName = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellName];
        }
        cell.backgroundColor = RGBCOLOR(237, 238, 239);
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = @"验证码已发送到";
                cell.detailTextLabel.text = self.phoneNum;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"设置昵称";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.textColor = [UIColor blackColor];
                
                
            }
                break;
            case 4:
            {
                cell.textLabel.text = @"推荐人的ID";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.textColor = [UIColor blackColor];
                
            }
                break;
            case 6:
            {
                cell.textLabel.text = @"设置密码";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.textColor = [UIColor blackColor];
            }
                break;
        }
        return cell;
        
    }
    else
    {
        
        
        switch (indexPath.row)
        {
            case 1:
            {
                registeredCell.userInteractionEnabled=YES;
                registeredCell.textField.tag = 101;
                registeredCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                [registeredCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                if (!_showTimeBtn) {
                    _showTimeBtn.userInteractionEnabled=YES;
                    _showTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(MSW-100, 5, 90, 30)];
                    _showTimeBtn.backgroundColor = [UIColor clearColor];
                    _showTimeBtn.layer.borderColor = RGBCOLOR(232, 234, 235).CGColor;
                    _showTimeBtn.layer.borderWidth = 1;
                    _showTimeBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [_showTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [_showTimeBtn setTitle:@"90秒后重发" forState:UIControlStateNormal];
                    [_showTimeBtn removeTarget:self action:@selector(resendSms) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                
                [registeredCell addSubview:_showTimeBtn];
                
            }
                break;
            case 3:
            {
                registeredCell.textField.placeholder = @"1-20个字符";
                registeredCell.textField.tag = 102;
                registeredCell.textField.delegate = self;
                registeredCell.textField.inputAccessoryView=_wancheng;
                
                [registeredCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }
                break;
            case 5:
            {
                registeredCell.textField.placeholder = @"选填";
                registeredCell.textField.tag = 103;
                registeredCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                registeredCell.textField.delegate = self;
                registeredCell.textField.inputAccessoryView=_wancheng;
                
                [registeredCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 7:
            {
                registeredCell.textField.placeholder = @"6-20个字符，包含字母和数字";
                registeredCell.textField.delegate = self;
                registeredCell.textField.secureTextEntry = YES;
                registeredCell.textField.tag = 104;
                registeredCell.textField.inputAccessoryView=_wancheng;
                
                [registeredCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(5, 150 + 120 + 10+100, MSW - 10, 40);
                btn.backgroundColor = MainColor;
                btn.layer.cornerRadius = 5;
                [btn setTitle:@"注册" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(registered:) forControlEvents:UIControlEventTouchUpInside];
                [self.tableView addSubview:btn];
                
            }
                break;
        }
        return registeredCell;
    }
    
}

-(void)resendSms
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.phoneNum forKey:@"mobile"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Registered postParam:dic getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"%@－－－－%@",responseDic,responseDic[@"msg"]);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            [self starrTimer];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [self stopTimer];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"sssssss%@",error);
    }];
    
}

-(void)starrTimer{
    _times = 90;
    [_showTimeBtn setTitle:@"90秒后重发" forState:UIControlStateNormal];
    [_showTimeBtn removeTarget:self action:@selector(resendSms) forControlEvents:UIControlEventTouchUpInside];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
}

-(void)onTimer{
    _times --;
    //  多少秒后重发
    [_showTimeBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",_times] forState:UIControlStateNormal];
    [_showTimeBtn removeTarget:self action:@selector(resendSms) forControlEvents:UIControlEventTouchUpInside];
    if (_times == 0) {
        [self stopTimer];
        // 重新发送
        [_showTimeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_showTimeBtn addTarget:self action:@selector(resendSms) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if((textField.tag==103)) {
        //        case 104:
        self.tableView.contentOffset=CGPointMake(0, IPhone4_5_6_6P(170, 50, 0, 0));
        //            break;
    }else if(textField.tag==104)
    {
        self.tableView.contentOffset=CGPointMake(0, IPhone4_5_6_6P(200, 120, 0, 0));
    }else if (textField.tag==102){
        self.tableView.contentOffset=CGPointMake(0, IPhone4_5_6_6P(80, 0, 0, 0));
        
    }
    else{
        
        self.tableView.contentOffset=CGPointMake(0, 0);
        
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tableView.contentOffset=CGPointMake(0, 0);
    
    return YES;
}


#pragma mark - textField 监听事件
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.tag == 101)
    {
        self.yanzheng = textField.text;
    }
    else if (textField.tag == 102)
    {
        self.name = textField.text;
    }
    else if (textField.tag==103)
    {
        self.tid=textField.text;
    }
    if (textField.tag == 104)
    {
        self.password = textField.text;
    }
    
    DebugLog(@"%@",textField.text);
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisteredCell *cell1 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    [cell1.textField resignFirstResponder];
    RegisteredCell *cell3 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    [cell3.textField resignFirstResponder];
    RegisteredCell *cell5 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
    [cell5.textField resignFirstResponder];
    RegisteredCell *cell7 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:7 inSection:0]];
    [cell7.textField resignFirstResponder];
    
    
    
    self.tableView.contentOffset=CGPointMake(0, 0);
    
    DebugLog(@"===%ld====%ld",(long)indexPath.section,(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row % 2 == 0)
    {
        DebugLog(@"1111");
    }
    else
    {
        DebugLog(@"22222");
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0)
    {
        return 50;
    }
    else{
        
        return 40;
    }
    
    
}


#pragma mark - 注册请求
- (void)registered:(UIButton *)button
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.yanzheng forKey:@"code"];
    [dict setValue:self.name forKey:@"nickname"];
    [dict setValue:self.password forKey:@"password"];
    [dict setValue:self.phoneNum forKey:@"mobile"];
    [dict setValue:self.tid forKey:@"tid"];
    DebugLog(@"%@",dict[@"code"]);
    DebugLog(@"%@",dict[@"nickname"]);
    DebugLog(@"%@",dict[@"password"]);
    DebugLog(@"%@",dict[@"mobile"]);
    //        [MDYAFHelp AFGetHost:APPHost bindPath:RegisteredData param:dict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
    //            DebugLog(@"%@",responseDic);
    //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //            DebugLog(@"%@",error);
    //        }];
    [MDYAFHelp AFPostHost:APPHost bindPath:RegisteredData postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"!!!!!!!%@",responseDic);
        
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self login];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        NSString *str = [[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding];
        DebugLog(@"str:===========%@",str);
    }];
    
    
    
    //       [dic setValue:self.textField.text forKey:@"mobile"];
    //     DebugLog(@"!!!!!!!!!!!%@",self.textField.text);
    
}

#pragma mark - 登陆
- (void)login
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.phoneNum forKey:@"mobile"];
    [dict setValue:self.password forKey:@"password"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Login postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"!!!!!!!!!!!!!%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"302"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        if ([responseDic[@"code"]isEqualToString:@"400"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:responseDic[@"msg"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dict = responseDic[@"data"];
            NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
            [userDefauts  setObject:dict[@"uid"] forKey:@"uid"];
            [userDefauts setObject:dict[@"code"] forKey:@"code"];
            [UserDataSingleton userInformation].isLogin = YES;
            [UserDataSingleton userInformation].code = dict[@"code"];
            [UserDataSingleton userInformation].uid = dict[@"uid"];
            //                  self.userName.text=dict[@"mobile"];
            DebugLog(@"!!!!!!!!!!!!!!!!%@,%@",dict[@"uid"],dict[@"code"]);
            for (UIViewController *temp in self.navigationController.viewControllers)
            {
                if ([temp isKindOfClass:[LoginViewController class]])
                {
                    // self.tabBarController.selectedIndex = 4;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         DebugLog(@"==============%@",error);
     }];
    
    
    
    
}
-(void)wancheng{
    RegisteredCell *cell1 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    [cell1.textField resignFirstResponder];
    RegisteredCell *cell3 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    [cell3.textField resignFirstResponder];
    RegisteredCell *cell5 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
    [cell5.textField resignFirstResponder];
    RegisteredCell *cell7 = (RegisteredCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:7 inSection:0]];
    [cell7.textField resignFirstResponder];
    
    
    
    self.tableView.contentOffset=CGPointMake(0, 0);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self starrTimer];
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
