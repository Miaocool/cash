//
//  ChangeGameController.m
//  yydz
//
//  Created by mac02 on 16/4/21.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "ChangeGameController.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"


@interface ChangeGameController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,TextViewCellDelegate>{
    
    UIView       *_tablefooterView;
    CGRect       _frame;
    CGFloat      _height;

}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong)UIView * completeView;



@end

@implementation ChangeGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"游戏充值账号";
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 35)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton * completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSW-70, 0, 70, 35)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:MainColor forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:completeBtn];
    [completeBtn addTarget:self action:@selector(addChange) forControlEvents:UIControlEventTouchUpInside];
    self.completeView = view;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=self.tablefooterView;
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
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
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
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
    if (indexPath.row !=5) {
        static NSString *textCellName = @"TextFieldCell.h";
        
        TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:textCellName];
        if (!textCell) {
            textCell = [[TextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];

        }
        textCell.titleLabel.frame = CGRectMake(15, 50 / 2 - 15, 85, 30);
        textCell.textField.frame = CGRectMake(textCell.titleLabel.right +35, textCell.titleLabel.frame.origin.y, MSW - (40 + textCell.titleLabel.frame.origin.y + textCell.titleLabel.frame.size.width + 10), 30);
        
        textCell.textField.inputAccessoryView = self.completeView;
        
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
                textCell.textField.placeholder = @"请输入游戏名称";
                textCell.titleLabel.text = @"游戏名称";
                textCell.textField.tag = 102;
                textCell.textField.text = self.addressDto.game_name;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 2:
            {
                textCell.textField.placeholder = @"请输入游戏账号";
                textCell.titleLabel.text = @"游戏账号";
                textCell.textField.tag = 103;
                textCell.textField.text = self.addressDto.game_number;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }
                break;
                
            case 3:
            {
                textCell.textField.placeholder = @"请输入游戏区/服";
                textCell.titleLabel.text = @"游戏区/服";
                textCell.textField.tag = 104;
                textCell.textField.text = self.addressDto.game_zone;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }
                break;
            case 4:
            {
                textCell.textField.placeholder = @"请输入游戏昵称";
                textCell.textField.delegate = self;
                textCell.titleLabel.text = @"游戏昵称";
                textCell.textField.tag = 105;
                textCell.textField.text = self.addressDto.game_nickname;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }
                break;

            case 6:
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
        cell.type = @"1";
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

    if (indexPath.row==6){
        
        [self cancelAddress];
    }
    
}


#pragma mark - TextViewCellDelegate
- (void)textViewCell:(TextViewCell *)cell didChangeText:(NSString *)text
{
    CGSize size = [cell.textView sizeThatFits:CGSizeMake(CGRectGetWidth(cell.textView.frame), MAXFLOAT)];
    
    _height = size.height;
    self.addressDto.remark= text;
}


#pragma  mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 105:
            self.tableView.frame = CGRectMake(0, IPhone4_5_6_6P(-150, -120, 0, 0), MSW,MSH - 64);
            break;
    }
    
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tableView.frame = CGRectMake(0, 0, MSW,MSH -64);
    
    return YES;
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
            self.addressDto.game_name  = textField.text;
            break;
            
        case 103:
            self.addressDto.game_number = textField.text;
            break;
        case 104:
            self.addressDto.game_zone = textField.text;
            break;
        case 105:
            self.addressDto.game_nickname = textField.text;
            break;

    }
    
}



- (void)addSaveBtn{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:self.addressDto.game_name forKey:@"game_name"];
    [dict setValue:@"3" forKey:@"status"];
    [dict setValue:self.addressDto.idd forKey:@"id"];
    [dict setValue:self.addressDto.mobile forKey:@"mobile"];
    [dict setValue:self.addressDto.game_number forKey:@"game_number"];
    [dict setValue:self.addressDto.game_zone forKey:@"game_zone"];
    [dict setValue:self.addressDto.game_nickname forKey:@"game_nickname"];
    [dict setValue: @"1" forKey:@"type"];
    [dict setValue:self.addressDto.remark forKey:@"remark"];
    [dict setValue:@"N" forKey:@"moren"];
    [dict setValue:@"3" forKey:@"status"];
    [MDYAFHelp AFPostHost:APPHost bindPath:SaveAddress postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic[@"code"] isEqual:@"200"])
        {
            DebugLog(@"%@",responseDic);
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

#pragma mark - 删除
-(void)cancelAddress
{
    UIAlertView * alertView1 =[[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要删除该地址吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView1.tag = 1234;
    [alertView1 show];
    
}

#pragma mark - 确定删除地址
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1234)
    {
     if (buttonIndex == 1)
     {
            [self getChange];

     }
    }
    else{
        
    }
}

- (void)getChange
{
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


#pragma mark - 点击完成按钮

- (void)addChange{
    TextFieldCell *cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell.textField resignFirstResponder];
    TextFieldCell *cell1 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    [cell1.textField resignFirstResponder];
    TextFieldCell *cell2 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    [cell2.textField resignFirstResponder];
    TextFieldCell *cell3 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    [cell3.textField resignFirstResponder];
    TextFieldCell *cell4 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
    [cell4.textField resignFirstResponder];
    TextViewCell *cell5 = (TextViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
    [cell5.textView resignFirstResponder];
    
    self.tableView.frame = CGRectMake(0, 0, MSW,MSH- 64);

    
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
