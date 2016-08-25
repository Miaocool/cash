//
//  MyStudentController.m
//  kl1g
//
//  Created by lili on 16/2/17.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "MyStudentController.h"
#import "MyStudentCell.h"
#import "StudentNoteCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "GoodsDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "OrdershareModel.h"
#import <ShareSDK/ShareSDK.h>
#import "DateHelper.h"
#import "EGOImageLoader.h"
#import "PersonalcenterController.h"
#import "FoundViewCell.h"
#import "ZhaomuWenzhangModel.h"
#import "TudiBangdanModel.h"

#import "TudiJiluModel.h"

#import "PictureDetailController.h"
@interface MyStudentController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

{
    UIScrollView *_scrollview;
    UILabel*_lbleiji;  //累计邀请
    UILabel*_lbsuccess;//成功邀请
    UIButton*_btguize;//招募规则
    UIButton*_btnote;//徒弟纪录
    UIButton*_btpaihang;//排行榜单
    int _seleteview;//选择第几个view
    
    UIView*_headview;
    UIView*_headview2;
    NSString*_baishi;//拜师
    NSString*_hongbao;//红包
    NSString*_shouyi;//收益
    NSString*_yaoqong;//签到
    UILabel *lbhead;//
    
    
    UILabel *lbstudentcount; //徒弟获得的积分
    
    UILabel *lbsoncount;//徒孙获得的积分
    
    UILabel *lbjin;//累计获得积分
    
    UILabel*lbmystudent;//我的徒弟
    
    UILabel*lbmyson;//我的徒孙
     OrdershareModel*model;
    
    
    UILabel              *_sharetext;  //分享推广内容
    UILabel                 *_lab;    //文字lab
    UILabel                 *_shouyiLab;  //下方推广收益label
    NSString                *_url;      //下载页url
    NSString                *_title;    //推广标题
    NSString                *_content;   //推广内容
    NSString                *_imgurl;  //头像url
    
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源

@property (nonatomic, strong) NSMutableArray *bangdanArray; //徒弟榜单

@property (nonatomic, strong) NSMutableArray *tudiiluArray; //徒弟纪录
@property (nonatomic, strong) NSMutableArray *wenzhangArray; //招募文章
@end

@implementation MyStudentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"招募徒弟";
    _seleteview=1;
     [self Getzhaomuwenzhang];
    
     [self Getzhaomudata];
    [self crateview];
    [self createTableView];
    [self initData];
    [self refreshData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getShareData];
}
#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    _bangdanArray=[NSMutableArray array];
    _tudiiluArray=[NSMutableArray array];
    
}
#pragma mark - 招募文章

-(void)Getzhaomuwenzhang{
    _wenzhangArray=[NSMutableArray array];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [MDYAFHelp AFPostHost:APPHost bindPath:ZhaomuWenzhang postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        
        DebugLog(@"=----zhaonmu-%@--%@",responseDic,responseDic[@"msg"]);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            
            
            NSArray *array = responseDic[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                ZhaomuWenzhangModel  *wenmodel = [[ZhaomuWenzhangModel alloc]initWithDictionary:obj];
                [_wenzhangArray addObject:wenmodel];
                
            
            }];
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
        
    }];
    


}
#pragma mark - 请求数据

