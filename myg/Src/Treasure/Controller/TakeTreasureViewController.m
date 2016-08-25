//
//  TakeTreasureViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//主页

#import "TakeTreasureViewController.h"

#import "AdvertisingCell.h" //轮播

#import "RadioCell.h" //广播

#import "GoodsCell.h" //商品

#import "ClassificationViewController.h" //分类浏览

#import "SearchViewController.h" //搜索

#import "ClassificationGoodsViewController.h" // 共用。 10元  分类....

#import "ProblemViewController.h" //常见问题

#import "LoginViewController.h" //测试登陆

#import "GoodsDetailsViewController.h" //商品详情


#import "OrdershareController.h"   //晒单分享

#import "GoodsModel.h"

#import "AdModel.h"

#import "IanScrollView.h"
#import "ListingViewController.h"

@interface TakeTreasureViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) UIView *buttonView; // 4 分类
@property (nonatomic, strong) UIImageView *shangImageView;
@property (nonatomic, strong) UIImageView *xiaImageView;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, copy) NSString *classNum; // 类型
@property (nonatomic, assign) NSInteger tagd; //按钮状态

@property (nonatomic, strong) AdScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageArray; // 轮播图


@end

@implementation TakeTreasureViewController
{
    BOOL _isSorting;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //LoginViewController *loginVC = [[LoginViewController alloc]init];
    //[self.navigationController pushViewController:loginVC animated:YES];
    self.left.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

      
    [self initData];
    [self refreshData];
    [self setNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushi:) name:@"NavPushi" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shaidan) name:@"shaidan" object:nil];
//    
    
}

//-(void)shaidan{
//    
////           ListingViewController *classVC = [[ListingViewController alloc]init];
////            classVC.hidesBottomBarWhenPushed = NO;
////  
////            [self.navigationController pushViewController:classVC animated:YES];
//
////    
//}









//修改的－－－一元寻宝
#pragma mark - 通知
- (void)pushi:(NSNotification *)text
{
    GoodsModel *model = text.userInfo[@"Id"];
    DebugLog(@"~~~~~%@",model.idd);
    DebugLog(@"收到通知");

    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    detailsVC.tiaozhuantype = 1;
    detailsVC.idd = model.idd;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - 导航 - 搜索
- (void)setNavBar
{
   
    UIButton *sellerDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    sellerDetail.frame = CGRectMake(50, 20, 27, 29);
    [sellerDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sellerDetail setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    sellerDetail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sellerDetail addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leBtn = [[UIBarButtonItem alloc] initWithCustomView:sellerDetail];
    self.navigationItem.leftBarButtonItem = leBtn;

}

#pragma mark  - 搜索
- (void)search
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];

}

#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    self.btns = [NSMutableArray array];
    self.classNum = @"10";
    self.tagd = 101;
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    
    self.num = 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:self.classNum forKey:@"order"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    DebugLog(@"==========%@",dict[@"order"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:Goods postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [self refreshSuccessful:responseDic];
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
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GoodsModel *model = [[GoodsModel alloc]initWithDictionary:obj];
                DebugLog(@"成功%@",model.title);

                [self.dataArray addObject:model];
            }];
        }
        
    }
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    [self createTableView];

}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    NSLog(@"失败");
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    
    self.num = self.num +1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.classNum forKey:@"order"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
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
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GoodsModel *model = [[GoodsModel alloc]initWithDictionary:obj];
                DebugLog(@"成功%@",model.title);
                
                [self.dataArray addObject:model];
            }];
        }
        
    }
    
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
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
    if (!self.tableView)
    {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) pullingDelegate:self style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //    self.tableView.showsVerticalScrollIndicator = FALSE;
        //    self.tableView.showsHorizontalScrollIndicator = FALSE;
        
        [self.view addSubview:self.tableView];
        [self requestPicture];
    }
}


