//
//  AlterAddressViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/26.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AlterAddressViewController.h"
#import "TextFieldCell.h"
#import "AddressDto.h"
#import "TextViewCell.h"
#import "ProvineDto.h"

@interface AlterAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,TextViewCellDelegate>{
    int           _index;
    int           _indexCity;
    int           _indexTown;
    NSString      *_addressId;   //地址自增id
    UIView        *_cover;        //遮罩
    NSString      *_Province;   //省
    NSString      *_city;       //市
    NSString      *_toun;       //地区
    NSString      *_Street;     //详细地址
    
    NSString      *_person;     //收货人
    NSString      *_phone;     //手机
    NSString      *_type;      //类型 1修改地址 2新增地址
    NSString      *_select;    //判断默认类型
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

//view
@property (strong, nonatomic) UIPickerView *myPicker; //pickView
@property (strong, nonatomic) UIView *pickerBgView; //放置pickView的view
@property (strong, nonatomic) UIView *maskView;  //遮罩

@property (strong, nonatomic) UILabel *lbProvince;  //省button
@property (strong, nonatomic) UILabel *lbCity;      //市button
@property (strong, nonatomic) UILabel *lbTown;      //区button

@property (strong, nonatomic) UIButton *canceBtn;    //取消
@property (strong, nonatomic) UIButton *sureBtn;     //确定
//data
@property (strong, nonatomic) NSDictionary *pickerDic; //省市区字典
@property (strong, nonatomic) NSArray *provinceArray;  //省数组
@property (strong, nonatomic) NSArray *cityArray;     //市数组
@property (strong, nonatomic) NSArray *townArray;    //区数组
@property (strong, nonatomic) NSArray *selectedArray;  //选中
@property (nonatomic, strong)UIButton * completeBtn;
@property (nonatomic, strong)UIView * completeView;
@property (nonatomic, strong)NSArray * rememberCityArray;//记录城市
@property (nonatomic, strong)NSMutableArray * rememberTownArray;//记录县

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

@implementation AlterAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"实物收货地址";
    self.dataArray = [NSMutableArray array];
    self.aArray2= [NSMutableArray array];
    self.shengidArray = [NSMutableArray array];
    _addressId=self.model.idd;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton * completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSW-70, 0, 70, 40)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:MainColor forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:completeBtn];
    self.completeBtn = completeBtn;
    [completeBtn addTarget:self action:@selector(addChange) forControlEvents:UIControlEventTouchUpInside];
    self.completeView = view;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=self.tablefooterView;
    [self.view addSubview:self.tableView];
    
    
}

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
        [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
         btn.backgroundColor=MainColor;
        [_tablefooterView addSubview:btn];
        
    }
    return _tablefooterView;
}

#pragma mark -保存数据
-(void)save
{
    DebugLog(@"person***%@%@%@%@",_Province,_city,_toun,_select);
   
    if ( [_person isEqualToString:@""] || [_phone isEqualToString:@""] ||[_Street isEqualToString:@""]) {
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil message:@"必填信息不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    
    if (IsStrEmpty(_Province)||IsStrEmpty(_city)||IsStrEmpty(_toun)) {
            _Province=self.model.sheng;
            _city=self.model.shi;
            _toun=self.model.xian;

    }

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict setValue:self.model.idd forKey:@"id"];
        [dict setValue:_Province forKey:@"sheng"];
        [dict setValue:_city forKey:@"shi"];
        [dict setValue:_toun forKey:@"xian"];
        [dict setValue:self.model.jiedao forKey:@"jiedao"];
        [dict setValue:self.model.shouhuoren forKey:@"shouhuoren"];
        [dict setValue:self.model.mobile forKey:@"mobile"];
        [dict setValue:_select forKey:@"moren"];
        [dict setValue:@"1" forKey:@"type"];
        [dict setValue:@"1" forKey:@"status"];
    [dict setValue:self.model.remark forKey:@"remark"];
    
//        DebugLog(@"id:%@ sheng:%@ shi:%@ xian:%@ jiedao:%@ shouhuoren:%@ mobile:%@ moren:%@ select:%@ ",self.model.idd,_Province,_city,_toun,self.model.jiedao,self.model.shouhuoren,self.model.mobile,self.model.moren,_select);
    
        [MDYAFHelp AFPostHost:APPHost bindPath:SaveAddress postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
              DebugLog(@"=responseDic===%@",responseDic[@"msg"]);
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                   [SVProgressHUD dismiss];

                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([responseDic[@"code"] isEqualToString:@"400"]){
               [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert3 show];
        }];

}

