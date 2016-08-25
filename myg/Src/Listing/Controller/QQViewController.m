//
//  QQViewController.m
//  yydz
//
//  Created by mac02 on 16/4/21.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "QQViewController.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"

@interface QQViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TextViewCellDelegate>
{
    UIView        *_tablefooterView;
    CGFloat       _height;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) UIView * completeView;


@end

@implementation QQViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值账号";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [self tablefooterView];
    [self.view addSubview:self.tableView];
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 35)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton * completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSW-70, 0, 70, 35)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:MainColor forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:completeBtn];
    [completeBtn addTarget:self action:@selector(addChange) forControlEvents:UIControlEventTouchUpInside];
    self.completeView = view;
}

- (UIView *)tablefooterView
{
    if (!_tablefooterView) {
        _tablefooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 100)];
        _tablefooterView.backgroundColor = [UIColor clearColor];
        _tablefooterView.tag = 1;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, MSW, 50)];
        bgView.backgroundColor =  RGBCOLOR(242, 242, 242);;
        [_tablefooterView addSubview:bgView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 50, MSW-20, 40)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = MainColor.CGColor;
        btn.layer.cornerRadius=5;
        btn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addSaveBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=MainColor;
        [_tablefooterView addSubview:btn];
        
    }
    return _tablefooterView;
}

#pragma mark -  dataSource 创建表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        if (_height<40) {
            return 50;
            
        }else{
            return  _height+10;
            
        }
    }
    return 50;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row !=2) {
        static NSString *textCellName = @"TextFieldCell.h";
        
        TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:textCellName];
        
        textCell = [[TextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];
        textCell.titleLabel.frame = CGRectMake(15, 50 / 2 - 15, 85, 30);
        textCell.textField.frame = CGRectMake(textCell.titleLabel.right +35, textCell.titleLabel.frame.origin.y, MSW - (40 + textCell.titleLabel.frame.origin.y + textCell.titleLabel.frame.size.width + 10), 30);
        
        
        switch (indexPath.row)
        {
            case 0:
            {
                textCell.textField.placeholder = @"请输入联系方式";
                textCell.titleLabel.text = @"联系方式";
                textCell.textField.tag = 101;
                textCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                textCell.textField.text = self.addressDto.mobile;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
                
            case 1:
            {
                textCell.textField.placeholder = @"请输入QQ号码";
                textCell.titleLabel.text = @"QQ号码";
                textCell.textField.tag = 102;
                textCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                textCell.textField.text = self.addressDto.qq;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;

            case 3:
            {
                textCell.titleLabel.text = @"删除地址";
                textCell.titleLabel.textColor=MainColor;
                textCell.textField.hidden = YES;
                
            }
                break;
                
            default:
                break;
        }
        return textCell;
    }else{
        static NSString *textCellName = @"TextViewCell";
        
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellName];
        
        cell = [[TextViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];
        cell.delegate = self;
        cell.type = @"2";
        cell.textView.inputAccessoryView = self.completeView ;
        cell.titleLabel.text = @"备注";
        cell.textView.text = self.addressDto.remark;
        
        CGRect frame = cell.textView.frame;
        CGSize size = [cell.textView sizeThatFits:CGSizeMake(CGRectGetWidth(cell.textView.frame), MAXFLOAT)];
        frame.size.height = size.height;
        cell.textView.frame = frame;
        _height = size.height;
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TextFieldCell *cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textField resignFirstResponder];
    if (indexPath.row==3){
        
        [self cancelAddress];
    }
    
}


#pragma mark - 记录用户收件人 电话 地址
- (void)textFieldDidChange:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 101:
            self.addressDto.mobile = textField.text;
            break;
            
        case 102:
            self.addressDto.qq  = textField.text;
            break;
            
    }
    
}



- (void)addSaveBtn
{
    if ( IsStrEmpty(self.addressDto.qq)  ||IsStrEmpty(self.addressDto.mobile)) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"必填信息不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else{
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict setValue:self.addressDto.mobile forKey:@"mobile"];
        [dict setValue:@"2" forKey:@"status"];
        [dict setValue:self.addressDto.idd forKey:@"id"];
        [dict setValue:self.addressDto.remark forKey:@"remark"];
        [dict setValue:self.addressDto.qq forKey:@"qq"];
        [dict setValue:@"1" forKey:@"type"];
        [MDYAFHelp AFPostHost:APPHost bindPath:SaveAddress postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"-----%@",responseDic);
            if ([responseDic[@"code"] isEqualToString:@"200"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    }
}

#pragma mark - 删除
-(void)cancelAddress
{
    UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要删除该地址吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1234;
    [alertView show];
    
}

 #pragma mark 确认弹话框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    {
        if (alertView.tag ==1234)
        {
            // buttonIndex ==1 用户选择了去兑换
            if (buttonIndex == 1)
            {
                [self getExchange];
            }
        }
        
    }
}

- (void)getExchange{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:self.addressDto.idd forKey:@"id"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:DeleteAddress postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}

#pragma mark - TextViewCellDelegate
- (void)textViewCell:(TextViewCell *)cell didChangeText:(NSString *)text
{
    CGSize size = [cell.textView sizeThatFits:CGSizeMake(CGRectGetWidth(cell.textView.frame), MAXFLOAT)];
    
    _height = size.height;
    self.addressDto.remark= text;
}



#pragma mark - 点击完成按钮

- (void)addChange{
    TextFieldCell *cell1 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell1.textField resignFirstResponder];
    TextFieldCell *cell2 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    [cell2.textField resignFirstResponder];
    TextViewCell *cell3 = (TextViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    [cell3.textView resignFirstResponder];
    
    
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
