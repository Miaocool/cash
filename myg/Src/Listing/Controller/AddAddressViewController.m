//
//  AddAddressViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AddAddressViewController.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"
#import "ProvineDto.h"


#define Margin 10
@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,TextViewCellDelegate>{
    
    UIView *_cover;        //遮罩
    NSString *_Province;   //省
    NSString *_city;       //市
    NSString *_toun;       //地区
    NSString *_Street;     //详细地址
    NSString *_remark;    //买家备注
    
    NSString *_person;     //收货人
    NSString *_phone;     //手机
    NSString *_type;      //类型 1修改地址 2新增地址
    NSString      *select;   //判断默认类型
    UIView        *_tablefooterView;
    NSString *morenId; //默认北京省id
    NSString *morenShiId; //默认北京市id
    NSString *shengid;   //添加默认id
    NSString *shiid;
    
    CGRect _frame;
    CGFloat _height;
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) UISwitch *mySwitch; //默认地址开关
@property (nonatomic, strong) NSDictionary *dataDict;

//view
@property (strong, nonatomic) UIPickerView *myPicker;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UILabel *lbProvince;  //省
@property (strong, nonatomic) UILabel *lbCity;      //市
@property (strong, nonatomic) UILabel *lbTown;      //区

@property (strong, nonatomic) UITextView * tvRemark;  //备注

@property (strong, nonatomic) UIButton *canceBtn;
@property (strong, nonatomic) UIButton *sureBtn;
//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@property (nonatomic, strong)TextFieldCell *textCell;
@property (nonatomic, strong) UIView * completeView;

//市
@property (nonatomic, strong)NSMutableArray * aArray2;
//县
@property (nonatomic, strong)NSMutableArray * cArray3;
//省
@property (nonatomic, strong)NSMutableArray * dArray3;
//市id
@property (nonatomic, strong)NSMutableArray * shiidArray2;
@property (nonatomic, strong)ProvineDto *proModel;
//省id
@property (nonatomic, strong)NSMutableArray * shengidArray;

@end

@implementation AddAddressViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"实物收货地址";
    self.dataArray = [NSMutableArray array];
    self.aArray2= [NSMutableArray array];
    self.shengidArray = [NSMutableArray array];
    [self initData];
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


- (UIView *)tablefooterView
{
    if (!_tablefooterView) {
        _tablefooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 90)];
        _tablefooterView.backgroundColor = [UIColor clearColor];
        _tablefooterView.tag = 1;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, MSW, 50)];
        bgView.backgroundColor =  RGBCOLOR(242, 242, 242);;
        [_tablefooterView addSubview:bgView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, MSW-20, 40)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = MainColor.CGColor;
        btn.layer.cornerRadius=5;
        btn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=MainColor;
        [_tablefooterView addSubview:btn];
        
    }
    return _tablefooterView;
}


#pragma mark -保存
- (void)add
{
//    DebugLog(@"*****%@",_person);
    if ( [_person isEqualToString:@""] || [_phone isEqualToString:@""] ||[_Street isEqualToString:@""]) {
 
         UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil message:@"必填信息不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_Province forKey:@"sheng"];
    [dict setValue:_city forKey:@"shi"];
    [dict setValue:_toun forKey:@"xian"];
    [dict setValue:_Street forKey:@"jiedao"];
    [dict setValue:_person forKey:@"shouhuoren"];
    [dict setValue:_phone forKey:@"mobile"];
    [dict setValue:@"" forKey:@"id"];
    [dict setValue:_remark forKey:@"remark"];
    [dict setValue:select forKey:@"moren"];
    [dict setValue:@"2" forKey:@"type"];
    [dict setValue:@"1" forKey:@"status"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:SaveAddress postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
//        DebugLog(@"======%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            DebugLog(@"=====%@",dict);
            [SVProgressHUD dismiss];

            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([responseDic[@"code"] isEqualToString:@"400"]){
            [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
        [alert show];
      }];
    }
}



- (void)initData
{
    self.dataArray = [NSMutableArray array];
    
}
#pragma arguments - 创建表UITableView
- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [self tablefooterView];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - init view
- (void)initView {
    [self getPickerData];

    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    [self.view addSubview:self.maskView];
    
    self.pickerBgView=[[UIView alloc]initWithFrame:CGRectMake(0, MSH-300, MSW, 300)];
    self.pickerBgView.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.pickerBgView.alpha=1;
    [self.maskView addSubview:self.pickerBgView];
    
    self.canceBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    self.canceBtn.backgroundColor=[UIColor clearColor];
    [self.canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.canceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.canceBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.canceBtn];
    
    self.sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(MSW-100, 0, 100, 50)];
    self.sureBtn.backgroundColor=[UIColor whiteColor];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.sureBtn];
    
    self.myPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, MSW, self.pickerBgView.height-50)];
    self.myPicker.delegate=self;
    self.myPicker.backgroundColor=[UIColor whiteColor];
    [self.pickerBgView addSubview:self.myPicker];
    
    }

