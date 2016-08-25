//
//  GoodsDetailsViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/12.
//  Copyright (c) 2015年 杨易. All rights reserved.
//商品详情

#import "GoodsDetailsViewController.h"

#import "AdCell.h" //广告

#import "BeforeController.h"//往期揭晓
#import "UIImageView+WebCache.h"
#import "OrdershareController.h"   //晒单分享
#import "QuartzCore/QuartzCore.h"
#import "CommentViewCell.h"
#import "GoodsModel.h"
#import "PictureDetailController.h"
#import "DateHelper.h"
#import "PersonalcenterController.h"

#import "CalculateDetailController.h"

#import "DateHelper.h"
#import "GoodsOrderController.h"

#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "PictureDetailController.h"
#import "TakepateNoteModel.h"
#import "HonorRollViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import "EGOImageLoader.h"
#import "AwardTipView.h"
#import "WinningRecordViewController.h"
@interface GoodsDetailsViewController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,CloseTipViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) UIView *buttonView; // 4 分类
@property (nonatomic, strong) UIView*headview; // 页眉
@property (nonatomic, strong) UIView*blackview; // 黑色透明view
@property (nonatomic, strong) UIView*whiteview;//白色view
@property (nonatomic, strong) UIButton*addclick;//点击确定
@property (nonatomic,strong) NSString* timecount;
@property (nonatomic,strong)UITextField  *lbcount;
@property (nonatomic,strong) GoodsModel *model;
@property (nonatomic, strong) NSMutableArray *canyuArray; // 商品图片
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL iscanyu;
@property (nonatomic, strong) UIView *moreview; //点击更多
@property (nonatomic, strong)UIView *white;
@property (nonatomic, strong) UILabel *cartcount;  //记录购物车数量

@property (nonatomic, assign)int shengyucount;//剩余数

@property (nonatomic, assign) NSInteger goodnum; //购买数量



@property (nonatomic, strong) NSMutableArray  *awardTipArray;
@property (nonatomic, strong) AwardTipView    *awardTipView;
@end

@implementation GoodsDetailsViewController
{
    BOOL _isTextField;
    UIButton*yyxb;
    int iscart;//是否是点击购物车图标
    
    UILabel*lbcount;
    
    NSString*_title;
    NSString*_content;
    NSString*_url;
    NSString *_imgurl;
    
    NSString*_title1;
    NSString*_content1;
    NSString*_url1;
    NSString *_imgurl1;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.title = @"商品详情";
    iscart=0;
    [self initData];
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //右导航
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    message.frame = CGRectMake(MSW-50, 20, 29, 29);
    [message setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [message setImage:[UIImage imageNamed:@"cartdetail"] forState:UIControlStateNormal];
    message.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [message addTarget:self action:@selector(gotoshopcart) forControlEvents:UIControlEventTouchUpInside];
    
    lbcount=[[UILabel alloc]initWithFrame:CGRectMake(19,-5, 15, 15)];
    lbcount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
    lbcount.textColor=MainColor;
    lbcount.font=[UIFont systemFontOfSize:MiddleFont];
    
    lbcount.backgroundColor=[UIColor whiteColor];
    lbcount.textAlignment=NSTextAlignmentCenter;
    
    lbcount.layer.cornerRadius = 7.5;
    lbcount.layer.masksToBounds = YES;
    [message addSubview:lbcount];
    if ([lbcount.text isEqualToString:@"0"]) {
        lbcount.hidden=YES;
    }
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openJiangResult) name:@"openJiang" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tishiView) name:@"adcellJieXiao" object:nil];
    
}
- (void)openJiangResult{
    
    DebugLog(@"开奖结果");
    
    
    
    
    [self refreshData];
    
    
    
}

