//
//  HomeViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "HomeViewController.h"
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
#import "MJRefresh.h"
#import "GoodsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "HeadlineScrollview.h"
#import "PWWebViewController.h" //获得网站链接
#import "PictureDetailController.h"
#import "UIImageView+WebCache.h"
#import "LanMuModel.h"
#import "MyStudentController.h"//招募徒弟
#import "NewGoodsModel.h"

#import "LatestAnnouncedModel.h" // model
#import "NewRedController.h"
#import "LatesAnnViewCell.h"
#import "NotifyController.h"

#import "AwardTipView.h"
#import "WinningRecordViewController.h"
#import "EGOImageLoader.h"
#import <ShareSDK/ShareSDK.h>
#import "FindTreasureController.h"
#import "SettlementViewController.h"
#import "SettlementModel.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HeadlineScrollviewDelegate,GoodsCollectionViewCellDelegate,UIScrollViewDelegate, CloseTipViewDelegate>{
    NSInteger       _timedata; //时间计时
    
    NSString                *_url;      //下载页url
    NSString                *_title;    //推广标题
    NSString                *_content;   //推广内容
    NSString                *_imgurl;
    
    UILabel* lbtime;
    UILabel* lbtime2;
    UILabel* lbtime3;
    
    UIView      *_redLine;
    UIView      *_redLine2;
    UIButton    *_lastSelectedBtn;
    UIButton    *_lastSelectedBtn2;
    UIButton *sellerDetail;
}
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) UIView *buttonView; // 4 分类
@property (nonatomic, strong) UIImageView *shangImageView;
@property (nonatomic, strong) UIImageView *xiaImageView;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, copy) NSString *classNum; // 类型
@property (nonatomic, assign) NSInteger tagd; //按钮状态
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageArray; // 轮播图
@property (nonatomic, strong) IanScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *barArray; //栏目数组
@property (nonatomic, strong) HeadlineScrollview  *radioScrollView; // 广播
@property (nonatomic, strong) UIView *headerView;  //按钮分类view
@property (nonatomic, strong) UIView *headerView2;
@property (nonatomic,strong) NSMutableArray        *headlineArray;  //首页公告
@property (nonatomic, strong) UITapGestureRecognizer *tap; //手势
@property (nonatomic, assign) int buttonstate; //人气颜色
@property (nonatomic, strong) UIImageView *btn;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSMutableArray *NewGoodsArray;
@property (nonatomic, strong) NSMutableArray *LatesAnnArray;

@property (nonatomic, strong) UICollectionViewFlowLayout *layOut2;

@property (nonatomic, strong) UICollectionView *collectionView2;

@property (nonatomic, strong) NoNetwork *nonetwork;

//Added by Winzlee(liwenzhi)
@property (nonatomic, strong) NSMutableArray  *awardTipArray;
@property (nonatomic, strong) AwardTipView    *awardTipView;
/** 中奖提示索引 */
@property (nonatomic, assign) int             index;


@end

static NSString *collectionCellName = @"collectionCell";
static NSString *collectionCellName2 = @"collectionCell";
@implementation HomeViewController
{
    
    BOOL _isSorting;
    int seleview;
    UIView*latesview;
    
    int ishave;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self NewGoodsproduct];
    
    //            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 95 ,24)];
    //            UIImageView *titleView=[[UIImageView alloc] initWithFrame:view1.bounds];
    //            titleView.image = [UIImage imageNamed:@"首页标题logo"];
    //            [view1 addSubview:titleView];
    //            self.navigationItem.titleView= view1;
    
    
    self.left.hidden = YES;
    self.headlineArray = [NSMutableArray array];
    _buttonstate=1;
    
    [self initData];
//    [self initcollectionView];
    [self setNavBar];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kaijiangTishi) name:@"homeOpenJiang" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jiexiaoRes) name:@"jiexiaoResult" object:nil];
    
}
- (void)jiexiaoRes{
    
    DebugLog(@"揭晓结果");
    
    [self GetLatesAnnounce];
    
    
    
}
- (void)kaijiangTishi{
    
    DebugLog(@"显示开奖提示");
    [self httpGetAwardTip];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _LatesAnnArray=[NSMutableArray array];
    [self GetLatesAnnounce];
    if (self.num>1) {
        
        DebugLog(@"ferce");
    }else{
        [self refreshData];
        
    }
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = NO;
    //    [self getTopNotice];
    //    [self startTimer];
    
    [self httpGetAwardTip];

}

#pragma mark - 请求新品推介

