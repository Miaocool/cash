//
//  MyViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MyViewController.h"
#import "SetUpViewController.h"
#import "UserDataViewController.h"
#import "NotifyController.h"
#import "TopuprecordController.h"
#import "WinningRecordViewController.h"
#import "MyRedViewController.h"
#import "FindTreasureController.h"
#import "MyShareOrderController.h"
#import "UIImageView+WebCache.h"
#import "ExtensionViewController.h"
#import "TopupController.h"
#import "UserDataModel.h"
#import "AddShaidanController.h"
#import "PWWebViewController.h"
#import "RedPacketController.h"
#import "PayResultController.h"
#import "UserDataView.h"
#import "MyScoreViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "EGOImageLoader.h"
#import <ShareSDK/ShareSDK.h>
#import "UserAddressViewController.h"

#import "EGOImageLoader.h"
#import <ShareSDK/ShareSDK.h>
#import "UserAddressViewController.h"
#import "AwardTipView.h"
#import "GoodsModel.h"


@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, CloseTipViewDelegate>
{
    __block UITableView     *tbView;
    
    NSArray * titlesArray;  //原始数组
    NSArray * imgArray;
    
    NSMutableArray *arrTitles;    //首段
    NSMutableArray *arrImages;
    
    UIButton *haedBtn;
    
    
    NSString *integral;  //总积分
    NSString *continuous; //签到天数
    NSString * is_perfect; //  是否完善地址  0 没有 1 有
    
    
    UITextView              *_shareView;  //分享推广内容
    UILabel                 *_lab;    //文字lab
    UILabel                 *_shouyiLab;  //下方推广收益label
    NSString                *_url;      //下载页url
    NSString                *_title;    //推广标题
    NSString                *_content;   //推广内容
    NSString                *_imgurl;  //头像url
}
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIImageView *roundImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *userView; //用户view
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *topUpBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) UIImageView*imgheadview;
@property (nonatomic, strong) UserDataModel *model;

@property (nonatomic, strong) NSString * share_img;

@property (nonatomic, strong) UserDataView *userDataView;

@property (nonatomic, strong) NSMutableArray  *awardTipArray;
@property (nonatomic, strong) AwardTipView    *awardTipView;
/** 中奖提示索引 */
@property (nonatomic, assign) int             index;
@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    titlesArray = @[@"我的积分",@"我的红包",@"收货信息管理",@"",@"夺宝记录",@"中奖记录",@"我的晒单",@"充值记录",@"我的推广",@"一键加群"];
    imgArray = @[@"pic_me_points",@"icon_my_12",@"pic_me_address",@"",@"pic_me_buy",@"pic_me_win",@"pic_me_share",@"icon_my_10",@"icon_my_11",@"icon09_my"];
    
    arrTitles = [NSMutableArray arrayWithArray:titlesArray];
    arrImages = [NSMutableArray arrayWithArray:imgArray];
    _awardTipArray = [NSMutableArray array];

    [self createUI ];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self userLogin];

    [self.scrollView reloadInputViews];
    self.left.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
    if ([UserDataSingleton userInformation].isLogin == YES)
    {
        self.userDataView.loginBtn.hidden = YES;
        self.userDataView.topUpBtn.hidden = NO;
    }
    else
    {
        self.userDataView.loginBtn.hidden = NO;
        self.userDataView.topUpBtn.hidden = YES;
        self.userDataView.imgheadview.image=[UIImage imageNamed:@"head1"];
        self.userDataView.nameLabel.text = @"";
        self.userDataView.yueLabel.text = @"";
        _imgheadview.image=[UIImage imageNamed:@"head"];
    }
    
    [tbView reloadData];
    [self getShareData];
    
    
    //中奖提示
    [self httpGetAwardTip];
}