- (void)tishiView{
    
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

- (void)keyboardWillHide:(NSNotification *)notif
{
    NSInteger shengyu = [self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue];
    if ([self.lbcount.text integerValue] > shengyu)
    {
        self.lbcount.text = [NSString stringWithFormat:@"%ld",shengyu];
        self.goodnum = [self.lbcount.text integerValue];
    }
    if ([self.lbcount.text integerValue] <= 0)
    {
        self.lbcount.text = self.model.yunjiage;
        self.goodnum = [self.lbcount.text integerValue];
    }
    NSInteger i = [self.lbcount.text integerValue] %[self.model.yunjiage integerValue];
    self.lbcount.text = [NSString stringWithFormat:@"%ld",[self.lbcount.text integerValue] - i];
    self.goodnum = [self.lbcount.text integerValue];
}

- (void)createView
{
    //    下方的view
    UIView*_carview=[[UIView alloc]initWithFrame:CGRectMake(0, MSH-50-64, MSW,50)];
    _carview.backgroundColor=[UIColor whiteColor];
    _carview.layer.masksToBounds = YES;
    _carview.userInteractionEnabled = YES;
    //    _carview.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_carview];
    
    if (_tiaozhuantype==1) {
        yyxb=[[UIButton alloc]initWithFrame:CGRectMake(MSW-MSW/2+60, 5, [UIScreen mainScreen].bounds.size.width/2-80, 35)];
        [yyxb setTitle:@"立即参与" forState:UIControlStateNormal];
        [yyxb setBackgroundColor:MainColor];
        [yyxb setUserInteractionEnabled:YES];
        [yyxb addTarget:self action:@selector(yiyuanxunbaoaaaa) forControlEvents:UIControlEventTouchUpInside];
        yyxb.titleLabel.font = [UIFont systemFontOfSize:15];
        yyxb.layer.cornerRadius = 5;
        
        [_carview addSubview:yyxb];
        UIButton*carimgBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
        [carimgBtn addTarget:self action:@selector(pushShopping) forControlEvents:UIControlEventTouchUpInside];
        [carimgBtn setBackgroundImage:[UIImage imageNamed:@"icon_addcart"] forState:UIControlStateNormal];
        [_carview addSubview:carimgBtn];
    
    }else{
        
        UILabel*lbdoing=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200,30)];
        lbdoing.text=[NSString stringWithFormat:@"新一期正在火热进行"];
        lbdoing.textColor=[UIColor blackColor];
        lbdoing.font=[UIFont systemFontOfSize:BigFont];
        [_carview addSubview:lbdoing];
        lbdoing.textColor=[UIColor grayColor];
        UIButton*gotoplay=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width/2+60, 5, [UIScreen mainScreen].bounds.size.width/2-80,35)];
        [gotoplay setTitle:@"立即参与" forState:UIControlStateNormal];
        [gotoplay setBackgroundColor:MainColor];
        [gotoplay setUserInteractionEnabled:YES];
        [gotoplay addTarget:self action:@selector(gototakepart) forControlEvents:UIControlEventTouchUpInside];
        gotoplay.titleLabel.font = [UIFont systemFontOfSize:15];
        gotoplay.layer.cornerRadius = 5;
        [_carview addSubview:gotoplay];
        if ([_model.sale isEqualToString:@"2"]) {
            UILabel*lbxiajia=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSW, 60)];
            lbxiajia.text=@"该商品已下架";
            lbxiajia.textAlignment=NSTextAlignmentCenter;
            lbxiajia.backgroundColor= MainColor;
            lbxiajia.font=[UIFont systemFontOfSize:BigFont];
            lbxiajia.textColor=[UIColor whiteColor];
            [_carview addSubview:lbxiajia];
            
            gotoplay.hidden=YES;
            
        }
    }
    
}
-(void)gototakepart{
    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    detailsVC.tiaozhuantype = 1;
    detailsVC.sid=_model.sid;
    detailsVC.qishu=_model.nextqishu;
    detailsVC.idd =_model.nextid;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

#pragma mark - 弹出选择框
-(void)selectAction
{
    _blackview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _blackview.backgroundColor=[UIColor blackColor];
    _blackview.alpha=0.4;
    [self.view addSubview:_blackview];
    _whiteview=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-300, [UIScreen mainScreen].bounds.size.width, 300)];
    _whiteview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_whiteview];
    UILabel*select=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 30)];
    select.text=@"人次期数选择";
    select.textColor=[UIColor blackColor];
    [_whiteview addSubview:select];
    UIButton*butop=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width- 70, 100)];
    butop.backgroundColor=[UIColor clearColor];
    [butop addTarget:self action:@selector(handleSingleTapFrom) forControlEvents:UIControlEventTouchUpInside];
    [_whiteview addSubview:butop];
    UIButton*buright=[[UIButton alloc]initWithFrame:CGRectMake(160, 50,[UIScreen mainScreen].bounds.size.width- 160, 110)];
    buright.backgroundColor=[UIColor clearColor];
    [buright addTarget:self action:@selector(handleSingleTapFrom) forControlEvents:UIControlEventTouchUpInside];
    [_whiteview addSubview:buright];
    UILabel*takecount=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 120, 30)];
    takecount.text=@"参与人次";
    
    takecount.textColor=[UIColor blackColor];
    [_whiteview addSubview:takecount];
    
    UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(20,95, 130, 40)];
    //    image.backgroundColor=[UIColor greenColor];
    
    image.layer.borderWidth = 0.5;
    image.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_whiteview addSubview:image];
    UIButton*reduce=[[UIButton alloc]initWithFrame:CGRectMake(20, 95, 40, 40)];
    
    [reduce setTitle:@"-" forState:UIControlStateNormal];
    [reduce setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([self.model.xiangou isEqualToString:@"1"]) {
        reduce.userInteractionEnabled = NO;
    }
    else
    {
        reduce.userInteractionEnabled = YES;
    }
    reduce.layer.borderWidth = 0.5;
    reduce.layer.borderColor = [UIColor lightGrayColor].CGColor;
    reduce.tag = 101;
    [reduce addTarget:self action:@selector(reduceShopping) forControlEvents:UIControlEventTouchUpInside];
    [_whiteview addSubview:reduce];
    
    _lbcount=[[UITextField alloc]initWithFrame:CGRectMake(60, 95, 50, 40)];
    _lbcount.text= [NSString stringWithFormat:@"%ld",(long)_goodnum];
    _lbcount.keyboardType=UIKeyboardTypeNumberPad;
    _lbcount.delegate=self;
    if ([self.model.xiangou isEqualToString:@"1"]) {
        _lbcount.userInteractionEnabled = NO;
    }
    else
    {
        _lbcount.userInteractionEnabled = YES;
    }
    _lbcount.textAlignment = UITextAlignmentCenter;
    //   [_lbcount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_whiteview addSubview:_lbcount];
    
    UIButton*add=[[UIButton alloc]initWithFrame:CGRectMake(110, 95, 40, 40)];
    [add setTitle:@"+" forState:UIControlStateNormal];
    if ([self.model.xiangou isEqualToString:@"1"]) {
        add.userInteractionEnabled = NO;
    }
    else
    {
        add.userInteractionEnabled = YES;
    }
    
    [add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    add.layer.borderWidth = 0.5;
    add.layer.borderColor = [UIColor lightGrayColor].CGColor;
    add.tag = 102;
    
    [add addTarget:self action:@selector(addShopping) forControlEvents:UIControlEventTouchUpInside];
    [_whiteview addSubview:add];
    
    UIButton*btclose=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 10, 20, 20)];
    [btclose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btclose setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [btclose addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_whiteview addSubview:btclose];
    UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(0, 160, [UIScreen mainScreen].bounds.size.width, 2)];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_whiteview addSubview:line];
    
    
    _addclick=[[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-80, 170, 160, 55)];
    _addclick.layer.cornerRadius = 5;
    // _addclick.layer.borderWidth = 1;
    [_whiteview addSubview:_addclick];
    UILabel*lbshiyuan=[[UILabel alloc]initWithFrame:CGRectMake(20, 135, 240, 20)];
    
    lbshiyuan.text= @"参与人次需是10的倍数";
    lbshiyuan .font= [UIFont systemFontOfSize:10];
    lbshiyuan.textColor = MainColor;
    [_whiteview addSubview:lbshiyuan];
    
    if ([_model.yunjiage isEqualToString:@"1"]) {
        if ([self.model.xiangou isEqualToString:@"1"]||[self.model.xiangou isEqualToString:@"2"])
        {
            lbshiyuan.hidden = NO;
            lbshiyuan.text= @"该商品为限购商品,不能更改数量";
        }
        else
        {
            lbshiyuan.hidden=YES;
        }
    }else
    {
        lbshiyuan.hidden=NO;
    }
    
    
}
#pragma mark - 点击壹圆夺宝
-(void)yiyuanxunbao{
    [self selectAction];
    _addclick.backgroundColor=MainColor;
    [_addclick setTitle:@"立即参与" forState:UIControlStateNormal ];
    [_addclick addTarget:self action:@selector(yiyuanxunbaoaaaa) forControlEvents:UIControlEventTouchUpInside];
    }