-(void)NewGoodsproduct{
    _NewGoodsArray=[NSMutableArray array];
    [MDYAFHelp AFPostHost:APPHost bindPath:NewGoods postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"～～新品推介：%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = responseDic[@"data"];
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NewGoodsModel *model = [[NewGoodsModel alloc]initWithDictionary:obj];
                [self.NewGoodsArray addObject:model];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
}
#pragma mark - 请求最新揭晓
-(void)GetLatesAnnounce{
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Announced postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"～～～请求最新揭晓：%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            [_LatesAnnArray removeAllObjects];
            NSArray *array = responseDic[@"data"];
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LatestAnnouncedModel *model = [[LatestAnnouncedModel alloc]initWithDictionary:obj];
                [self.LatesAnnArray addObject:model];
            }];

        }
        if (_LatesAnnArray.count>0) {
            ishave=1;
        }else{
            
            ishave=2;
        }
        
        [self.collectionView2 reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
}


- (void)crateView
{
    if (!self.headerView2){
        //分类按钮
        self.headerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 50 - 10)];
        self.headerView2.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i = 0; i < 5 ; i ++)
        { UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(MSW/5 * i, 0,MSW/5, 50 - 10);
            button.tag = 101 + i;
            button.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:MainColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(sortingButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.textAlignment=UITextAlignmentCenter;
            button.backgroundColor=[UIColor clearColor];
            
            switch (button.tag)
            {
                case 101:
                {
                    [button setTitle:@"最热" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    button.selected = YES;
                    _lastSelectedBtn2 = button;
                    [self.btns addObject:button];
                    
                }
                    break;
                case 102:
                {
                    [button setTitle:@"最快" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                    
                }
                    break;
                case 103:
                {
                    [button setTitle:@"最新" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                    
                }
                    break;
                case 104:
                {
                    [button setTitle:@"高价" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                    
                }
                    break;
                    
                default:
                {
                    [button setTitle:@"低价" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                    
                }
                    break;
            }
            
            
            UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, MSW, 0.5)];
            myView.backgroundColor = RGBCOLOR(219, 219, 219);
            [self.headerView2 addSubview:myView];
            [self.headerView2 addSubview:button];
            
        }
        
        _redLine2 = [[UIView alloc]initWithFrame:CGRectMake(MSW/10-20, 38,40,2)];
        _redLine2.backgroundColor = MainColor;
        [self.headerView2 addSubview:_redLine2];
        
        self.headerView2.hidden = YES;
        [self.view addSubview:self.headerView2];
     }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.headerView2 removeFromSuperview];
    sellerDetail.userInteractionEnabled=YES;

    
}

#pragma mark - 滚动视图监听事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    DebugLog(@"==================%lf",scrollView.contentOffset.y);
    
    if (ishave==1) {
        if (scrollView.contentOffset.y >= MSW*0.4+MSW/3+30+10+30+10 + 10)
        {
            self.headerView2.hidden = NO;
        }
        if (scrollView.contentOffset.y <= MSW*0.4+MSW/3+30+10+30+10 +10)
        {
            self.headerView2.hidden = YES;
        }
    }else{
    
        if (scrollView.contentOffset.y >= MSW*0.4)
        {
            self.headerView2.hidden = NO;
        }
        if (scrollView.contentOffset.y <= MSW*0.4)
        {
            self.headerView2.hidden = YES;
        }
    
    }
}

#pragma mark - 导航 - 搜索
- (void)setNavBar
{
    //左导航
   sellerDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    sellerDetail.frame = CGRectMake(50, 20, 29, 29);
    [sellerDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sellerDetail setImage:[UIImage imageNamed:@"shouyesearch"] forState:UIControlStateNormal];
    sellerDetail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sellerDetail addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leBtn = [[UIBarButtonItem alloc] initWithCustomView:sellerDetail];
    self.navigationItem.leftBarButtonItem = leBtn;
    //右导航
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    message.frame = CGRectMake(MSW-50, 20, 29, 29);
    [message setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [message setImage:[UIImage imageNamed:@"shouyetongzhi"] forState:UIControlStateNormal];
    message.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [message addTarget:self action:@selector(message) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}


#pragma mark  - 搜索
- (void)search
{
//    SearchViewController *searchVC = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:searchVC animated:YES];
    //分类
    sellerDetail.userInteractionEnabled=NO;
    ClassificationViewController *classificationVC = [[ClassificationViewController alloc]init];
    [self.navigationController pushViewController:classificationVC animated:YES];
    
}

#pragma mark  - 消息
-(void)message
{
    NotifyController *userData = [[NotifyController alloc]init];
    userData.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:userData animated:YES];
}
#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    _awardTipArray = [NSMutableArray array];
    self.btns = [NSMutableArray array];
    self.barArray = [NSMutableArray array];
    self.btnArray = [NSMutableArray array];
    self.classNum = @"10";
    self.tagd = 101;
}


#pragma mark   添加 下拉刷新 和 上拉 加载
-(void)addPullRefreshToCollectionView:(UICollectionView *)collectionView
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshData];
        [weakSelf GetLatesAnnounce];
    }];
    [collectionView.mj_header beginRefreshing];
    
    // 上拉加载
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    // 默认先隐藏footer
    collectionView.mj_footer.hidden = YES;
}