#pragma mark - 轮播图
- (void)requestPicture
{
    self.imageArray = [NSMutableArray array];
    [MDYAFHelp AFGetHost:APPHost bindPath:ShufflingFigure param:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic isKindOfClass:[NSDictionary class]])
        {
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                NSArray *array = responseDic[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AdModel *model = [[AdModel alloc]initWithDictionary:obj];
                    [self.imageArray addObject:model];
                }];
                [self createUI];
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];

    }];
    
}

- (void)createUI
{
    
    IanScrollView *scrollView = [[IanScrollView alloc] initWithFrame:CGRectMake(0, 0, MSW , 150)];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < self.imageArray.count; i ++) {
        [array addObject:[NSString stringWithFormat:((AdModel *)self.imageArray[i]).img]];
    }
    scrollView.slideImagesArray = array;
    scrollView.ianEcrollViewSelectAction = ^(NSInteger i){
        
        NSLog(@"点击了%ld张图片",(long)i);
    };
    scrollView.ianCurrentIndex = ^(NSInteger index){
        NSLog(@"测试一下：%ld",(long)index);
    };
    scrollView.PageControlPageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:244/255.0f blue:227/255.0f alpha:1];
    scrollView.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
    scrollView.autoTime = [NSNumber numberWithFloat:4.0f];
    NSLog(@"%@",scrollView.slideImagesArray);
    [scrollView startLoading];

    self.tableView.tableHeaderView =  scrollView;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage =  scrollView.contentOffset.x / MSW;
    
}



#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  //  return self.dataArray.count;
    if (section == 0)
    {
        return 2;
    }
    else
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && indexPath.row == 0)
    {
        static NSString *cellName = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        
        // 4类
        for (NSInteger i = 0; i < 4; i ++)
        {
            UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(MSW / 4 * i, 0, MSW / 4, 90)];
            btnView.userInteractionEnabled = YES;
            btnView.layer.masksToBounds = YES;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnView.frame.size.width / 2 - 20, 15, 40, 40);
            btn.tag = 101 + i;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            switch (btn.tag)
            {
                case 101:
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"1-11"] forState:UIControlStateNormal];
                    
                }
                    
                    break;
                case 102:
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"1-12"] forState:UIControlStateNormal];
                    
                }
                    
                    break;
                case 103:
                {
                    
                    [btn setBackgroundImage:[UIImage imageNamed:@"1-13"] forState:UIControlStateNormal];
                    
                }
                    break;
                    
                default:
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"1-14"] forState:UIControlStateNormal];
                    
                    
                }
                    break;
            }
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.size.height + btn.frame.origin.y + 5, btnView.frame.size.width, 10)];
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 101 + i;
            switch (label.tag)
            {
                case 101:
                {
                    label.text = @"分类";
                }
                    break;
                case 102:
                {
                    label.text = @"10元专区";
                    
                }
                    break;
                case 103:
                {
                    label.text = @"晒单";
                    
                }
                    break;
                    
                    
                default:
                {
                    label.text = @"常见问题";
                    
                }
                    break;
            }
            
            [btnView addSubview:btn];
            [btnView addSubview:label];
            [cell addSubview:btnView];
        }
        cell.userInteractionEnabled = YES;
        return cell;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
 
        static NSString *radioCellName = @"RadioCell.h";
        RadioCell *radioCell = [tableView dequeueReusableCellWithIdentifier:radioCellName];
        if (!radioCell)
        {
            radioCell = [[RadioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:radioCellName];
        }
        
        return radioCell;

    }
    
    else
    {
                static NSString *GoodsCellName = @"GoodsCell";
        GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsCellName];
        if (!cell)
        {
            cell = [[GoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoodsCellName];
        }
        
        //cell.textLabel.text = @"111";
        cell.dataArray = self.dataArray;
        DebugLog(@"!!!!!!!!!!!%li",self.dataArray.count);
        cell.indx = 0;
        [cell.collectionView reloadData];
        return cell;
    }
}

