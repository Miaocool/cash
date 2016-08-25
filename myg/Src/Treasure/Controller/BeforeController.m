//
//  BeforeController.m
//  yyxb
//
//  Created by lili on 15/11/16.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "BeforeController.h"
#import "OrdershareViewCell.h"
#import "BeforeViewCell.h"
#import "BeforeModel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "UIImageView+WebCache.h"
#import "GoodsDetailsViewController.h" //商品详情
#import "DateHelper.h"
#import "PersonalcenterController.h"


@interface BeforeController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UITextFieldDelegate>

{
    UITextField*tysearch;
    UIView*_carview;
     int haveqishu;
    UIButton *butt;
      UIImageView*img;
    int iscunzai;//判断图标是否存在
}
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *willArray; //数据源
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源

@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic, strong) NoNetwork *nonetwork;
@end

@implementation BeforeController

- (void)viewDidLoad {
    [super viewDidLoad];
     iscunzai=1;
    self.title=@"往期揭晓";
    UIButton *callBtn = [[UIButton alloc]init];
    callBtn.frame = CGRectMake(0, 0, 23, 13);
    [callBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(morehAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:callBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
      [self initData];
        [self refreshData];
//    修改的－－－往期揭晓
}

#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    self.willArray=[NSMutableArray array];

}


//
#pragma mark - 下拉刷新
- (void)refreshData
{
    
    self.num = 1;
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
     [dict1 setValue:_sid forKey:@"sid"];
    DebugLog(@"---sid:%@",_sid);
    [MDYAFHelp AFPostHost:APPHost bindPath:Before postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {

        DebugLog(@"------%@",responseDic);
        
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self refreshFailure:error];
        
    }];
}

- (void)refreshSuccessful:(id)data
{
    [self.nonetwork removeFromSuperview];
    [self.willArray removeAllObjects];
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            
            self.tableView.footerView.state = kPRStatePulling;
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                BeforeModel  *model = [[BeforeModel alloc]initWithDictionary:obj];
                DebugLog(@"------%@",model.status);
                if ([model.status isEqualToString:@"0"]) {
                    [self.willArray addObject:model];
                }else{
                
                    [self.dataArray addObject:model];

                }

                DebugLog(@"-------%li-------%li",_willArray.count,_dataArray.count);
                [self createTableView];
            }];
        }
        if ([data[@"code"] isEqualToString:@"400"])
        {
            
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                self.tableView.footerView.state = kPRStateHitTheEnd;
            }];
            
        }
        
        
    }
    
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    [self createTableView];
    
}

- (void)refreshFailure:(NSError *)error
{
    [self nonetworking];
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)createView
{


    //    下方的view
    _carview=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60-64, [UIScreen mainScreen].bounds.size.width,60)];
    _carview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _carview.layer.masksToBounds = YES;
    _carview.userInteractionEnabled = YES;
    _carview.backgroundColor = [UIColor whiteColor];
    _carview.alpha=1;
    [self.view addSubview:_carview];
    UIView*_line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
    _line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_carview addSubview:_line];
    UILabel*lbseach=[[UILabel alloc]initWithFrame:CGRectMake(40, 20, 170, 20)];
    lbseach.text=@"快速查询第             期";

    [_carview addSubview:lbseach];
    tysearch=[[UITextField alloc]initWithFrame:CGRectMake(128, 18, 50, 24)];
    tysearch.textAlignment=UITextAlignmentCenter;
    tysearch.layer.borderWidth = 1.5;
    tysearch.delegate=self;
    tysearch.keyboardType=UIKeyboardTypeNumberPad;
//      tysearch.layer.cornerRadius = 5;
   tysearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_carview addSubview:tysearch];
    UIButton *btsearch=[[UIButton alloc]initWithFrame:CGRectMake(lbseach.frame.size.width+40, 16, 80, 28)];
    [btsearch setBackgroundColor:MainColor];
    btsearch.layer.borderWidth = 0.5;
    btsearch.layer.cornerRadius = 5;
    
    [btsearch setTitle:@"查看" forState:UIControlStateNormal];
    [btsearch addTarget:self action:@selector(lookqishu) forControlEvents:UIControlEventTouchUpInside];
    btsearch.layer.borderColor = [UIColor redColor].CGColor;
    [_carview addSubview:btsearch];
    }