#pragma mark 刷新数据的方法
-(void)refreshData
{
    self.num = 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.classNum forKey:@"order"];
    DebugLog(@"--%@",self.classNum);
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    DebugLog(@"==========%@",dict[@"order"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:Goods postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        [self requestPicture];
        [self refreshSuccessful:responseDic];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self refreshFailure:error];
   
    }];
}


- (void)refreshSuccessful:(id)data
{
    
    
    [self.nonetwork removeFromSuperview];
    [self.dataArray removeAllObjects];
    
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            self.collectionView.mj_footer.state = MJRefreshStateIdle;
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GoodsModel *model = [[GoodsModel alloc]initWithDictionary:obj];
                DebugLog(@"成功%@",model.title);
                
                [self.dataArray addObject:model];
            }];
        }
        
    }
    [self initcollectionView];
    
    [self.collectionView reloadData];
    // 结束刷新
    [self.collectionView.mj_header endRefreshing];
}

- (void)refreshFailure:(NSError *)error
{
    
    [self nonetworking];
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    [self.collectionView.mj_header endRefreshing];
    
}


#pragma mark 加载数据的方法
-(void)loadMoreData
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
    
    [self.nonetwork removeFromSuperview];

    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"400"])
        {
            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            
        }
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GoodsModel *model = [[GoodsModel alloc]initWithDictionary:obj];
                DebugLog(@"成功%@",model.title);
                if ([[NSString stringWithFormat:@"%lu",self.dataArray.count] isEqualToString:data[@"count"]])
                {
                    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                
                [self.dataArray addObject:model];
                [self.collectionView.mj_footer endRefreshing];
                
            }];
        }
        
    }
    [self.collectionView reloadData];
}

- (void)loadingFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"当前网络不给力"];
    [self nonetworking];
    self.num = self.num -1;
    [self.collectionView.mj_footer endRefreshing];
}


