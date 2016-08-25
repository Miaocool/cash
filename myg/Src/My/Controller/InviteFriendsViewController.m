//
//  InviteFriendsViewController.m
//  myg
//
//  Created by lidan on 16/7/8.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "InviteFriendsViewCell.h"
#import "ExtenShareViewController.h"
#import "FriendsModel.h"
#import "MJRefresh.h"
#import "InviteFriendsView.h"
#import "PersonalcenterController.h"

@interface InviteFriendsViewController ()<PullingRefreshTableViewDelegate,UIScrollViewDelegate,InviteFriendsViewDelegate>

@property (nonatomic, strong) UIButton * btInstructions; //邀请说明
@property (nonatomic, strong) UIButton * btRankingList;   //排行榜
@property (nonatomic, strong) UIButton * firstButton;    //一级好友
@property (nonatomic, strong) UIButton * secondButton;    //二级好友
@property (nonatomic, strong) UIButton * thirdButton;     //三级好友

@property (nonatomic, strong) UIScrollView * scrollView;


@property (nonatomic, strong) NSString * friend_num1;
@property (nonatomic, strong) NSString * friend_num2;
@property (nonatomic, strong) NSString * friend_num3;

@property (nonatomic, strong) UIView * topView;

@property (nonatomic, assign) NSInteger num;   //页数

@property (nonatomic, assign) NSInteger type;   //下级级别  1 or 2 or 3

@property (nonatomic, strong) NSString * friend_all;  //累计好友数
@property (nonatomic, strong) NSString * all_shouyi;  //累计收益
@property (nonatomic, strong) NSString * img;   //头像

@property (nonatomic, strong) NSString * firstIncome;   //一级下线提成
@property (nonatomic, strong) NSString * secondIncome;   //二级下线提成
@property (nonatomic, strong) NSString * thirdIncome;   //三级下线提成

@property (nonatomic, strong) NSString * shareshouyi;

@property (nonatomic, strong) InviteFriendsView * tableView;




@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"邀请好友";
    [self initData];
    
}

-(void)initData{
    
    self.num = 1;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.num] forKey:@"p"];
    [dict setValue:@"1" forKey:@"type"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:three_distribution postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            self.friend_num1 = responseDic[@"data"][@"friend_num1"];
            self.friend_num2 = responseDic[@"data"][@"friend_num2"];
            self.friend_num3 = responseDic[@"data"][@"friend_num3"];
            
            self.img = responseDic[@"data"][@"img"];
            self.all_shouyi = responseDic[@"data"][@"all_shouyi"];
            self.friend_all = responseDic[@"data"][@"friend_all"];
            
            //三级分销规则
            [MDYAFHelp AFPostHost:APPHost bindPath:distribution_role postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                DebugLog(@"===================%@",responseDic);
                if([responseDic[@"code"] isEqualToString:@"200"])
                {
                    self.firstIncome = responseDic[@"data"][@"firstIncome"];
                    self.secondIncome = responseDic[@"data"][@"secondIncome"];
                    self.thirdIncome = responseDic[@"data"][@"threeIncome"];
                    self.shareshouyi = responseDic[@"data"][@"shareshouyi"];
                    [self headerView];
                    [self createUI];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }];
        }
        if ([responseDic[@"code"] isEqualToString:@"400"]) {
            [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];

}



-(void)createUI{
    
    [self.scrollView removeAllSubviews];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.bottom-IPhone4_5_6_6P(45, 45, 50, 50), MSW, MSH - _topView.height+IPhone4_5_6_6P(45, 45, 50, 50))];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    //邀请说明页面
    UIScrollView * instructionsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - _topView.height)];
    instructionsScroll.backgroundColor = [UIColor whiteColor];
    instructionsScroll.contentSize = CGSizeMake(self.view.bounds.size.width, MSH);
    
    UIView * instructionsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, MSH - 150)];
    instructionsView.backgroundColor = [UIColor whiteColor];
    [instructionsScroll addSubview:instructionsView];
    
    NSDictionary* style = @{@"body" :
                                @[[UIFont systemFontOfSize:14],
                                  [UIColor grayColor]],
                            @"u": @[MainColor, ]};
    
    UILabel *share = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, MSW - 30, 30)];
    share.text = self.shareshouyi;
    share.font = [UIFont systemFontOfSize:15];
    [instructionsView addSubview:share];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, share.bottom + 10, MSW - 30, 30)];
    label1.text = @"一级好友：您邀请的好友";
    label1.font = [UIFont systemFontOfSize:15];