-(void)cancel{
    [self hideMyPicker];
}
-(void)sure{
    //在点击pickView上的确定按钮的时候  把选择pickView上的第几行的数据给传递给_lbProvince.text
    _lbProvince.text = [self.dataArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    _lbCity.text = [self.aArray2 objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    

    _Province=[self.dataArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    _city=[self.aArray2 objectAtIndex:[self.myPicker selectedRowInComponent:1]];
   
    if (self.cArray3.count == 0) {
        _lbTown.text = @"";
        _toun = @"";
    }
    else{
        _lbTown.text = [self.cArray3 objectAtIndex:[self.myPicker selectedRowInComponent:2]];
        _toun=[self.cArray3 objectAtIndex:[self.myPicker selectedRowInComponent:2]];
    }
    
   [self hideMyPicker];

}
#pragma mark - get data
- (void)getPickerData {
    
    [self.aArray2 removeAllObjects];
    [self.cArray3 removeAllObjects];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:ThirdListCity postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                DebugLog(@"省列表-->%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dict = responseDic[@"data"];
            NSArray *array = dict[@"sheng"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ProvineDto *model = [[ProvineDto alloc]initWithDictionary:obj];
                //                DebugLog(@"6666%@",obj);
                [self.dataArray addObject:model.name];
                [self.shengidArray addObject:model.Id];
                //                DebugLog(@"---%@",[self.dataArray objectAtIndex:0]);
                //                NSInteger i = 0;
                //                for (NSString *  province in self.shengidArray) {
                //
                //                    if ([province isEqualToString:self.model.sheng]) {
                //                        [self.myPicker selectRow:i inComponent:0 animated:YES];
                //                    }
                //                    i++;
                //
                //
                //                }
            }];
            //获取一遍市列表
            [self getProvince:[self.shengidArray objectAtIndex:0]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }
        [self.myPicker reloadAllComponents];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
    }];
    
}

#pragma mark -获取市id
- (void)getProvince:(NSString *)idd{
    
    [self.aArray2 removeAllObjects];
    [self.cArray3 removeAllObjects];
    [self.shiidArray2 removeAllObjects];
    morenId=idd;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:morenId forKey:@"shengid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:ThirdListCity postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"市列表-->%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dict = responseDic[@"data"];
            NSArray *array = dict[@"shi"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ProvineDto *model = [[ProvineDto alloc]initWithDictionary:obj];
                // DebugLog(@"6666%@",obj);
                [self.aArray2 addObject:model.name];
                [self.shiidArray2 addObject:model.Id];
                DebugLog(@"city->%@",self.aArray2);
                //                DebugLog(@"--****->%@",self.shiidArray2);
            }];
//            self.rememberCityArray = self.shiidArray2;
            //获取一遍县列表
            [self getTown:[self.shengidArray objectAtIndex:0] iddd:[self.shiidArray2 objectAtIndex:0]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }
        [self.myPicker reloadComponent:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
    }];
    
}