#pragma mark 点击加入清单
-(void)addorder{
    [self selectAction];
    _addclick.layer.borderColor = MainColor.CGColor;
    _addclick.layer.borderWidth = 1;
    _addclick.backgroundColor=[UIColor whiteColor];
    [_addclick setTitle:@"加入清单" forState:UIControlStateNormal ];
    [_addclick setTitleColor:MainColor forState:UIControlStateNormal];
    [_addclick addTarget:self action:@selector(confirmAddOrder) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 确认加入清单
- (void)confirmAddOrder
{
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        if ([self.lbcount.text integerValue] > [self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"参与人数不能大于剩余人数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else
        {
            if ([self.model.yunjiage isEqualToString:@"1"])
            {
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.num = [self.lbcount.text integerValue];
                model.goodsId = self.model.idd;
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
            else
            {
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.num = [self.lbcount.text integerValue];
                model.goodsId = self.model.idd;
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
        }
        
    }
    else
    {
        
        __block  BOOL isHaveId = NO;
        __block BOOL isAdd = NO;
        
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.goodsId isEqualToString:self.model.idd])
            {
                if ([self.model.yunjiage isEqualToString:@"1"])
                {
                    
                    if ((obj.num + [self.lbcount.text integerValue]) > ([self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue]))
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"参与人数不能大于剩余人数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        isAdd = YES;
                        *stop = YES;
                        return ;
                    }
                    else
                    {
                        isAdd = NO;
                        DebugLog(@"====%d",obj.num);
                        DebugLog(@"!!!!!%d",[self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue]);
                        obj.num = obj.num + [self.lbcount.text integerValue];
                        isHaveId = YES;
                        *stop = YES;
                    }
                }
                else
                {
                    
                    if ((obj.num + [self.lbcount.text integerValue]) > ([self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue]))
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"参与人数不能大于剩余人数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        isAdd = YES;
                        *stop = YES;
                        return;
                    }
                    else
                    {
                        isAdd = NO;
                        obj.num = obj.num+[self.lbcount.text integerValue];;
                        isHaveId = YES;
                        *stop = YES;
                    }
                    
                }
            }
            DebugLog(@"%ld---------%@",(long)obj.num,obj.goodsId);
        }];
        
        if (isHaveId == NO)
        {
            if (isAdd == YES)
            {
                
            }
            else
            {
                if ([self.model.yunjiage isEqualToString:@"1"])
                {
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    //                    model.num =  1 * [self.model.minNumber integerValue];
                    model.num = [self.lbcount.text integerValue];
                    model.goodsId = self.model.idd;
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
                else
                {
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.num = [self.lbcount.text integerValue];
                    model.goodsId = self.model.idd;
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                    
                }
            }
            
        }
        
        
    }
    
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        self.cartcount.hidden = YES;
    }
    else
    {
        self.cartcount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
        self.cartcount.hidden = NO;
        
    }
    //通知 改变徽标个数
    NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    [self closeAction];
    
}


#pragma mark textField 限制
- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *str = textField.text;
    if ([UserDataSingleton userInformation].shoppingArray.count > 0)
    {
        
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj.goodsId isEqualToString:self.model.idd])
            {
                if ([self.model.yunjiage isEqualToString:@"1"])
                {
                    //  obj.num = [str integerValue];
                    self.goodnum = [str integerValue];
                    if ([self.lbcount.text integerValue] > ([self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue]))
                    {
                        obj.num = [self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue];
                        self.goodnum = [self.model.zongrenshu integerValue] - [self.model.canyurenshu intValue];
                    }
                    if ([self.lbcount.text integerValue] == 0)
                    {
                        obj.num = 1 * [self.model.minNumber integerValue];
                        self.goodnum = 1 * [self.model.minNumber integerValue];
                    }
                    *stop = YES;
                }
                else
                {
                    //   obj.num = [str integerValue];
                    self.goodnum = [str integerValue];
                    if ([lbcount.text integerValue] > ([self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue]))
                    {
                        //     obj.num = [self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue];
                        self.goodnum = [self.model.zongrenshu integerValue] - [self.model.canyurenshu integerValue];
                    }
                    if ([self.lbcount.text integerValue] < 10)
                    {
                        obj.num = 10;
                        self.goodnum = 10;
                    }
                    *stop = YES;
                    //
                    //                    obj.num = obj.num+10;
                    //                    self.num = self.num +10;
                    //                    *stop = YES;
                }
            }
        }];
    }
    else
    {
        if ([self.model.yunjiage isEqualToString:@"1"])
        {
            ShoppingModel *model = [[ShoppingModel alloc]init];
            model.num = 1 * [self.model.gonumber integerValue];
            model.goodsId = self.model.idd;
            self.goodnum = [str integerValue];
            [[UserDataSingleton userInformation].shoppingArray addObject:model];
        }
        else
        {
            ShoppingModel *model = [[ShoppingModel alloc]init];
            model.num = [self.lbcount.text integerValue];
            model.goodsId = self.model.idd;
            self.goodnum = [str integerValue];
            
            [[UserDataSingleton userInformation].shoppingArray addObject:model];
        }
        
    }
    DebugLog(@"%@",textField.text);
    
    //    [self showOrderNumbers:self.goodnum];
    
}


-(void)showOrderNumbers:(NSUInteger)count
{
    self.lbcount.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.goodnum];
}


#pragma mark 删除对话框
-(void)closeAction{
    //    if ([_model.yunjiage isEqualToString:@"1"])
    //    {
    //        _goodnum=1 * [self.model.minNumber integerValue];
    //    }
    //    else
    //    {
    //        _goodnum=10;
    //    }
    if ([self.model.xiangou isEqualToString:@"1"])
    {
        _goodnum=1 * [self.model.zongrenshu integerValue];
    }
    else if ([self.model.xiangou isEqualToString:@"2"])
    {
        _goodnum=1 * [self.model.xg_number integerValue];
    }
    else
    {
        if ([self.model.minNumber integerValue] >([self.model.zongrenshu integerValue]-[self.model.canyurenshu integerValue]) )
        {
            _goodnum=1 * [self.model.yunjiage integerValue];
        }
        else
        {
            _goodnum=1 * [self.model.minNumber integerValue];
        }
    }
    
    [_blackview removeFromSuperview];
    [_whiteview removeFromSuperview];
    [_addclick removeFromSuperview];
    [_lbcount removeFromSuperview];
}