-(void)lookqishu{
    
    [butt removeFromSuperview];
    [tysearch resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [_carview setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60-64, _carview.frame.size.width, _carview.frame.size.height)];
    [UIView commitAnimations];

    for (int i=0; i<_willArray.count; i++) {
        
        BeforeModel*model=[_willArray objectAtIndex:i];
        if ([model.qishu isEqualToString:tysearch.text]) {
         
            haveqishu=1;
        }
        
    }
    for (int j=0; j<_dataArray.count; j++) {
        
        BeforeModel*model=[_dataArray objectAtIndex:j];
        if ([model.qishu isEqualToString:tysearch.text]) {
            haveqishu=1;
        }
    }
    
    DebugLog(@"-zheqi --%i",haveqishu);
    if (haveqishu==1) {
    DebugLog(@"%@----id=%@",tysearch.text,_shopid);
        GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
        
        detailsVC.sid=_sid;
        detailsVC.idd = _shopid;
        detailsVC.qishu=tysearch.text;
        detailsVC.hidesBottomBarWhenPushed = YES;
        
        for (int i=0; i<_willArray.count; i++) {
            
            BeforeModel*model=[_willArray objectAtIndex:i];
            if ([model.qishu isEqualToString:tysearch.text]) {
                detailsVC.tiaozhuantype=1;
            }else{
                detailsVC.tiaozhuantype=2;
            }
            
        }
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else{
    
        DebugLog(@"没有这期");
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有这期商品信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    
haveqishu=2;

}
//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom{
    
    [butt removeFromSuperview];
    [tysearch resignFirstResponder];
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [_carview setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60-64, _carview.frame.size.width, _carview.frame.size.height)];
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    butt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-64-215)];
    ////    添加手势隐藏键盘
    
    
    butt.backgroundColor=[UIColor clearColor];
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [butt addGestureRecognizer:singleRecognizer];
    [self.view addSubview:butt];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [_carview setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60-64-215, _carview.frame.size.width, _carview.frame.size.height)];
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   if (textField == tysearch) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 5) {
            return NO;
        }
    }

    return YES;
}


