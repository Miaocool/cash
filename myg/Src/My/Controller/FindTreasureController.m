//
//  FindTreasureController.m
//  yyxb
//
//  Created by lili on 15/11/20.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "FindTreasureController.h"
#import "FoundViewCell.h"
#import "ListingViewController.h"
#import "TopUpViewCell.h"
#import "DoingViewCell.h"
#import "NodataViewCell.h"
#import "MyBuyListModel.h"
#import "TreasureNoController.h"
#import "PersonalcenterController.h"
#import "RefreshView.h"
#import "GoodsCollectionViewCell.h"
#import "ListingViewController.h"

#import "FindDetailController.h"
#import "GoodsDetailsViewController.h"
#import "NewGoodsModel.h"

#import "WinningRecordViewController.h"
#import "AwardTipView.h"
#import "GoodsModel.h"
#import "EGOImageLoader.h"
#import <ShareSDK/ShareSDK.h>
@interface FindTreasureController ()<PullingRefreshTableViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate, CloseTipViewDelegate>
{
    
    NSString                *_url;      //下载页url
    NSString                *_title;    //推广标题
    NSString                *_content;   //推广内容
    NSString                *_imgurl;  //头像url
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *selectedView;


@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
//@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic, strong) RefreshView *tableView;

@property (nonatomic, strong) UIView *normalview;


@property (nonatomic, strong) NSString *allcount;
@property (nonatomic, strong) NSString *doingcount;
@property (nonatomic, strong) NSString *didcount;
@property (nonatomic, strong) NoDataView *nodataView;

@property (nonatomic, assign) int butype;

@property (nonatomic, strong) NSMutableArray *awardTipArray;
@property (nonatomic, strong) AwardTipView   *awardTipView;
@property (nonatomic, assign) int            index;


@end

@implementation FindTreasureController
{
    int _i;
    
    NSMutableArray *_arrall;
    NSMutableArray *_arr1;
    NSMutableArray *_arr2;
    
    int arrcount;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self colorReset:0];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = NO;
    
    if (_tiaozhuan==1) {
        
        DebugLog(@"从前往后跳");
    }else{
        DebugLog(@"从前往----==---后跳");
        [self setButtoncolor];
        [self colorReset:_butype];
    }
    _tiaozhuan=0;
    //添加中奖提示
    [self httpGetAwardTip];

}

