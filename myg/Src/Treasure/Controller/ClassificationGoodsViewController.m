//
//  ClassificationGoodsViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/10.
//  Copyright (c) 2015年 杨易. All rights reserved.
//
//分类商品  10元 
#import "ClassificationGoodsViewController.h"

#import "ClassificationGoodsCell.h"

#import "GoodsModel.h"
#import "GoodsDetailsViewController.h"
#import "NewGoodsModel.h"
@interface ClassificationGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UIScrollViewDelegate,ClassificationGoodsCellDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) GoodsModel *goodsModel; //判断
@property (nonatomic, copy) NSString *yunjiage;
@property (nonatomic, strong) NSString *count;  //商品总数

@property (nonatomic, strong) NoDataView *nodataView;
@property (nonatomic, strong) UIView *view1;


@end

@implementation ClassificationGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBar];
    [self initData];
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber) name:@"shoppingNum" object:nil];
//    ------－－修改－－－-商品列表－－－－
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchtongzhi:) name:@"search" object:nil];
    
}
-(void)searchtongzhi:(NSNotification *)model{
    
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    DebugLog(@"收到通知");
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    [self.navigationController pushViewController:goods animated:YES];
}


#pragma mark 设置导航
- (void)setNavBar
{
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    UIImageView * img= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartdetail"]];
    img.frame = CGRectMake(0, 5, 30, 30);
    [self.view1 addSubview:img];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageNamed:@"cartdetail"]
//                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shopping)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 40, 40);
    [self.view1 addSubview:button];
    
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:self.view1];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 16, 16)];
    self.numLabel.font = [UIFont systemFontOfSize:8];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.layer.cornerRadius = 8;
    self.numLabel.backgroundColor = [UIColor whiteColor];
    self.numLabel.textColor = MainColor;
    self.numLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:SmallFont];
    self.numLabel.hidden = NO;
    self.numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        self.numLabel.hidden = YES;
    }      [button addSubview:self.numLabel];
    self.navigationItem.rightBarButtonItem = menuButton;
}

- (void)shopping
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 购物车数量
- (void)changeNumber
{
    self.numLabel.hidden = NO;
    self.numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        self.numLabel.hidden = YES;
    }
    
}

#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    self.num = 1;
    
    DebugLog(@"---%@-----%@---",_fromcateid,self.dataString);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_fromcateid forKey:@"cateid"];
    [dict setValue:self.dataString forKey:@"search"];

    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.num] forKey:@"p"];
    if (_isVIP==1) {
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];

    }
    
    //添加历史记录
    if (!IsStrEmpty([UserDataSingleton userInformation].uid)) {
        
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];

    }
    [MDYAFHelp AFPostHost:APPHost bindPath:Goods postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                DebugLog(@"shiyuan--%@----%@",responseDic,responseDic[@"msg"]);
        
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               [self refreshFailure:error];
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{

//    _titlestr=self.title;
////
//   self.title=@"";
}

- (void)refreshSuccessful:(id)data
{
    [SVProgressHUD dismiss];
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"200"])
        {
            self.tableView.footerView.state = kPRStatePulling;

            NSArray *array = data[@"data"];
            _count = data[@"count"];

            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GoodsModel *model = [[GoodsModel alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
                
            }];
//            修改的－－－标题－－－－－－
            if (_isVIP==1) {
                
            }else
            {
            self.title=[NSString stringWithFormat:@"搜索结果(%lu)" ,_dataArray.count];
            }
            if (_isSarch) {
                self.title = @"搜索结果";
                
            }
            if (_isSection) {
                if (!IsStrEmpty(_count)) {
                    self.title = [NSString stringWithFormat:@"%@(%@)",_titlestr,_count];
                    
                }else{
                    self.title = [NSString stringWithFormat:@"%@",_titlestr];
                }
            }
      if (!self.tableView)
            {
                [self createTableView];
            }

        }else{
//        没有数据－－－－－－－
            [self noData];
            
            if (_isSarch) {

            }else{
            
                DebugLog(@"dfghjkl");
            
            }        
        }
        
    }
    
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    
}