#pragma mark - 创建数据
- (void)initData
{
    self.num = 0;
    
    self.dataArray = [NSMutableArray array];
    self.canyuArray =[NSMutableArray array];
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.idd forKey:@"id"];
    [dict setValue:self.zhongjiangID forKey:@"yhid"];
    [dict setValue:self.sid forKey:@"sid"];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"logonuid"];
    [dict setValue:self.qishu forKey:@"qishu"];
    [MDYAFHelp AFPostHost:APPHost bindPath:GoodsDetails postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"!!!!!!!!!!!!!!!!!!!~~~~~~~~~~%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            self.tableView.footerView.state = kPRStatePulling;
            [SVProgressHUD dismiss];
            [self.dataArray removeAllObjects];
            _model =[[GoodsModel alloc]initWithDictionary:responseDic[@"data"]];
            if ([self.model.yunjiage isEqualToString:@"1"])
            {
                _goodnum= 1 * [self.model.minNumber integerValue];
                self.lbcount.text = [NSString stringWithFormat:@"%ld",(long)_goodnum];
            }
            else
            {
                _goodnum=10;
                self.lbcount.text = [NSString stringWithFormat:@"%ld",(long)_goodnum];
            }
            
            
            [self.dataArray addObject:self.model];
        }
        if (!self.tableView)
        {
            
            [self createTableView];
            [self createView];
            
        }
        [self getshareinfo];
        
if ([_model.type isEqualToString:@"进行中"]) {
            _tiaozhuantype=1;
        }else{
            _tiaozhuantype=0;
        }
        
        [self refreshSuccessful:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self refreshFailure:error];
    }];
    
}

- (void)refreshSuccessful:(id)data
{
    [SVProgressHUD dismiss];
    [self.canyuArray removeAllObjects];
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    self.num =0;
    [self loadingData];
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    [self.view showHUDTextAtCenter:@"网络不给力"];
//    DebugLog(@"失败");
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    self.num = self.num +1;
    ////    ----------所有的参与记录
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:self.idd forKey:@"shopid"];
    [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    [MDYAFHelp AFPostHost:APPHost bindPath:TakepateNote postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"-----%@",responseDic);
        [self loadingSuccessful:responseDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"失败:%@",error);
        [self loadingFailure:error];
    }];
    
}
- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        DebugLog(@"%@",data[@"msg"]);
        if ([data[@"code"] isEqualToString:@"400"])
        {
            DebugLog(@"%@",data[@"msg"]);
            
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                self.num = 0;
                self.tableView.footerView.state = kPRStateHitTheEnd;
            }];
            
        }
        
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                TakepateNoteModel  *model = [[TakepateNoteModel alloc]initWithDictionary:obj];
                
                DebugLog(@"----%@===////////==",data);
                DebugLog(@"-----%@",model.gonumber);
                
                DebugLog(@"-----%@",model.uphoto);
                [self.canyuArray addObject:model];
            }];
            
            if([[NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count] isEqualToString:data[@"count"]])
            {
                [UIView animateWithDuration:2 animations:^{
                    
                } completion:^(BOOL finished) {
                    self.num = 0;
                    self.tableView.footerView.state = kPRStateHitTheEnd;
                }];
            }
        }
        
        
    }   if (!self.tableView)
    {
        [self createTableView];
        [self createView];
        
    }
    
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}



- (void)loadingFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
  
    [self.view showHUDTextAtCenter:@"请检查您的网络"];
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
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,self.view.bounds.size.height - 44 ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = FALSE;
    //    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