#pragma mark - 判断用户是否登陆
- (void)userLogin
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [UserDataSingleton userInformation].isLogin = NO;
     [dict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"ver"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:UserData postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [UserDataSingleton userInformation].isLogin = NO;
        DebugLog(@"==============%@=====%@",responseDic[@"msg"],responseDic);
        
        if ([responseDic[@"code"] isEqualToString:@"302"])
        {
            [UserDataSingleton userInformation].isLogin = NO;
            self.userDataView.imgheadview.image=[UIImage imageNamed:@"head1"];
            self.userDataView.nameLabel.text = @"";
            self.userDataView.yueLabel.text = @"";
            self.userDataView.loginBtn.hidden = NO;
            self.userDataView.topUpBtn.hidden = YES;
        }
        if ([responseDic[@"code"] isEqualToString:@"400"])
        {
            [UserDataSingleton userInformation].uid = nil;
            [UserDataSingleton userInformation].code = nil;
            [UserDataSingleton userInformation].isLogin = NO;
            self.userDataView.loginBtn.hidden = NO;
            self.userDataView.topUpBtn.hidden = YES;
            self.userDataView.imgheadview.image=[UIImage imageNamed:@"head1"];
            self.userDataView.nameLabel.text = @"";
            self.userDataView.yueLabel.text = @"";
        }
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            [UserDataSingleton userInformation].isLogin = YES;
            _model=[[UserDataModel alloc]init];
            NSDictionary*data=responseDic[@"data"];
            _model.username=data[@"username"];
            _model.img=data[@"img"];
            _model.mobile=data[@"mobile"];
            _model.money=data[@"money"];
            _model.score=data[@"score"];
            _model.uid=data[@"uid"];
            is_perfect = data[@"is_perfect"];
            continuous=data[@"sign_in_time_all"];
            _model.validToken=data[@"validToken"];
            _share_img = data[@"share_img"];  //三级分销二维码
            if ([data[@"city"] isEqualToString:@"0"])
            {
                
            }
            if ([UserDataSingleton userInformation].isLogin == YES)
            {
                self.userDataView.loginBtn.hidden = YES;
                
                if ([_model.validToken isEqualToString:@"u8122576178c"])
                {
                    self.userDataView.topUpBtn.hidden = NO;
                }
                
                DebugLog(@"头像：%@",_model.img);
                [self.userDataView.imgheadview sd_setImageWithURL:[NSURL URLWithString:_model.img ] placeholderImage:[UIImage imageNamed:@"head1"]];
                [tbView reloadData];
            }else{
                _imgheadview.image=[UIImage imageNamed:@"head1"];
                
            }

            self.dataDict = responseDic[@"data"];
            self.nameLabel.font = [UIFont systemFontOfSize:BigFont];
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            self.userDataView.nameLabel.text = self.dataDict[@"username"];
            self.moneyLabel.font = [UIFont systemFontOfSize:14];
            self.moneyLabel.textAlignment = NSTextAlignmentCenter;
            if ([_model.validToken isEqualToString:@"u8122576178c"])
            {
                self.userDataView.yueLabel.text = [NSString stringWithFormat:@"余额：%@米币",self.dataDict[@"money"]];
            }
        }
        
        [arrTitles removeAllObjects];
        [arrImages removeAllObjects];
        
        arrTitles = [NSMutableArray arrayWithArray:titlesArray];
        arrImages = [NSMutableArray arrayWithArray:imgArray];
        
        [tbView reloadData];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UserDataSingleton userInformation].isLogin = NO;
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

#pragma mark - 创建UI
- (void)createUI
{
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 40)];
    _footView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(MSW/2 - 150, 5, 300, 30)];
    label.text = @"所有奖品抽奖活动与苹果公司(Apple lnc.)无关";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [_footView addSubview:label];
    
}

