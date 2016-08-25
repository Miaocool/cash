//
//  MyRedViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MyRedViewController.h"
#import "MyRedCell.h"
#import "RedBoxDto.h"
#import "GroupRedViewController.h"
#import "MJRefresh.h"
#import "DidViewCell.h"
#import "ExchangeRedViewController.h"

@interface MyRedViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NoDataView *nodataView;


@end

@implementation MyRedViewController
{
    UIScrollView         *_scrollView;  //滑动view
    UIView               *_buttonView;  //摆放按钮view
    NSArray              *_titleArray;  //使用，可使用数组
    UIButton             *_button;      //使用，已使用button
    NSMutableArray       *_buttonArray; //封装button数组
    UIView               *_selectedView; //线条
    NSInteger num;       //记录当前页数
    NSMutableArray       *_dataArray; //数据源
    UITableView          *_tableView;
   
    NSInteger _i;
    
    NSMutableArray *_arrall;
    NSMutableArray *_arr1;
    NSMutableArray *_arr2;
    int arrcount;
    
    NSMutableArray *_couldarray;;
    
    NSString *type_name;  //标题
    NSString *type_money;  //红包余额
    NSString *User_start_date; //红包使用日期
    NSString *User_end_date;  //过期时间
    NSString *Type;    //红包是否过期
    NSString *isuse;   //红包是否使用
    NSString *Desc;   //红包说明
    NSString* _redstype;   //判断红包状态
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavBar];
    self.title=@"我的红包";
    _redstype=@"1";
   
    [self initData];
    [self getRedList];
    

    UIButton *exchangeBtn = [[UIButton alloc]init];
    exchangeBtn.frame = CGRectMake(0, 0, 80,20);
    exchangeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [exchangeBtn setTitle:@"兑换红包" forState:(UIControlStateNormal)];
    [exchangeBtn addTarget:self action:@selector(gototoExchange) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:exchangeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initData];
    [self getRedList];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor=RGBCOLOR(234, 229, 225 );
    
}

-(void)gototoExchange
{
    ExchangeRedViewController *red=[[ExchangeRedViewController alloc]init];
    [self.navigationController pushViewController:red animated:YES];
}


#pragma mark - 数据
- (void)initData
{
    _arr1=[NSMutableArray array];
    _arr2=[NSMutableArray array];
    _arrall=[NSMutableArray array];
    
    
    _couldarray=[NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _titleArray = @[@"可使用1",@"已使用/过期"];
    _buttonArray = [NSMutableArray array];
    _i = 0;
}

#pragma mark - UI
- (void)createUI
{
    //按钮的view
    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    _buttonView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_buttonView];
    //选择view
    _selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, _buttonView.frame.size.height + _buttonView.frame.origin.y, self.view.frame.size.width /2, 3)];
    _selectedView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_selectedView];
    
    for (NSInteger i = 0; i < _titleArray.count; i ++)
    {   //title按钮
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(_buttonView.frame.size.width / 2 * i, 3, _buttonView.frame.size.width /2, 30);
        _button.tag = 101+i;
        [_button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [_button setTitleColor:RGBCOLOR(111, 111, 111) forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:18];
        [_button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([_redstype isEqualToString:@"1"]) {
if (_button.tag == 101)
            {
                [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

            }
        }else{
        
           
            if (_button.tag == 101)
            {
                [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else{
                [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
            }
        
        }
        [_buttonView addSubview:_button];
        [_buttonArray addObject:_button];
    }
    //滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _selectedView.frame.size.height + _selectedView.frame.origin.y , self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    _scrollView.showsHorizontalScrollIndicator=FALSE;
    _scrollView.showsVerticalScrollIndicator=FALSE;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor=RGBCOLOR(234, 229, 225 );
    
    for (NSInteger i = 0; i < 2; i++)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, MSH - 64 - 40)];
        _tableView.tag = 101 + i ;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [_scrollView addSubview:_tableView];
        
        if (_tableView.tag==101)
        {
            _tableView.backgroundColor=RGBCOLOR(234, 229, 225 );
        }else{
            _tableView.backgroundColor=RGBCOLOR(234, 229, 225 );
        }
    }
[self.view addSubview:_scrollView];
}

-(void)getRedList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_redstype forKey:@"status"];
    [MDYAFHelp AFPostHost:APPHost bindPath:RedBao postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
       DebugLog(@"====++++%@",responseDic);
        [self refreshSuccessful:responseDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self refreshFailure:error];
    }];
}
- (void)refreshSuccessful:(id)data
{
    [_couldarray removeAllObjects];
    [_arrall removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            DebugLog(@"****%@",array);   //有值
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                RedBoxDto *model = [[RedBoxDto alloc]initWithDictionary:obj];
          if ([_redstype isEqualToString:@"1"]) {
                [_couldarray addObject:model];
                RedBoxDto *model = [_couldarray objectAtIndex:0];
                DebugLog(@"---===%@",model.type);
            }
          else{
                [_arrall addObject:model];
                RedBoxDto *model = [_arrall objectAtIndex:0];
                DebugLog(@"---===%@",model.type);
               }
                [_arrall addObject:model];
                
            }];
        }
        
        [self createUI];
    }

    [_tableView reloadData];
    
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    
}
//红包点击
-(void)touchBtn
{
    GroupRedViewController *group=[[GroupRedViewController alloc]init];
    [self.navigationController pushViewController:group animated:YES];
}