#pragma mark - 4分类点击事件
- (void)buttonClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 101:
        {
            //分类
            ClassificationViewController *classificationVC = [[ClassificationViewController alloc]init];
            [self.navigationController pushViewController:classificationVC animated:YES];
        
        }
            break;
        case 102:
        {
            //十元专区
            ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
            [self.navigationController pushViewController:classVC animated:YES];

                    
            
        }
            break;
        case 103:
        {
            
            OrdershareController *classVC = [[OrdershareController alloc]init];
             
            [self.navigationController pushViewController:classVC animated:YES];
            

        }
            break;
            
        default:
        {
            //常见问题
            ProblemViewController *problemVC = [[ProblemViewController alloc]init];
            [self.navigationController pushViewController:problemVC animated:YES];
        
        }
            break;
    }


}


#pragma mark - 返回Cell的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 90;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        return 36;
    }
    else
    {
        return self.dataArray.count / 2 * 180;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
        return 50;
}


#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DebugLog(@"%li===========%li",indexPath.section,indexPath.row);
    
}

#pragma mark - 自定义section
- (UIView *)tableView:(UITableView *)tableView

viewForHeaderInSection:(NSInteger)section

{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    for (NSInteger i = 0; i < 4 ; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(IPhone4_5_6_6P(80, 80, 90, 100) * i + 10, 0, 12 * 4, 50);
        button.tag = 101 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sortingButton:) forControlEvents:UIControlEventTouchUpInside];     
        
        switch (button.tag)
        {
            case 101:
            {
                [button setTitle:@"人气" forState:UIControlStateNormal];
                
               
                
               
                
                 [self.btns addObject:button];

            }
                break;
            case 102:
            {
                [button setTitle:@"最新" forState:UIControlStateNormal];
                [self.btns addObject:button];

            }
                break;
            case 103:
            {
                [button setTitle:@"进度" forState:UIControlStateNormal];
                [self.btns addObject:button];

            }
                break;
                
            default:
            {
                [button setTitle:@"总需人次" forState:UIControlStateNormal];
                [self.btns addObject:button];

                self.shangImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1-16-1"]];
                self.shangImageView.frame = CGRectMake(button.frame.size.width + button.frame.origin.x , 16, 11, 11);
                [headerView addSubview:self.shangImageView];
                self.xiaImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1-17-1"]];
                self.xiaImageView.frame = CGRectMake(button.frame.size.width + button.frame.origin.x , self.shangImageView.frame.origin.y + self.shangImageView.frame.size.height - 5, 11, 11);
                [headerView addSubview:self.xiaImageView];
            }
                break;
        }
        
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, MSW, 0.5)];
        myView.backgroundColor = RGBCOLOR(219, 219, 219);
        [headerView addSubview:myView];
        [headerView addSubview:button];
        
    }
    
   
    return headerView;
    
}

#pragma mark - 刷新tableview
- (void)sortingButton:(UIButton *)button
{
    DebugLog(@"%li",button.tag);

    self.tagd =  button.tag;
    for (UIButton *tempButton in self.btns)
    {
        if (tempButton.selected == YES && tempButton.tag != button.tag)
        {
            tempButton.selected = NO;
            [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else{
            button.selected = YES;
            [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
    }

    switch (button.tag)
    {
        case 101:
        {
        self.classNum = @"10";
            [self refreshData];
        }
            break;
        case 102:
        {
            self.classNum = @"20";
            [self refreshData];
        }
            break;
        case 103:
        {
            self.classNum = @"30";
            [self refreshData];
        }
            break;
        case 104:
        {
            _isSorting = !_isSorting;
            if (_isSorting)
            {
                self.classNum = @"40";
            }
            else
            {
                self.classNum = @"50";

            }
            [self refreshData];
        }
            break;
            
        default:
            break;
    }
    

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