//修改的－－－－奖品详情
#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 2;
    }else if (section==2)   {
        
        return 1;
    }else if (section==3){
        return 1;
    }
    else
    {
        return self.canyuArray.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
    {
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
        }
        if (indexPath.row==0)
        {
            
            BeforeController *classVC = [[BeforeController alloc]init];
            classVC.shopid=_model.idd;
            classVC.sid= _model.sid;
            [self.navigationController pushViewController:classVC animated:YES];
        }
        if (indexPath.row==1) {
            GoodsOrderController *classVC = [[GoodsOrderController alloc]init];
            classVC.tiaostaty=1;
            classVC.sid= _model.sid;
            classVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:classVC animated:YES];
            
        }
    }
    if (indexPath.section==4) {
        TakepateNoteModel*model=[_canyuArray objectAtIndex:indexPath.row];
        PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
        classVC.yhid=model.uid;
        [self.navigationController pushViewController:classVC animated:YES];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *adCellName = @"AdCell.h";
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
        //             如果   登录用户参与人次不为空则参与了，否则就是没有参与
    

    if([[NSString stringWithFormat:@"%@",_model.gonumber] isEqualToString:@""])
    {
        _iscanyu=NO;
        
    }else{
        _iscanyu=YES;
        
    }
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            AdCell *adCell = [tableView dequeueReusableCellWithIdentifier:adCellName];
            if (!adCell)
            {
                adCell = [[AdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adCellName];
                
            }
            adCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [adCell.lookBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
            
            if (self.dataArray.count >0)
            {
                adCell.goodsModel = self.dataArray[indexPath.row];
            }
            //        修改的－－－－判断是否从首页跳转
            if (_tiaozhuantype==1)
            {
                //            从首页跳转
                if ([UserDataSingleton userInformation].isLogin == YES)
                {
                    adCell.jiexiaoBgView.hidden = YES;
                    //                    adCell.jiexiao.hidden=YES;修改
                    //                    adCell.redview.hidden=YES;
                    adCell.redViewBg.hidden = YES;
                    adCell.goumaiLabel.hidden = NO;
                    //                    adCell.lookBtn.hidden = YES;
                    
                    double a=[_model.zongrenshu doubleValue];
                    double b=[_model.canyurenshu doubleValue];
                    NSDictionary* style = @{@"body" :
                                                @[[UIFont systemFontOfSize:MiddleFont],
                                                  [UIColor grayColor]],
                                            @"u": @[MainColor,
                                                    
                                                    ]};
                    
                    adCell.remainingLabel.attributedText =  [[NSString stringWithFormat:@"剩余<u>%.0f</u>",a-b]attributedStringWithStyleBook:style];
                    adCell.progressView.progress=b/a;
                    _shengyucount=[_model.zongrenshu intValue]-[_model.canyurenshu intValue];
                    if (_iscanyu==YES)
                    {//判断参与－－－－参与了
                        adCell.goumaiLabel.hidden=YES;
                        adCell.canyuview.hidden=NO;
                        adCell.lookBtn.hidden = YES;
                    }
                    else
                    {
                        //                没参与
                        adCell.lookBtn.hidden = YES;
                        adCell.goumaiLabel.hidden = NO;
                    }
                }
                else
                {//没有登录
                    
                    adCell.jiexiaoBgView.hidden = YES;
                    //                    adCell.jiexiao.hidden=YES;修改
                    //                    adCell.redview.hidden=YES;
                    adCell.redViewBg.hidden = YES;
                    
                    adCell.goumaiLabel.hidden=YES;
                    adCell.lookBtn.hidden = NO;
                    adCell.canyuview.hidden=YES;//修改
                    
                    //                    adCell.jiexiao.hidden=YES;
                    //                    adCell.redview.hidden=YES;
                    
                    double a=[_model.zongrenshu doubleValue];
                    double b=[_model.canyurenshu doubleValue];
                    NSDictionary* style = @{@"body" :
                                                @[[UIFont systemFontOfSize:MiddleFont],
                                                  [UIColor grayColor]],
                                            @"u": @[MainColor,
                                                    
                                                    ]};
                    
                    adCell.remainingLabel.attributedText =  [[NSString stringWithFormat:@"剩余<u>%.0f</u>",a-b]attributedStringWithStyleBook:style];
                    adCell.progressView.progress=b/a;
                    
                    _shengyucount=[_model.zongrenshu intValue]-[_model.canyurenshu intValue];
                }
            }
            else
            {//不是从首页跳转的
                //            判断状态－－－－进行中
                if ([_model.type isEqualToString:@"倒计时"])
                {
                    
                    adCell.jiexiaoBgView.hidden = YES;
                    adCell.stateLabel.text = @"揭晓中";
                    adCell.stateLabel.backgroundColor = MainColor;
                    adCell.totalLabel.hidden=NO;
                    adCell.remainingLabel.hidden=YES;
                    adCell.progressView.hidden=YES;
                    adCell.guzhangLabel.hidden = YES;
                    adCell.lookBtn.hidden = NO;//xiugai
                    //            判断状态－－－是否登录
                    if ([UserDataSingleton userInformation].isLogin == YES)
                    {
                        adCell.goumaiLabel.hidden = YES;
                        
                        if (_iscanyu==YES) {//判断是否参与
                            adCell.goumaiLabel.hidden=YES;
                            adCell.lookBtn.hidden = YES;
                            adCell.canyuview.hidden=NO;
                        }
                        else
                        {
                            adCell.lookBtn.hidden = YES;
                            adCell.goumaiLabel.hidden = NO;
                            
                        }
                        
                    }
                    else
                    {//未登录
                        adCell.goumaiLabel.hidden=YES;
                        
                        adCell.canyuview.hidden=YES;
                        _iscanyu=NO;
                    }
                    
                }
                //            判断状态－－－－已揭晓
                else  if ([_model.type isEqualToString:@"已揭晓"])
                {
                    adCell.stateLabel.text = @"已揭晓";
                    adCell.stateLabel.backgroundColor = MainColor;
                    adCell.redViewBg.hidden = YES;
                    adCell.jiexiaoBgView.hidden =  NO;
                    adCell.totalLabel.hidden=NO;
                    adCell.remainingLabel.hidden=YES;
                    adCell.progressView.hidden=YES;
                    if ([UserDataSingleton userInformation].isLogin == YES) {//已揭晓登陆中
                        adCell.goumaiLabel.frame =CGRectMake(adCell.lookBtn.frame.origin.x, 300, adCell.lookBtn.frame.size.width,adCell.lookBtn.frame.size.height);
                        
                        adCell.canyuview.frame=CGRectMake(adCell.lookBtn.frame.origin.x, 265, adCell.lookBtn.frame.size.width,60);
                        if (_iscanyu==YES)
                        {//判断参与
                            adCell.canyuview.frame=CGRectMake(adCell.lookBtn.frame.origin.x, IPhone4_5_6_6P(200, 222, 250, 265), adCell.lookBtn.frame.size.width,60);
                            adCell.jiexiaoBgView.frame = CGRectMake(0,IPhone4_5_6_6P(230, 250, 280, 295), MSW, 160);
                            adCell.goumaiLabel.hidden=NO;//修改
                            adCell.canyuview.hidden=NO;
                        }
                        else
                        {
                            adCell.lookBtn.hidden = YES;
                            adCell.goumaiLabel.frame=CGRectMake(5, IPhone4_5_6_6P(200, 223, 250, 265), MSW-10, 30);
                        }
                    }
                    else
                    {//已揭晓未登录
                        
                        adCell.lookBtn.frame =CGRectMake(adCell.lookBtn.frame.origin.x, IPhone4_5_6_6P(200, 225, 252, 267), adCell.lookBtn.frame.size.width,adCell.lookBtn.frame.size.height);
                        if (IsStrEmpty(_model.ip)) {
                            [adCell.jiexiao addSubview:adCell.lbzjid];
                            [adCell.jiexiao addSubview:adCell.lbzjcanyu];
                            [adCell.jiexiao addSubview:adCell.lbzjtime];
                            
                            adCell.lbzjid.frame=CGRectMake(58, 30, 250, 20);
                            adCell.lbzjcanyu.frame=CGRectMake(58, 50, 250, 20);
                            adCell.lbzjtime.frame=CGRectMake(58,70, 250, 20);
                        }
                        
                        adCell.goumaiLabel.hidden=YES;
                        
                        adCell.canyuview.hidden=YES;
                        _iscanyu=NO;
                        
                    }
                }
                else  //            判断状态－－－－彩票故障
                {
                    adCell.jiexiaoBgView.hidden = YES;
                    
                    //                    adCell.jiexiao.hidden=YES;修改
                    //  adCell. pageControl.hidden=YES;
                    adCell.stateLabel.hidden = NO;
                    adCell.stateLabel.text = @"故障中";
                    adCell.stateLabel. backgroundColor = MainColor;
                    adCell.totalLabel.hidden=NO;
                    adCell.remainingLabel.hidden=YES;
                    adCell.progressView.hidden=YES;
                    adCell.guzhangLabel.hidden = NO;
                    adCell.timecount.hidden=YES;
                    adCell.time.hidden=YES;
                    adCell.redView.hidden= YES;
                    adCell.countdetail.hidden=YES;
                    //            判断状态－－－是否登录
                    if ([UserDataSingleton userInformation].isLogin == YES)
                    {
                        if (_iscanyu==YES)
                        {//判断是否参与
                            adCell.goumaiLabel.hidden=YES;
                            adCell.lookBtn.hidden = YES;
                            adCell.canyuview.hidden=NO;
                        }
                        else
                        {
                            adCell.goumaiLabel.frame=CGRectMake(5, IPhone4_5_6_6P(200, 223, 250, 265), MSW-10, 30);
                        }
                        
                    }
                    else
                    {//未登录
                        adCell.goumaiLabel.hidden=YES;
                        adCell.canyuview.hidden=YES;
                        _iscanyu=NO;
                        
                    }
                }
            }
            //        －－－－－－－－已揭晓－－－－－－－－－－－
            [adCell.buzjname setTitle:_model.username forState:UIControlStateNormal];
            [adCell.bumore addTarget:self action:@selector(moreduobaono) forControlEvents:UIControlEventTouchUpInside];
            [adCell.imgerweima sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:DefaultImage]];
            if (IsStrEmpty(_model.ip)) {
                [adCell.jiexiao addSubview:adCell.lbzjid];
                [adCell.jiexiao addSubview:adCell.lbzjcanyu];
                [adCell.jiexiao addSubview:adCell.lbzjtime];
                adCell.lbzjid.frame=CGRectMake(58, 30, 250, 20);
                adCell.lbzjcanyu.frame=CGRectMake(58, 50, 250, 20);
                adCell.lbzjtime.frame=CGRectMake(58, 70, 250, 20);
            }
            else
            {
                adCell.lbzjaddress.text=[NSString stringWithFormat:@"手机号码：(%@)",_model.ip];
            }
            adCell.lbzjcanyu.attributedText=[[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",_model.zjgonumber]attributedStringWithStyleBook:style1];
            adCell.lbzjid.text=[NSString stringWithFormat:@"归  属  地：%@",_model.ip];
            NSString *str=_model.jiexiao_time;//时间戳
            NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            adCell.lbzjtime.text=[NSString stringWithFormat:@"揭晓时间：%@",[dateFormatter stringFromDate: detaildate]];
            adCell.lbzjluckno.text=_model.q_user_code;
            adCell.countdetail.hidden = NO;
            [adCell.countdetail addTarget:self action:@selector(gotopicdetail) forControlEvents:UIControlEventTouchUpInside];
            //        夺宝号码:--
            adCell.lbduobaono.text=[NSString stringWithFormat:@"夺宝号码：%@",_model.goucode];
            
            adCell.bujisuan.hidden = NO;
            [adCell.bujisuan addTarget:self action:@selector(gotopicdetail) forControlEvents:UIControlEventTouchUpInside];
            [adCell.countDetailBtn addTarget:self action:@selector(gotopicdetail) forControlEvents:UIControlEventTouchUpInside];
            [adCell.clickButton addTarget:self action:@selector(huojianggerenzhongxin) forControlEvents:UIControlEventTouchUpInside];
                        [adCell.btjiexiao addTarget:self action:@selector(huojianggerenzhongxin) forControlEvents:UIControlEventTouchUpInside];
            [adCell.btlooktuwen addTarget:self action:@selector(looktuwendetail) forControlEvents:UIControlEventTouchUpInside];
            [adCell.btshare addTarget:self action:@selector(sharegoods) forControlEvents:UIControlEventTouchUpInside];
            
            return adCell;
        }
    }
    
    if (indexPath.section==1)
    {
        static NSString *cellName = @"Cell111";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:BigFont];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:MiddleFont];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text= @"往期揭晓";
                cell.imageView.image=[UIImage imageNamed:@"icon_detail_jiexiao"];
//                UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, MSW, 0.7)];
//                lineLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1];
//                [cell.contentView addSubview:lineLabel];
                //                cell.textLabel.frame = CGRectMake(0, 0, MSW, 0.5);
            }
                break;
            default:
            {
                cell.textLabel.text= @"往期晒单";
                cell.imageView.image=[UIImage imageNamed:@"icon_detail_saidan"];
            }
                break;
                
        }
        
        return cell;
    }
    else if (indexPath.section==3)
    {
        static NSString *cellName1 = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName1];
        }
        cell.textLabel.text=@"所有参与记录";
        cell.textLabel.font = [UIFont systemFontOfSize:BigFont];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(12, 12, 14, 14)];
        return cell;
    }
    else if(indexPath.section==4)
    {
        static NSString *commentsCellName = @"commentsCell"; //评论
        CommentViewCell *commentViewCell = [tableView dequeueReusableCellWithIdentifier:commentsCellName];
        if (!commentViewCell)
        {
            commentViewCell = [[CommentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentsCellName];
        }
        _index=indexPath.row;
        TakepateNoteModel*model=[self.canyuArray objectAtIndex:indexPath.row];
        commentViewCell.model=model;
        return commentViewCell;
    }else{
        static NSString *cellName = @"HonorRollViewCell.h";
        HonorRollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[HonorRollViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        cell.honorArray=_model.people;
        if (_model.people.count==1) {
            [cell.user1 addTarget:self action:@selector(rongyubang:) forControlEvents:UIControlEventTouchUpInside];
        }else if (_model.people.count==2){
            [cell.user1 addTarget:self action:@selector(rongyubang:) forControlEvents:UIControlEventTouchUpInside];
            [cell.user2 addTarget:self action:@selector(rongyubang:) forControlEvents:UIControlEventTouchUpInside];
        }else if (_model.people.count==3){
            [cell.user1 addTarget:self action:@selector(rongyubang:) forControlEvents:UIControlEventTouchUpInside];
            [cell.user2 addTarget:self action:@selector(rongyubang:) forControlEvents:UIControlEventTouchUpInside];
            [cell.user3 addTarget:self action:@selector(rongyubang:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.btguize addTarget:self action:@selector(shangbangguize) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //    _model.type=@"已揭晓";   //写死的状态待判断
    if (_tiaozhuantype==1) {
        if ([_model.type isEqualToString:@"进行中"]||_tiaozhuantype==1) {
            if (indexPath.section == 0 )
            {
                if( indexPath.row == 0)
                {
                    if (_iscanyu)
                    {
                        
                        return 125+MSH/4;
                    }
                    else
                    {
                        return 125+MSH/4;
                    }
                }
                else
                {
                    return 150;
                }
            }
            
        }
        else{
            if (indexPath.section == 0  )
            {
                if(indexPath.row == 0)
                {
                    if (_iscanyu)
                    {
                        return 225+30+MSH/4;
                        
                    }
                    else{
                        
                        return 225+30+MSH/4;
                        
                    }
                }
            }
        }
        
        
    }else{
if ([_model.type isEqualToString:@"倒计时"]||[_model.type isEqualToString:@"故障中"])
        {
            if (indexPath.section == 0)
            {
                if(indexPath.row == 0)
                {
                    if (_iscanyu) {
                        return 105+78+30+MSH/4;
                        
                    }
                    else{
                        return 105+78+30+MSH/4;
                        
                    }
                }
                else
                {
                    return 150;
                }
            }
            
        }
        else
        {
            if (indexPath.section == 0 && indexPath.row == 0)
            {
                
                if (_iscanyu) {
                    
                  return 255+10+6+MSH/4;
                    
                }else{//已揭晓没参与
                    
                    return 225+10+36+MSH/4;
                    
                }
            }
        }
        
    }
    
    if (indexPath.section==1) {
        return 40;
    }else if (indexPath.section==2){
        return 180;
    }
    else if(indexPath.section==3){
        return 40;
    }
    else
    {
        
        return 70;
    }
}


#pragma mark -  查看夺宝号         点击更多的视图
-(void)moreduobaono{
    _moreview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    _moreview.alpha=0.5;
    _moreview.backgroundColor=[UIColor blackColor];
    [self.navigationController.view addSubview:_moreview];
    _white=[[UIView alloc]initWithFrame:CGRectMake((MSW - 250)/2, (MSH - 240)/2, 250, 240)];
    _white.backgroundColor=[UIColor whiteColor];
    _white.layer.cornerRadius = 10;
    _white.layer.masksToBounds = YES;
    [self.navigationController.view addSubview:_white];
    UILabel*lbduobao=[[UILabel alloc]initWithFrame:CGRectMake(_white.frame.size.width/2-30, 0,  _white.frame.size.width, 40)];
    lbduobao.text=@"夺宝号";
        UILabel * canyuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, _white.frame.size.width, 20)];
    canyuLabel.textColor = MainColor;
    canyuLabel.font = [UIFont systemFontOfSize:15];
    canyuLabel.text = [NSString stringWithFormat:@"本期参与了%@人次:",_model.gonumber];
    [_white addSubview:canyuLabel];
    [_white addSubview:lbduobao];
    UIScrollView*scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(5,70,  _white.frame.size.width-10,  120)];
    NSString*str=_model.goucode;
    NSArray * arr = [str componentsSeparatedByString:@","];
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.showsVerticalScrollIndicator=YES;
    scroll.contentSize = CGSizeMake( _white.frame.size.width-10, (arr.count/3));
    [_white addSubview:scroll];
        for (int i = 0;  i < arr.count/3 + 1; i ++)
    {
        int item = 3;
        if (i == arr.count / 3)
        {
            item = arr.count % 3;
        }
        for (int j = 0; j < item; j ++)
        {
            UILabel *lbno = [[UILabel alloc]initWithFrame:CGRectMake(5 + j * 80, 10 + i * 30, 70, 20)];
            lbno.font = [UIFont systemFontOfSize:12];
            lbno.text = arr[i*3+j];
            scroll.contentSize = CGSizeMake(lbno.width,30* (arr.count/3+1));
            [scroll addSubview:lbno];
        }
    }
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 199, MSW, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1];
    [_white addSubview:lineLabel];
    UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 250, 40)];
    [sureBtn setTitle:@"确定" forState: UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
    [sureBtn setTitleColor:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(closelook) forControlEvents:UIControlEventTouchUpInside];
    [_white addSubview:sureBtn];
    
}

