//
//  PersonalcenterController.m
//  yyxb
//
//  Created by lili on 15/11/24.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "PersonalcenterController.h"
#import "DoingViewCell.h"

#import "SharedetailController.h"
#import "TreasureNoController.h"
#import "OrdershareViewCell.h"
#import "GoodsDetailsViewController.h"
#import "WinningViewCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
#import "PersonalModel.h"
#import "UsercenterModel.h"

#import "OrdershareModel.h"

#import "CommentController.h"
#import "GoodsDetailsViewController.h"

#import "NodataViewCell.h"
#import "DidViewCell.h"
#import "FindDetailController.h"
#import "NewGoodsModel.h"
@interface PersonalcenterController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,OrdershareViewCellDelegate>

{
    NSArray*titlearray;
    UIView*_headview;

}
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, assign)int style;//1为寻宝纪录，2，中奖纪录。3我的晒单
@property (nonatomic, assign)int addcount;//未完成计数
@property (nonatomic, strong) NoDataView *nodataView;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源

@property (nonatomic, strong) NSMutableArray *zhongjiangArray; //中奖
@property (nonatomic, strong) NSMutableArray *shaidanArray; //晒单

@property (nonatomic, assign) int BUttonstate; //button状态


@property (nonatomic, strong) NSMutableArray *willArray; //未揭晓
@property (nonatomic, strong) NSMutableArray *didArray; //已揭晓

@property (nonatomic, strong) UsercenterModel*model; //个人资料

@end

@implementation PersonalcenterController
{
    UIView * view_bar;
    UIImageView* _image;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"个人中心";
    titlearray=@[@"夺宝记录",@"中奖记录",@"晒单分享"];
    _BUttonstate=1;
    _style=1;
    [self userhead];
    [self initData];
    self.buttonArray = [NSMutableArray array];
    //    修改的－－－－－个人中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gerentongzhi:) name:@"gerentz" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
//创建透明的顶部导航栏
-(UIView*)NavigationBa
{
    view_bar =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        
        
    }else{
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44);
        
        //        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        //        imageV.image=[UIImage imageNamed:@"top"];
        //[view_bar addSubview:imageV];
    }
    view_bar.backgroundColor=[UIColor clearColor];

    [self.view addSubview: view_bar];
    //    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar.frame.size.height-44, self.view.frame.size.width-130, 44)];
    //    title_label.text=@"渐变色";
    //    title_label.font=[UIFont boldSystemFontOfSize:17];
    //    title_label.backgroundColor=[UIColor clearColor];
    //    title_label.textColor =[UIColor whiteColor];
    //    title_label.textAlignment=1;
    //    [view_bar addSubview:title_label];
    UIButton* cartBtn=[[UIButton alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(view_bar.frame.size.width-40, view_bar.frame.size.width-40, view_bar.frame.size.width-50, view_bar.frame.size.width-50), IPhone4_5_6_6P(view_bar.frame.size.height-28, view_bar.frame.size.height-28, view_bar.frame.size.height-38, view_bar.frame.size.height-38), IPhone4_5_6_6P(20, 20, 30, 30), IPhone4_5_6_6P(20, 20, 30, 30))];
    [cartBtn setBackgroundImage:[UIImage imageNamed:@"ic_cart_black"] forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(pushShopping) forControlEvents:UIControlEventTouchUpInside];
    //    [cartBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view_bar addSubview:cartBtn];
    
    UIButton* homeBtn=[[UIButton alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(view_bar.frame.size.width-72, view_bar.frame.size.width-72, view_bar.frame.size.width-82, view_bar.frame.size.width-82), IPhone4_5_6_6P(view_bar.frame.size.height-28, view_bar.frame.size.height-28, view_bar.frame.size.height-38, view_bar.frame.size.height-38), IPhone4_5_6_6P(20, 20, 30, 30), IPhone4_5_6_6P(20, 20, 30, 30))];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_black"] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(pushHome) forControlEvents:UIControlEventTouchUpInside];
    //    [cartBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view_bar addSubview:homeBtn];
    UIButton* shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(view_bar.frame.size.width-104, view_bar.frame.size.width-104, view_bar.frame.size.width-114, view_bar.frame.size.width-114), IPhone4_5_6_6P(view_bar.frame.size.height-28, view_bar.frame.size.height-28, view_bar.frame.size.height-38, view_bar.frame.size.height-38), IPhone4_5_6_6P(20, 20, 30, 30), IPhone4_5_6_6P(20, 20, 30, 30))];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_gooddetail_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [cartBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view_bar addSubview:shareBtn];
    
//    redimg=[[UIImageView alloc]initWithFrame:CGRectMake(view_bar.frame.size.width-36, view_bar.frame.size.height-42, 20, 20)];
//    redimg.image=[UIImage imageNamed:@"dot"];
//    redimg.hidden = YES;
//    [view_bar addSubview:redimg];
//    
//    if([UserDataSingleton userInformation].shoppingArray.count == 0)
//    {
//        redimg.hidden = YES;
//    }
//    
//    else
//    {
//        redimg.hidden = NO;
//    }
    //