//    [instructionsView addSubview:label1];
    UILabel * lbPushMoney1 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.bottom, MSW - 30, 30)];
    lbPushMoney1.text = @"夺宝提成60积分";
    lbPushMoney1.attributedText = [[NSString stringWithFormat:@"夺宝提成<u>%@积分</u>",self.firstIncome] attributedStringWithStyleBook:style];
//    [instructionsView addSubview:lbPushMoney1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label1.bottom +40, MSW - 30, 30)];
    label2.text = @"二级好友：您好友邀请的好友";
    label2.font = [UIFont systemFontOfSize:15];
//    [instructionsView addSubview:label2];
    UILabel * lbPushMoney2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label2.bottom, MSW - 30, 30)];
    lbPushMoney2.text = @"夺宝提成30积分";
    lbPushMoney2.attributedText = [[NSString stringWithFormat:@"夺宝提成<u>%@积分</u>",self.secondIncome]attributedStringWithStyleBook:style];
//    [instructionsView addSubview:lbPushMoney2];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label2.bottom +40, MSW - 30, 30)];
    label3.text = @"三级好友：您的好友的好友邀请的好友";
//    [instructionsView addSubview:label3];
    label3.font = [UIFont systemFontOfSize:15];
    UILabel * lbPushMoney3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label3.bottom, MSW - 30, 30)];
    lbPushMoney3.text = @"夺宝提成10积分";
    lbPushMoney3.attributedText = [[NSString stringWithFormat:@"夺宝提成<u>%@积分</u>",self.thirdIncome] attributedStringWithStyleBook:style];
//    [instructionsView addSubview:lbPushMoney3];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(80, lbPushMoney3.bottom +50, MSW - 160, 40)];
    [button setTitle:@"邀请好友" forState:UIControlStateNormal];
    button.backgroundColor = MainColor;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(gotoInstructionsView) forControlEvents:(UIControlEventTouchUpInside)];
    [instructionsView addSubview:button];
    
    [self.scrollView addSubview:instructionsScroll];

    
//    for (NSInteger i = 0; i < 4; i++)
//    {
        self.tableView = [[InviteFriendsView alloc]initWithFrame:CGRectMake(MSW * (0+1), 0, MSW, MSH - _topView.height - 64) withType:@"1"];
        self.tableView.tag = 200 + 1 ;
        self.tableView.delegate = self;
        [self.scrollView addSubview:self.tableView];
//    }
    
    [self.view addSubview:self.scrollView];
    
}



-(void)headerView{
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, IPhone4_5_6_6P(180, 180, 200, 200))];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    UIImageView * headImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, IPhone4_5_6_6P(60, 60, 70, 70), IPhone4_5_6_6P(60, 60, 70, 70))];
    [headImg sd_setImageWithURL:[NSURL URLWithString:self.img] placeholderImage:[UIImage imageNamed:DefaultImage]];
    headImg.layer.cornerRadius = IPhone4_5_6_6P(30, 30, 35, 35);
    headImg.layer.masksToBounds = YES;
    headImg.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:headImg];
    
    NSDictionary* style = @{@"body" :
                                @[[UIFont systemFontOfSize:15],
                                  [UIColor blackColor]],
                            @"u": @[MainColor, ]};
    
    UILabel * friendsCount = [[UILabel alloc] initWithFrame:CGRectMake( headImg.right +15, 15, 200, 30)];
    friendsCount.attributedText = [[NSString stringWithFormat:@"累计好友：<u>%@</u>",self.friend_all] attributedStringWithStyleBook:style];
    [self.topView addSubview:friendsCount];
    
    UILabel * EarningsCount = [[UILabel alloc] initWithFrame:CGRectMake( headImg.right +15, friendsCount.bottom , 200, 30)];
    EarningsCount.attributedText = [[NSString stringWithFormat:@"累计收益：<u>%@</u>",self.all_shouyi] attributedStringWithStyleBook:style];