#pragma mark - 轮播图
- (void)requestPicture
{
    self.imageArray = [NSMutableArray array];
    [MDYAFHelp AFGetHost:APPHost bindPath:ShufflingFigure param:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic isKindOfClass:[NSDictionary class]])
        {
            DebugLog(@"=-%@",responseDic);
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                NSArray *array = responseDic[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AdModel *model = [[AdModel alloc]initWithDictionary:obj];
                    
                    DebugLog(@" 轮播图-－－－-%@------%@",responseDic,model.img);
                    
                    [self.imageArray addObject:model];
                }];
                
                if (ishave==1 ||ishave==2) {
                    [self createUI];
 
                }
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}
#pragma mark - 请求栏目
- (void)renquelanmu
{
    [MDYAFHelp AFPostHost:APPHost bindPath:Bar postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"栏目：%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = responseDic[@"data"];
            DebugLog(@"栏目数量====%ld",(unsigned long)self.barArray.count);
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LanMuModel *model = [[LanMuModel alloc]initWithDictionary:obj];
                [self.barArray addObject:model];
                
                DebugLog(@"%lu---%@",self.barArray.count,model.thumb);
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
}

#pragma mark - UI
- (void)createUI
{
   
    if (!self.scrollView)
    {
        self.scrollView = [[IanScrollView alloc] initWithFrame:CGRectMake(0, 0, MSW ,MSW*0.4)];
        NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < self.imageArray.count; i ++) {
            [array addObject:[NSString stringWithFormat:@"%@",((AdModel *)self.imageArray[i]).img]];
        }
        self.scrollView.slideImagesArray = array;
        self.scrollView.ianEcrollViewSelectAction = ^(NSInteger i){
            
            
            
            AdModel *model=[self.imageArray objectAtIndex:(long)i];
            
            if ([model.type isEqualToString:@"1"]) {//文章
                PictureDetailController *classVC = [[PictureDetailController alloc]init];
                classVC.style=3;
                classVC.fromtitle=model.title;
                classVC.fromurl=model.val;
                [self.navigationController pushViewController:classVC animated:YES];
            }
            if ([model.type isEqualToString:@"2"]) {//专题
                PictureDetailController *classVC = [[PictureDetailController alloc]init];
                classVC.style=3;
                classVC.fromtitle=model.title;
                classVC.fromurl=model.val;
                [self.navigationController pushViewController:classVC animated:YES];
            }
            
            if ([model.type isEqualToString:@"3"]) {
                //  商品列表
                GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
                detailsVC.tiaozhuantype = 1;
                detailsVC.idd = model.val;//
                detailsVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailsVC animated:YES];
            }
            if ([model.type isEqualToString:@"4"]) {//商品详情
                
                ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
                classVC.dataString = model.val;
                classVC.title = @"搜索结果";
                classVC.titlestr= model.val;
                classVC.nameString=model.val;
                classVC.isSarch=YES;
                classVC.isSection=NO;
                classVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:classVC animated:YES];
                
}
            
        };
        self.scrollView.ianCurrentIndex = ^(NSInteger index){
            DebugLog(@"测试一下：%ld",(long)index);
        };
        self.scrollView.PageControlPageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:244/255.0f blue:227/255.0f alpha:1];
        self.scrollView.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
        self.scrollView.autoTime = [NSNumber numberWithFloat:4.0f];
        
        [self.scrollView startLoading];
        [self.collectionView addSubview:self.scrollView];
        
        
        if (ishave==1)
        {
            latesview=[[UIView alloc]initWithFrame:CGRectMake(0, MSW*0.4, MSW, MSW/3+60+10 + 20)];
            latesview.backgroundColor=[UIColor clearColor];
            [self.collectionView addSubview:latesview];
            
            if (!self.layOut2)
            {
                self.layOut2 = [[UICollectionViewFlowLayout alloc] init];
            }
            self.layOut2.itemSize = CGSizeMake(MSW / 3, MSW/3+70 + 19);
            self.collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSW/3+70 + 19) collectionViewLayout:self.layOut2];
            self.collectionView2.dataSource = self;
            self.collectionView2.delegate = self;
            self.collectionView2.backgroundColor = [UIColor clearColor];
            [self.collectionView2 registerClass:[LatesAnnViewCell class] forCellWithReuseIdentifier:collectionCellName2];
            self.collectionView2.tag=2;
            self.collectionView2.scrollEnabled = NO;
            [latesview addSubview:self.collectionView2];
            
            UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 3, MSW-70, 37)];
            lbtitle.text=@"最新揭晓";
            lbtitle.backgroundColor=[UIColor whiteColor];
            lbtitle.userInteractionEnabled = YES;
            lbtitle.font=[UIFont systemFontOfSize:BigFont];
            lbtitle.textColor=[UIColor blackColor];
            [latesview addSubview:lbtitle];
            
            UIButton*btall=[[UIButton alloc]initWithFrame:CGRectMake(MSW-70, 3, 70, 37)];
            [btall setTitle:@"显示全部>" forState:UIControlStateNormal];
            [btall addTarget:self action:@selector(gotolatesannounce) forControlEvents:UIControlEventTouchUpInside];
            btall.backgroundColor=[UIColor whiteColor];
            btall.userInteractionEnabled = YES;
            btall.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
            [btall setTitleColor:[UIColor grayColor] forState:0];
            [latesview addSubview:btall];
            
            UILabel*lbline2=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, MSW, 1)];
            lbline2.backgroundColor=[UIColor groupTableViewBackgroundColor];
            [latesview addSubview:lbline2];
            UILabel*lbline3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSW, 2)];
            lbline3.backgroundColor=[UIColor groupTableViewBackgroundColor];
            [latesview addSubview:lbline3];
        }
        
        //下面间隔
        //    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, latesview.frame.size.height + latesview.frame.origin.y, MSW, 10)];
        //    myView.backgroundColor = RGBCOLOR(234, 235, 236);
        //    [self.collectionView addSubview:myView];
        //    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, MSW*0.4 +MSW/3+30+10+30+10, MSW, 50)];
        
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, latesview.bottom, MSW, 50 -10)];

     if (ishave==1) {
         self.headerView .frame= CGRectMake(0, latesview.bottom, MSW, 50 -10);

    }else{
        
         self.headerView .frame= CGRectMake(0, MSW*0.4, MSW, 50 -10);
        }
        
        self.headerView.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i = 0; i < 5 ; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(MSW/5 * i, 0, MSW/5, 50 - 10);
            button.tag = 101 + i;
            button.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:MainColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(sortingButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.textAlignment=UITextAlignmentCenter;
            button.backgroundColor=[UIColor clearColor];
            
            switch (button.tag)
            {
                case 101:
                {
                    [button setTitle:@"最热" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    button.selected = YES;
                    _lastSelectedBtn = button;
                    [self.btns addObject:button];
                    
                }
                    break;
                case 102:
                {
                    [button setTitle:@"最快" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                    
                }
                    break;
                case 103:
                {
                    [button setTitle:@"最新" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                    
                }
                    break;
                case 104:
                {
                    [button setTitle:@"高价" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                    
                }
                    break;
                    
                default:
                {
                    [button setTitle:@"低价" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [self.btns addObject:button];
                }
                    break;
            }
            
            
            UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, MSW, 0.5)];
            myView.backgroundColor = RGBCOLOR(219, 219, 219);
            [self.headerView addSubview:myView];
            [self.headerView addSubview:button];
            
        }
        
        _redLine = [[UIView alloc]initWithFrame:CGRectMake(MSW/10-20, 38,40,2)];
        _redLine.backgroundColor = MainColor;
        [self.headerView addSubview:_redLine];
        
        [self.collectionView addSubview:self.headerView];
        
        
        
    }
    //    if (self.barArray.count > 0)
    //    {
    //        //按钮
    //        if (!self.buttonView)
    //        {
    //            self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, MSW, 90)];
    //            self.buttonView.backgroundColor = [UIColor whiteColor];
    //            [self.collectionView addSubview:self.buttonView];
    //
    //            for (int i = 0; i < 4; i ++)
    //            {
    //                UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(MSW / 4 * i, 0, MSW / 4, 90)];
    //                btnView.userInteractionEnabled = YES;
    //                btnView.layer.masksToBounds = YES;
    //                self.btn = [[UIImageView alloc]init];
    //                self.btn.userInteractionEnabled = YES;
    //                self.btn.frame = CGRectMake(btnView.frame.size.width / 2 - 25, 15,IPhone4_5_6_6P(50, 50, 50, 60), IPhone4_5_6_6P(50, 50, 50, 60));
    //                self.btn.tag = 101 + i;
    //
    //                //1.创建手势
    //                self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick:)];
    //                //2.设置属性
    //                self.tap.numberOfTapsRequired = 1;//次数 单击
    //                self.tap.numberOfTouchesRequired = 1;//几根手指
    //                [self.btn addGestureRecognizer:self.tap];
    //
    //                // [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    //                switch (self.btn.tag)
    //                {
    //                    case 101:
    //                    {
    //                        [self.btn sd_setImageWithURL:[NSURL URLWithString: ((LanMuModel *)self.barArray[i]).thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    //                        //      [btn setBackgroundImage:imageView.image forState:UIControlStateNormal];
    //                    }
    //                        break;
    //                    case 102:
    //                    {
    //                        [self.btn sd_setImageWithURL:[NSURL URLWithString: ((LanMuModel *)self.barArray[i]).thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    //
    //                        // [btn setBackgroundImage:[UIImage imageNamed:@"1-12"] forState:UIControlStateNormal];
    //                    }
    //                        break;
    //                    case 103:
    //                    {
    //                        [self.btn sd_setImageWithURL:[NSURL URLWithString: ((LanMuModel *)self.barArray[i]).thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    //
    //                        //    [btn setBackgroundImage:[UIImage imageNamed:@"1-13"] forState:UIControlStateNormal];
    //                    }
    //                        break;
    //                    default:
    //                    {
    //                        //      [btn setBackgroundImage:[UIImage imageNamed:@"1-14"] forState:UIControlStateNormal];
    //                        [self.btn sd_setImageWithURL:[NSURL URLWithString: ((LanMuModel *)self.barArray[i]).thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    //                    }
    //                        break;
    //                }
    //                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.btn.frame.size.height + self.btn.frame.origin.y + 5, btnView.frame.size.width, 10)];
    //                label.font = [UIFont systemFontOfSize:BigFont];
    //                label.textColor=RGBCOLOR(25, 25, 25);
    //                label.textAlignment = NSTextAlignmentCenter;
    //                label.tag = 101 + i;
    //                switch (label.tag)
    //                {
    //                    case 101:
    //                    {
    //                        label.text = ((LanMuModel *)self.barArray[i]).title;
    //                    }
    //                        break;
    //                    case 102:
    //                    {
    //                        label.text = ((LanMuModel *)self.barArray[i]).title;
    //
    //                    }
    //                        break;
    //                    case 103:
    //                    {
    //                        label.text = ((LanMuModel *)self.barArray[i]).title;
    //
    //                    }
    //                        break;
    //                        default:
    //                    {
    //                        label.text = ((LanMuModel *)self.barArray[i]).title;
    //
    //                    }
    //                        break;
    //                }
    //
    //                [btnView addSubview:self.btn];
    //                [self.barArray addObject:self.btn];
    //                [btnView addSubview:label];
    //                [self.buttonView addSubview:btnView];
    //
    //            }
    //
    //        }
    //    }
    //
    //    //广播滚动
    //    if (!self.radioScrollView)
    //    {
    //        self.radioScrollView = [[HeadlineScrollview alloc]initWithFrame:CGRectMake(0,150 + 90,MSW,35)];
    //        _radioScrollView.delegate = self;
    //        _radioScrollView.backgroundColor = [UIColor whiteColor];
    //        [self.collectionView addSubview:self.radioScrollView];
    //
    //        //下面间隔
    //        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, self.radioScrollView.frame.size.height + self.radioScrollView.frame.origin.y, MSW, 10)];
    //        myView.backgroundColor = RGBCOLOR(234, 235, 236);
    //        [self.collectionView addSubview:myView];
    //        //图标
    //        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1-15"]];
    //        imageView.frame = CGRectMake(10, self.radioScrollView.frame.size.height / 2 - 8, 25, 17);
    //        [self.radioScrollView addSubview:imageView];
    //        //上方间隔线
    //        UIView *hengView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 1)];
    //        hengView.backgroundColor = RGBCOLOR(234, 235, 236);
    //        [self.radioScrollView addSubview:hengView];
    //    }
    
    //-----------B模块－－－－－－z最新揭晓－－－－－－－－－－－－
    
    
    
}

//#pragma mark 定时器
//- (void)startTimer
//{
//    _timedata = 0;
//    if (!_topImageChangeTimer || ![_topImageChangeTimer isValid])
//    {
//        self.topImageChangeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                                                    target:self selector:@selector(onTimer)
//                                                                  userInfo:nil  repeats:YES];
//    }
//}
//-(void)onTimer{
//    _timedata ++;
//    if (_timedata % 5 == 0) {
//        [_radioScrollView changeHeadlinePage];
//    }
//    
//}


#pragma mark 首页公告点击
-(void)selectHeadline:(NotifyDto *)dto{
    
    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    detailsVC.idd = dto.sid;
    detailsVC.username=dto.title;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
    
}
#pragma mark - 获取首页公告
-(void)getTopNotice{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Notice postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===:%@",responseDic);
        if ([responseDic isKindOfClass:[NSDictionary class]])
        {
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                NSArray *array = responseDic[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NotifyDto *model = [[NotifyDto alloc]initWithDictionary:obj];
                    [self.headlineArray addObject:model];
                    //                    DebugLog(@"++++++%@===",self.headlineArray);
                    [_radioScrollView setHeadlineView:self.headlineArray];
                }];
            }
            else{
                [self.headlineArray removeAllObjects];
                [_radioScrollView updateError];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
    
    
}


#pragma mark - 刷新tableview按钮
- (void)sortingButton:(UIButton *)button
{
    DebugLog(@"%ld",button.tag);
    
    [UIView animateWithDuration:0.3 animations:^{
        _redLine.frame = CGRectMake(MSW/5 * (button.tag-101)+MSW/10-20, 38,40,2);
        _redLine2.frame = CGRectMake(MSW/5 * (button.tag-101)+MSW/10-20, 38,40,2);
    }];
    
    if (_lastSelectedBtn) {
        _lastSelectedBtn.selected = !_lastSelectedBtn.selected;
    }
    if (_lastSelectedBtn2) {
        _lastSelectedBtn2.selected = !_lastSelectedBtn2.selected;
    }
//    button.selected = !button.selected;
//    _lastSelectedBtn = button;
    
    UIButton *btn = (UIButton *)[self.headerView viewWithTag:button.tag];
    btn.selected = !btn.selected;
    _lastSelectedBtn = btn;
    
    UIButton *btn2 = (UIButton *)[self.headerView2 viewWithTag:button.tag];
    btn2.selected = !btn2.selected;
    _lastSelectedBtn2 = btn2;
    
    
    switch (button.tag)
    {
        case 101:
        {
            _buttonstate=1;
            self.classNum = @"10";
            
            [self refreshData];
        }
            break;
        case 102:
        {
            _buttonstate=2;
            self.classNum = @"30";
            [self refreshData];
        }
            break;
        case 103:
        {
            _buttonstate=3;
            self.classNum = @"20";
            [self refreshData];
        }
            break;
            
        case 104:
        {
            _buttonstate=4;
            self.classNum = @"40";
            [self refreshData];
        }
            break;
            
        default:
        {
            _buttonstate=5;
            self.classNum = @"50";
            _isSorting = !_isSorting;
            
//            if (_isSorting)
//            {
//                self.classNum = @"40";
//                self.xiaImageView.image = [UIImage imageNamed:@"1-17-2"];
//                self.shangImageView.image = [UIImage imageNamed:@"1-16-1"];
//            }
//            else
//            {
//                self.classNum = @"50";
//                self.shangImageView.image = [UIImage imageNamed:@"1-16-2"];
//                self.xiaImageView.image = [UIImage imageNamed:@"1-17-1"];
//            }
            [self refreshData];
            
        }
            break;
    }
    
    
    DebugLog(@"%@",_classNum);
    
//    [self.headerView2 removeFromSuperview];
    if (ishave==1)
    {
    if (self.collectionView.contentOffset.y >= MSW*0.4+MSW/3+30+10+30+10 +10)
    {
        self.collectionView.contentOffset = CGPointMake(0, MSW*0.4 +MSW/3+30+10+30+10 +10);
    }
    }else{
    
        if (self.collectionView.contentOffset.y >= MSW*0.4)
        {
            self.collectionView.contentOffset = CGPointMake(0, MSW*0.4 );
        }
   
    }
//    [self createUI];
}


#pragma mark - 4分类点击事件
- (void)buttonClick:(UITapGestureRecognizer *)button
{
    UIImageView *v = (UIImageView *)button.view;
    
    switch (v.tag)
    {
        case 101:
        {
            //分类
            ClassificationViewController *classificationVC = [[ClassificationViewController alloc]init];
            [self.navigationController pushViewController:classificationVC animated:YES];
            //
        }
            break;
        case 102:
        {
            //十元专区
            ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
            classVC.title = @"VIP专区";
            classVC.titlestr= @"VIP专区";
            classVC.hidesBottomBarWhenPushed=YES;
            classVC.isVIP=1;
            classVC.fromcateid= ((LanMuModel *)self.barArray[1]).cateid;
            [self.navigationController pushViewController:classVC animated:YES];
        }
            break;
        case 103:
        {
            //            OrdershareController *classVC = [[OrdershareController alloc]init];
            //
            //             classVC.hidesBottomBarWhenPushed = YES;
            //
            //            [self.navigationController pushViewController:classVC animated:YES];
            
            if ([UserDataSingleton userInformation].isLogin == YES)
            {
                NewRedController *classificationVC = [[NewRedController alloc]init];
                classificationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:classificationVC animated:YES];
            }
            else
            {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        default:
        {
            //常见问题
            //            ProblemViewController *problemVC = [[ProblemViewController alloc]init];
            //            [self.navigationController pushViewController:problemVC animated:YES];
            //            [self progam];
            
            if ([UserDataSingleton userInformation].isLogin == YES)
            {
                MyStudentController *classVC = [[MyStudentController alloc]init];
                
                classVC.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:classVC animated:YES];
                
            }
            else
            {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
    }
}

#pragma mark  常见问题请求
-(void)progam
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    // DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:changjian postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            PWWebViewController *web = [[PWWebViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]]];
            web.showToolBar = NO;
            web.hidesBottomBarWhenPushed = YES;
            //  常见问题
            web.navtitle = @"常见问题";
            [self.navigationController pushViewController:web animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
    
}

#pragma mark -collectionView
- (void)initcollectionView
{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake(MSW / 2, 70+MSW/2);
    if (!self.collectionView)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 64 - 44) collectionViewLayout:layOut];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[GoodsCollectionViewCell class] forCellWithReuseIdentifier:collectionCellName];
        self.collectionView.scrollEnabled = YES;
        self.collectionView.tag = 1;
        [self.view addSubview:self.collectionView];
        [self addPullRefreshToCollectionView:self.collectionView];
//        [self requestPicture];
    }
    
    [self crateView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //有多少个Cell
    // self.collectionView.frame = CGRectMake(0, 0, MSW, self.dataArray.count / 2 * 180);
    if (collectionView.tag==2) {
        if (_LatesAnnArray.count>2) {
            return 3;
        }else{
            if (_LatesAnnArray.count>0) {
                return _LatesAnnArray.count;
            }else{
                return 0;
            }
        }
    }else{
    return self.dataArray.count;
    }
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 2) {
        LatesAnnViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
        
        cell.lbtime.text = @"";
        
        if (_LatesAnnArray.count>0) {
           
            cell.latestModel = self.LatesAnnArray[indexPath.item];
            
        }
        
        return cell;
    }else{
        GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.delegate = self;
        cell.goodsModel = self.dataArray[indexPath.item];
        
        return cell;
    }
    
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (collectionView.tag==2) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    
    if (ishave==1) {
       return UIEdgeInsetsMake(MSW*0.4 +50+MSW/3+30+10+30+10, 0, 0, 0);
    }else{
    return UIEdgeInsetsMake(MSW*0.4 +40, 0, 0, 0);
    }
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//修改的－－－主页网格cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag==2) {
        if (_LatesAnnArray.count>0)
        {
            GoodsModel *model =[_LatesAnnArray objectAtIndex:indexPath.row];
            
            
            
            GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
            detailsVC.tiaozhuantype=2;
            detailsVC.idd=model.idd;
            
            detailsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
    }else{
        
        GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
        detailsVC.tiaozhuantype = 1;
        
        
        detailsVC.idd = ((GoodsModel *)self.dataArray[indexPath.row]).idd;
        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}