-(void)setButtoncolor{
    if (_butype==0) {
        UIButton*button1=[_buttonArray objectAtIndex:0];
        UIButton*button2=[_buttonArray objectAtIndex:1];
        UIButton*button3=[_buttonArray objectAtIndex:2];
        [button1 setTitleColor:MainColor forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (_butype==1)
    {
        UIButton*button1=[_buttonArray objectAtIndex:0];
        UIButton*button2=[_buttonArray objectAtIndex:1];
        UIButton*button3=[_buttonArray objectAtIndex:2];
        [button2 setTitleColor:MainColor forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if(_butype==2){
        UIButton*button1=[_buttonArray objectAtIndex:0];
        UIButton*button2=[_buttonArray objectAtIndex:1];
        UIButton*button3=[_buttonArray objectAtIndex:2];
        [button3 setTitleColor:MainColor forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"夺宝记录";
    _arr1=[NSMutableArray array];
    _arr2=[NSMutableArray array];
    _arrall=[NSMutableArray array];
    _awardTipArray = [NSMutableArray array];

    [self initData];
    
    // 刷新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpGetAwardTip) name:@"refreshAction" object:nil];

 
    //    查看我的号码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookno:) name:@"lookno" object:nil];
    
    //    //    个人中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gerenzhongxin:) name:@"gerenzhongxin" object:nil];
    //    //    追加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhuijia:) name:@"zhuijia" object:nil];
    //    //    详情
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiangqing:) name:@"xiangqing" object:nil];
    //修改的－－
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xunbaotongzhi:) name:@"xunbaojilu" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoxunbao) name:@"gotoxunbao2" object:nil];
}
-(void)xunbaotongzhi:(NSNotification *)model{
    
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    [self.navigationController pushViewController:goods animated:YES];
}
-(void)lookno:(NSNotification *)model{
MyBuyListModel*mymodel=[[MyBuyListModel alloc]init];
    mymodel=model.userInfo[@"model"];
    FindDetailController *detailsVC = [[FindDetailController alloc]init];
    detailsVC.tiaotype=1;
    detailsVC.sid=mymodel.shopid;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
-(void)gerenzhongxin:(NSNotification *)model{
    
    MyBuyListModel *mymodel=[[MyBuyListModel alloc]init];
    mymodel=model.userInfo[@"model"];
    PersonalcenterController *detailsVC = [[PersonalcenterController alloc]init];
    detailsVC.yhid=mymodel.q_uid;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

-(void)zhuijia:(NSNotification *)model{
    MyBuyListModel*mymodel=[[MyBuyListModel alloc]init];
    mymodel=model.userInfo[@"model"];
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        if ([mymodel.zongrenshu integerValue] == [mymodel.canyurenshu integerValue] )
        {
            [SVProgressHUD showErrorWithStatus:@"该商品已没有剩余数量！"];
            return;
        }
        else
        {
            if ([mymodel.xiangou isEqualToString:@"0"])
            {
                //普通
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = mymodel.shopid;
                model.num = [mymodel.yunjiage integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
            else if ([mymodel.xiangou isEqualToString:@"1"])
            {
                //垄断  限购次数
                
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = mymodel.shopid;
                model.num = [mymodel.zongrenshu integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
            else
            {
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = mymodel.shopid;
                model.num = [mymodel.xg_number integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
        }
    }
    else
    {
        __block  BOOL isHaveId = NO;
        __block BOOL isAdd = NO;
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            if (obj.num == ([mymodel.zongrenshu integerValue] - [mymodel.canyurenshu integerValue]))
            {
                [SVProgressHUD showErrorWithStatus:@"参与人数不能大于剩余人数"];
                isAdd = YES;
                *stop = YES;
                return ;
            }
            else
            {
                if ([obj.goodsId isEqualToString:mymodel.shopid])
                {
                    if ([mymodel.xiangou isEqualToString:@"1"])
                    {
                        [SVProgressHUD showErrorWithStatus:@"参与人数不能大于剩余人数"];
                        isAdd = YES;
                        *stop = YES;
                        return;
                        
                    }
                    else
                    {
                        obj.num = obj.num + [mymodel.yunjiage integerValue];
                        isAdd = NO;
                        isHaveId = YES;
                        *stop = YES;
                    }
                }
                
            }
        }];
        
        if (isHaveId == NO)
        {
            if (isAdd == YES)
            {
                
            }
            else
            {
                
                if ([mymodel.xiangou isEqualToString:@"0"])
                {
                    //普通
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = mymodel.shopid;
                    model.num = [mymodel.yunjiage integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
                else if ([mymodel.xiangou isEqualToString:@"1"])
                {
                    //垄断  限购次数
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = mymodel.shopid;
                    model.num = [mymodel.zongrenshu integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                    
                }
                else
                {
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = mymodel.shopid;
                    model.num = [mymodel.xg_number integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
                
                
            }
        }
}

    //通知 改变徽标个数
    NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    self.tabBarController.selectedIndex = 3;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    self.tabBarController.tabBar.hidden=NO;
}
-(void)xiangqing:(NSNotification *)model{
    MyBuyListModel*mymodel=[[MyBuyListModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    if ([mymodel.type isEqualToString:@"1"]) {
    }else{
    detailsVC.tiaozhuantype = 1;
    }
    
    detailsVC.idd =mymodel.shopid;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - 数据
- (void)initData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:@"1" forKey:@"type"];
    [MDYAFHelp AFPostHost:APPHost bindPath:MyBuyList postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"----%@---%@---",responseDic,responseDic[@"msg"]);
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            NSDictionary*data=responseDic[@"data"];
            NSDictionary*count=data[@"count"];
            _allcount=count[@"all"];
            _doingcount=count[@"jinxing"];
            _didcount=count[@"jiexiao"];
              self.titleArray = [NSMutableArray array];
            self.dataArray = [NSMutableArray array];
            
            self.titleArray = @[[NSString stringWithFormat:@"全部(%@)",_allcount],[NSString stringWithFormat:@"进行中(%@)",_doingcount],[NSString stringWithFormat:@"已揭晓(%@)",_didcount]];
            self.buttonArray = [NSMutableArray array];
            _i = 0;
            
          [self createUI];
            }else{
            
            [self noData];
}
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark - UI
- (void)createUI
{
    
    //    //按钮的view
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [self.view addSubview:self.buttonView];
    
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0,43, self.view.frame.size.width , 1)];
    bjView.backgroundColor = RGBCOLOR(220, 220, 221);
    [self.view addSubview:bjView];
    //选择view
    self.selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width /3, 4)];
    self.selectedView.backgroundColor = MainColor;
    [self.view addSubview:self.selectedView];
    
    for (NSInteger i = 0; i < self.titleArray.count; i ++)
    {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        // self.button.layer.borderWidth = 1;
        self.button.frame = CGRectMake(self.buttonView.frame.size.width / 3 * i, 5, self.buttonView.frame.size.width /3, 30);
        self.button.tag = 101+i;
        //self.button.backgroundColor = [UIColor redColor];
        [self.button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:15];
        // self.button.backgroundColor = [UIColor yellowColor];
        [self.button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        if (self.button.tag == 101)
        {
            [self.button setTitleColor:MainColor forState:UIControlStateNormal];
        }
        
        [self.buttonView addSubview:self.button];
        [self.buttonArray addObject:self.button];
        
    }
    
    //滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    for (NSInteger i = 0; i < 3; i++)
    {
        
        self.tableView = [[RefreshView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.scrollView.frame.size.height)AndNum:[NSString stringWithFormat:@"%ld",i + 1]];
        self.tableView.tag = 101 + i ;
        
        [self.scrollView addSubview:self.tableView];
        
    }
    [self.view addSubview:self.scrollView];
    
}

#pragma mark - 滚动视图协议
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _i = scrollView.contentOffset.x/self.view.bounds.size.width;
    [self colorReset:_i];
    
    self.selectedView.frame = CGRectMake(scrollView.contentOffset.x / 3, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width / 3, 4);
    _butype=_i;
}


#pragma mark - 为自体变色封装
-(void)colorReset:(NSInteger)tempNub
{
    static NSInteger f = 1;
    if (!f) {
    }else
    {
        UIButton *tempBut = self.buttonArray[f-1];
        [tempBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    UIButton *btn = self.buttonArray[tempNub];
    [btn setTitleColor:MainColor forState:UIControlStateNormal];
    f = tempNub+1;
}


- (void)button:(UIButton *)button
{
switch (button.tag)
    {
        case 101:
        {
            [self colorReset:0];
            self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
            self.selectedView.frame = CGRectMake(self.scrollView.contentOffset.x /3, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width / 3, 4);
            DebugLog(@"1");
            
            
            _butype=0;
        }
            break;
            
        case 102:
        {
            [self colorReset:1];
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0.0);
            self.selectedView.frame = CGRectMake(self.scrollView.contentOffset.x / 3, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width /3, 4);
            _butype=1;
        }
            DebugLog(@"2");
            
            break;
        case 103:
        {
            [self colorReset:2];
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*2, 0.0);
            self.selectedView.frame = CGRectMake(self.scrollView.contentOffset.x / 3, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width /3, 4);
            
            _butype=2;
        }
            DebugLog(@"2fredwsa");
            
            break;
            
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        self.nodataView.imageView.image = [UIImage imageNamed:@"pic_empty_me_buy"];
        _nodataView.titleLabel.text=@"暂时没有记录~";
        _nodataView.type=2;
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.nodataView];
}

-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - 中奖提示
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



@end