- (void)refreshFailure:(NSError *)error
{
     [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    
    [self.tableView tableViewDidFinishedLoading];
}


#pragma mark - 上拉加载更多
- (void)loadingData
{
    
    self.num = self.num +1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.dataString forKey:@"search"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    [dict setValue:self.fromcateid forKey:@"cateid"];

    [MDYAFHelp AFPostHost:APPHost bindPath:Goods postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [self loadingSuccessful:responseDic];
        
        DebugLog(@"成功%@",responseDic);
    
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self loadingFailure:error];
    }];
    
}

- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            _count = data[@"count"];

            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GoodsModel *model = [[GoodsModel alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            if([[NSString stringWithFormat:@"%lu",self.dataArray.count] isEqualToString:data[@"count"]])
            {
                [UIView animateWithDuration:2 animations:^{
                    
                } completion:^(BOOL finished) {
                    self.tableView.footerView.state = kPRStateHitTheEnd;
                }];
            }

        }
        if ([data[@"code"] isEqualToString:@"400"])
        {
            DebugLog(@"%@",data[@"msg"]);
                            [UIView animateWithDuration:2 animations:^{

                } completion:^(BOOL finished) {
                    self.tableView.footerView.state = kPRStateHitTheEnd;
                }];

            
        }
    }
    if (_isVIP==1) {
        
    }else{
        self.title=[NSString stringWithFormat:@"搜索结果(%lu)" ,_dataArray.count];
    }
    self.title =@"搜索结果";
    
    if (_isSection) {
        if (!IsStrEmpty(_count)) {
            self.title = [NSString stringWithFormat:@"%@(%@)",_titlestr,_count];
            
        }else{
            self.title = [NSString stringWithFormat:@"%@",_titlestr];
        }
    }
    [self.tableView tableViewDidFinishedLoading];

    [_tableView reloadData];
}

- (void)loadingFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    self.num = self.num -1;
    [self.tableView tableViewDidFinishedLoading];
}




#pragma mark - tableview继承滚动试图的协议
//滚动视图已经滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果滚动视图是Tableview的话 就执行方法
    if ([scrollView isEqual:self.tableView])
    {
        //tab已经滚动的时候调用
        [self.tableView tableViewDidScroll:self.tableView];
        
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
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = FALSE;
    //    self.tableView.showsHorizontalScrollIndicator = FALSE;
     //self.tableView.isClearFoot = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DebugLog(@"%li",self.dataArray.count);
   return self.dataArray.count;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoodsModel*model=[self.dataArray objectAtIndex:indexPath.row];
    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    detailsVC.tiaozhuantype = 1;
    detailsVC.idd = model.idd;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellName = @"ClassificationGoods";
    ClassificationGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[ClassificationGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
//        if (self.dataArray.count > 0)
//        {
//            cell.goodsModel = self.dataArray[indexPath.row];
//        }
//        cell.delegate = self;
    }
    
    
    cell.delegate = self;
    cell.goodsModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;

}

#pragma mark - 自定义section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"1";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 30)];
    view1.backgroundColor = RGBCOLOR(234, 234, 235);
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30)];
    textLabel.font = [UIFont systemFontOfSize:MiddleFont];
    textLabel.text = [NSString stringWithFormat:@"%@，共%lu件商品",self.nameString,(unsigned long)self.dataArray.count];
    
    
    
    
    
    
    [view1 addSubview:textLabel];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(MSW - 12 * 6 - 10, 0, 12 * 6, 40);
//    button.titleLabel.font = [UIFont systemFontOfSize:12];
//    [button addTarget:self action:@selector(addShopping) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"全部加入清单" forState:UIControlStateNormal];
//    [button setTitleColor:MainColor forState:UIControlStateNormal];
//    [view1 addSubview:button];
    
    return view1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSection)
    {
        return 0;
    }
    return 30;
}