#pragma mark 购物车动画
- (void)clickCell:(GoodsCollectionViewCell *)cell
{
    //用坐标转化就将传出来的按钮左边转换为相对self.view的坐标
    CGRect rect = [cell.goodsImageView convertRect:cell.goodsImageView.bounds toView:self.view];
    //创建一个视图，模拟购物图片
    UIImageView *someThing = [[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+64, MSW/2-20, MSW/2-20)];
    someThing.layer.cornerRadius = 10;
    
    someThing.image  = cell.goodsImageView.image;
    someThing.backgroundColor=[UIColor clearColor];
    //加入到父视图
    //[self.view addSubview:someThing];
    [[UIApplication sharedApplication].keyWindow addSubview:someThing];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    //动画改变坐标
    [UIView animateWithDuration:1 animations:^{
        someThing.frame = CGRectMake(tabBar.frame.origin.x + IPhone4_5_6_6P(215, 215, 250, 280),tabBar.frame.origin.y ,20,20);
        
    } completion:^(BOOL finished) {
        [someThing removeFromSuperview];
    }];
    
    
}
-(void)gotolatesannounce{
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)allnewgoods{
    ClassificationViewController *classificationVC = [[ClassificationViewController alloc]init];
    [self.navigationController pushViewController:classificationVC animated:YES];
}