-(void)closelook{
    [_moreview removeFromSuperview];
    [_white removeFromSuperview];
    
}
#pragma mark 跳转购物车
- (void)pushShopping
{
    iscart=1;
    UIImageView *someThing = [[UIImageView alloc]initWithFrame:CGRectMake(MSW/2-90, 64, 180, 180)];
    someThing.layer.cornerRadius = 10;
    UIImageView*imagegoods=[[UIImageView alloc]init];
    [imagegoods sd_setImageWithURL:[NSURL URLWithString:[_model.picarr objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
    imagegoods.alpha=0.5;
    someThing.image  = imagegoods.image;
    someThing.backgroundColor=[UIColor clearColor];
    //加入到父视图
    //[self.view addSubview:someThing];
    //    [[UIApplication sharedApplication].keyWindow addSubview:someThing];
    [self.navigationController.view addSubview:someThing];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    //动画改变坐标
    [UIView animateWithDuration:1 animations:^{
        someThing.frame = CGRectMake(tabBar.frame.origin.x+MSW-40,20,20,20);
        
    } completion:^(BOOL finished) {
        [someThing removeFromSuperview];
    }];
    [self yiyuanxunbaoaaaa];
    iscart=0;
    
    lbcount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
    if ([lbcount.text isEqualToString:@"0"]) {
        lbcount.hidden=YES;
    }else{
        lbcount.hidden=NO;
        
    }
}

-(void)huojianggerenzhongxin{
        PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
    classVC.yhid=_model.uid;
    
    [self.navigationController pushViewController:classVC animated:YES];
    
}
#pragma mark - 荣誉榜
-(void)rongyubang:(UIButton *)sender{
    int index=(int)sender.tag;
    NSDictionary*dic;
    if (index==101) {
        dic=[_model.people objectAtIndex:0];
    }else if(index==102){
        dic=[_model.people objectAtIndex:1];
    }else{
        dic=[_model.people objectAtIndex:2];
        
    }
    PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
    classVC.yhid=dic[@"uid"];
    
    [self.navigationController pushViewController:classVC animated:YES];
}


#pragma mark - 如果没有登录跳转登陆
- (void)login
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}
-(void)personalcenter{
    TakepateNoteModel*model=[TakepateNoteModel alloc];
    PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
    [self.navigationController pushViewController:classVC animated:YES];
}

//跳转计算详情
-(void)gotopicdetail{
    CalculateDetailController *classVC = [[CalculateDetailController alloc]init];
    classVC.shopid=_model.idd;
    classVC.qishu=_model.qishu;
    [self.navigationController pushViewController:classVC animated:YES];
    
}

#pragma mark - 增加
- (void)addShopping
{
    
    if ([_lbcount.text intValue]<_shengyucount)
    {
        self.goodnum = self.goodnum + [self.model.yunjiage integerValue];
        _lbcount.text = [NSString stringWithFormat:@"%ld",(long)self.goodnum];
    }
    else
    {
        [self.view showHUDTextAtCenter:@"购买数量不能大于剩余数量"];
    }
    
}

#pragma mark - 减少
-(void)reduceShopping
{
    if (self.goodnum > [self.model.yunjiage integerValue])
    {
        self.goodnum = self.goodnum - [self.model.yunjiage integerValue];
        _lbcount.text = [NSString stringWithFormat:@"%li",(long)self.goodnum];
            self.goodnum = self.goodnum - [self.model.yunjiage integerValue];
            _lbcount.text = [NSString stringWithFormat:@"%li",(long)self.goodnum];
    }
    else
    {
        [self.view showHUDTextAtCenter:[NSString stringWithFormat:@"该商品最小参与数量为%@",self.model.yunjiage]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }else if (section==4||section==3){
        
        return 0;
    }
    else
    {
        return 15;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView)
    {
        [self.tableView reloadData];
    }
    self.hidesBottomBarWhenPushed=YES;
    [self getshareinfo];

    
}

#pragma mark - 减少购物车商品
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (self.lbcount.text.length >= 9)
    {
//        [SVProgressHUD showErrorWithStatus:@"输入数量已超出"];
        [self.view showHUDTextAtCenter:@"输入数量已超出"];
        return NO;
    }
    if (range.location == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //    ////    添加手势隐藏键盘
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_blackview addGestureRecognizer:singleRecognizer];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [_whiteview setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-500, _whiteview.frame.size.width, _whiteview.frame.size.height)];
    [UIView commitAnimations];
    
    _addclick.hidden=YES;
    
    return YES;
}

//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom{
    
    _addclick.hidden=NO;
    [_lbcount resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [_whiteview setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-300, _whiteview.frame.size.width, _whiteview.frame.size.height)];
    [UIView commitAnimations];
}