#pragma mark -获取县id
- (void)getTown:(NSString *)idd iddd:(NSString *)iddd{
    
    [self.cArray3 removeAllObjects];
    [self.dArray3 removeAllObjects];
//    [self.rememberTownArray removeAllObjects];
    if (IsStrEmpty(idd))
    {
        morenId=idd;
    }
    morenShiId=iddd;
    
    //    DebugLog(@"idd==>=iddd=>%@%@",idd,iddd);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:morenId forKey:@"shengid"];
    [dict setValue:morenShiId forKey:@"shiid"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:ThirdListCity postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        //        DebugLog(@"县列表-->%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dict = responseDic[@"data"];
            NSArray *array = dict[@"xian"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                ProvineDto *model = [[ProvineDto alloc]initWithDictionary:obj];
                // DebugLog(@"6666%@",obj);
                [self.cArray3 addObject:model.name];
                [self.dArray3 addObject:model.Id];
                //                DebugLog(@"---》%@",model.idd );
            }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }
        [self.myPicker reloadComponent:2];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
    }];
    
}

//创建pickview
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataArray.count;
    } else if (component == 1) {
        return self.aArray2.count;
    } else {
        return self.cArray3.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.dataArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.aArray2 objectAtIndex:row];
    } else {
        return [self.cArray3 objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self getProvince:[self.shengidArray objectAtIndex:row]];
        shengid = [self.shengidArray objectAtIndex:row];
        [pickerView reloadComponent:1];
        }
     if (component == 1) {
            [self getTown:shengid iddd:[self.shiidArray2 objectAtIndex:row]];
            shiid = [self.shiidArray2 objectAtIndex:row];
         [pickerView reloadComponent:2];
        }

    [pickerView reloadAllComponents];
}

- (void)hideMyPicker {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}



#pragma mark -  dataSource 创建表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 6) {
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
    
    if (indexPath.row == 0 || indexPath.row ==1 || indexPath.row == 5 )
    {
        //复用的方式就未注册过的方式
        static NSString *textCellName = @"TextFieldCell.h";
        
        TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:textCellName];
        if (!textCell)
        {
            textCell = [[TextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];
        }
        textCell.textField.inputAccessoryView = self.completeView ;
        self.textCell = textCell;
        switch (indexPath.row)
        {
            case 0:
            {
                textCell.textField.placeholder = @"请输入收件人";
                textCell.titleLabel.text = @"收件人";
                textCell.textField.tag = 101;
                textCell.textField.inputAccessoryView = self.completeView;
                _person=textCell.textField.text;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
                
            case 1:
            {
            textCell.textField.placeholder = @"请输入手机号码";
            textCell.titleLabel.text = @"手机号码";
            textCell.textField.tag = 102;
            textCell.textField.keyboardType = UIKeyboardTypeNumberPad;
            _phone=textCell.textField.text;
            [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 5:
            {  
                textCell.textField.placeholder = @"请输入详细地址";
                textCell.titleLabel.text = @"详细地址";
                textCell.textField.tag = 103;
                textCell.textField.delegate = self;
                _Street=textCell.textField.text;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }
                break;

            default:
                break;
        }
        return textCell;
        
    }else if (indexPath.row == 6){
        
        static NSString *textCellName = @"TextViewCell";
        
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textCellName];
        
        cell = [[TextViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];
        cell.delegate = self;
        cell.type = @"1";
        cell.textView.inputAccessoryView = self.completeView ;
        cell.titleLabel.text = @"备注";
        _remark =cell.textView.text;
        return cell;
    }
    
    else
    {
        static NSString *cellName = @"CELL";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MSW - 12 - 10, 50 / 2 - 5, 12, 10)];
        imageView.image = [UIImage imageNamed:@"triangle"];

        
        self.mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MSW - 51 - 10, 50 / 2 - 15, 51, 31)];
        //状态   开启  还是关闭
        self.mySwitch.on = [UserDataSingleton userInformation].isSwitch;
        [self.mySwitch addTarget:self action:@selector(switchBtnTouched:) forControlEvents:UIControlEventValueChanged];

        switch (indexPath.row)
        {
            case 2:
            {
                cell.textLabel.text = @"省份";
                self.lbProvince=[[UILabel alloc]initWithFrame:CGRectMake(124, 0, MSW-40 - 124, cell.height)];
                self.lbProvince.backgroundColor=[UIColor clearColor];
                self.lbProvince.backgroundColor=[UIColor clearColor];
                self.lbProvince.textColor = [UIColor blackColor];
                self.lbProvince.text = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
                [cell addSubview:self.lbProvince];
                [cell addSubview:imageView];
                
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"城市";
                self.lbCity=[[UILabel alloc]initWithFrame:CGRectMake(124, 0, MSW-40 - 124, cell.height)];
                self.lbCity.backgroundColor=[UIColor clearColor];
                self.lbCity.textColor = [UIColor blackColor];
                self.lbCity.text =[self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
                [cell addSubview:self.lbCity];
                [cell addSubview:imageView];


            }
                break;
            case 4:
            {
                cell.textLabel.text = @"地区";
                self.lbTown=[[UILabel alloc]initWithFrame:CGRectMake(124, 0, MSW-40 - 124, cell.height)];
                self.lbTown.backgroundColor=[UIColor clearColor];
                self.lbTown.textColor = [UIColor blackColor];
                self.lbTown.text = [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:2]] ;
                [cell addSubview:self.lbTown];
                [cell addSubview:imageView];


            }
                break;
            case 7:
            {
                cell.textLabel.text = @"设置默认地址";
                [cell addSubview:self.mySwitch];
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
    
}

#pragma mark - switch值改变
-(void)switchBtnTouched:(id)sender
{
   UISwitch *btn = sender;
   BOOL isButtonOn = [btn isOn];
    if(isButtonOn)
    {
        select = @"Y";
        DebugLog(@"开启");
    }
    else
    {
        select=@"N";
        DebugLog(@"关闭");
    }
}


#pragma mark - 记录用户收件人 电话 地址
- (void)textFieldDidChange:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 101:
            _person = textField.text;
            break;
        case 102:
          _phone  =  textField.text;
            break;
        case 103:
           _Street = textField.text;
            break;
    }

}