//最新揭晓－－－－－模块点击事件
-(void)Lasetesannaction:(UIButton *)sender{
    
    DebugLog(@"-----点击了第%li个",sender.tag);
    
    GoodsModel *model =[_LatesAnnArray objectAtIndex:sender.tag];
    
    DebugLog(@"-------%@",model.idd);
    
    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    detailsVC.tiaozhuantype=2;
    detailsVC.idd=model.idd;
    DebugLog(@"!!!!!!!!!!%@",((LatestAnnouncedModel *)self.dataArray[sender.tag]).idd);
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}
//新品推介 －－－－－模块点击事件
-(void)newgddsaction:(UIButton *)sender{
    DebugLog(@"-----点击了第%li个",sender.tag);
    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    detailsVC.tiaozhuantype = 1;
    DebugLog(@"---%@",((NewGoodsModel *)self.NewGoodsArray[sender.tag]).idd);
    detailsVC.idd = ((NewGoodsModel *)self.NewGoodsArray[sender.tag]).idd;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

#pragma mark - 消息推送
-(void)getAPNS:(NSDictionary *)userInfo{
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

#pragma mark - 中奖提示(Added by liwenzhi)
- (void)httpGetAwardTip
{
    self.index = 0;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    NSLog(@"yhid=%@, code=%@",[UserDataSingleton userInformation].uid, [UserDataSingleton userInformation].code);
    [MDYAFHelp AFPostHost:APPHost bindPath:AwardTip postParam:dict getParam:nil
                  success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                      
                      DebugLog(@"中奖提示 = %@",responseDic);
                      if ([EncodeFormDic(responseDic, @"code") isEqualToString:@"200"]) {
                          NSMutableArray *awardArray = [NSMutableArray array];
                          NSArray *array = responseDic[@"data"];
                          
                          for (NSDictionary *item in array) {
                              GoodsModel *model =[[GoodsModel alloc]initWithDictionary:item];
                              [awardArray addObject:model];
                          }
                          _awardTipArray = awardArray;
                          
                          [self showTipView];
                      }
                      else{
                          //                          [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                          [_awardTipArray removeAllObjects];
                      }
                      
                      
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
                  }];
}
- (void)showTipView
{
    if (self.index < _awardTipArray.count) {
        
        GoodsModel *model = _awardTipArray[_index];
        _awardTipView = [[AwardTipView alloc]init];
        _awardTipView.periodLbl.text = [NSString stringWithFormat:@"第%@期",model.qishu];
        _awardTipView.awardLbl.text = model.title;
        _awardTipView.delegate = self;
        _awardTipView.lookBtn.tag = 100 + _index;
        _awardTipView.shareBtn.tag = 200 + _index;
        [_awardTipView.lookBtn addTarget:self action:@selector(lookBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_awardTipView.shareBtn addTarget:self action:@selector(shareBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        //控制中奖提示是否显示
        [_awardTipView show];
        self.index ++;
    }else{
        self.index = 0;
    }
}
- (void)lookBtnTouched:(UIButton *)button
{
    [_awardTipView hidden];
    
    WinningRecordViewController *vc = [[WinningRecordViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)shareBtnTouched:(UIButton *)button
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    //    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Share postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            [_awardTipView hidden];
            
            NSDictionary*data = responseDic[@"data"];
            _url              = data[@"url"];
            _title            = data[@"title"];
            _content          = data[@"content"];
            _imgurl           = data[@"imgurl"];
            
            [self shareAction];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

- (void)shareAction
{
    UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:_imgurl] shouldLoadWithObserver:nil];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",_content]
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:_title
                                                  url:_url
                                          description:_content
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    //
    //    //在授权页面中添加关注官方微博
    //    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
    //                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
    //                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
    //                                    nil]];
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          //                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          //                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                          nil];
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:nil
                                                      friendsViewDelegate:nil
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [self.view showHUDTextAtCenter:@"分享成功"];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                    if (type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline) {
                                        [self.view showHUDTextAtCenter:@"您未安装微信客户端，分享失败"];
                                    }else{
                                        [self.view showHUDTextAtCenter:@"分享失败"];
                                    }
                                }
                            }];
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