//    //    购物车数量
//    self.cartcount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    self.cartcount.font = [UIFont systemFontOfSize:10];
//    self.cartcount.layer.cornerRadius = 10;
//    self.cartcount.layer.masksToBounds = YES;
//    self.cartcount.textAlignment = UITextAlignmentCenter;
//    self.cartcount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
//    self.cartcount.textColor=[UIColor whiteColor];
//    [redimg addSubview:self.cartcount];
    
    UIButton * backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, view_bar.frame.size.height-34, 35, 35)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    backBtn.backgroundColor=[UIColor greenColor];

    [view_bar addSubview:backBtn];
    
    return view_bar;
}

-(void)gerentongzhi:(NSNotification *)model{
    
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    [self.navigationController pushViewController:goods animated:YES];
}
//个人中心头像ID
-(void)userhead{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_yhid forKey:@"yhid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Userindex postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"----%@---%@",responseDic,responseDic[@"msg"]);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            _tableView.footerView.state = kPRStatePulling;
            NSDictionary *dic = responseDic[@"data"];
            _model = [[UsercenterModel alloc]init];
            DebugLog(@"----%@",dic);
            _model.img=dic[@"img"];
            _model.mobile=dic[@"mobile"];
            _model.uid=dic[@"uid"];
            _model.user_ip=dic[@"user_ip"];
            _model.username=dic[@"username"];
            _model.money=dic[@"money"];
            [self refreshData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark - 创建数据
- (void)initData
{
    self.num=1;
    self.dataArray = [NSMutableArray array];
    _willArray=[NSMutableArray array];
    _didArray=[NSMutableArray array];
    _zhongjiangArray=[NSMutableArray array];
    _shaidanArray=[NSMutableArray array];
}
#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
   self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegeta
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IPhone4_5_6_6P(180, 180, 210, 210))];
    _image.image=[UIImage imageNamed:@"bg_user_center"];
    [_headview addSubview:_image];
    UIButton * backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
    backBtn.backgroundColor=[UIColor clearColor];
    [_headview addSubview:backBtn];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back-1.png"]];
    arrow.frame = CGRectMake(19,(44 - 20) / 2.0, 13, 20);
    arrow.backgroundColor = [UIColor clearColor];
    [backBtn addSubview:arrow];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((MSW - 100)/2, 35, 100, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"个人中心";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [_headview addSubview:titleLabel];
    
    UIImageView* _imagehead=[[UIImageView alloc]initWithFrame:CGRectMake(20, IPhone4_5_6_6P(85, 85, 105, 105), 60,60)];
    [_imagehead sd_setImageWithURL:[NSURL URLWithString:_model.img ] placeholderImage:[UIImage imageNamed:DefaultImage]];
    _imagehead.layer.masksToBounds = YES;
    _imagehead.layer.cornerRadius =30;
    
    [_image addSubview:_imagehead];
    [_headview addSubview:_imagehead];
    
    UILabel*lbname=[[UILabel alloc]initWithFrame:CGRectMake(90, IPhone4_5_6_6P(85, 85, 105, 105), 190, 20)];
    lbname.textAlignment=UITextAlignmentLeft;
    lbname.textColor = [UIColor whiteColor];
    lbname.text=_model.username;
    lbname.font = [UIFont systemFontOfSize:16];
    [_headview addSubview:lbname];
    
    UILabel*lbaddress=[[UILabel alloc]initWithFrame:CGRectMake(90, IPhone4_5_6_6P(115, 115, 135, 135), MSW - 45-70, 15)];
    lbaddress.textAlignment=NSTextAlignmentLeft;
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]],
                             @"u": @[[UIColor redColor],
                                     
                                     ]};
    
    NSDictionary* style2 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1]],
                             @"u": @[FontBlue,
                                     
                                     ]};
    lbaddress.attributedText =  [[NSString stringWithFormat:@"归属地：<u>%@</u>",_model.user_ip]attributedStringWithStyleBook:style1];
    lbaddress.font = [UIFont systemFontOfSize:MiddleFont];
//    lbaddress.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1];
    [_headview addSubview:lbaddress];
    
    UILabel*lbid=[[UILabel alloc]initWithFrame:CGRectMake(90, IPhone4_5_6_6P(125, 125, 150, 150), 150, 20)];
    lbid.textAlignment=NSTextAlignmentLeft;
//    lbid.text=[NSString stringWithFormat:@"唯一ID：%@",_model.uid];
    lbid.attributedText = [[NSString stringWithFormat:@"唯一ID：<u>%@</u>",_model.uid] attributedStringWithStyleBook:style2];
    lbid.font = [UIFont systemFontOfSize:MiddleFont];