#pragma mark - 创建tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_model.validToken isEqualToString:@"u8122576178c"]) {
        if ([[UserDataSingleton userInformation].is_push isEqualToString:@"1"]) {
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                //全部都开放
                
            }else{
                //没有QQ
                [arrTitles removeObject:@"一键加群"];
            }
        }else{
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                //没有推广
                [arrTitles removeObject:@"我的推广"];
            }else{
                //没有推广和QQ
                [arrTitles removeObject:@"我的推广"];
                [arrTitles removeObject:@"一键加群"];
            }
        }
    }else{
        if ([[UserDataSingleton userInformation].is_push isEqualToString:@"1"]) {
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                //没有 红包和充值记录
                [arrTitles removeObject:@"我的红包"];
                [arrTitles removeObject:@"充值记录"];
                
            }else{
                //没有 红包和充值记录、 QQ
                [arrTitles removeObject:@"我的红包"];
                [arrTitles removeObject:@"充值记录"];
                [arrTitles removeObject:@"一键加群"];
                
            }
        }else{
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                //没有 红包和充值记录、推广
                [arrTitles removeObject:@"我的红包"];
                [arrTitles removeObject:@"充值记录"];
                [arrTitles removeObject:@"我的推广"];
            }else{
                //都不开放
                [arrTitles removeObject:@"我的红包"];
                [arrTitles removeObject:@"充值记录"];
                [arrTitles removeObject:@"我的推广"];
                [arrTitles removeObject:@"一键加群"];
            }
        }
    }

    return arrTitles.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        return 10;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if ([UserDataSingleton userInformation].isLogin==YES) {
            return IPhone4_5_6_6P(230, 230, MSW/1.53, 270);
        }else{
            return IPhone4_5_6_6P(190, 190, MSW/1.85, 220);
        }
    }
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        if (!self.userDataView)
        {
            self.userDataView = [[UserDataView alloc]init];
        }
        
        if ([UserDataSingleton userInformation].isLogin==YES) {
            self.userDataView.frame = CGRectMake(0, 0, MSW, IPhone4_5_6_6P(230, 230, MSW/1.53, 270));
            self.userDataView.bgImageView.frame = CGRectMake(0, 0, MSW, IPhone4_5_6_6P(230, 230, MSW/1.53, 270));
        }else{
            self.userDataView.frame = CGRectMake(0, 0, MSW, IPhone4_5_6_6P(190, 190, MSW/1.85, 220));
            self.userDataView.bgImageView.frame = CGRectMake(0, 0, MSW, IPhone4_5_6_6P(190, 190, MSW/1.85, 220));
        }
        
        [self.userDataView.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [self.userDataView.leBtn addTarget:self action:@selector(NavBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.userDataView.riBtn addTarget:self action:@selector(NavBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.userDataView.topUpBtn addTarget:self action:@selector(recharge1) forControlEvents:UIControlEventTouchUpInside];
        [self.userDataView.haedBtn addTarget:self action:@selector(userData) forControlEvents:UIControlEventTouchUpInside];
        
        return self.userDataView;
    }
    
    else
    {
        return nil;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{if ([UserDataSingleton userInformation].isLogin==YES) {
    if (tbView == scrollView) {
        CGFloat yOffset = tbView.contentOffset.y;
        if (yOffset <0 ) {
            CGRect frame1 = self.userDataView.frame;
            frame1.origin.y = yOffset;
            frame1.size.height =  -yOffset;
            float y;
            y=(float)yOffset;
            self.userDataView.bgImageView.frame = CGRectMake(frame1.origin.y,-frame1.size.height, MSW-frame1.origin.y*2, IPhone4_5_6_6P(230, 230, MSW/1.53, 270)+frame1.size.height);
        }
        else {
            self.userDataView.frame = CGRectMake(0, 0, MSW, IPhone4_5_6_6P(230, 230, MSW/1.53, 270));
        }
    }
}else{
    
    if (tbView == scrollView) {
        CGFloat yOffset = tbView.contentOffset.y;
        
        if (yOffset <0 ) {
            
            CGRect frame1 = self.userDataView.frame;
            frame1.origin.y = yOffset;
            frame1.size.height =  -yOffset;
            float y;
            y=(float)yOffset;
            self.userDataView.bgImageView.frame = CGRectMake(frame1.origin.y,-frame1.size.height, MSW-frame1.origin.y*2,  IPhone4_5_6_6P(190, 190, MSW/1.85, 220)+frame1.size.height);
        }
        else {
            self.userDataView.frame = CGRectMake(0, 0, MSW, IPhone4_5_6_6P(190, 190, MSW/1.85, 220));
        }
    }
}
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"proCommonCell";
    UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString* title = nil;
    NSString* image = nil;

    NSDictionary* style = @{@"body" :
                                @[[UIFont systemFontOfSize:14],
                                  [UIColor blackColor]],
                            @"u": @[MainColor, ]};
    
    
    if ([_model.validToken isEqualToString:@"u8122576178c"]) {
        
        if ([[UserDataSingleton userInformation].is_push isEqualToString:@"1"]) {
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                //全部都开放
                
            }else{
                //没有QQ
                [arrTitles removeObject:@"一键加群"];
                [arrImages removeObject:@"icon09_my"];
            }
        }else{
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                //没有推广
                [arrTitles removeObject:@"我的推广"];
                [arrImages removeObject:@"icon_my_11"];
            }else{
                //没有推广和QQ
                [arrTitles removeObject:@"我的推广"];
                [arrImages removeObject:@"icon_my_11"];
                [arrTitles removeObject:@"一键加群"];
                [arrImages removeObject:@"icon09_my"];
            }
        }
        
        title = [arrTitles objectAtIndex:indexPath.row];
        image = [arrImages objectAtIndex:indexPath.row];
        
        if (indexPath.row == 2){
            
            cell.textLabel.text = [NSString stringWithFormat:@"        %@",title];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
            cell.detailTextLabel.textColor=[UIColor whiteColor];
            
            if ([UserDataSingleton userInformation].isLogin==YES) {
                
                UILabel*lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 12, 60, 20)];
                lbdetail.layer.cornerRadius = 3;
                lbdetail.layer.masksToBounds = YES;
                lbdetail.textColor=[UIColor whiteColor];
                lbdetail.textAlignment=UITextAlignmentCenter;
                lbdetail.font=[UIFont systemFontOfSize:MiddleFont];
                if ([is_perfect isEqualToString:@"0"]) {
                    lbdetail.text=@"未完善";
                    lbdetail.backgroundColor=MainColor;
                }else{
                    lbdetail.backgroundColor=[UIColor whiteColor];
                }

                [cell.contentView addSubview:lbdetail];

            }else{
                cell.detailTextLabel.text=[NSString stringWithFormat:@""];
                UILabel*lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 12, 60, 20)];
                lbdetail.backgroundColor=[UIColor whiteColor];
                [cell.contentView addSubview:lbdetail];
                
            }
            
        }
        else{
            
            cell.textLabel.text = [NSString stringWithFormat:@"        %@",title];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
            cell.detailTextLabel.textColor=[UIColor whiteColor];
        }

        
        
    }else{
        //没有 红包和充值记录
        [arrTitles removeObject:@"我的红包"];
        [arrTitles removeObject:@"充值记录"];
        [arrImages removeObject:@"icon_my_12"];
        [arrImages removeObject:@"icon_my_10"];

        [arrTitles replaceObjectAtIndex:2 withObject:@"夺宝记录"];
        [arrImages replaceObjectAtIndex:2 withObject:@"pic_me_buy"];
        [arrTitles replaceObjectAtIndex:3 withObject:@""];
        [arrImages replaceObjectAtIndex:3 withObject:@""];
        

        if ([[UserDataSingleton userInformation].is_push isEqualToString:@"1"]) {
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {

            }else{
                //没有 红包和充值记录、 QQ
                [arrTitles removeObject:@"一键加群"];
                [arrImages removeObject:@"icon09_my"];
            }
        }else{
            if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                //没有 红包和充值记录、推广
                [arrTitles removeObject:@"我的推广"];
                [arrImages removeObject:@"icon_my_11"];
            }else{
                //都不开放
                [arrTitles removeObject:@"我的推广"];
                [arrImages removeObject:@"icon_my_11"];
                [arrTitles removeObject:@"一键加群"];
                [arrImages removeObject:@"icon09_my"];
            }
        }
        
        title = [arrTitles objectAtIndex:indexPath.row];
        image = [arrImages objectAtIndex:indexPath.row];
        
        if (indexPath.row == 1){
            
            cell.textLabel.text = [NSString stringWithFormat:@"        %@",title];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
            cell.detailTextLabel.textColor=[UIColor whiteColor];
            
            if ([UserDataSingleton userInformation].isLogin==YES) {

                UILabel*lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 12, 60, 20)];
                lbdetail.layer.cornerRadius = 3;
                lbdetail.layer.masksToBounds = YES;
                lbdetail.textColor=[UIColor whiteColor];
                lbdetail.textAlignment=UITextAlignmentCenter;
                lbdetail.font=[UIFont systemFontOfSize:MiddleFont];
                if ([is_perfect isEqualToString:@"0"]) {
                    lbdetail.text=@"未完善";
                    lbdetail.backgroundColor=MainColor;
                }else{
                    lbdetail.backgroundColor=[UIColor whiteColor];
                }

                [cell.contentView addSubview:lbdetail];

            }else{
                
                cell.detailTextLabel.text=[NSString stringWithFormat:@""];
                UILabel*lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 12, 60, 20)];
                lbdetail.backgroundColor=[UIColor whiteColor];
                [cell.contentView addSubview:lbdetail];
            }
        }
        else{
            
            cell.textLabel.text = [NSString stringWithFormat:@"        %@",title];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
            cell.detailTextLabel.textColor=[UIColor whiteColor];
        }
    }

    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 25, 25)];
    img.image = [UIImage imageNamed:image];
    [cell addSubview:img];
    
    
    

    
    //我的积分 位置一直不动
    if (indexPath.row == 0) {
        
        if ([UserDataSingleton userInformation].isLogin==YES) {
            cell.textLabel.attributedText =  [[NSString stringWithFormat:@"        %@<u>(%@)</u>",title,_model.score] attributedStringWithStyleBook:style];
            
            UILabel*lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 12, 60, 20)];
            lbdetail.layer.cornerRadius = 3;
            lbdetail.layer.masksToBounds = YES;
            lbdetail.backgroundColor=MainColor;
            lbdetail.textColor=[UIColor whiteColor];
            if ([continuous isEqualToString:@"0"]) {
                lbdetail.text=@"未签到";
                lbdetail.backgroundColor = MainColor;
                
            }else{
                lbdetail.text=[NSString stringWithFormat:@"签到%@天",continuous];
                lbdetail.backgroundColor=RGBACOLOR(42, 132, 236, 1);
                
            }
            lbdetail.textAlignment=UITextAlignmentCenter;
            
            lbdetail.font=[UIFont systemFontOfSize:MiddleFont];
            
            [cell.contentView addSubview:lbdetail];
        }
        else{
            
            cell.textLabel.attributedText =  [[NSString stringWithFormat:@"        %@<u></u>",title] attributedStringWithStyleBook:style];
            UILabel*lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 12, 60, 20)];
            lbdetail.text = @"";
            lbdetail.backgroundColor=[UIColor whiteColor];
            [cell.contentView addSubview:lbdetail];
        }
        cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.frame=CGRectMake(0, 0, 100, 30);
        
    }
    //空白行 不动
    if (indexPath.row == 3) {
        cell.contentView.backgroundColor = RGBCOLOR(235, 235, 241);
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([UserDataSingleton userInformation].isLogin == YES)
    {
        if (indexPath.row == 0)
        {
            //我的积分
            MyScoreViewController *score=[[MyScoreViewController alloc]init];
            score.hidesBottomBarWhenPushed=YES;
            score.model = _model;
            [self.navigationController pushViewController:score animated:YES];
        }
        else if (indexPath.row == 1)
        {
            if ([_model.validToken isEqualToString:@"u8122576178c"])
            {
                //红包
                RedPacketController *red=[[RedPacketController alloc]init];
                red.hidesBottomBarWhenPushed=YES;
                red.tiaozhuan=1;
                [self.navigationController pushViewController:red animated:YES];
            }else{
                //收货地址
                UserAddressViewController *address=[[UserAddressViewController alloc]init];
                address.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:address animated:YES];
            }
        }else if (indexPath.row == 2)
        {
            if ([_model.validToken isEqualToString:@"u8122576178c"])
            {
                //收货地址
                UserAddressViewController *address=[[UserAddressViewController alloc]init];
                address.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:address animated:YES];
            }else{
                //夺宝记录
                FindTreasureController *userData = [[FindTreasureController alloc]init];
                userData.hidesBottomBarWhenPushed = YES;
                userData.tiaozhuan=1;
                [self.navigationController pushViewController:userData animated:YES];
            }
        }else if (indexPath.row == 4)
        {
            if ([_model.validToken isEqualToString:@"u8122576178c"])
            {
                //夺宝记录
                FindTreasureController *userData = [[FindTreasureController alloc]init];
                userData.hidesBottomBarWhenPushed = YES;
                userData.tiaozhuan=1;
                [self.navigationController pushViewController:userData animated:YES];
            }
            else{
                //中奖记录
                WinningRecordViewController *win=[[WinningRecordViewController alloc]init];
                win.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:win animated:YES];
            }
        }else if (indexPath.row == 5)
        {
            if ([_model.validToken isEqualToString:@"u8122576178c"])
            {
                //中奖记录
                WinningRecordViewController *win=[[WinningRecordViewController alloc]init];
                win.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:win animated:YES];
                
            }else{
                //我的晒单
                MyShareOrderController *win=[[MyShareOrderController alloc]init];
                win.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:win animated:YES];
            }
        }else if (indexPath.row == 6)
        {
            if ([_model.validToken isEqualToString:@"u8122576178c"]) {
                //我的晒单
                MyShareOrderController *win=[[MyShareOrderController alloc]init];
                win.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:win animated:YES];
            }else{
                if ([[UserDataSingleton userInformation].is_push isEqualToString:@"1"]) {
                    //推广
                    ExtensionViewController *exten=[[ExtensionViewController alloc]init];
                    exten.hidesBottomBarWhenPushed=YES;
                    exten.model=_model;
                    exten.share_img = _share_img;
                    [self.navigationController pushViewController:exten animated:YES];
                    
                }else if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]){
                    //一键加群
                    [self joinGroup];
                }
            }
            
        }else if (indexPath.row == 7)
        {
            if ([_model.validToken isEqualToString:@"u8122576178c"])
            {
                //充值记录
                TopuprecordController *userData = [[TopuprecordController alloc]init];
                userData.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userData animated:YES];
                
            }else{
                if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]) {
                    //一键加群
                    [self joinGroup];
                }
            }

        }else if (indexPath.row == 8)
        {
            if ([[UserDataSingleton userInformation].is_push isEqualToString:@"1"]) {
                //推广
                ExtensionViewController *exten=[[ExtensionViewController alloc]init];
                exten.hidesBottomBarWhenPushed=YES;
                exten.model=_model;
                exten.share_img = _share_img;
                [self.navigationController pushViewController:exten animated:YES];
            }else if ([[UserDataSingleton userInformation].is_qq isEqualToString:@"1"]){
                //一键加群
                [self joinGroup];
            }
        }else if (indexPath.row == 9){
            //一键加群
            [self joinGroup];
        }

    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}