#pragma mark - tableViewDelegeta
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag == 101)
    {
         return _couldarray.count;
     }
    else
    {
        return _arrall.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//      DebugLog(@"-----%li----%li===",_couldarray.count,_arrall.count);
    _tableView.tableFooterView = [[UIView alloc] init];
      static   NSString *cellIndentifer =@"cellIndenfier";
//    static NSString *cellName = @"Cell";
    if (tableView.tag == 101)
    {
        MyRedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (!cell)
        {
            cell = [[MyRedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        cell.redModel=_couldarray[indexPath.row];
        
        DebugLog(@"---%li",_couldarray.count);
        
        return cell;
    }
    else
    {
    MyRedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell)
    {
        cell = [[MyRedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
   
    cell.redModel=_arrall[indexPath.row];
    return cell;
    }

}

#pragma mark - 滚动视图协议
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _i = scrollView.contentOffset.x/self.view.bounds.size.width;
    [self colorReset:_i];
    
    _selectedView.frame = CGRectMake(scrollView.contentOffset.x / 2, _buttonView.frame.size.height + _buttonView.frame.origin.y, self.view.frame.size.width / 2, 4);
    
}

#pragma mark - 为自体变色封装
-(void)colorReset:(NSInteger)tempNub
{
    static NSInteger f = 1;
    if (!f) {
    }else
    {
        UIButton *tempBut = _buttonArray[f-1];
        [tempBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    UIButton *btn = _buttonArray[tempNub];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    f = tempNub+1;
}

- (void)button:(UIButton *)button
{    DebugLog(@"===%li",button.tag);
    switch (button.tag)
    {
        case 101:
        {
            [self colorReset:0];
            
            _scrollView.contentOffset = CGPointMake(0.0, 0.0);
            _selectedView.frame = CGRectMake(_scrollView.contentOffset.x /2, _buttonView.frame.size.height + _buttonView.frame.origin.y, self.view.frame.size.width / 2, 4);
_redstype=@"1";
            
            
        }
            break;
             
        case 102:
        {
            [self colorReset:1];
            
            _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0.0);
            _selectedView.frame = CGRectMake(_scrollView.contentOffset.x / 2, _buttonView.frame.size.height + _buttonView.frame.origin.y, self.view.frame.size.width /2, 4);

            _redstype=@"2";
        }
            DebugLog(@"2");
            
            break;

    }
    [self getRedList];
    [_tableView reloadData];
    
}
//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"列表为空哦！";
        _nodataView.frame=CGRectMake(0, 80, MSW, MSH-80);
        
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

@end