#pragma mark - 点击完成按钮

- (void)addChange{
    TextFieldCell *cell1 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell1.textField resignFirstResponder];
    TextFieldCell *cell2 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    [cell2.textField resignFirstResponder];
    TextFieldCell *cell5 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
    [cell5.textField resignFirstResponder];
    TextViewCell *cell6 = (TextViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:6 inSection:0]];
    [cell6.textView resignFirstResponder];
    
    self.tableView.frame = CGRectMake(0, 0, MSW,MSH- 64);


    
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"====%ld",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==2 ||indexPath.row==3 ||indexPath.row==4) {
        
        TextFieldCell *cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [cell.textField resignFirstResponder];
        TextFieldCell *cell2 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell2.textField resignFirstResponder];
        
        TextFieldCell *cell5 = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
        [cell5.textField resignFirstResponder];
        TextViewCell *cell6 = (TextViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:6 inSection:0]];
        [cell6.textView resignFirstResponder];
       
        [self initView];
        [self.view addSubview:self.maskView];
        [self.maskView addSubview:self.pickerBgView];
        
        [UIView animateWithDuration:0.3 animations:^{
        self.pickerBgView.backgroundColor= [[UIColor whiteColor]colorWithAlphaComponent:1];
        self.myPicker.backgroundColor= [[UIColor whiteColor]colorWithAlphaComponent:1];

        }];
       
    }
    
}

#pragma mark - TextViewCellDelegate
- (void)textViewCell:(TextViewCell *)cell didChangeText:(NSString *)text
{
    CGSize size = [cell.textView sizeThatFits:CGSizeMake(CGRectGetWidth(cell.textView.frame), MAXFLOAT)];

    _height = size.height;
    _remark= text;
}



#pragma  mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.tableView.frame = CGRectMake(0, IPhone4_5_6_6P(-150, -120, 0, 0), MSW,MSH - 64);
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tableView.frame = CGRectMake(0, 0, MSW, MSH-64);
    
    return YES;
}


#pragma mark - 懒加载县
- (NSMutableArray *)cArray3{
    if (_cArray3 == nil) {
        _cArray3 = [NSMutableArray array];
    }
    return _cArray3;
}

#pragma mark - 懒加载市id
- (NSMutableArray *)shiidArray2{
    if (_shiidArray2 == nil) {
        _shiidArray2 = [NSMutableArray array];
    }
    return _shiidArray2;
}

#pragma mark - 懒加载在省id
- (NSMutableArray *)shengidArray{
    if (_shengidArray == nil) {
        _shengidArray = [NSMutableArray array];
    }
    return _shengidArray;
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