-(void)Getzhaomudata{
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:BigFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    NSDictionary* style = @{@"body" :
                                 @[[UIFont systemFontOfSize:BigFont],
                                   [UIColor grayColor]],
                             @"u": @[[UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1],
                                     
                                     ]};
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Zhaomu postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        NSDictionary*data=responseDic[@"data"];
        _baishi=data[@"baishi"];
        _hongbao=data[@"hongbao"];
        _shouyi=data[@"shouyi"];
        _yaoqong=data[@"yaoqing"];
        lbhead.attributedText=[[NSString stringWithFormat:@"全国累计<u>%@</u>万人拜师\n累计发放红包<u>%@</u>万",_baishi,_hongbao]attributedStringWithStyleBook:style1];
        _lbleiji.attributedText=[[NSString stringWithFormat:@"累计邀请受益 <u>%@</u>",_shouyi]attributedStringWithStyleBook:style];
        _lbsuccess.attributedText=[[NSString stringWithFormat:@"成功邀请 <u>%@</u>",_yaoqong]attributedStringWithStyleBook:style];
//        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self refreshFailure:error];
        
    }];
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    
    
    self.num = 1;
    if (_seleteview==1) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [MDYAFHelp AFPostHost:APPHost bindPath:ZhaomuGuize postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
            if (!_headview) {
                  [self crateheadview];
            }
            if ([responseDic[@"code"] isEqualToString:@"200"]) {
                NSDictionary*data=responseDic[@"data"];
                lbstudentcount.text=[NSString stringWithFormat:@"%@个",data[@"tudi_number"]];
                lbsoncount.text=[NSString stringWithFormat:@"%@个",data[@"tusun_number"]];
                lbjin.text=[NSString stringWithFormat:@"%@积分",data[@"shouyi"]];
                lbmystudent.text=data[@"tudi"];
                lbmyson.text=data[@"tusun"];
            }
            [_tableView reloadData];
            [self.tableView tableViewDidFinishedLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DebugLog(@"失败:%@",error);
            [self refreshFailure:error];
            
        }];
    }else if (_seleteview==2){
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];

        [MDYAFHelp AFPostHost:APPHost bindPath:Tudijilu postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
            DebugLog(@"=----zhaonmu-%@--%@",responseDic,responseDic[@"msg"]);
            if([responseDic[@"code"] isEqualToString:@"200"])
            {
                NSArray *array = responseDic[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    TudiJiluModel  *wenmodel = [[TudiJiluModel alloc]initWithDictionary:obj];
                    [_tudiiluArray addObject:wenmodel];
                    
                    
                }];
            }
            [_tableView reloadData];
             [self.tableView tableViewDidFinishedLoading];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DebugLog(@"失败:%@",error);
            [self refreshFailure:error];
            
        }];
    
    }else{
    
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
        
        [MDYAFHelp AFPostHost:APPHost bindPath:Tudibangdan postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
            
            DebugLog(@"=----zhaonmu-%@--%@",responseDic,responseDic[@"msg"]);
            
            [self refreshSuccessful:responseDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DebugLog(@"失败:%@",error);
            [self refreshFailure:error];
            
        }];
    
    }
}

- (void)refreshSuccessful:(id)data
{
    
    [self.dataArray removeAllObjects];
    [self.bangdanArray removeAllObjects];
   
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            if (_seleteview==3) {
                self.tableView.footerView.state = kPRStatePulling;
                NSArray *array = data[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    TudiBangdanModel  *model3 = [[TudiBangdanModel alloc]initWithDictionary:obj];
                    [_bangdanArray addObject:model3];
                }];
            }
            
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
    if (!self.tableView) {
          [self createTableView];
    }
 
    
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    DebugLog(@"失败");
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 下面的点击事件

