//
//  ListingViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//清单

#import "ListingViewController.h"

#import "ListingCell.h"

#import "ListingModel.h"

#import "SettlementViewController.h" //结算

#import "SettlementModel.h"

#import "NSString+WPAttributedMarkup.h"
#import "GoodsDetailsViewController.h"
#import "NewGoodsModel.h"

@interface ListingViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ListingCellDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) UIView *buttonView; // 4 分类
@property (nonatomic, strong) UIView *settlementView; //结算
@property (nonatomic, strong) UILabel *numLabel; //记录多少件商品
@property (nonatomic, strong) UILabel *totalLabel; //总计多少钱

@property (nonatomic, strong) UIButton *editButton;//导航按钮

@property (nonatomic, strong) UIView *deleteView; //删除
@property (nonatomic, strong) UILabel *deleteLabel; //删除显示
@property(nonatomic,strong)NSMutableArray *deleteArray; //储存删除对象
@property (nonatomic, strong) NSMutableDictionary *deleteDict;
@property (nonatomic, strong) NSString *idd; //商品id
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *chooseBtn; //全选按钮
@property (nonatomic, strong) NSMutableArray *selectedArray; //选中的array
//@property (nonatomic, strong) NSMutableArray *settlementArray; //结算array
//@property (nonatomic, copy) NSString *settlementString; //结算字符串
@property (nonatomic, strong) NSMutableArray *shopArray; //购物车n
@property (nonatomic, strong) NoDataView *nodataView;
@property (nonatomic, assign) NSInteger sum;  //和
@property (nonatomic, copy) NSMutableArray*morenarray;  //默认数组

@property (nonatomic, assign)int  firstcome;  //第一次进入页面
@property (nonatomic, assign)int  seletecell;  //选择第几行

@property(nonatomic,strong)NSMutableArray *classArray;  //支付方式
@property(nonatomic,strong)NSMutableArray *zhifuNameArray; //支付名
@property(nonatomic,strong)NSMutableArray *zhifuTishiArray; //支付小标题
@property(nonatomic,strong)NSMutableArray *zhifuColorArray; //支付颜色
@property(nonatomic,strong)NSMutableArray *zhifuImgArray; //支付图片

@property (nonatomic, strong) NoNetwork *nonetwork;
@end

@implementation ListingViewController
{
    BOOL _isDelete; //是否是编辑状态
    
    BOOL _isAllSelected; //是否全部选中
    int _isback;//是否从结算返回
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstcome=0;
    _isback=0;
    
    self.classArray=[NSMutableArray array];
    self.zhifuNameArray=[NSMutableArray array];
    self.zhifuColorArray=[NSMutableArray array];
    self.zhifuImgArray=[NSMutableArray array];
    self.zhifuTishiArray=[NSMutableArray array];
    
    [self initData];
    [self setNavBtn];
    [self createTableView];
    _isDelete = NO;
    _isAllSelected = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jieSuan) name:@"jieSuan" object:nil];
    //修改的－－－清单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qiangdantongzhi:) name:@"qingdan" object:nil];
    
}
-(void)qiangdantongzhi:(NSNotification *)model{
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    goods.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:goods animated:YES];
    
}

- (void)jieSuan
{
    self.num = 0;
    [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
        self.num += obj.num;
    DebugLog(@"%li",self.num);
    }];
    //总需
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                   [UIColor whiteColor]],
                             @"u": @[MainColor,
                                     ]};
    
    NSDictionary* style2 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0],
                                   [UIColor lightTextColor]],
                             @"u": @[MainColor,
                                     ]};
    
    self.numLabel.attributedText =  [[NSString stringWithFormat:@"共%lu件商品",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count] attributedStringWithStyleBook:style2];
    
    self.totalLabel.attributedText = [[NSString stringWithFormat:@"总计：<u>%ld</u>米币",(long)self.num] attributedStringWithStyleBook:style1];
}