//    [self.topView addSubview:EarningsCount];

    
    NSDictionary* style3 = @{@"body" :
                                 @[[UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)],
                                   [UIColor grayColor]],
                             @"u": @[FontBlue, ]};
    
    self.btInstructions = [[UIButton alloc] initWithFrame:CGRectMake(0, headImg.bottom + 20, MSW/2, IPhone4_5_6_6P(45, 45, 50, 50))];
    [self.btInstructions setTitle:@"邀请说明" forState:UIControlStateNormal];
    [self.btInstructions setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btInstructions.backgroundColor = MainColor;
    self.btInstructions.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.btInstructions.layer.borderWidth = 0.3;
    self.btInstructions.layer.borderColor = RGBCOLOR(230, 231, 232).CGColor;
    [self.btInstructions addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    self.btInstructions.tag = 100;
    [self.topView addSubview:self.btInstructions];
    
#warning 3.0.6版本
    
    self.btRankingList = [[UIButton alloc] initWithFrame:CGRectMake(MSW/2, headImg.bottom + 20, MSW/2, IPhone4_5_6_6P(45, 45, 50, 50))];
    [self.btRankingList setTitle:@"我的好友" forState:UIControlStateNormal];
    [self.btRankingList setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.btRankingList.backgroundColor = RGBCOLOR(244, 245, 246);
    self.btRankingList.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.btRankingList.layer.borderWidth = 0.3;
    self.btRankingList.layer.borderColor = RGBCOLOR(230, 231, 232).CGColor;
    [self.btRankingList addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    self.btRankingList.tag = 101;
    [self.topView addSubview:self.btRankingList];
    
    self.firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.btInstructions.bottom, MSW/3, IPhone4_5_6_6P(45, 45, 50, 50))];
    [self.firstButton setTitle:@"收益" forState:UIControlStateNormal];
    [self.firstButton setAttributedTitle:[[NSString stringWithFormat:@"一级好友  <u>%@</u>",self.friend_num1] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
    self.firstButton.backgroundColor = RGBCOLOR(244, 245, 246);
    self.firstButton.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.firstButton.layer.borderWidth = 0.3;
    self.firstButton.layer.borderColor = RGBCOLOR(230, 231, 232).CGColor;
    [self.firstButton addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    self.firstButton.tag = 102;
//    [self.topView addSubview:self.firstButton];
    
    self.secondButton = [[UIButton alloc] initWithFrame:CGRectMake(self.firstButton.right, self.btInstructions.bottom, MSW/3, IPhone4_5_6_6P(45, 45, 50, 50))];
    [self.secondButton setTitle:@"二级好友 5" forState:UIControlStateNormal];
    [self.secondButton setAttributedTitle:[[NSString stringWithFormat:@"二级好友  <u>%@</u>",self.friend_num2] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
    self.secondButton.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.secondButton.backgroundColor = RGBCOLOR(244, 245, 246);
    self.secondButton.layer.borderWidth = 0.3;
    self.secondButton.layer.borderColor = RGBCOLOR(230, 231, 232).CGColor;
    [self.secondButton addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    self.secondButton.tag = 103;
//    [self.topView addSubview:self.secondButton];
    
    self.thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(self.secondButton.right, self.btInstructions.bottom, MSW/3, IPhone4_5_6_6P(45, 45, 50, 50))];
    [self.thirdButton setTitle:@"用户昵称" forState:UIControlStateNormal];
    [self.thirdButton setAttributedTitle:[[NSString stringWithFormat:@"三级好友  <u>%@</u>",self.friend_num3] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
    self.thirdButton.backgroundColor = RGBCOLOR(244, 245, 246);
    self.thirdButton.titleLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.thirdButton.layer.borderWidth = 0.3;
    self.thirdButton.layer.borderColor = RGBCOLOR(230, 231, 232).CGColor;
    [self.thirdButton addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    self.thirdButton.tag = 104;
//    [self.topView addSubview:self.thirdButton];
    
}

-(void)seleteview:(UIButton*)sender{
    
    [self selectButton:sender.tag];
    
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width * (sender.tag-100), 0.0);
}

//button变换背景、字体颜色
-(void)selectButton:(NSInteger)tag{
    
    NSDictionary* style2 = @{@"body" :
                                 @[[UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)],
                                   [UIColor whiteColor]],
                             @"u": @[[UIColor whiteColor], ]};
    
    NSDictionary* style3 = @{@"body" :
                                 @[[UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)],
                                   [UIColor grayColor]],
                             @"u": @[FontBlue, ]};
    
    if (tag ==100) {
        [self.btInstructions setBackgroundColor:MainColor];
        [self.btInstructions setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btRankingList setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btRankingList setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.firstButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.firstButton setAttributedTitle:[[NSString stringWithFormat:@"一级好友  <u>%@</u>",self.friend_num1] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.secondButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.secondButton setAttributedTitle:[[NSString stringWithFormat:@"二级好友  <u>%@</u>",self.friend_num2] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.thirdButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.thirdButton setAttributedTitle:[[NSString stringWithFormat:@"三级好友  <u>%@</u>",self.friend_num3] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        
    }else if (tag ==101){
        [self.btInstructions setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btInstructions setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btRankingList setBackgroundColor:MainColor];
        [self.btRankingList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.firstButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.firstButton setAttributedTitle:[[NSString stringWithFormat:@"一级好友  <u>%@</u>",self.friend_num1] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.secondButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.secondButton setAttributedTitle:[[NSString stringWithFormat:@"二级好友  <u>%@</u>",self.friend_num2] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.secondButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.thirdButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.thirdButton setAttributedTitle:[[NSString stringWithFormat:@"三级好友  <u>%@</u>",self.friend_num3] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        
        
    }else if (tag == 102){
        
        [self.btInstructions setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btInstructions setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btRankingList setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btRankingList setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.firstButton setBackgroundColor:MainColor];
        [self.firstButton setAttributedTitle:[[NSString stringWithFormat:@"一级好友  <u>%@</u>",self.friend_num1] attributedStringWithStyleBook:style2] forState:UIControlStateNormal];
        [self.secondButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.secondButton setAttributedTitle:[[NSString stringWithFormat:@"二级好友  <u>%@</u>",self.friend_num2] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.secondButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.thirdButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.thirdButton setAttributedTitle:[[NSString stringWithFormat:@"三级好友  <u>%@</u>",self.friend_num3] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        
        self.type = 1;
        
    }else if (tag == 103){
        
        [self.btInstructions setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btInstructions setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btRankingList setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btRankingList setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.firstButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.firstButton setAttributedTitle:[[NSString stringWithFormat:@"一级好友  <u>%@</u>",self.friend_num1] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.secondButton setBackgroundColor:MainColor];
        [self.secondButton setAttributedTitle:[[NSString stringWithFormat:@"二级好友  <u>%@</u>",self.friend_num2] attributedStringWithStyleBook:style2] forState:UIControlStateNormal];
        [self.thirdButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.thirdButton setAttributedTitle:[[NSString stringWithFormat:@"三级好友  <u>%@</u>",self.friend_num3] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        
        self.type = 2;
        
    }else if (tag == 104){
        
        [self.btInstructions setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btInstructions setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btRankingList setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.btRankingList setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.firstButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.firstButton setAttributedTitle:[[NSString stringWithFormat:@"一级好友  <u>%@</u>",self.friend_num1] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.secondButton setBackgroundColor:RGBCOLOR(244, 245, 246)];
        [self.secondButton setAttributedTitle:[[NSString stringWithFormat:@"二级好友  <u>%@</u>",self.friend_num2] attributedStringWithStyleBook:style3] forState:UIControlStateNormal];
        [self.thirdButton setBackgroundColor:MainColor];
        [self.thirdButton setAttributedTitle:[[NSString stringWithFormat:@"三级好友  <u>%@</u>",self.friend_num3] attributedStringWithStyleBook:style2] forState:UIControlStateNormal];
        
        self.type = 3;
    }
    
}




#pragma mark 邀请好友
-(void)gotoInstructionsView{
    ExtenShareViewController * exten = [[ExtenShareViewController alloc] init];
    [self.navigationController pushViewController:exten animated:YES];
}


#pragma mark - UIScrollViewDelegate
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView  == self.scrollView) {
        NSInteger i = scrollView.contentOffset.x/self.view.bounds.size.width;
        
        NSLog(@"i----%ld",(long)i);
        
        [self selectButton:i+100];
    }
}

#pragma mark - InviteFriendsViewDelegate
-(void)shouldPushControllerWithUid:(NSString *)uid{
    
    PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
    classVC.yhid = uid;
    [self.navigationController pushViewController:classVC animated:YES];
}

-(void)shouldPushInstructionsView{
    [self gotoInstructionsView];
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