-(void)crateview{
NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    
    
    UIImageView*imghead=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    imghead.backgroundColor=[UIColor clearColor];
    imghead.layer.masksToBounds=YES;
    imghead.image=[UIImage imageNamed:@"icon-120"];
    imghead.layer.cornerRadius = 30;
    [self.view addSubview:imghead];
    lbhead=[[UILabel alloc]initWithFrame:CGRectMake(90,10, MSW-80, 60)];
    
    
    lbhead.font=[UIFont systemFontOfSize:16];
    lbhead.numberOfLines=0;
    [self.view addSubview:lbhead];
    _lbleiji=[[UILabel alloc]initWithFrame:CGRectMake(-2, 80, MSW/2+2, 50)];
    _lbleiji.layer.borderWidth = 2;
    _lbleiji.textAlignment=UITextAlignmentCenter;
    _lbleiji.attributedText=[@"累计邀请受益 <u>666</u>"attributedStringWithStyleBook:style1];
    _lbleiji.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    _lbleiji.font=[UIFont systemFontOfSize:BigFont];
    [self.view addSubview:_lbleiji];
    
    _lbsuccess=[[UILabel alloc]initWithFrame:CGRectMake( MSW/2-2, 80, MSW/2+4, 50)];
    _lbsuccess.layer.borderWidth = 2;
    _lbsuccess.textAlignment=UITextAlignmentCenter;
    _lbsuccess.attributedText=[@"成功邀请 <u>6</u>"attributedStringWithStyleBook:style1];
    _lbsuccess.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    _lbsuccess.font=[UIFont systemFontOfSize:BigFont];
    [self.view addSubview:_lbsuccess];
    
    _btguize=[[UIButton alloc]initWithFrame:CGRectMake(-2, 128, MSW/3+2, 40)];
    _btguize.layer.borderWidth=2;
    _btguize.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    [_btguize setTitle:@"招募规则" forState:UIControlStateNormal];
    _btguize.tag=101;
    [_btguize addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    [_btguize setBackgroundColor:MainColor];
    
    _btguize.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:_btguize];
    
    _btnote=[[UIButton alloc]initWithFrame:CGRectMake(MSW/3-2, 128, MSW/3, 40)];
    _btnote.layer.borderWidth=2;
    _btnote.tag=102;
    [_btnote addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    _btnote.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    [_btnote setTitle:@"徒弟纪录" forState:UIControlStateNormal];
    [_btnote setBackgroundColor:[UIColor whiteColor]];
    [_btnote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnote.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:_btnote];
    
    _btpaihang=[[UIButton alloc]initWithFrame:CGRectMake(MSW/3*2-4, 128, MSW/3+4, 40)];
    _btpaihang.layer.borderWidth=2;
    _btpaihang.tag=103;
    [_btpaihang addTarget:self action:@selector(seleteview:) forControlEvents:UIControlEventTouchUpInside];
    _btpaihang.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    [_btpaihang setTitle:@"排行榜单" forState:UIControlStateNormal];
    [_btpaihang setBackgroundColor:[UIColor whiteColor]];
    [_btpaihang setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btpaihang.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:_btpaihang];
}


#pragma mark - 设置选中时的状态

-(void)seleteview:(UIButton*)sender{
    if (sender.tag==101) {
        _seleteview=1;
        [_btguize setBackgroundColor:MainColor];
        [_btguize setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnote setBackgroundColor:[UIColor whiteColor]];
        [_btnote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btpaihang setBackgroundColor:[UIColor whiteColor]];
        [_btpaihang setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else if (sender.tag==102){
        _seleteview=2;
        [_btnote setBackgroundColor:MainColor];
        [_btnote setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btguize setBackgroundColor:[UIColor whiteColor]];
        [_btguize setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btpaihang setBackgroundColor:[UIColor whiteColor]];
        [_btpaihang setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }else{
        _seleteview=3;
        [_btpaihang setBackgroundColor:MainColor];
        [_btpaihang setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnote setBackgroundColor:[UIColor whiteColor]];
        [_btnote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btguize setBackgroundColor:[UIColor whiteColor]];
        [_btguize setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self refreshData];
    
    
    [_tableView reloadData];
}
#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0,168, MSW,MSH-198  ) pullingDelegate:self style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    self.tableView.tableHeaderView = [[UIView alloc]init];
    _tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    
    [self.view addSubview:self.tableView];
    
    
    
}

#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_seleteview==1) {
      
        DebugLog(@"=---%li",_wenzhangArray.count);
        return _wenzhangArray.count;
    }else
        if
        (_seleteview==2){
        
        if (_tudiiluArray.count!=0)
        {
                return _tudiiluArray.count;

        }
        else
        {
                  return 1;
        }
        
    }
        else
        {
        return _bangdanArray.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_seleteview==2) {
        return 40;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
        
        if (_seleteview==1) {
            return 160;
        }
        else{
            return 5;
        }
    }else{
        
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_seleteview==1) {
      
        return _headview;
    }
    else{
        return nil;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_seleteview==1) {
        
        
        ZhaomuWenzhangModel*zmmodel=[_wenzhangArray objectAtIndex:indexPath.row];

        PictureDetailController *classVC = [[PictureDetailController alloc]init];
        classVC.style=3;
        classVC.fromtitle=zmmodel.title;
        classVC.fromurl=zmmodel.url;
        [self.navigationController pushViewController:classVC animated:YES];
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_seleteview==1) {
        static NSString *cellName = @"Cell111";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        cell.textLabel.font = [UIFont systemFontOfSize:BigFont];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:MiddleFont];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
        if (_wenzhangArray.count!=0) {
            
            ZhaomuWenzhangModel*zmmodel=[_wenzhangArray objectAtIndex:indexPath.row];
            cell.textLabel.text=zmmodel.title;
            
        }

        return cell;
    }else if (_seleteview==2){
        
        static NSString *cellName = @"StudentNoteCell.h";
        StudentNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[StudentNoteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        
        
        if (_tudiiluArray.count!=0) {
            TudiJiluModel*tdmodel=[_tudiiluArray objectAtIndex:indexPath.row];
            cell.lbname.text=tdmodel.username;
            cell.lbtime.text=tdmodel.time;
        }else{
            cell.lbname.text=@"";
            cell.lbtime.text=@"";
        cell.textLabel.text=@"没有邀请记录";
            cell.textLabel.textAlignment=UITextAlignmentCenter;
        
        }
        
        return cell;
        
        
    }
    
    else{
        static NSString *cellName = @"MyStudentCell.h";
        MyStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[MyStudentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        DebugLog(@"=---%li",_bangdanArray.count);
        if (_bangdanArray.count!=0) {
            
            if (indexPath.row>0) {
                TudiBangdanModel*model1=[_bangdanArray objectAtIndex:indexPath.row-1];
                cell.lbname.text=model1.yaoqing;
                
                cell.lbpaiming.text=[NSString stringWithFormat:@"%li",indexPath.row];
                cell.lbcount.text=model1.count;
            }
 
        }
               return cell;
    }
    
}


#pragma mark - 上拉加载更多
- (void)loadingData
{
    if (_seleteview==2) {
            self.num = self.num +1;
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
        
        [MDYAFHelp AFPostHost:APPHost bindPath:Tudijilu postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
            
            DebugLog(@"=----zhaonmu-%@--%@",responseDic,responseDic[@"msg"]);
            if([responseDic[@"code"] isEqualToString:@"200"])
            {
                
                
                NSArray *array = responseDic[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    TudiJiluModel  *wenmodel = [[TudiJiluModel alloc]initWithDictionary:obj];
                    [_tudiiluArray addObject:wenmodel];
                    
                    
                }];
            }
            
          [self loadingSuccessful:responseDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DebugLog(@"失败:%@",error);
        [self loadingFailure:error];
            
        }];
 
    }
    
    
    }

- (void)loadingSuccessful:(id)data
{

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
        if (_seleteview==2) {
         [self loadingData];
        
        }else{
        
            
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                self.tableView.footerView.state = kPRStateHitTheEnd;
            }];
            [self.tableView tableViewDidFinishedLoading];
            

        }
       
    });
}