#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    self.deleteDict = [NSMutableDictionary dictionary];
    self.selectedArray = [NSMutableArray array];
    self.shopArray = [NSMutableArray array];
    
}

#pragma mark - 设置导航按钮
- (void)setNavBtn
{
    
    //右导航
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(MSW-50, 20, 36, 29);
    [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    _editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_editButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:_editButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

#pragma mark - 导航 - 删除cell按钮
- (void)delete:(UIBarButtonItem *)riBtn
{
    
    if (self.dataArray.count > 0)
    {
        if (_isDelete == NO)
        {
            [_editButton setTitle:@"完成" forState:UIControlStateNormal];
            [_editButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            self.deleteLabel.text = @"共选中0件商品";
            self.deleteView.hidden = !self.deleteView.hidden;
            self.settlementView.hidden = !self.settlementView.hidden;
            [self.tableView setEditing:YES animated:YES];
            _isDelete = YES;
            _isAllSelected = NO;
            [self.deleteDict removeAllObjects];
            [self.selectedArray removeAllObjects];
            [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"recharge_no_choose"] forState:UIControlStateNormal];
        }
        else
        {
            [_editButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
            [_editButton setTitle:@"" forState:UIControlStateNormal];
            
            self.deleteLabel.text = @"共选中0件商品";
            [self.tableView setEditing:NO animated:YES];
            _isDelete = NO;
            _isAllSelected = NO;
            self.deleteView.hidden = !self.deleteView.hidden;
            self.settlementView.hidden = !self.settlementView.hidden;
            
        }
    }
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if (_isDelete == YES)
    {
        [_editButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
        [_editButton setTitle:@"" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        self.settlementView.hidden = NO;
        self.deleteView.hidden = YES;
        _isDelete = NO;
    }
    
    //存放商品id
    NSMutableArray *array = [NSMutableArray array];
    [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
        
        [array addObject:obj.goodsId];
    }];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *str = [array componentsJoinedByString:@","];
    [dict setValue:str forKey:@"shopid"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:ShoppingList postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"成功：%@",responseDic);
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
    }];
}

- (void)refreshSuccessful:(id)data
{
    [self.nonetwork removeFromSuperview];
    [self.dataArray removeAllObjects];
    [SVProgressHUD dismiss];
    
    if ([data isKindOfClass:[NSDictionary class]])
    {
        
        NSArray *array = data[@"data"];
        if ([data[@"code"] isEqualToString:@"200"])
        {
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ListingModel *model = [[ListingModel alloc]initWithDictionary:obj];
                if ([model.shengyurenshu integerValue] > 0)
                {
                    [self.dataArray addObject:model];
                }
                else
                {
                    [[UserDataSingleton userInformation].shoppingArray removeObjectAtIndex:idx];
                }
                
                
                ShoppingModel*model1=[[UserDataSingleton userInformation].shoppingArray objectAtIndex:idx];
                
                if ([model.shopid isEqualToString:model1.goodsId]) {
                    DebugLog(@"==--没有买完还有剩余");
                }else{
                    DebugLog(@"==---已经买完开始下一期");
                    model1.goodsId=model.shopid;
                    
                }

            }];
            
            //通知 改变徽标个数
            NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            self.num = 0;
            [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
                self.num += obj.num;
            }];
            //总需
            NSDictionary* style1 = @{@"body" :
                                         @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                           [UIColor whiteColor]],
                                     @"u": @[MainColor,
                                             ]};
            NSDictionary* style2 = @{@"body" :
                                         @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0],
                                           [UIColor lightTextColor]],
                                     @"u": @[MainColor,
                                             ]};
            
            self.totalLabel.attributedText = [[NSString stringWithFormat:@"总计：<u>%ld</u>米币",(long)self.num] attributedStringWithStyleBook:style1];
            
            self.numLabel.attributedText =  [[NSString stringWithFormat:@"共%lu件商品",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count] attributedStringWithStyleBook:style2];
            
        }
    }
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)refreshFailure:(NSError *)error
{
    [self nonetworking];
    self.settlementView.hidden = YES;
    [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    [UIView animateWithDuration:2 animations:^{
        
    } completion:^(BOOL finished) {
        self.tableView.footerView.state = kPRStateHitTheEnd;
    }];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        
    }
    [self.nonetwork removeFromSuperview];
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)loadingFailure:(NSError *)error
{
    [self nonetworking];
    [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
    self.num = self.num -1;
    [self.tableView tableViewDidFinishedLoading];
}
#pragma mark - tableview继承滚动试图的协议
//滚动视图已经滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    DebugLog(@"-----     %f------%f",scrollView.contentOffset.y,scrollView.contentSize.height);
    //如果滚动视图是Tableview的话 就执行方法
    if ([scrollView isEqual:self.tableView])
    {
        
        if (scrollView.contentOffset.y<=0) {
            //tab已经滚动的时候调用
            [self.tableView tableViewDidScroll:self.tableView];
  
        }
        
    }
    
}

