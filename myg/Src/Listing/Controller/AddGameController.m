//
//  AddGameController.m
//  yydz
//
//  Created by mac02 on 16/4/20.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "AddGameController.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"



@interface AddGameController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TextViewCellDelegate>
{
    UIView    *_tablefooterView;
    CGRect    _frame;
    CGFloat   _height;

}

@property(nonatomic,strong)UITableView *tableView;


@property (nonatomic, strong) NSString * phoneStr;
@property (nonatomic, strong) NSString * gameNameStr;
@property (nonatomic, strong) NSString * gameNumStr;
@property (nonatomic, strong) NSString * gameQuStr;
@property (nonatomic, strong) NSString * gameNickStr;
@property (nonatomic, strong) NSString * remarkStr;

@property (nonatomic, strong) UIView * completeView;

@end

@implementation AddGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"游戏充值账号";
    [self initTableView];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
}

#pragma arguments - 创建表UITableView
- (void)initTableView
{
    [self tablefooterView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [self tablefooterView];
    [self.view addSubview:self.tableView];
    
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
        
        UILabel * explainLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, MSW , 30)];
        explainLable.text = @"充值号码填写用于手机话费、Q币等虚拟奖品中奖后的充值,最多添加1个";
        explainLable.font = [UIFont systemFontOfSize:11];
        explainLable.textColor = [UIColor lightGrayColor];
        explainLable.numberOfLines = 0;
        explainLable.textAlignment = NSTextAlignmentCenter;
        [_tablefooterView addSubview:explainLable];
        
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
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        if (_height<40) {
            return 50;
            
        }else{
            return  _height+10;
            
        }
    }else{
        return 50;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=5) {
        static NSString *textCellName = @"TextFieldCell.h";

        TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:textCellName];
        if (textCell == nil) {
            textCell = [[TextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];

        }
        textCell.titleLabel.frame = CGRectMake(15, 50 / 2 - 15, 85, 30);
        textCell.textField.frame = CGRectMake(textCell.titleLabel.right +35, textCell.titleLabel.frame.origin.y, MSW - (40 + textCell.titleLabel.frame.origin.y + textCell.titleLabel.frame.size.width + 10), 30);
        
        textCell.textField.inputAccessoryView = self.completeView ;
        
        
        switch (indexPath.row)
        {
            case 0:
            {
                textCell.textField.placeholder = @"请输入联系方式";
                textCell.titleLabel.text = @"联系方式";
                textCell.textField.tag = 101;
                _phoneStr=textCell.textField.text;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
                
            case 1:
            {
                textCell.textField.placeholder = @"请输入游戏名称";
                textCell.titleLabel.text = @"游戏名称";
                textCell.textField.tag = 102;
                textCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                _gameNameStr=textCell.textField.text;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 2:
            {
                textCell.textField.placeholder = @"请输入游戏账号";
                textCell.titleLabel.text = @"游戏账号";
                textCell.textField.tag = 103;
                _gameNumStr=textCell.textField.text;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }
                break;
                
            case 3:
            {
                textCell.textField.placeholder = @"请输入游戏区/服";
                textCell.titleLabel.text = @"游戏区/服";
                textCell.textField.tag = 104;
                _gameQuStr=textCell.textField.text;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }
                break;
            case 4:
            {
                textCell.textField.placeholder = @"请输入游戏昵称";
                textCell.textField.delegate = self;
                textCell.titleLabel.text = @"游戏昵称";
                textCell.textField.tag = 105;
                _gameNickStr=textCell.textField.text;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
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
        cell.textView.inputAccessoryView = self.completeView ;
        cell.titleLabel.text = @"备注";
        cell.type = @"1";
        _remarkStr =cell.textView.text;
        
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)addSaveBtn{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_gameNameStr forKey:@"game_name"];
    [dict setValue:@"3" forKey:@"status"];
    [dict setValue:_phoneStr forKey:@"mobile"];
    [dict setValue:_gameNumStr forKey:@"game_number"];
    [dict setValue:_gameQuStr forKey:@"game_zone"];
    [dict setValue:_gameNickStr forKey:@"game_nickname"];
    [dict setValue: @"2" forKey:@"type"];
    [dict setValue:_remarkStr forKey:@"remark"];
    [dict setValue:@"N" forKey:@"moren"];
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

#pragma mark - 记录用户收件人 电话 地址
- (void)textFieldDidChange:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 101:
            _phoneStr = textField.text;
            break;
            
        case 102:
            _gameNameStr  = textField.text;
            break;
            
        case 103:
            _gameNumStr = textField.text;
            break;
        case 104:
            _gameQuStr = textField.text;
            break;
        case 105:
            _gameNickStr = textField.text;
            break;
    }
}


#pragma mark - TextViewCellDelegate
- (void)textViewCell:(TextViewCell *)cell didChangeText:(NSString *)text
{
    CGSize size = [cell.textView sizeThatFits:CGSizeMake(CGRectGetWidth(cell.textView.frame), MAXFLOAT)];
    
    _height = size.height;
    _remarkStr= text;
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
    self.tableView.frame = CGRectMake(0, 0, MSW,MSH-64);
    
    return YES;
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
