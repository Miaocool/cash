//
//  LatestAnnouncedViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "LatestAnnouncedViewController.h"

#import "AnnouncedCell.h"

#import "MJRefresh.h"

#import "GoodsDetailsViewController.h" //商品详情

#import "MJRefresh.h"
#import "GoodsModel.h"
#import "LatestAnnouncedModel.h" // model
#import "ClassModel.h"
#import "DidJiexiaoViewCell.h"
#import "OyTool.h"
#import "PersonalCenterController.h"
#import "LatesAnnountViewCell.h"
#import "GoodsDetailsViewController.h"
#import "LatestAnnouncedModel.h"
#import "FenLeiViewCell.h"
#import "PersonalcenterController.h"
#import "AwardTipView.h"
#import "WinningRecordViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "EGOImageLoader.h"

@interface LatestAnnouncedViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CloseTipViewDelegate>
{
    
    UITableView *tbView;
    UITableView *tbview2;
    
    NSArray                 *arrOfTypeImage;
    UIButton                *btnRigth;
    
    NSDictionary            *dicTypeName;
    
    __block int             curPage;
    __block int             iCodeType;
    __block NSMutableArray  *listNew;
    
    NSInteger seleteindex;
    int isopen;//判断是否展示分类  1  展开 0 收起
    
    NSArray*fenlei;
    
    NSTimer     *timer;
    UIButton *sellerDetail;
    
    
    NSString*_title1;
    NSString*_content1;
    NSString*_url1;
    NSString *_imgurl1;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) LatestAnnouncedModel *model;
@property (nonatomic, strong) NSMutableArray *fenlei;


@property (nonatomic, strong) NoNetwork *nonetwork;


@property (nonatomic, strong) NSMutableArray  *awardTipArray;
@property (nonatomic, strong) AwardTipView    *awardTipView;
@property (nonatomic,assign) NSInteger index;
@end

@implementation LatestAnnouncedViewController

static NSString *announcedCellName = @"AnnouncedCell.h";

- (void)viewDidLoad
{
    [super viewDidLoad];
    isopen=0;
    seleteindex=0;
    self.num = 1;

    fenlei=@[@"全部分类",@"手机数码",@"电脑办公",@"家用电器",@"化妆个护",@"钟表首饰",@"其他商品"];
    [self initData];
    UIImageView*imgsanjiao=[[UIImageView alloc]initWithFrame:CGRectMake(110, 15, 8, 8)];
    imgsanjiao.backgroundColor=[UIColor clearColor];
    imgsanjiao.image=[UIImage imageNamed:@"triangle_white"];
    [sellerDetail addSubview:imgsanjiao];
    
    [sellerDetail addTarget:self action:@selector(btnRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leBtn = [[UIBarButtonItem alloc] initWithCustomView:sellerDetail];
    self.navigationItem.rightBarButtonItem = leBtn;
    
    [self refreshData];
    
    //注册开奖通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficaationOpenPrize:) name:@"openPrize" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJiangTishi) name:@"DidJiexiaoViewCellJieXiao" object:nil];
}
//开奖结果
- (void)notficaationOpenPrize:(NSNotification *)note{
    
    DebugLog(@"倒计时结束");
    
    [self refreshData];  
    
}

- (void)getJiangTishi{
    
    DebugLog(@"tishi");
    
    [self httpGetAwardTip];
}

#pragma mark - 中奖提示(Added by liwenzhi)
- (void)httpGetAwardTip
{
    self.index = 0;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:AwardTip postParam:dict getParam:nil
                  success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                      
                      DebugLog(@"res = %@",responseDic);
                      if ([EncodeFormDic(responseDic, @"code") isEqualToString:@"200"]) {
                          
                          NSMutableArray *awardArray = [NSMutableArray array];
                          NSArray *array = responseDic[@"data"];
                          DebugLog(@"%zd",array.count);
                          for (NSDictionary *item in array) {
                              GoodsModel *model =[[GoodsModel alloc]initWithDictionary:item];
                              [awardArray addObject:model];
                          }
                          _awardTipArray = awardArray;
                          
                          [self showTipView];
                      }else{
                          
                          
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
            _url1              = data[@"url"];
            _title1            = data[@"title"];
            _content1          = data[@"content"];
            _imgurl1           = data[@"imgurl"];
            
            [self shareAction];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

- (void)shareAction
{
    UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:_imgurl1] shouldLoadWithObserver:nil];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",_content1]
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:_title1
                                                  url:_url1
                                          description:_content1
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




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
    self.left.hidden = YES;
    [self refreshData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:0.2f];
    [tbview2 setFrame:CGRectMake(0, -MSH, tbview2.frame.size.width, tbview2.frame.size.height)];
    [UIView commitAnimations];
    isopen=0;
}

#pragma mark - 请求分类数据
-(void)initData{
    _fenlei=[NSMutableArray array];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [MDYAFHelp AFPostHost:APPHost bindPath:Fenlei postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        NSArray*array=responseDic[@"data"];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"type"] isEqualToString:@"1"])
            {
                ClassModel *model = [[ClassModel alloc]initWithDictionary:obj];
                [_fenlei addObject:model];
            }
            else
            {
                ClassModel *model = [[ClassModel alloc]initWithDictionary:obj];
                [_fenlei insertObject:model atIndex:0];
            }
            DebugLog(@"data:%li",self.dataArray.count);
            if (! tbview2)
            {
                [self creatseletetableview];
            }
        }];
        [tbview2 reloadData];
        [self.tableView tableViewDidFinishedLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark 刷新数据的方法
-(void)refreshData
{
    self.num=1;
    self.tableView.userInteractionEnabled=NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.dataArray = [NSMutableArray array];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    [dict setValue:_fromcateid forKey:@"cateid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Announced postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"~~~~~~%@----%@",responseDic,responseDic[@"msg"]);
        [self refreshSuccessful:responseDic];
        self.tableView.userInteractionEnabled=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        self.tableView.userInteractionEnabled=YES;
        [self refreshFailure:error];
    }];
    // 结束刷新
    
}
- (void)refreshSuccessful:(id)data
{
    [self.nonetwork removeFromSuperview];
    [SVProgressHUD dismiss];
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LatestAnnouncedModel *model = [[LatestAnnouncedModel alloc]initWithDictionary:obj];
                
                [self.dataArray addObject:model];
            }];
        }
        
    }
    
    if (!self.tableView)
    {
        [self createView];
    }
    [self.tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)refreshFailure:(NSError *)error
{
    [self nonetworking];

    [SVProgressHUD showErrorWithStatus:@"当前网络不给力"];
    
    DebugLog(@"!!!!!!!!!!!!!!!!%@",error);
    
    [self.tableView tableViewDidFinishedLoading];
    
}