//已经结束拖拽 将要减速
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.tableView])
    {
        //停止拖拽调用
        [self.tableView tableViewDidEndDragging:self.tableView];
    }
    
}


#pragma mark - 继承刷新的tableview方法
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
        
    });
    
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadingData];
        
    });
    
    
}


#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height - 60 - 49 - 55) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    //    self.tableView.showsVerticalScrollIndicator = FALSE;
    //    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
    //结算View
    self.settlementView = [[UIView alloc]initWithFrame:CGRectMake(0, MSH - 60 - 49 - 55, MSW, 55)];
    self.settlementView.layer.borderWidth = 1;
    self.settlementView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.settlementView.backgroundColor = RGBCOLOR(67, 67, 75);
    
    self.settlementView.hidden = YES;
    [self.view addSubview:self.settlementView];
    
    //总计多少钱
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 180, 20)];
    self.totalLabel.font = [UIFont systemFontOfSize:17];
    self.totalLabel.text = [NSString stringWithFormat:@"总计：<u>%ld</u>米币",(long)self.num];
    [self.settlementView addSubview:self.totalLabel];
    
    //计算多少商品
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.totalLabel.bottom, 180, 20)];
    self.numLabel.font = [UIFont systemFontOfSize:BigFont];
    self.numLabel.text = [NSString stringWithFormat:@"共%d件商品",[UserDataSingleton userInformation].shoppingArray.count];
    
    [self.settlementView addSubview:self.numLabel];
    
    //结算
    UIButton *settlementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settlementBtn.frame = CGRectMake(MSW - 90, 0, 90, 55);
    [settlementBtn setTitle:@"去结算>" forState:UIControlStateNormal];
    settlementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [settlementBtn addTarget:self action:@selector(settlement) forControlEvents:UIControlEventTouchUpInside];
    settlementBtn.backgroundColor = MainColor;
    [self.settlementView addSubview:settlementBtn];
    
    //删除
    self.deleteView = [[UIView alloc]initWithFrame:CGRectMake(0, MSH - 60 - 49 - 55, MSW, 55)];
    self.deleteView.layer.borderWidth = 1;
    self.deleteView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.deleteView.backgroundColor = RGBCOLOR(67, 67, 75);
    [self.view addSubview:self.deleteView];
    
    //全选按钮
    self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseBtn.frame = CGRectMake(10,self.deleteView.frame.size.height / 2 - 10,20,20);
    self.chooseBtn.backgroundColor = [UIColor whiteColor];
    [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"recharge_no_choose"] forState:UIControlStateNormal];
    self.chooseBtn.layer.cornerRadius = 10;
    [self.chooseBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteView addSubview:self.chooseBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chooseBtn.frame.size.width + self.chooseBtn.frame.origin.x + 10, 10, 50, 20)];
    titleLabel.text = @"全选";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    [self.deleteView addSubview:titleLabel];
    
    //选择label
    self.deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.chooseBtn.frame.size.width + self.chooseBtn.frame.origin.x + 10, titleLabel.frame.origin.y + titleLabel.frame.size.height, 150, 20)];
    self.deleteLabel.text = @"共选中0件商品";
    self.deleteLabel.textColor = [UIColor whiteColor];
    self.deleteLabel.font = [UIFont systemFontOfSize:14];

    [self.deleteView addSubview: self.deleteLabel];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(MSW - 90, 0, 90, 55);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    deleteBtn.backgroundColor = MainColor;
    [deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteView addSubview:deleteBtn];
    
    self.deleteView.hidden = YES;
    
}