#pragma mark - 购物车动画
- (void)clickCell:(ClassificationGoodsCell *)cell
{
    //用坐标转化就将传出来的按钮左边转换为相对self.view的坐标
    CGRect rect = [cell.pictureImageView convertRect:cell.pictureImageView.bounds toView:self.view];
    //创建一个视图，模拟购物图片
    UIImageView *someThing = [[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+64, 80, 80)];
    someThing.image  = cell.pictureImageView.image;

//    someThing.backgroundColor = [UIColor redColor];
    someThing.layer.cornerRadius = 10;
    //加入到父视图
  //  [self.view addSubview:someThing];
    [self.navigationController.view addSubview:someThing];

    
    //动画改变坐标
    [UIView animateWithDuration:1 animations:^{
        someThing.frame = CGRectMake(self.view1.frame.origin.x ,self.view1.frame.origin.y + 5 ,20,20);
    } completion:^(BOOL finished) {
        [someThing removeFromSuperview];
    }];

}


#pragma mark 全部加入购物车
- (void)addShopping
{
    [self.dataArray enumerateObjectsUsingBlock:^(GoodsModel *obj, NSUInteger idx, BOOL *stop) {
        DebugLog(@"!!!!!%@",obj.idd);
    }];
    
    if (self.dataArray.count > 0)
    {
        if ([UserDataSingleton userInformation].shoppingArray.count == 0)
        {
            [self.dataArray enumerateObjectsUsingBlock:^(GoodsModel *obj, NSUInteger idx, BOOL *stop) {
               
                if ([obj.yunjiage isEqualToString:@"1"])
                {
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.num = 1;
                    model.goodsId = obj.idd;
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
                else
                {
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.num = 10;
                    model.goodsId = obj.idd;
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
            }];
            [SVProgressHUD dismiss];
        }
        else
        {
            
            __block  BOOL isHaveId = NO;
            [self.dataArray enumerateObjectsUsingBlock:^(GoodsModel *goodsModel, NSUInteger idx, BOOL *stop) {

            [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *shaoppingModel, NSUInteger idx, BOOL *stop) {
                    self.yunjiage = goodsModel.yunjiage;
                    if ([shaoppingModel.goodsId isEqualToString:goodsModel.idd])
                    {
                        if ([self.yunjiage isEqualToString:@"1"])
                        {
                            shaoppingModel.num = shaoppingModel.num + 1;
                            isHaveId = YES;
                            *stop = YES;
                        }
                        else
                        {
                            shaoppingModel.num = shaoppingModel.num+ 10;
                            isHaveId = YES;
                            *stop = YES;
                        }
                    }
                    if(isHaveId == NO)
                    {
                        if ([self.yunjiage isEqualToString:@"1"])
                        {
                            ShoppingModel *model = [[ShoppingModel alloc]init];
                            model.num = 1;
                            model.goodsId = goodsModel.idd;
                            DebugLog(@"idd:%@",goodsModel.idd);
                            [[UserDataSingleton userInformation].shoppingArray addObject:model];
                            *stop = YES;
                        }
                        else
                        {
                            ShoppingModel *model = [[ShoppingModel alloc]init];
                            model.num =  10;
                            model.goodsId = goodsModel.idd;
                            DebugLog(@"idd2:%@",goodsModel.idd);
                            
                            [[UserDataSingleton userInformation].shoppingArray addObject:model];
                            *stop = YES;
                        }
                    }
                }];
                
            }];
      
        }
            
    }

    NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}



//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        if (_isSection) {
            _nodataView.titleLabel.text=@"暂时没有该类商品";
        }else{
            _nodataView.titleLabel.text=[NSString stringWithFormat:@"抱歉，没有关键字为%@的商品",_nameString];
            
        }
        
        _nodataView.frame=CGRectMake(0, 0, MSW, MSH);
        
        _nodataView.titleLabel.frame=CGRectMake(0, _nodataView.titleLabel.frame.origin.y-10, MSW, _nodataView.titleLabel.frame.size.height);
        _nodataView.imageView.hidden=NO;
        _nodataView.textLabel.text=@"";
        _nodataView.type=7;
        [_nodataView.btgoto setTitle:@"马上去夺宝" forState:UIControlStateNormal];
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