#pragma mark 加载数据的方法
-(void)loadMoreData
{
    self.tableView.userInteractionEnabled=NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.num = self.num +1;
    DebugLog(@"%li",_num);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    [dict setValue:_fromcateid forKey:@"cateid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Announced postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        [self loadingSuccessful:responseDic];
        DebugLog(@"成功%@",responseDic);
        self.tableView.userInteractionEnabled=YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self loadingFailure:error];
        self.tableView.userInteractionEnabled=YES;
    }];
    
}

- (void)loadingSuccessful:(id)data
{
    [self.nonetwork removeFromSuperview];
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"400"])
        {
            
        }
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                LatestAnnouncedModel *model = [[LatestAnnouncedModel alloc]initWithDictionary:obj];
                
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
        
    }
    
    [self.tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    
}

- (void)loadingFailure:(NSError *)error
{
    [self nonetworking];

    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    
    self.num = self.num -1;
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==10) {
        return _fenlei.count;
    }else{
        
        return _dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10) {
        return 40;
    }
    return 110+3;
}

//修改的－－－－－最新揭晓

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10) {
        
        
        static   NSString *fenleiName = @"FenLeiViewCell.h";
        FenLeiViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fenleiName];
        if (!cell)
        {
            cell = [[FenLeiViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fenleiName];
        }

        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        if (indexPath.row==seleteindex) {
            cell.title.textColor=RGBCOLOR(255, 130, 139);
        }else{
            cell.title.textColor=[UIColor grayColor];

        }
        ClassModel*model=[_fenlei objectAtIndex:indexPath.row];
        [cell.imgview sd_setImageWithURL:[NSURL URLWithString:((ClassModel *)_fenlei[indexPath.row]).thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
        cell.title.text = model.name;
    return cell;
    }
    if (self.dataArray.count != 0)
    {
        self.model = [_dataArray objectAtIndex:indexPath.row];
    }
    if ([self.model.type isEqualToString:@"0"]||[self.model.type isEqualToString:@"2"]) {
        
        static   NSString *ListingCellName = @"LatesAnnountViewCell.h";
        LatesAnnountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
        if (!cell)
        {
            cell = [[LatesAnnountViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
        }
        cell.latestModel= self.model;
        return cell;
    }
    else{
        static   NSString *DidCellName = @"DidJiexiaoViewCell.h";
        DidJiexiaoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DidCellName];
        if (!cell)
        {
            cell = [[DidJiexiaoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DidCellName];
        }
        
        cell.bthead.tag=indexPath.row;
        [cell.bthead addTarget:self action:@selector(personalcenter:) forControlEvents:UIControlEventTouchUpInside];
        cell.latestModel=self.model;
        return cell;
    }
}
-(void)personalcenter:(UIButton *)sender{
    
    
    int index=(int)[sender tag];
    DebugLog(@"个人中心");
    LatestAnnouncedModel*model=[_dataArray objectAtIndex:index];
    PersonalcenterController  *searchVC = [[PersonalcenterController alloc]init];
    searchVC.yhid=model.uid;
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10) {
        if(indexPath.row==seleteindex)
        {
            return UITableViewCellAccessoryCheckmark;
        }
        else{
            return UITableViewCellAccessoryNone;
        }
        
    }else{
        return UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==10) {
        isopen=0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:0.2f];
        [tbview2 setFrame:CGRectMake(0, -MSH, tbview2.frame.size.width, tbview2.frame.size.height)];
        tbview2.separatorStyle = UITableViewCellSeparatorStyleNone;
        [UIView commitAnimations];
        [tbview2 reloadData];
        
        if (_fenlei.count>0) {
            seleteindex=indexPath.row;
        ClassModel*model=[_fenlei objectAtIndex:seleteindex];
        [sellerDetail setTitle:model.name forState:UIControlStateNormal];
        _fromcateid=model.cateid;
        [self refreshData];
        [self.tableView reloadData];
        }
    }else{
        LatestAnnouncedModel*model=[_dataArray objectAtIndex:indexPath.row];
       GoodsDetailsViewController *searchVC = [[GoodsDetailsViewController alloc]init];
            if (_dataArray.count > 0)
            {
                searchVC.idd=model.idd;
                
            }
            searchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchVC animated:YES];
    }
}

