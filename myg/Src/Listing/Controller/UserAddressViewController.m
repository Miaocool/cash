//
//  UserAddressViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//地址

#import "UserAddressViewController.h"
#import "UserAddressCell.h"
#import "AddAddressViewController.h"
#import "AlterAddressViewController.h"
#import "AddressDto.h"
#import "AddPayController.h"
#import "AddGameController.h"
#import "ChangeGameController.h"
#import "QQViewController.h"

#define btnWidth 40
#define Margin 20
#define FontSize 14

@interface UserAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UserAddressCellDelegate
>{
    
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

@end

@implementation UserAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收货信息管理";
    [self addRiButtonItem];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    [self getAddressList];
    [self initTableView];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark - 导航按钮
- (void)addRiButtonItem
{
//    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
//    btn_right.tintColor=[UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = btn_right;
//    
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    message.frame = CGRectMake(MSW-100, 20, 30, 30);
    message.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    [message setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [message setImage:[UIImage imageNamed:@"addwin"] forState:UIControlStateNormal];
    message.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [message addTarget:self action:@selector(addCoverView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}


#pragma mark - 添加遮罩效果
-(void)addCoverView{
    UIView * coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    UIColor * color = [UIColor blackColor];
    coverView.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    [self.view.window addSubview:coverView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    self.coverView = coverView;
    
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(40, self.view.window.center.y - 70, MSW - 80, 140)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5;
    [self.coverView addSubview:whiteView];
    
    UIButton * addressbtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10 , whiteView.width - 20, 35)];
    self.addressbtn = addressbtn;
    [addressbtn setTitle:@"添加实物收货地址" forState:UIControlStateNormal];
    addressbtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    addressbtn.layer.cornerRadius = 2;
    addressbtn.tag = 1;
    [addressbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addressbtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:addressbtn];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(Margin, addressbtn.bottom +5, MSW - btnWidth*3, 0.5)];
    line.backgroundColor = RGBCOLOR(220, 220, 223);
    [whiteView addSubview:line];
    
    UIButton * paybtn = [[UIButton alloc]initWithFrame:CGRectMake(10,line.bottom +5 , whiteView.width - 20, 35)];
    self.paybtn = paybtn;
    [paybtn setTitle:@"添加充值账号" forState:UIControlStateNormal];
    paybtn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    paybtn.layer.cornerRadius = 2;
    paybtn.tag = 2;
    [paybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [paybtn addTarget:self action:@selector(addParBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:paybtn];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(Margin, paybtn.bottom +5, MSW - btnWidth*3 , 0.5)];
    line2.backgroundColor = RGBCOLOR(220, 220, 223);
    [whiteView addSubview:line2];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10,line2.bottom +5 , whiteView.width - 20, 35)];
    self.btn = btn;
    [btn setTitle:@"添加游戏充值账号" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    btn.layer.cornerRadius = 2;
    btn.tag = 3;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [whiteView addSubview:btn];
    [btn addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    [coverView addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(changeCoverView)];
}
#pragma mark - 给遮罩添加点击手势

- (void)changeCoverView{
    self.coverView.alpha = 0;
}

#pragma mark - 添加实物收货地址按钮
- (void)add
{
    self.coverView.alpha = 0;
    AddAddressViewController *addVC = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - 点击添加充值账号按钮
- (void)addParBtn{
    self.coverView.alpha = 0;
    AddPayController * addPay = [[AddPayController alloc]init];
    [self.navigationController pushViewController:addPay animated:YES];
    
}

#pragma mark - 点击添加游戏账号按钮
- (void)addBtn{
    self.coverView.alpha = 0;
    AddGameController * game = [[AddGameController alloc]init];
    [self.navigationController pushViewController:game animated:YES];
    
}



- (void)initData
{
    self.dataArray = [NSMutableArray array];
    
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBCOLOR(240, 239, 241);
    self.tableView.tableFooterView=self.tablefooterView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

- (UIView *)tablefooterView
{
    if (!_tablefooterView) {
        _tablefooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 80)];
        _tablefooterView.backgroundColor = [UIColor clearColor];
        _tablefooterView.tag = 1;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, MSW, 50)];
        bgView.backgroundColor = [UIColor clearColor];
        [_tablefooterView addSubview:bgView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, MSW-20, 40)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = MainColor.CGColor;
        btn.layer.cornerRadius=10;
        btn.backgroundColor=RGBCOLOR(242, 242, 242);
        btn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
        [btn setTitle:@"添加地址" forState:UIControlStateNormal];
        [btn setTitleColor:MainColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addCoverView) forControlEvents:UIControlEventTouchUpInside];
        [_tablefooterView addSubview:btn];
        
    }
    return _tablefooterView;
}

-(void)getAddressList{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_shouhuoren forKey:@"shouhuoren"];
    [dict setValue:_mobile forKey:@"mobile"];
    [dict setValue:_sheng forKey:@"sheng"];
    [dict setValue:_shi forKey:@"shi"];
    [dict setValue:_xian forKey:@"xian"];
    [dict setValue:_jiedao forKey:@"jiedao"];
    [dict setValue:@"" forKey:@"moren"];
    //    [dict setValue:_id forKey:@"id"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:AddressAlter postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"====++++%@",responseDic);
        [self refreshSuccessful:responseDic];
        DebugLog(@"=====%@",responseDic[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
                AddressDto *model = [[AddressDto alloc]initWithDictionary:obj];
//                DebugLog(@"**+**%@",model.idd);
                [self.dataArray addObject:model];
//                DebugLog(@"dataArray=%@",self.dataArray);
            }];
        }
        else
        {
            //        [self noData];
            //          [SVProgressHUD showErrorWithStatus:data[@"msg"]];
        }
    }
    [_tableView reloadData];
    
}

- (void)refreshFailure:(NSError *)error
{
   [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellName = @"Cell";
    UserAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    cell = [[UserAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.addressModel= self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
    
}



#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_index isEqualToString:@"1234"]) {
        AddressDto *dto=self.dataArray[indexPath.row];
        [self.delegate passAddressDto:dto tag:@"0"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark UserAddressCellDelegate 编辑
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

@end