#pragma mark - init view 创建联动view
- (void)initView {
    
    [self getPickerData];
    //遮罩
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.maskView];
    //下方弹出view
    self.pickerBgView=[[UIView alloc]initWithFrame:CGRectMake(0, MSH-300, MSW, 300)];
    self.pickerBgView.backgroundColor=  [[UIColor grayColor] colorWithAlphaComponent:0.7];   /////
    self.pickerBgView.alpha=1;
    [self.maskView addSubview:self.pickerBgView];
    
    self.canceBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    self.canceBtn.backgroundColor=[UIColor clearColor];//////
    [self.canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.canceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.canceBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.canceBtn];
    
    self.sureBtn=[[UIButton alloc]initWithFrame:CGRectMake(MSW-100, 0, 100, 50)];
    self.sureBtn.backgroundColor=[UIColor clearColor];//////
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:self.sureBtn];
    //pickview视图
    self.myPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, MSW, self.pickerBgView.height-100)];
    self.myPicker.delegate=self;
    self.myPicker.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1];

    [self.pickerBgView addSubview:self.myPicker];
    
}



-(void)cancel{
    [self hideMyPicker];
}
-(void)sure{
    
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
#pragma mark - 获取省 pickview数据
- (void)getPickerData {
    
    [self.aArray2 removeAllObjects];
    [self.cArray3 removeAllObjects];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:ThirdListCity postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        //        DebugLog(@"省列表-->%@",responseDic);
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
    DebugLog(@"dict->%@",dict);
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
             self.rememberCityArray = self.shiidArray2;
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
    [self.rememberTownArray removeAllObjects];
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
            self.rememberTownArray = self.dArray3;

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


#pragma mark - 创建UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return self.dataArray.count;
    }
    else if (component == 1) {
        return self.aArray2.count;
    }
    else {
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
        return 100;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        //        DebugLog(@"---->%@",[self.shengidArray objectAtIndex:row]);
        [self getProvince:[self.shengidArray objectAtIndex:row]];
        shengid=[self.shengidArray objectAtIndex:row];
        [pickerView reloadComponent:1];
    }
    if (component == 1) {
        //         DebugLog(@"---->%@",[self.shiidArray2 objectAtIndex:row]);
        //        DebugLog(@"=====%@",self.shiidArray2);
        [self getTown:shengid iddd:[self.shiidArray2 objectAtIndex:row]];
        
        shiid=[self.shiidArray2 objectAtIndex:row];
        
        [pickerView reloadComponent:2];
        //        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadAllComponents];
}



- (void)hideMyPicker {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        //        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}



#pragma mark -  dataSource 创建表

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
    if (indexPath.row == 0 || indexPath.row ==1 || indexPath.row == 5)
    {
        static NSString *textCellName = @"TextFieldCell.h";
        TextFieldCell *textCell = [tableView dequeueReusableCellWithIdentifier:textCellName];

        textCell = [[TextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:textCellName];
        textCell.textField.inputAccessoryView = self.completeView;
        switch (indexPath.row)
        {
            case 0:
            {
                textCell.textField.placeholder = @"请输入收件人";
                textCell.titleLabel.text = @"收件人";
                textCell.textField.tag = 101;
                textCell.textField.text=self.model.shouhuoren;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 1:
            {
                textCell.textField.placeholder = @"请输入手机号码";
                textCell.titleLabel.text = @"手机号码";
                textCell.textField.tag = 102;
                textCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                textCell.textField.text=self.model.mobile;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 5:
            {
                textCell.textField.placeholder = @"请输入详细地址";
                textCell.textField.delegate = self;
                textCell.titleLabel.text = @"详细地址";
                textCell.textField.tag = 103;
                textCell.textField.delegate=self;
                textCell.textField.text=self.model.jiedao;
                [textCell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
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
        cell.textView.text = self.model.remark;
        
        CGRect frame = cell.textView.frame;
        CGSize size = [cell.textView sizeThatFits:CGSizeMake(CGRectGetWidth(cell.textView.frame), MAXFLOAT)];
        frame.size.height = size.height;
        cell.textView.frame = frame;
        _height = size.height;
        
        return cell;
    }
    
    
    else
    {
        static NSString *cellName = @"CELL";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MSW - 12 - 10, 50 / 2 - 5, 12, 10)];
        imageView.image = [UIImage imageNamed:@"triangle"];
        
        self.mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MSW - 51 - 10, 50 / 2 - 15, 51, 31)];
        //状态   开启  还是关闭
        self.mySwitch.on = NO;
        if (self.model.moren != nil)
        {
            _select = self.model.moren;
            if ([self.model.moren isEqualToString:@"Y"])
            {
                self.mySwitch.on = YES;
            }
            else
            {
                self.mySwitch.on = NO;
            }
        }
        [self.mySwitch addTarget:self action:@selector(switchBtnTouched:) forControlEvents:UIControlEventValueChanged];
        switch (indexPath.row)
        {
            case 2:
            {
                cell.textLabel.text = @"省份";
                self.lbProvince=[[UILabel alloc]initWithFrame:CGRectMake(124, 0, MSW-40 - 124, cell.height)];
                self.lbProvince.backgroundColor=[UIColor clearColor];
                self.lbProvince.textColor = [UIColor blackColor];
                self.lbProvince.text = self.model.sheng ;
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
                self.lbCity.text = self.model.shi ;
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
                self.lbTown.text = self.model.xian ;
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
            case 8:
            {
                cell.textLabel.text = @"删除地址";
                cell.textLabel.textColor=MainColor;
                
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
//    DebugLog(@"值改变");
    UISwitch *btn = sender;
    BOOL isButtonOn = [btn isOn];
    if(isButtonOn)
    {
        _select = @"Y";
        DebugLog(@"开启");
    }
    else
    {
        _select=@"N";
        DebugLog(@"关闭");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}


#pragma mark - 记录用户收件人 电话 地址
- (void)textFieldDidChange:(UITextField *)textField
{
    DebugLog(@"%@",textField.text);
    switch (textField.tag)
        {
            case 101:
                self.model.shouhuoren = textField.text;
                break;
            case 102:
                self.model.mobile  =  textField.text;
                break;
            case 103:
                self.model.jiedao = textField.text;
                break;

        }
}


#pragma mark - 选中弹出
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
       // self.maskView.alpha = 1;
        
        [UIView animateWithDuration:0.3 animations:^{
        self.pickerBgView.backgroundColor= [[UIColor whiteColor]colorWithAlphaComponent:1];
        self.myPicker.backgroundColor= [[UIColor whiteColor]colorWithAlphaComponent:1];
        }];
       
    }
    else if (indexPath.row==8)
    {
        [self cancelAddress];
    }

}


#pragma mark - TextViewCellDelegate
- (void)textViewCell:(TextViewCell *)cell didChangeText:(NSString *)text
{
    CGSize size = [cell.textView sizeThatFits:CGSizeMake(CGRectGetWidth(cell.textView.frame), MAXFLOAT)];
    
    _height = size.height;
    self.model.remark= text;
}

#pragma  mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 103:
           self.tableView.frame = CGRectMake(0, IPhone4_5_6_6P(-150, -120, 0, 0), MSW,MSH);
            break;
    }

    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.tableView.frame = CGRectMake(0, 0, MSW,MSH);
    
    return YES;
}



#pragma mark - 删除
-(void)cancelAddress
{
    
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除该地址吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1234;
        [alertView show];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1234) {
        if (buttonIndex == 1) {
            [self getChange];
        }
    }
}

- (void)getChange{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_addressId forKey:@"id"];
    
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

#pragma mark - 懒加载市
//- (NSMutableArray *)aArray2{
//    if (_aArray2 == nil) {
//        _aArray2 = [NSMutableArray array];
//    }
//    return _aArray2;
//}

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
//- (NSMutableArray *)shengidArray{
//    if (_shengidArray == nil) {
//        _shengidArray = [NSMutableArray array];
//    }
//    return _shengidArray;
//}

#pragma mark - 懒加载省array
- (NSMutableArray *)dArray3{
    if (_dArray3 == nil) {
        _dArray3 = [NSMutableArray array];
    }
    return _dArray3;
}

- (NSArray *)rememberCityArray{
    if (_rememberCityArray == nil) {
        _rememberCityArray = [NSMutableArray array];
    }
    return _rememberCityArray;
}

- (NSMutableArray *)rememberTownArray{
    if (_rememberTownArray == nil) {
        _rememberTownArray = [NSMutableArray array];
    }
    return _rememberTownArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