#pragma mark - 多行
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListingCell *cell = (ListingCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row]];
    
    [cell.textField resignFirstResponder];
    
    if(_isDelete)
    {
        ShoppingModel *model = [UserDataSingleton userInformation].shoppingArray[indexPath.row];
        [self.deleteDict setValue:indexPath forKey:model.goodsId];
        [self.selectedArray addObject:model];
        self.deleteLabel.text = [NSString stringWithFormat:@"共选中%lu件商品",self.selectedArray.count];
        if (_selectedArray.count == _dataArray.count) {
            _isAllSelected = YES;
            [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"recharge_choose"] forState:UIControlStateNormal];
        }
        
    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}

#pragma mark - 取消选中
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{    if(_isDelete)
    {
        _isAllSelected = NO;
        [self.chooseBtn setBackgroundImage:[UIImage imageNamed:@"recharge_no_choose"] forState:UIControlStateNormal];

        ShoppingModel *model = [UserDataSingleton userInformation].shoppingArray[indexPath.row];
        [self.deleteDict removeObjectForKey:model.goodsId];
        [self.selectedArray removeObject:model];
        self.deleteLabel.text = [NSString stringWithFormat:@"共选中%lu件商品",self.selectedArray.count];
    }
}


#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_dataArray.count==0) {
        _editButton.hidden = YES;
        [self noData];
    }else{
        
        _editButton.hidden = NO;
        [_nodataView removeFromSuperview];
        
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *ListingCellName = @"ListingCell111";
    self.index = indexPath.row;
    
    ListingCell *Listingcell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!Listingcell)
    {
        Listingcell = [[ListingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
    }
    if (self.dataArray.count > 0)
    {
        Listingcell.listingModel = self.dataArray[indexPath.row];
        
        DebugLog(@"%i",Listingcell.listingModel.isbaowei);
        
        ShoppingModel *model =  [UserDataSingleton userInformation].shoppingArray[indexPath.row];
        if ([Listingcell.listingModel.xiangou isEqualToString:@"2"]) {
            
            //限购2商品
            Listingcell.productType = ProductTypeLimit2;
            
            if (model.num > [Listingcell.listingModel.shengyurenshu integerValue]) {
                if ([Listingcell.listingModel.shengyurenshu integerValue] >= [Listingcell.listingModel.xg_number integerValue]) {
                    model.num = [Listingcell.listingModel.xg_number integerValue];
                }else{
                    model.num = [Listingcell.listingModel.shengyurenshu integerValue];
                }
            }else{
                if (model.num >= [Listingcell.listingModel.xg_number integerValue]) {
                    model.num = [Listingcell.listingModel.xg_number integerValue];
                }else{
                    model.num = model.num;
                }
            }
            
            if ([Listingcell.listingModel.xg_number isEqualToString:@"0"])
            {
                model.num = [Listingcell.listingModel.xg_number integerValue];
            }
        }else if ([Listingcell.listingModel.xiangou isEqualToString:@"1"]){
            //限购1商品
            Listingcell.productType = ProductTypeLimit1;
            if ([Listingcell.listingModel.xg_number integerValue] > 0) {
                model.num = [Listingcell.listingModel.zongrenshu integerValue];
            }else{
                model.num = 0;
            }
            
        }else{
            //普通商品
            Listingcell.productType = ProductTypeNormal;
            if (model.num > [Listingcell.listingModel.shengyurenshu integerValue]) {
                model.num = [Listingcell.listingModel.shengyurenshu integerValue];
            }else{
                
                //本地值与云价格比较
                if (model.num <= [Listingcell.listingModel.yunjiage integerValue]) {
                    model.num = [Listingcell.listingModel.yunjiage integerValue];
                }else{
                    model.num = model.num/[Listingcell.listingModel.yunjiage integerValue]*[Listingcell.listingModel.yunjiage integerValue];
                }
            }
        }
        Listingcell.textField.text = [NSString stringWithFormat:@"%ld",model.num];
        Listingcell.num = model.num;
        if (_isDelete)
        {
            self.settlementView.hidden = YES;
        }
        else
        {
            self.settlementView.hidden = NO;
            
        }
        Listingcell.textField.delegate=self;
        
        Listingcell.textField.tag=indexPath.row;
        if (_firstcome==0) {
            //            没有点击包尾
                        Listingcell.textField.text=[NSString stringWithFormat:@"%li",model.num];
            
            Listingcell.btbaowei.selected = NO;
            Listingcell.lbbaowei.text=@"";
            Listingcell.lbbaowei.textColor=[UIColor redColor];
            ShoppingModel *model =  [UserDataSingleton userInformation].shoppingArray[indexPath.row];
            model.num=[Listingcell.textField.text integerValue];
            if (_isback==1) {
                if ([Listingcell.textField.text isEqualToString:Listingcell.listingModel.shengyurenshu])
                {
                    Listingcell.btbaowei.selected = YES;
                    Listingcell.lbbaowei.text=@"购买人次自动调整为包尾人次！";
                    Listingcell.lbbaowei.textColor=[UIColor redColor];
                    Listingcell.listingModel.isbaowei=1;
                }
                else
                {
                    Listingcell.btbaowei.selected = NO;
                    Listingcell.lbbaowei.text=@"";
                    Listingcell.lbbaowei.textColor=[UIColor redColor];
                }
            }
        }
        else
        {
            if (indexPath.row==_seletecell) {
if (Listingcell.listingModel.isbaowei==0)
                {
                    Listingcell.textField.text=[NSString stringWithFormat:@"%@",Listingcell.listingModel.yunjiage];
                    Listingcell.btbaowei.selected = NO;
                    Listingcell.lbbaowei.text=@"";
                    Listingcell.lbbaowei.textColor=MainColor;
                    ShoppingModel *model =  [UserDataSingleton userInformation].shoppingArray[_seletecell];
                    model.num=[Listingcell.textField.text integerValue];
                    Listingcell.num=model.num;
                    
                }
                else
                {
                    Listingcell.btbaowei.selected = YES;
                    Listingcell.textField.text=Listingcell.listingModel.shengyurenshu;
                    Listingcell.lbbaowei.text=@"购买人次自动调整为包尾人次！";
                    Listingcell.lbbaowei.textColor=[UIColor redColor];
                    ShoppingModel *model =  [UserDataSingleton userInformation].shoppingArray[_seletecell];
                    model.num=[Listingcell.textField.text integerValue];
                    Listingcell.num=model.num;
                }
            }
        }
    }
    
    
    if ([Listingcell.textField.text isEqualToString:Listingcell.listingModel.shengyurenshu])
    {
        Listingcell.btbaowei.selected = YES;
        Listingcell.lbbaowei.text=@"购买人次自动调整为包尾人次！";
        Listingcell.lbbaowei.textColor=[UIColor redColor];
        Listingcell.listingModel.isbaowei=1;
            }else
    {
        Listingcell.btbaowei.selected = NO;
        Listingcell.lbbaowei.text=@"";
        Listingcell.lbbaowei.textColor=[UIColor redColor];
    }

    
    self.index = indexPath.row;
    [Listingcell.btbaowei addTarget:self action:@selector(setbaowei:) forControlEvents:UIControlEventTouchUpInside];
    Listingcell.btbaowei.tag=indexPath.row;
    Listingcell.textField.tag = self.index;
    Listingcell.delegate = self;
    Listingcell.tintColor = MainColor;
    [self jieSuan];
    return Listingcell;
}


-(void)viewWillDisappear:(BOOL)animated{
    _firstcome=0;
    _isback=1;
    
}
-(void)setbaowei:(UIButton*)sender{
    _firstcome=1;
    int index=(int)sender.tag;
    _seletecell=index;
ListingModel*model=[_dataArray objectAtIndex:index];

    if (model.isbaowei==0)
    {
        
        model.isbaowei=1;
    }
    else
    {
        
        model.isbaowei=0;
        
    }
    [_tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

#pragma mark - 删除
- (void)deleteData
{
    if ([self.deleteDict count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        
        [_editButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
        [_editButton setTitle:@"" forState:UIControlStateNormal];
        
        [self.deleteDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            self.idd = key;
            for (int i = 0; i < [UserDataSingleton userInformation].shoppingArray.count; i++)
            {
                ShoppingModel *model = [UserDataSingleton userInformation].shoppingArray[i];
                if ([model.goodsId isEqualToString:self.idd])
                {
                    [[UserDataSingleton userInformation].shoppingArray removeObjectAtIndex:i];
                }

            }

        }];
        self.idd = @"";
        [self refreshData];
        [self.deleteDict removeAllObjects];
        [self.selectedArray removeAllObjects];
        [self.tableView setEditing:NO animated:YES];
        _isDelete = NO;
        self.deleteView. hidden = YES;
        //通知 改变徽标个数
        NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        self.numLabel.text = [NSString stringWithFormat:@"共%ld件商品",[UserDataSingleton userInformation].shoppingArray.count];
        
        if ([UserDataSingleton userInformation].shoppingArray.count == 0)
        {
            self.settlementView.hidden = YES;
        }
    }
    
}

#pragma mark 全选中
- (void)selected:(UIButton *)button
{
    
    if (_isAllSelected ==NO)
    {
        [self.selectedArray removeAllObjects];
        
        for (int row=0; row<[UserDataSingleton userInformation].shoppingArray.count; row++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            ShoppingModel *model = [UserDataSingleton userInformation].shoppingArray[row];
            [self.deleteDict setValue:indexPath forKey:model.goodsId];
            [self.selectedArray addObject:model];
            [button setBackgroundImage:[UIImage imageNamed:@"recharge_choose"] forState:UIControlStateNormal];
        }
        self.deleteLabel.text = [NSString stringWithFormat:@"共选中%lu件商品",self.selectedArray.count];
        
        _isAllSelected = YES;
    }
    else
    {
        
        [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.selectedArray removeAllObjects];
        [self.deleteDict removeAllObjects];
        
        self.deleteLabel.text = [NSString stringWithFormat:@"共选中%lu件商品",self.selectedArray.count];
        _isAllSelected = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"recharge_no_choose"] forState:UIControlStateNormal];

    }
    
}

#pragma mark 结算
- (void)settlement
{
    __block NSString *settlementString;
    NSMutableArray *settlementArray = [NSMutableArray array]; //结算array
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    if ([UserDataSingleton userInformation].isLogin == YES)
    {
        //解析数据对象
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            settlementString =  [NSString stringWithFormat:@"{\"shopid\":%@,\"number\":%ld}",obj.goodsId,(long)obj.num];
            [settlementArray addObject:settlementString];
            DebugLog(@"str:---------%@",settlementString);
        }];
        NSString *string = [NSString stringWithFormat:@"[%@]",[settlementArray componentsJoinedByString:@","]];
        DebugLog(@"!!!!!!!!!!!解析%@",string);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict setValue:string forKey:@"cart"];
        [dict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"ver"];
        [MDYAFHelp AFPostHost:APPHost bindPath:xinjiesuan postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"====%@",responseDic);
            if ([responseDic[@"code"] isEqualToString:@"302"])
            {
                [SVProgressHUD showErrorWithStatus:@"请登录"];
                
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            if ([responseDic[@"code"]isEqualToString:@"400"])
            {
               [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                [SVProgressHUD dismiss];
                
                [self.classArray removeAllObjects];
                [self.zhifuNameArray removeAllObjects];
                [self.zhifuTishiArray removeAllObjects];
                [self.zhifuColorArray removeAllObjects];
                [self.zhifuImgArray removeAllObjects];
                
                NSDictionary *dict = responseDic[@"data"];
                SettlementModel *model = [[SettlementModel alloc]initWithDictionary:dict];
//                DebugLog(@"===================%@",model.jiage);
                for (int i=0; i<model.pay_type.count; i++) {
                    NSDictionary*dic1=[model.pay_type objectAtIndex:i];
                    [self.classArray addObject:dic1[@"pay_class"]];
                    [self.zhifuNameArray addObject:dic1[@"pay_name"]];
                    [self.zhifuTishiArray addObject:dic1[@"tishi"]];
                    [self.zhifuColorArray addObject:dic1[@"color"]];
                    [self.zhifuImgArray addObject:dic1[@"img"]];
                    
                    DebugLog(@"---->%@",self.classArray);
                    DebugLog(@"++++>%@",self.zhifuNameArray);
                }
                
                SettlementViewController *settVC = [[SettlementViewController alloc]init];
                settVC.settModel = model;
                settVC.goods = string;
                settVC.totalYue = [NSString stringWithFormat:@"%@",dict[@"totalYue"]];
                settVC.classArray=self.classArray;
                settVC.zhifuNameArray=self.zhifuNameArray;
                settVC.zhifuTishiArray=self.zhifuTishiArray;
                settVC.zhifuColorArray=self.zhifuColorArray;
                settVC.zhifuImgArray=self.zhifuImgArray;
               [self.navigationController pushViewController:settVC animated:YES];
                _isback=1;
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
            [settlementArray removeAllObjects];
            DebugLog(@"%@",error);
            NSData *data = [operation responseData];
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            DebugLog(@"请求下来的数据%@",str);
        }];
    }
    else
    {
        [SVProgressHUD dismiss];
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [self refreshData];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    DebugLog(@"===--%ld",(long)textField.tag);
    
    if ([UserDataSingleton userInformation].shoppingArray.count>IPhone4_5_6_6P(1, 1, 2, 2)&&textField.tag>IPhone4_5_6_6P(0, 0, 1, 1)) {
        self.tableView.contentOffset=CGPointMake(0, 160*(textField.tag-IPhone4_5_6_6P(0, 0, 1, 1))-IPhone4_5_6_6P(20, 90, 20, 20));
        
    }
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.tableView.contentOffset=CGPointMake(0, 0);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.left.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
    
    
    [_editButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    [_editButton setTitle:@"" forState:UIControlStateNormal];
    
    [self initData];
    [self refreshData];
    self.numLabel.text = [NSString stringWithFormat:@"共%li件商品",[UserDataSingleton userInformation].shoppingArray.count];
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        self.settlementView.hidden = YES;
    }
    else
    {
        self.settlementView.hidden = NO;
        
    }
    [self refreshData];
    
    
}
//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        
        
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.imageView.image = [UIImage imageNamed:@"pic_empty_shopping_cart"];
        _nodataView.titleLabel.text=@"购物车空空如也~";
        _nodataView.type=1;
        _nodataView.textLabel.text=@"";
        [_nodataView.btgoto setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];

    }
    
    [self.view addSubview:self.nodataView];
}
- (void)nonetworking
{
    if (!self.nonetwork)
    {
        self.nonetwork = [[NoNetwork alloc]init];
        
        [self.nonetwork.btrefresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.nonetwork];
}

-(void)Lasetesannaction{
    
    }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 6) {
        return NO;
    }
    
    
    return YES;
}



-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
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
