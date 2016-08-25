//
//  payController.m
//  yydz
//
//  Created by mac02 on 16/4/22.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "payController.h"
#import "AddPayController.h"
#import "GameViewController.h"
#import "AddGameController.h"
#import "AddressViewController.h"
#import "AddAddressViewController.h"
#import "UserAddressViewController.h"
#import "UserAddressCell.h"
#import "AlterAddressViewController.h"
#import "AddressDto.h"
#import "AddPayController.h"
#import "AddGameController.h"
#import "ChangeGameController.h"
#import "QQViewController.h"
#define btnWidth 40
#define Margin 20
#define FontSize 14
@interface payController ()<UITableViewDataSource,UITableViewDelegate,UserAddressCellDelegate>
{
    
    NSString       *_uid;
    NSString       *_img;
    NSString       *_shouhuoren;
    NSString       *_mobile;
    NSString       *_addressId;
    NSString       *_sheng;
    NSString       *_shi;
    NSString       *_xian;
    NSString       *_jiedao;
    NSString       *_default;
    
    UIView        *_tablefooterView;
}
@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) AddressDto *model;
@property (nonatomic, strong) NoDataView *nodataView;
@property (nonatomic, strong)UIView * coverView;
@property (nonatomic, strong)UIButton * addressbtn;
@property (nonatomic, strong)UIButton * paybtn;
@property (nonatomic, strong)UIButton * btn;
@property (nonatomic, strong)UITableViewCell *  cell;
@property (nonatomic,strong) AddressDto *model1;
@property (nonatomic, strong)UserAddressCell *userAddressCell;
@property (nonatomic, strong)NSMutableArray  *  addressMutableArray;
@property (nonatomic, strong)NSIndexPath *  indexPath;
@end

@implementation payController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self getAddressList];
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货信息管理";
    // Do any additional setup after loading the view.
    //    [self initData];
    [self addRiButtonItem];
    
}

#pragma mark - 导航按钮
- (void)addRiButtonItem
{
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(pushAddAddressViewController)];
    self.navigationItem.rightBarButtonItem = btn_right;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}

- (void)pushAddAddressViewController{
    
    AddPayController * addAddress = [[AddPayController alloc]init];
    [self.navigationController pushViewController:addAddress animated:YES];
}


//- (void)initData
//{
//    self.dataArray = [NSMutableArray array];
//
//}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.tableFooterView=self.tablefooterView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}


#pragma mark - 获取列表信息
-(void)getAddressList{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:AddressAlter postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"====++++%@",responseDic);
        [self refreshSuccessful:responseDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        NSString *str = [[NSString alloc] initWithData:[operation responseData] encoding:NSUTF8StringEncoding];
        DebugLog(@"str:===========%@",str);
        [self refreshFailure:error];
    }];
    
}

- (void)refreshSuccessful:(id)data
{
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            
            
            NSArray *array = data[@"data"];
            DebugLog(@"****%@",array);
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                _model = [[AddressDto alloc]initWithDictionary:obj];
                DebugLog(@"**+**%@",_model.idd);
                if (!IsStrEmpty(_model.sheng) || !IsStrEmpty(_model.game_name)) {
                    _model = nil;
                }else{
                    [self.dataArray addObject:_model];
                }
                
                
                DebugLog(@"dataArray=%@",self.dataArray);
                [self initTableView];
            }];
            //            }
            
        }
        else
        {
            //        [self noData];
            //           [SVProgressHUD showErrorWithStatus:data[@"msg"]];
        }
    }
    [_tableView reloadData];
    
}

- (void)refreshFailure:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    DebugLog(@"!!!!!!!!!!!!!!!!%@",error);
    
}

#pragma mark -  dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressDto * model = self.dataArray[indexPath.row];
    CGSize size = [model.remark sizeWithFont:[UIFont systemFontOfSize:BigFont] constrainedToSize:CGSizeMake(MSW -30,300) lineBreakMode:NSLineBreakByCharWrapping];
    
    if (IsStrEmpty(model.sheng)) {
        if (IsStrEmpty(model.qq))
        {
            
            return 190+size.height + 5;
        }
        else
        {
            return 115 + size.height +5;
        }
    }
    else
    {
        return 150 + size.height +5;
    }
    
}
- (NSMutableArray *)addressMutableArray{
    if (_addressMutableArray == nil) {
        _addressMutableArray = [NSMutableArray array];
    }
    return _addressMutableArray;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    static NSString *cellName = @"Cell";
    UserAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[UserAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.addressModel= self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
    
    
}


//代理方法编辑
- (void)changController:(UserAddressCell *)userAddressCell{
    
    if (!IsStrEmpty(userAddressCell.addressModel.sheng))
    {
        AlterAddressViewController * alert = [[AlterAddressViewController alloc]init];
        alert.model = userAddressCell.addressModel;
        [self.navigationController pushViewController:alert animated:YES];
        DebugLog(@"1");
    }
    else if(!IsStrEmpty(userAddressCell.addressModel.qq))
    {
        
        
        QQViewController * qq = [[QQViewController alloc]init];
        qq.addressDto = userAddressCell.addressModel;
        [self.navigationController pushViewController:qq
                                             animated:YES];
        DebugLog(@"2");
    }
    else if (!IsStrEmpty(userAddressCell.addressModel.game_name))
    {
        DebugLog(@"3");
        ChangeGameController * changGame = [[ChangeGameController alloc]init];
        changGame.addressDto = userAddressCell.addressModel;
        [self.navigationController pushViewController:changGame animated:YES];
    }
    
}



#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确认选择该地址吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1234;
    [alert show];
    
//        if ([_index isEqualToString:@"4567"]) {
//            AddressDto *dto=self.dataArray[indexPath.row];
//            [self.delegate passAddressDto:dto tag:@"0"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            AlterAddressViewController *alter=[[AlterAddressViewController alloc]init];
//            alter.model = self.dataArray[indexPath.row];
//            [self.navigationController pushViewController:alter animated:YES];
//        }
    
//    UserAddressCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    DebugLog(@"%@",cell.nameBtn.textInputContextIdentifier);
//    //    if (cell.nameBtn) {
//    //        <#statements#>
//    //    }
//    [cell.edit addTarget:self action:@selector(editAdress) forControlEvents:UIControlEventTouchUpInside];
//    DebugLog(@"%@",indexPath);
    
    
}
#pragma mark 确认弹话框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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

- (void)getExchange{
    if ([_index isEqualToString:@"4567"]) {
        AddressDto *dto=self.dataArray[self.indexPath.row];
        [self.delegate passAddressDto:dto tag:@"0"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        AlterAddressViewController *alter=[[AlterAddressViewController alloc]init];
//        alter.model = self.dataArray[.row];
//        [self.navigationController pushViewController:alter animated:YES];
    }
}

- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"您还没有添加地址哦！";
        
        
        
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.nodataView];
}
-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