#pragma mark - 招募徒弟

-(void)crateheadview{
    _headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 250)];
    _headview.backgroundColor=[UIColor whiteColor];
    
    lbmystudent=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, MSW-100, 20)];
    lbmystudent.text=@"我的徒弟     获得徒弟充值金额％2分成";
    lbmystudent.textColor=[UIColor grayColor];
    lbmystudent.font=[UIFont systemFontOfSize:BigFont];
    [_headview addSubview:lbmystudent];
    lbstudentcount=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 5, 90, 20)];
    lbstudentcount.textAlignment=UITextAlignmentRight;
    lbstudentcount.textColor=[UIColor redColor];
    lbstudentcount.font=[UIFont systemFontOfSize:BigFont];
//    lbstudentcount.text=@"0个";
    [_headview addSubview:lbstudentcount];
    
    
    lbmyson=[[UILabel alloc]initWithFrame:CGRectMake(10, 35, MSW-100, 20)];
    lbmyson.text=@"我的徒孙     获得徒孙充值金额％0分成";
    lbmyson.textColor=[UIColor grayColor];
    lbmyson.font=[UIFont systemFontOfSize:BigFont];
    [_headview addSubview:lbmyson];
    lbsoncount=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 35, 90, 20)];
    lbsoncount.textAlignment=UITextAlignmentRight;
    lbsoncount.textColor=[UIColor redColor];
    lbsoncount.font=[UIFont systemFontOfSize:BigFont];
    lbsoncount.text=@"2个";
    [_headview addSubview:lbsoncount];
    
    
    
    UILabel*lbleiji=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, MSW-100, 20)];
    lbleiji.text=@"累计奖励";
    lbleiji.textColor=[UIColor grayColor];
    lbleiji.font=[UIFont systemFontOfSize:BigFont];
    [_headview addSubview:lbleiji];
    lbjin=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 70, 90, 20)];
    lbjin.textAlignment=UITextAlignmentRight;
    lbjin.textColor=[UIColor redColor];
    lbjin.font=[UIFont systemFontOfSize:BigFont];
    lbjin.text=@"20金元宝";
    [_headview addSubview:lbjin];