//    lbid.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1];
    [_headview addSubview:lbid];
    //－－－－－－横杠
    UIView*_lineview=[[UIView alloc]initWithFrame:CGRectMake(0, IPhone4_5_6_6P(220, 220, 250, 250), MSW, 0.5)];
    _lineview.backgroundColor=[UIColor groupTableViewBackgroundColor];

    [_headview addSubview:_lineview];
    
    //按钮的view
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, IPhone4_5_6_6P(180, 180, 210, 210), self.view.frame.size.width, 40)];
    _buttonView.backgroundColor=[UIColor whiteColor];
    [_headview addSubview:self.buttonView];
    UILabel*lbred=[[UILabel alloc]init];
    if (_BUttonstate==1) {
        lbred.frame=CGRectMake(0,37, MSW/3, 3);
    }else if (_BUttonstate==2){
        lbred.frame=CGRectMake(MSW/3, 37, MSW/3, 3);
    }else{
        lbred.frame=CGRectMake(MSW/3*2, 37, MSW/3, 3);
    }
    lbred.backgroundColor=MainColor;
    [self.buttonView addSubview:lbred];

    for (NSInteger i = 0; i < titlearray.count; i ++)
    {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.button.frame = CGRectMake(self.buttonView.frame.size.width / 3 * i, 0, self.buttonView.frame.size.width /3,40);
        self.button.tag = 101+i;
        [self.button setTitle:titlearray[i] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
        [self.button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        if (_BUttonstate==1) {
            if (self.button.tag == 101)
            {
                [self.button setTitleColor:MainColor forState:UIControlStateNormal];
            }else{
                
                [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            };
        }
        if (_BUttonstate==2) {
            if (self.button.tag == 102)
            {
                [self.button setTitleColor:MainColor forState:UIControlStateNormal];
            }else{
                
                [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            };
        }
        
        if (_BUttonstate==3) {
            if (self.button.tag == 103)
            {
                [self.button setTitleColor:MainColor forState:UIControlStateNormal];
            }else{
                
                [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            };
        }
        [self.buttonView addSubview:self.button];
        [self.buttonArray addObject:self.button];
        
    }
    return _headview;
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击查看购买记录 中奖记录 我的晒单
- (void)button:(UIButton *)button
{
    
    switch (button.tag)
    {
        case 101:
        {
            
            [self colorReset:0];
            _style=1;
            
            _BUttonstate=1;
        }
            break;
            
        case 102:
        {
            [self colorReset:1];
            _style=2;
            
            _BUttonstate=2;
        }
            DebugLog(@"2");
            
            break;
        case 103:
        {
            [self colorReset:2];
            
            _style=3;
            _BUttonstate=3;
        }
            break;
    }
    
    [self refreshData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_style==1) {
        if (_dataArray.count==0) {
            return 1;
        }else{
            return self.dataArray.count;
        }
    }else if (_style==2){
        if (_zhongjiangArray.count==0) {
            return 1;
        }else{
            return self.zhongjiangArray.count;}
    }else{
        if (_shaidanArray.count==0) {
            return 1;
        }else{
            
            return self.shaidanArray.count;
        }
    }
    }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return IPhone4_5_6_6P(220, 220, 250, 250);
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_style==3) {
        
        if (_shaidanArray.count!=0) {
            PersonalModel*model=[_shaidanArray objectAtIndex:indexPath.row];
            
            SharedetailController *detailsVC = [[SharedetailController alloc]init];
            detailsVC.sid=model.sd_id;
            detailsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailsVC animated:YES];
        }else{
        }
    }else if(_style==2){
        
        
        if (_zhongjiangArray.count!=0) {
            PersonalModel*model=[self.zhongjiangArray objectAtIndex:indexPath.row];
            GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
            detailsVC.idd=model.shopid;
            detailsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailsVC animated:YES];
        }else{
        }
          }else{
              if (_dataArray.count==0) {
              }else{
        PersonalModel*model=[self.dataArray objectAtIndex:indexPath.row];
        
        GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
                  //        判断状态－－－－－未揭晓
                  if (indexPath.row<_willArray.count)
                  {
                  
  detailsVC.tiaozhuantype = 1;
                  }
                  
     detailsVC.idd=model.shopid;
        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     ]};
    
    //    寻宝纪录cell
    if (_style==1)
    {
        if (_dataArray.count==0) {
            static NSString *cellName = @"NodataViewCell.h";
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
//            _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
            cell.scrolike.hidden=YES;
            cell.lbline2.hidden=YES;
            cell.lblike.hidden=YES;

            cell.type=2;
            cell.titleLabel1.text=@"该用户还没有夺宝记录哦!";
            return cell;
        }
        else{
            PersonalModel*model=[self.dataArray objectAtIndex:indexPath.row];

            //        判断状态－－－－－未揭晓
            if ([model.type isEqualToString:@"0"])
            {    static   NSString *ListingCellName = @"DidViewCell";
                
                DidViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
                if (!cell)
                {
                    cell = [[DidViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                }
                cell.lbtitle.text=model.shopname;
                [cell.imgegood sd_setImageWithURL:[NSURL URLWithString:model.thumb ] placeholderImage:[UIImage imageNamed:DefaultImage]];
                cell.lbplay.attributedText=[ [NSString stringWithFormat:@"本期参与：<u>%@</u>人次",model.gonumber] attributedStringWithStyleBook:style1];
                cell.lbcount.text=[NSString stringWithFormat:@"总需%@",model.zongrenshu];
                int a;
                a=[model.zongrenshu intValue]-[model.canyurenshu intValue];
                cell.btadd.titleLabel.font=[UIFont systemFontOfSize:12];
                
                if (a==0) {
                    [cell.btadd setTitle:@"揭晓中" forState:UIControlStateNormal];
                    cell.btadd.userInteractionEnabled=NO;
                }else{
                    [cell.btadd setTitle:@"跟买" forState:UIControlStateNormal];
                    
                }
               cell.lbshengyu.attributedText=[[NSString stringWithFormat:@"剩余<u>%i</u>",a]attributedStringWithStyleBook:style1];
                                float b;
                b=[model.canyurenshu floatValue]/[model.zongrenshu floatValue];
                cell.progressView.progress=b;
                cell.btadd.tag=indexPath.row;
                
                cell.btname.tag=indexPath.row;
                cell.btlook.tag=indexPath.row;
                
                [cell.btadd addTarget:self action:@selector(addgoods:) forControlEvents:UIControlEventTouchUpInside];
                cell.blackview.hidden=YES;
                [cell.btlook setTitleColor:FontBlue forState:UIControlStateNormal];
                [cell.btlook setTitle:@"查看夺宝号>" forState:UIControlStateNormal];
                [cell.btlook addTarget:self action:@selector(looktreasureno:) forControlEvents:UIControlEventTouchUpInside];
                if ([model.yunjiage isEqualToString:@"1"]) {
                    if ([model.xiangou isEqualToString:@"1"])
                    {
                        cell.shiyuan.hidden=NO;
                        cell.shiyuan.image = [UIImage imageNamed:@"xiangou"];
                    }
                    else if ([model.xiangou isEqualToString:@"2"])
                    {
                        cell.shiyuan.hidden=NO;
                        cell.shiyuan.image = [UIImage imageNamed:@"xiangou"];
                    }

                    else
                    {
                        cell.shiyuan.hidden=YES;
                    }
                    
                }else{
                    
                    cell.shiyuan.hidden=NO;
                    cell.shiyuan.image = [UIImage imageNamed:@"3-1"];
                }
                return cell;
            }
            else
            {
                //            已揭晓
                static   NSString *ListingCellName = @"DoingViewCell";
                
                DoingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
                if (!cell)
                {
                    cell = [[DoingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                }
                
                cell.blackview.hidden=NO;
                cell.progressView.hidden=YES;
                cell.lbline.hidden=YES;
                cell.btadd.hidden=YES;
                cell.lbshengyu.hidden=YES;
                cell.lbcount.frame=CGRectMake(90, 50, 150, 20);
                cell.lbplay.frame=CGRectMake(90,70 , 150, 30);
                cell.btlook.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-130, 60, 120, 30);
                cell.blackview.frame=CGRectMake(15, 100, MSW - 30, 75);
                cell.headImg.frame = CGRectMake(cell.blackview.frame.size.width - 50, 20, 40, 40);
                cell.lbtitle.numberOfLines=2;
                cell.lbtitle.frame=CGRectMake(90, 5,MSW-110, 30);
                PersonalModel*model=[self.dataArray objectAtIndex:indexPath.row];
                [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.img ] placeholderImage:[UIImage imageNamed:@"head"]];
                cell.lbtitle.text=model.shopname;
                [cell.imgegood sd_setImageWithURL:[NSURL URLWithString:model.thumb ] placeholderImage:[UIImage imageNamed:DefaultImage]];
                cell.lbplay.frame = CGRectMake(90, 60, MSW - 100, 15);
                cell.lbcount.frame = CGRectMake(90, 40, MSW - 100, 15);
                cell.lbplay.attributedText=[ [NSString stringWithFormat:@"本期参与：<u>%@</u>人次",model.gonumber] attributedStringWithStyleBook:style1];
                cell.lbcount.text=[NSString stringWithFormat:@"总需：%@",model.zongrenshu];
                int a;
                a=[model.zongrenshu intValue]-[model.canyurenshu intValue];
                cell.lbshengyu.text=[NSString stringWithFormat:@"剩余：%i",a];
                float b;
                b=[model.canyurenshu floatValue]/[model.zongrenshu floatValue];
                cell.progressView.progress=b;
                NSString *str=model.jiexiao_time;//时间戳
                NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                cell.lbtime.text=[NSString stringWithFormat:@"揭晓时间：%@",[dateFormatter stringFromDate: detaildate]];
                cell.lbluckno.attributedText=  [[NSString stringWithFormat:@"中奖号码：<u>%@</u>",model.q_user_code] attributedStringWithStyleBook:style1];
                cell.lbplaycount.attributedText=  [[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",model.number]  attributedStringWithStyleBook:style1];
                [cell.btname setTitle:model.username forState:UIControlStateNormal];
                [cell.btadd setTitle:@"跟买" forState:UIControlStateNormal];
                cell.btadd.tag=indexPath.row;
                cell.btname.tag=indexPath.row;
                cell.btlook.tag=indexPath.row;
                [cell.btname addTarget:self action:@selector(gerenzhongxin:) forControlEvents:UIControlEventTouchUpInside];
                cell.btlook.frame = CGRectMake(MSW - 120, 60, 130, 15);
                [cell.btlook setTitle:@"查看夺宝号>" forState:UIControlStateNormal];
                [cell.btlook addTarget:self action:@selector(looktreasureno:) forControlEvents:UIControlEventTouchUpInside];
                if ([model.yunjiage isEqualToString:@"1"]) {
                    if ([model.xiangou isEqualToString:@"1"])
                    {
                        cell.shiyuan.hidden=NO;
                        cell.shiyuan.image = [UIImage imageNamed:@"xiangou"];
                    }
                    else if ([model.xiangou isEqualToString:@"2"])
                    {
                        cell.shiyuan.hidden=NO;
                        cell.shiyuan.image = [UIImage imageNamed:@"xiangou"];
                    }

                    else
                    {
                        cell.shiyuan.hidden=YES;
                    }
                    
                }else{
                    
                    cell.shiyuan.hidden=NO;
                    cell.shiyuan.image = [UIImage imageNamed:@"3-1"];
                }
                

                return cell;
                
            }
            
            
        }
    }
    //    中奖纪录
    else if (_style==2){
        
        if (_zhongjiangArray.count==0) {
            static NSString *cellName = @"NodataViewCell.h";
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

            cell.titleLabel1.text=@"该用户还没有中奖记录哦!";
            cell.scrolike.hidden=YES;
            cell.lbline2.hidden=YES;
            cell.lblike.hidden=YES;

            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
             cell.type=2;
            
            return cell;
        }else{
            DebugLog(@"%li",(unsigned long)_dataArray.count);
            
            static NSString *cellName = @"WinningViewCell.h";
            WinningViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell)
            {
                cell = [[WinningViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
       
            PersonalModel*model=[self.zhongjiangArray objectAtIndex:indexPath.row];
            [cell.imgegood sd_setImageWithURL:[NSURL URLWithString:model.uphoto ] placeholderImage:[UIImage imageNamed:DefaultImage]];
            cell.lbtitle.text=model.shopname;
            cell.lbcount.text=[NSString stringWithFormat:@"总       需：%@",model.zongrenshu];
            cell.lbplay.text=[NSString stringWithFormat:@"本期参与：%@人次",model.gonumber];
            cell.checkBtn.tag = indexPath.row;
            [cell.checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *str=model.time;//时间戳
            NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            cell.lbtime.text=[NSString stringWithFormat:@"揭晓时间：%@",[dateFormatter stringFromDate: detaildate]];
            cell.lbluckno.attributedText=  [[NSString stringWithFormat:@"中奖号码：<u>%@</u>",model.huode] attributedStringWithStyleBook:style1];
            cell.lbplay.attributedText=  [[NSString stringWithFormat:@"本期参与：<u>%@</u>",model.gonumber] attributedStringWithStyleBook:style1];
            //    改变图片尺寸   等比例缩放
          cell.imgegood.contentMode = UIViewContentModeScaleAspectFit;
            
            if ([model.yunjiage isEqualToString:@"1"]) {
                if ([model.xiangou isEqualToString:@"1"])
                {
                    cell.shiyuan.hidden=NO;
                    cell.shiyuan.image = [UIImage imageNamed:@"xiangou"];
                }
                else if ([model.xiangou isEqualToString:@"2"])
                {
                    cell.shiyuan.hidden=NO;
                    cell.shiyuan.image = [UIImage imageNamed:@"xiangou"];
                }

                else
                {
                    cell.shiyuan.hidden=YES;
                }
                
            }else{
                
                cell.shiyuan.hidden=NO;
                cell.shiyuan.image = [UIImage imageNamed:@"3-1"];
            }
            
            
            return cell;
            
        }
    }
    
    //    晒单分享cell
    else{
        
        DebugLog(@"%li",_dataArray.count);
        
        if (_shaidanArray.count==0) {
            static NSString *cellName = @"NodataViewCell.h";
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }cell.selectionStyle = UITableViewCellSelectionStyleNone;
             cell.type=2;
            
            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
            
            cell.scrolike.hidden=YES;
            cell.lbline2.hidden=YES;
            cell.lblike.hidden=YES;
            cell.titleLabel1.text=@"该用户还没有晒单哦！";
            return cell;
        }else{
            
            static NSString *cellName = @"OrdershareViewCell.h";
            OrdershareViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell)
            {
                cell = [[OrdershareViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            }
            
            OrdershareModel*model=[self.shaidanArray objectAtIndex:indexPath.row];
            
            
            [cell.username setTitle:model.username forState:UIControlStateNormal];
            [cell.userhead sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:DefaultImage]];
            NSString *str=model.sd_time ;//时间戳
            NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            cell.sharedate.text=[dateFormatter stringFromDate: detaildate];
            cell.sharetitle.text=model.sd_title;
            cell.sharegoods.text=[NSString stringWithFormat:@"(第%@期)",model.qishu];
            cell.shareinfo.text=model.sd_content;
            if (model.sd_photolist.count==1) {
                [cell.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
                cell.goodsimg2.hidden=YES;
                cell.goodsimg3.hidden=YES;
            }else if (model.sd_photolist.count==2){
                [cell.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
                [cell.goodsimg2 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:1]] placeholderImage:[UIImage imageNamed:DefaultImage]];
                cell.goodsimg2.hidden=YES;
                
            }else{
                [cell.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
                [cell.goodsimg2 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:1]] placeholderImage:[UIImage imageNamed:DefaultImage]];
                [cell.goodsimg3 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:2]] placeholderImage:[UIImage imageNamed:DefaultImage]];
            }
            cell.lbzan.font = [UIFont systemFontOfSize:SmallFont];
            cell.lbzan.text=[NSString stringWithFormat:@"攒人品(%@)",model.zan_number];
            cell.lbcomment.font = [UIFont systemFontOfSize:SmallFont];
            cell.lbcomment.text=[NSString stringWithFormat:@"评论(%@)",model.pinglun_number];
            if ([model.sd_type isEqualToString:@"0"]) {
                //没有点赞
                cell.imgzan.image=[UIImage imageNamed:@"good"];
            }else{
                //    点赞
                cell.imgzan.image=[UIImage imageNamed:@"good_selected1"];
            }
            cell.OrderModel.sd_type=model.sd_type;
            cell.OrderModel=model;
            cell.delegate=self;
            cell.btzan.tag=indexPath.row;
            cell.btcomment.tag=indexPath.row;
            [cell.btcomment addTarget:self action:@selector(pinglun:) forControlEvents:UIControlEventTouchUpInside];
            cell.tryBtn.tag=indexPath.row;
            [cell.tryBtn addTarget:self action:@selector(tryshouqi:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }
    
}

#pragma mark - 评论－－－


-(void)pinglun:(UIButton *)sender{
    if([UserDataSingleton userInformation].isLogin == YES)
    {
        int index=(int)[sender tag];
        PersonalModel*model=[self.shaidanArray objectAtIndex:index];
        CommentController *classVC = [[CommentController alloc]init];
        classVC.sid=model.sd_id;
        [self.navigationController pushViewController:classVC animated:YES];
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - 点赞动画
- (void)clickCell:(OrdershareViewCell *)cell
{
    if ([UserDataSingleton userInformation].isLogin == YES) {
        if ([cell.OrderModel.sd_type isEqualToString:@"0"]) {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
            [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
            [dict1 setValue:[NSString stringWithFormat:@"%@",cell.OrderModel.sd_id] forKey:@"sd_id"];
            [MDYAFHelp AFPostHost:APPHost bindPath:ShareZan postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                DebugLog(@"---%@---%@",responseDic,responseDic[@"msg"]);
                if ([responseDic[@"code"] isEqualToString:@"200"])
                {
                    cell.lbzan.text=[NSString stringWithFormat:@"攒人品(%i)",[cell.OrderModel.zan_number intValue]+1];
                    
                    cell.imgzan.image=[UIImage imageNamed:@"good_selected1"];
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((cell.btzan.frame.size.width/2) - 15 + (cell.btzan.frame.origin.x), cell.frame.size.height - cell.imgzan.frame.size.height, 20, 10)];
                    label.text = @"+1";
                    label.textColor=MainColor;
                    label.font=[UIFont systemFontOfSize:MiddleFont];
                    [cell addSubview:label];
                    [UIView animateWithDuration:1 animations:^{
                        label.frame = CGRectMake((cell.btzan.frame.size.width/2) - 15 + (cell.btzan.frame.origin.x), cell.frame.size.height - 50, 20, 10);
                    } completion:^(BOOL finished) {
                        [label reloadInputViews];
                        [label removeFromSuperview];
                    }];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                }

                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"失败:%@",error);
                [self loadingFailure:error];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"不要重复点赞哦！"];
        }
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void)addgoods:(UIButton *)sender{
    int index=(int)[sender tag];
    PersonalModel*permodel=[self.dataArray objectAtIndex:index];
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        if ([permodel.zongrenshu integerValue] == [permodel.canyurenshu integerValue] )
        {
            [SVProgressHUD showErrorWithStatus:@"该商品已没有剩余数量！"];
            return;
        }
        else
        {
            if ([permodel.xiangou isEqualToString:@"0"])
            {
                //普通
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = permodel.shopid;
                model.num = [permodel.yunjiage integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
            else if ([permodel.xiangou isEqualToString:@"1"])
            {
                //垄断  限购次数
                
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = permodel.shopid;
                model.num = [permodel.zongrenshu integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
                
            }
            else
            {
                
                ShoppingModel *model = [[ShoppingModel alloc]init];
                model.goodsId = permodel.shopid;
                model.num = [permodel.xg_number integerValue];
                [[UserDataSingleton userInformation].shoppingArray addObject:model];
            }
        }
    }
    else
    {
        __block  BOOL isHaveId = NO;
        __block BOOL isAdd = NO;
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            if (obj.num == ([permodel.zongrenshu integerValue] - [permodel.canyurenshu integerValue]))
            {
                [SVProgressHUD showErrorWithStatus:@"参与人数不能大于剩余人数"];
                isAdd = YES;
                *stop = YES;
            }
            else
            {
                if ([obj.goodsId isEqualToString:permodel.shopid])
                {
                    if ([permodel.xiangou isEqualToString:@"1"])
                    {
                        [SVProgressHUD showErrorWithStatus:@"参与人数不能大于剩余人数"];
                        isAdd = YES;
                        *stop = YES;
                        
                    }
                    else
                    {
                        obj.num = obj.num + [permodel.yunjiage integerValue];
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
                
                if ([permodel.xiangou isEqualToString:@"0"])
                {
                    //普通
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = permodel.shopid;
                    model.num = [permodel.yunjiage integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                }
                else if ([permodel.xiangou isEqualToString:@"1"])
                {
                    //垄断  限购次数
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = permodel.shopid;
                    model.num = [permodel.zongrenshu integerValue];
                    [[UserDataSingleton userInformation].shoppingArray addObject:model];
                    
                }
                else
                {
                    
                    ShoppingModel *model = [[ShoppingModel alloc]init];
                    model.goodsId = permodel.shopid;
                    model.num = [permodel.xg_number integerValue];
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
}
//查看他的号码
-(void)looktreasureno:(UIButton *)sender
{
    int index=(int)[sender tag];
    PersonalModel*model=[self.dataArray objectAtIndex:index];
    FindDetailController *detailsVC = [[FindDetailController alloc]init];
    detailsVC.yhid=_yhid;
    detailsVC.sid=model.shopid;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
//查看他的号码
-(void)checkBtnClick:(UIButton *)sender
{
    int index=(int)[sender tag];
    PersonalModel*model=[self.zhongjiangArray objectAtIndex:index];
    FindDetailController *detailsVC = [[FindDetailController alloc]init];
    detailsVC.yhid=_yhid;
    detailsVC.sid=model.shopid;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

-(void)gerenzhongxin:(UIButton *)sender{
    int index=(int)[sender tag];
    
    PersonalModel*model=[self.dataArray objectAtIndex:index];
    PersonalcenterController *detailsVC = [[PersonalcenterController alloc]init];
    //死数据带修改
    detailsVC.yhid=model.q_uid;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_style==1) {
        if (_dataArray.count>0) {
            
            PersonalModel*model = [self.dataArray objectAtIndex:indexPath.row];
            
            if ([model.type isEqualToString:@"0"]) {
                return 130;
            }else{
                return 190;
            }
            
        }else{
            
            return 300;
            
        }

    }else if (_style==2){
        if (_zhongjiangArray.count>0) {
            return 140;
        }else{
            return 300;
        }
        
    }
    else{
        if (_shaidanArray.count>0) {
            return 260;
        }else{
            return 300;
        }
    }
}
#pragma mark - 下拉刷新
- (void)refreshData
{
    _addcount=0;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_yhid forKey:@"yhid"];
    if (_style==1) {
        [dict1 setValue:@"1" forKey:@"type"];
    }if (_style==2) {
        [dict1 setValue:@"2" forKey:@"type"];
    }if (_style==3) {
        [dict1 setValue:@"3" forKey:@"type"];
    }
     [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"now_yhid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:UserBuyList postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
        
    }];

}

- (void)refreshSuccessful:(id)data
{
    [self.dataArray removeAllObjects];
    [self.willArray removeAllObjects];
    [self.didArray removeAllObjects];
    [self.zhongjiangArray removeAllObjects];
    [self.shaidanArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            self.tableView.footerView.state = kPRStatePulling;
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PersonalModel  *model = [[PersonalModel alloc]initWithDictionary:obj];
                OrdershareModel*model1=[[OrdershareModel alloc]initWithDictionary:obj];
                if (_style==1) {//寻宝纪录
                    if ([model.type isEqualToString:@"0"]) {
                        
                        [_willArray addObject:model];
                        
                        _addcount++;
                        [self.dataArray addObject:model];
                    }else{
                        
                        [_didArray addObject:model];
                        
                    }
                }else if(_style==2){
                    [_zhongjiangArray addObject:model];
                }else{
                    
                [_shaidanArray addObject:model1];
                }
                
            }];
        }else{
        }
    }
    if (_style==1) {
        for (int i=0; i<_didArray.count; i++) {
            PersonalModel*model=[_didArray objectAtIndex:i];
            [_dataArray addObject:model];
        }
        
    }else{
        
    }
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    
    if (!_tableView) {
      
        [self createTableView];
    }
}

- (void)refreshFailure:(NSError *)error
{
    
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    DebugLog(@"失败");
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多[self refreshData];
- (void)loadingData
{
    
    self.num = self.num +1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    [dict1 setValue:_yhid forKey:@"yhid"];
    if (_style==1) {
        
        
        [dict1 setValue:@"1" forKey:@"type"];
    }if (_style==2) {
        
        
        [dict1 setValue:@"2" forKey:@"type"];
        
    }if (_style==3) {
        
        
        [dict1 setValue:@"3" forKey:@"type"];
        
    }
    [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];

    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"now_yhid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:UserBuyList postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [self loadingSuccessful:responseDic];
        DebugLog(@"成功=------%@----%@",responseDic,responseDic[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self loadingFailure:error];
    }];
    
}

- (void)loadingSuccessful:(id)data
{
    
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"400"])
        {
            DebugLog(@"%@",data[@"msg"]);
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                self.tableView.footerView.state = kPRStateHitTheEnd;
            }];
        }
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                PersonalModel  *model = [[PersonalModel alloc]initWithDictionary:obj];
                OrdershareModel*model1=[[OrdershareModel alloc]initWithDictionary:obj];
                if (_style==1)
                {//寻宝纪录
                    if ([model.type isEqualToString:@"0"])
                    {
                        
                        [_willArray addObject:model];
                        
                        _addcount++;
                        [self.dataArray addObject:model];
                 }  else
                    {  [_didArray addObject:model];
                        
                    }
                }
                else if(_style==2){
                    
                    [_zhongjiangArray addObject:model];
                }
                else
                {
                 [_shaidanArray addObject:model1];
                 
                }
                
            }];
            if (_style==1) {
                for (int i=0; i<_didArray.count; i++) {
                    PersonalModel*model=[_didArray objectAtIndex:i];
                    [_dataArray addObject:model];
                }
            }else{
            }

        }
        else
        {
            
       }
         }
    
 
    if([[NSString stringWithFormat:@"%lu",self.dataArray.count] isEqualToString:data[@"count"]])
    {
        [UIView animateWithDuration:2 animations:^{
            
        } completion:^(BOOL finished) {
            self.tableView.footerView.state = kPRStateHitTheEnd;
        }];
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
        
//           DebugLog(@"==----%f----   ",_tableView.contentOffset.y);
        CGFloat yOffset = _tableView.contentOffset.y;
        
        if (yOffset <0 ) {
            CGRect frame1 = _headview.frame;
            frame1.origin.y = yOffset;
            frame1.size.height =  -yOffset;
            //            DebugLog(@"==----%f----    %f",tbView.contentOffset.y,-frame1.size.height);
            float y;
            y=(float)yOffset;
            _image.frame = CGRectMake(frame1.origin.y,-frame1.size.height, MSW-frame1.origin.y*2, IPhone4_5_6_6P(180, 180, 210, 210)+frame1.size.height);
        }
        else {
            [self.tableView tableViewDidScroll:self.tableView];

            _headview.frame = CGRectMake(0, 0, MSW, IPhone4_5_6_6P(220, 220, 250, 250));
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
    
//    //延迟 0.5秒刷新
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self refreshData];
//        
//    });
    
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadingData];
        
    });
    
    
}
//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"列表为空哦！";
        
        _nodataView.frame=CGRectMake(0,100 , MSW, MSH-100);
        _nodataView.scrolike.hidden=YES;
        
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.nodataView];
}

-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)tryshouqi:(UIButton *)sender{
    int index=(int)[sender tag];
    OrdershareModel*model=[self.shaidanArray objectAtIndex:index];
    GoodsDetailsViewController *classVC = [[GoodsDetailsViewController alloc]init];
    classVC.idd=model.shopid;
    classVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:classVC animated:YES];
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