-(void)looktuwendetail{
    
    PictureDetailController *classVC = [[PictureDetailController alloc]init];
    classVC.idd=_model.idd;
    [self.navigationController pushViewController:classVC animated:YES];
    
}

#pragma mark - 分享
-(void)sharegoods{
    UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:_imgurl] shouldLoadWithObserver:nil];
    
    //构造分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",_content]
                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:_title
                                                  url:_url
                                          description:_url
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
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
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
                                DebugLog(@"error = %@",error.errorDescription);
                                if (state == SSPublishContentStateSuccess)
                                {
                                    DebugLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                //                                else if (state == SSPublishContentStateCancel){
                                //                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"分享取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                //                                    [alert show];
                                //                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    DebugLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    if (type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline) {
                                        alert.message = @"您未安装微信客户端，分享失败";
                                    }
                                    [alert show];
                                }
                            }];
    
}
#pragma mark 点击前往购物车
-(void)gotoshopcart{
    DebugLog(@"前往购物车");
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark 确定一元夺宝 -----> 购物车 立即参与
- (void)yiyuanxunbaoaaaa
{
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        
        if ([_model.zongrenshu integerValue] == [_model.canyurenshu integerValue] )
        {
            [self.view showHUDTextAtCenter:@"该商品已没有剩余数量！"];
            return;
        }
        else
        {
            
            if ([_model.xiangou isEqualToString:@"0"])
            {
                //普通
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = _model.idd;
                model.num = [_model.minNumber integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
            else if ([_model.xiangou isEqualToString:@"1"])
            {
                //垄断  限购次数
                
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId =_model.idd;
                model.num = [_model.zongrenshu integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
                
            }
            else
            {
                
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = _model.idd;
                model.num = [_model.minNumber integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
        }
    }
    else
    {
        __block  BOOL isHaveId = NO;
        __block BOOL isAdd = NO;
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            if (obj.num == ([_model.zongrenshu integerValue] - [_model.canyurenshu integerValue]))
            {
                isAdd = YES;
                *stop = YES;
            }
            else
            {
                if ([obj.goodsId isEqualToString:_model.idd])
                {
                    if ([_model.xiangou isEqualToString:@"1"])
                    {
//                        [self.view showHUDTextAtCenter:@"参与人数不能大于剩余人数"];
                        
                        isAdd = YES;
                        *stop = YES;
                        
                    }
                    else
                    {
                        obj.num = obj.num + [_model.minNumber integerValue];
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
                
                if ([_model.xiangou isEqualToString:@"0"])
                {
                    //普通
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = _model.idd;
                    model.num = [_model.minNumber integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
                else if ([_model.xiangou isEqualToString:@"1"])
                {
                    //垄断  限购次数
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = _model.idd;
                    model.num = [_model.zongrenshu integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                    
                }
                else
                {
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = _model.idd;
                    model.num = [_model.minNumber integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
        }
        }
    }
    
    //通知 改变徽标个数
    NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if (iscart==1) {
        
    }else{
        self.tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - 上榜规则
-(void)shangbangguize{
    
    PictureDetailController *classVC = [[PictureDetailController alloc]init];
    classVC.url=_model.url;
    DebugLog(@"==--%@",_model.url);
    classVC.style=222;
    [self.navigationController pushViewController:classVC animated:YES];
    
    
}
#pragma mark - 下拉刷新
- (void)getshareinfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:_model.sid forKey:@"sid"];
    DebugLog(@"hhhhh-----%@----%@",_sid,[UserDataSingleton userInformation].uid);
    [MDYAFHelp AFPostHost:APPHost bindPath:Detaileshare postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"!!!!!!!!!!!!!!!!!!!~~~~%@~~~~~~%@",responseDic,responseDic[@"msg"]);
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            NSDictionary*data=responseDic[@"data"];
            _title=data[@"title"];
            _imgurl=data[@"imgurl"];
            _content=data[@"content"];
            _url=data[@"url"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
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