#pragma mark - right button action
- (void)btnRightAction
{
    [self initData];
    
    if (isopen==0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:0.2f];
        [tbview2 setFrame:CGRectMake(0, 0, tbview2.frame.size.width, tbview2.frame.size.height)];
        [UIView commitAnimations];
        isopen=1;
    }else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:0.2f];
        [tbview2 setFrame:CGRectMake(0, -MSH, tbview2.frame.size.width, tbview2.frame.size.height)];
        [UIView commitAnimations];
        isopen=0;
    }
}

-(void)createView{
    
    
    if (!self.tableView)
    {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) pullingDelegate:self style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc]init];
        self.tableView.showsVerticalScrollIndicator = FALSE;
        self.tableView.showsHorizontalScrollIndicator = FALSE;
        self.tableView.canRefresh = NO;
        [self.tableView setCanRefresh:YES];
        //    self.tableView.scrollsToTop=NO;
        [self.view addSubview:self.tableView];
        tbview2=[[UITableView alloc]initWithFrame:CGRectMake(0, -MSH,MSW, MSH-64-49)];
        tbview2.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbview2.backgroundColor=[UIColor whiteColor];
        tbview2.tag=10;
        tbview2.delegate=self;
        tbview2.dataSource=self;
        [self.view addSubview:tbview2];
        
    }
}
-(void)creatseletetableview{
    
    
}
#pragma mark - tableview继承滚动试图的协议
//滚动视图已经滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    DebugLog(@"%lf",scrollView.contentOffset.y);
    //如果滚动视图是Tableview的话 就执行方法
    if ([scrollView isEqual:self.tableView])
    {
        //        DebugLog(@"---===-%f",scrollView.contentOffset.y);
        
        
        //tab已经滚动的时候调用
        [self.tableView tableViewDidScroll:self.tableView];
        
    }
    
    //   [timer setFireDate:[NSDate distantFuture]];
    
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
        
        self.num = 1;
        [self refreshData];
        
    });
    
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadMoreData];
        
    });
    
    
}
- (void)actionCustomNavBtn:(UIButton *)btn nrlImage:(NSString *)nrlImage
                  htlImage:(NSString *)hltImage
                     title:(NSString *)title {
    [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    if (hltImage) {
        [btn setImage:[UIImage imageNamed:hltImage] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    }
    if (title) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)awardTipArray{
    if (!_awardTipArray) {
        self.awardTipArray = [NSMutableArray array];
    }
    return _awardTipArray;
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