#pragma mark - 登陆
- (void)login
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

-(void)problem
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    //    DebugLog(@"==========%@",dict[@"code"]);
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

#pragma mark ---- 点击 一键加群
- (BOOL)joinGroup{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", [UserDataSingleton userInformation].qq_uin,[UserDataSingleton userInformation].qq_groupkey];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

#pragma mark - 点击用户头像 - 资料
- (void)userData
{
    if ([UserDataSingleton userInformation].isLogin == YES)
    {
        UserDataViewController *userData = [[UserDataViewController alloc]init];
        userData.dataDict = self.dataDict;
        userData.share_img = _share_img;
        [self.navigationController pushViewController:userData animated:YES];
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


#pragma mark - 导航按钮
- (void)NavBtn:(UIButton *)button
{
    if (button.tag == 101)
    {
        
//        NotifyController *userData = [[NotifyController alloc]init];
//        [self.navigationController pushViewController:userData animated:YES];
//        // [self goTongzhi];
        [self share];
    }
    else
    {
//        if ([UserDataSingleton userInformation].isLogin == YES)
//        {
//            //设置
            SetUpViewController *setUpVC = [[SetUpViewController alloc]init];
            setUpVC.share_img = _share_img;
            setUpVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:setUpVC animated:YES];
//        }
//        else
//        {
//            LoginViewController *loginVC = [[LoginViewController alloc]init];
//            loginVC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:loginVC animated:YES];
//        }
        
    }
}
#pragma mark - 点击充值
-(void)recharge1
{
    TopupController *top=[[TopupController alloc]init];
    [self.navigationController pushViewController:top animated:YES];
}

#pragma mark - 获取分享请求
-(void)getShareData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Share postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary*data=responseDic[@"data"];
            _shareView.text=data[@"content"];
            _shouyiLab.text=data[@"shouyi"];
            _url=data[@"url"];
            _title=data[@"title"];
            _content=data[@"content"];
            _imgurl=data[@"imgurl"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}
#pragma mark - 获取分享
-(void)share
{
    UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:_imgurl] shouldLoadWithObserver:nil];
    
    //构造分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",_content]
                                       defaultContent:nil
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:_title
                                                  url:_url
                                          description:nil
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
            _url              = data[@"url"];
            _title            = data[@"title"];
            _content          = data[@"content"];
            _imgurl           = data[@"imgurl"];
            
            [self share];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
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