//    UILabel*lbhb=[[UILabel alloc]initWithFrame:CGRectMake(10, 95, MSW-100, 20)];
//    lbhb.text=@"发红包，收徒弟 红包领取码：";
//    lbhb.textColor=[UIColor grayColor];
//    lbhb.font=[UIFont systemFontOfSize:BigFont];
//    [_headview addSubview:lbhb];
//    UILabel *lbhongbao=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 95, 90, 20)];
//    lbhongbao.textAlignment=UITextAlignmentRight;
//    lbhongbao.textColor=[UIColor redColor];
//    lbhongbao.font=[UIFont systemFontOfSize:BigFont];
//    lbhongbao.text=@"987789";
//    [_headview addSubview:lbhongbao];
//    
//    UILabel*lbtishi=[[UILabel alloc]initWithFrame:CGRectMake(10, 120, MSW-20, 30)];
//    lbtishi.text=@"免费发3元红包给朋友，领取的同时成为您的徒弟";
//    lbtishi.textColor=[UIColor grayColor];
//    lbtishi.font=[UIFont systemFontOfSize:14];
//    [_headview addSubview:lbtishi];
    UIButton *btshare=[[UIButton alloc]initWithFrame:CGRectMake(20, 100, MSW-40, 40)];
    btshare.layer.masksToBounds=YES;
    btshare.layer.cornerRadius = 5;
    [btshare addTarget:self action:@selector(shareshoutudi) forControlEvents:UIControlEventTouchUpInside];
    [btshare setTitle:@"分享好友收徒弟" forState:0];
    [btshare setBackgroundColor:MainColor];
    [btshare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_headview addSubview:btshare];
    
    
}
#pragma mark -徒弟纪录
-(void)cratetudiheadvivw{
    _headview2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 50)];
    _headview2.backgroundColor=[UIColor whiteColor];
    UIImageView*imgtime=[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 30, 30)];
    imgtime.backgroundColor=[UIColor greenColor];
    [_headview2 addSubview:imgtime];
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, MSW-80, 30)];
    lbtitle.text=@"正在进行中1个，已完成0个";
    lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    [_headview2 addSubview:lbtitle];
    
}
#pragma mark - 获取分享请求
-(void)getShareData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Share postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        //        DebugLog(@"==============%@=====%@",responseDic[@"msg"],responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSDictionary*data=responseDic[@"data"];
            _shouyiLab.text=data[@"shouyi"];
            _url=data[@"url"];
            _title=data[@"title"];
            _content=data[@"content"];
            _imgurl=data[@"imgurl"];
            //            DebugLog(@"==%@==%@==%@==%@==%@==%@",_sharetext.text,_url,_title,_shouyiLab.text,_content,_imgurl);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        DebugLog(@"!!!!!!!!!!!!!!!!%@",error);
    }];
    
}

#pragma mark - 分享
-(void)shareshoutudi{
    //    DebugLog(@"分享");
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