-(void)morehAction{
    
    
    if (iscunzai==1) {
        
        
        img=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-130,0, 120, 82)];
        img.image=[UIImage imageNamed:@"chat01"];
        img.userInteractionEnabled = YES;
        [self.view addSubview:img];
        
        UIImageView*carimg=[[UIImageView alloc]initWithFrame:CGRectMake(10,13, 30, 30)];
        carimg.image=[UIImage imageNamed:@"cart-white"];
        [img addSubview:carimg];
        UIButton*btncar=[[UIButton alloc]initWithFrame:CGRectMake(6,10,110, 35)];
        btncar.backgroundColor=[UIColor clearColor];
        btncar.titleLabel.font=[UIFont systemFontOfSize:16];
        [btncar setTitle:@"清单" forState:UIControlStateNormal];
        [btncar addTarget:self action:@selector(qingdan) forControlEvents:UIControlEventTouchUpInside];
        
        [btncar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [img addSubview:btncar];
        
        UIImageView*redimg=[[UIImageView alloc]initWithFrame:CGRectMake(80,10, 20, 20)];
        //        redimg.image=[UIImage imageNamed:@"dot"];
        redimg.layer.cornerRadius = 10;
        redimg.layer.masksToBounds = YES;
        redimg.backgroundColor=MainColor;
        [img addSubview:redimg];
        
        UILabel*lbcount=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 20, 20)];
        lbcount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
        lbcount.textColor=[UIColor whiteColor];
        lbcount.textAlignment=NSTextAlignmentCenter;
        [redimg addSubview:lbcount];
        
        if ([lbcount.text isEqualToString:@"0"]) {
            redimg.hidden=YES;
            lbcount.hidden=YES;
        }
        UIImageView*homeimg=[[UIImageView alloc]initWithFrame:CGRectMake(10,47, 30, 30)];
        homeimg.image=[UIImage imageNamed:@"home-white"];
        [img addSubview:homeimg];
        
        
        UIButton*btnhome=[[UIButton alloc]initWithFrame:CGRectMake(6,44,110, 35)];
        btnhome.titleLabel.font=[UIFont systemFontOfSize:16];
        
        [btnhome setTitle:@"首页" forState:UIControlStateNormal];
        [btnhome addTarget:self action:@selector(returnhome) forControlEvents:UIControlEventTouchUpInside];
        
        [btnhome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [img addSubview:btnhome];
        
        iscunzai=2;
    }else{
        
        [img removeFromSuperview];
        iscunzai=1;
        
    }
    
}
//点击清单
-(void)qingdan
{
    //    DebugLog(@"---清单");
    [img removeFromSuperview];
    //   NSNotification *shaidan =[NSNotification notificationWithName:@"shaidan" object:nil userInfo:nil];
    //    [[NSNotificationCenter defaultCenter] postNotification:shaidan];
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)returnhome{
    [img removeFromSuperview];
    //    DebugLog(@"--首页");
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _willArray.count;
    }else{
        return _dataArray.count;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [img removeFromSuperview];
    GoodsDetailsViewController *detailsVC = [[GoodsDetailsViewController alloc]init];
    detailsVC.tiaozhuantype=1;
    if (indexPath.section == 0)
    {
        BeforeModel*model=[_willArray objectAtIndex:indexPath.row];
        detailsVC.idd = model.idd;
        
        detailsVC.tiaozhuantype=1;

        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    else
    {
        BeforeModel*model=[_dataArray objectAtIndex:indexPath.row];
        detailsVC.idd = model.idd;
        detailsVC.zhongjiangID = model.q_uid;
        detailsVC.hidesBottomBarWhenPushed = YES;
        detailsVC.tiaozhuantype=2;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    
    NSDictionary* style2 = @{@"body11" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   MainColor],
                             
                             
                             @"u": @[[UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1],
                                     
                                     ]};
    
    if (indexPath.section==0) {
        NSString *cellId=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        BeforeModel*model=[_willArray objectAtIndex:indexPath.row];

        
        if ([model.jiexiao_time isEqualToString:@""]&& model.q_end_time !=nil) {
            cell.textLabel.attributedText=[ [NSString stringWithFormat:@"第%@期｜<u>即将揭晓，正在倒计时...</u>",model.qishu] attributedStringWithStyleBook:style1];
        }else{
            cell.textLabel.attributedText=[ [NSString stringWithFormat:@"第%@期｜<u>正在火热进行中, 请前往购买</u>",model.qishu] attributedStringWithStyleBook:style1];
            
        }
        return cell;
        
    }else{
        
        static NSString *cellName = @"BeforeViewCell.h";
        BeforeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[BeforeViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        
        BeforeModel*model=[_dataArray objectAtIndex:indexPath.row];

        
        
        cell.username.tag=indexPath.row;
        [cell.username setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [cell.username addTarget:self action:@selector(gotogerenzhongxin:) forControlEvents:UIControlEventTouchUpInside];
                
        cell.lbnameip.attributedText=[[NSString stringWithFormat:@"<body11>中  奖  者：</body11><body>%@</body><u>(%@)</u>",model.username,model.ip]attributedStringWithStyleBook:style2];
     
        NSString *str1=model.jiexiao_time ;//时间戳
        NSTimeInterval time=[str1 doubleValue];//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        cell.jxdate.text=[NSString stringWithFormat:@"第%@期|揭晓时间:%@",model.qishu,[dateFormatter stringFromDate: detaildate]];
        
        cell.takecount.attributedText=[[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",model.gonumber]attributedStringWithStyleBook:style1];

        cell.luckno.attributedText=[[NSString stringWithFormat:@"中奖号码：<u>%@</u>",model.q_user_code]attributedStringWithStyleBook:style1];

        [cell.userhead sd_setImageWithURL:[NSURL URLWithString:model.img ] placeholderImage:[UIImage imageNamed:DefaultImage]];
        
        cell.userid.text=[NSString stringWithFormat:@"用  户  ID：%@(唯一不变的标识)",model.q_uid];
        
        return cell;
}
 }
//跳转个人中心
-(void)gotogerenzhongxin:(UIButton *)sender{
    int index=(int)[sender tag];
    BeforeModel*model = [self.dataArray objectAtIndex:index];
    
    DebugLog(@"---%@---%@",model.username,model.q_uid);
    
    PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
    classVC.yhid=model.q_uid;
    //
    [self.navigationController pushViewController:classVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 50;
    }else{
      return 160;
    }
  
    
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



#pragma mark - 上拉加载更多
- (void)loadingData
{
    self.num = self.num +1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_sid forKey:@"sid"];
     [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    DebugLog(@"---sid:%@",_sid);
    [MDYAFHelp AFPostHost:APPHost bindPath:Before postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"-----%@",responseDic);
        DebugLog(@"-----%@",responseDic[@"msg"]);
        [self loadingSuccessful:responseDic];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        [self loadingFailure:error];
    }];
    
    
}
- (void)loadingSuccessful:(id)data
{
    
    [self.nonetwork removeFromSuperview];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                BeforeModel  *model = [[BeforeModel alloc]initWithDictionary:obj];
                DebugLog(@"------%@",model.status);
                if ([model.status isEqualToString:@"0"]) {
                    [self.willArray addObject:model];
                }else{
                    
                    [self.dataArray addObject:model];
                    
                }
                DebugLog(@"-------%li-------%li",_willArray.count,_dataArray.count);
            }];
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
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}
- (void)loadingFailure:(NSError *)error
{
    [self nonetworking];
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    self.num = self.num -1;
    [self.tableView tableViewDidFinishedLoading];
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

#pragma mark - 创建tableView
- (void)createTableView
{
    if (!self.tableView) {

    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-64  ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //    self.tableView.backgroundColor=[UIColor greenColor];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
    
     [self createView];
    }
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
