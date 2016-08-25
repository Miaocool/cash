//
//  GoodsOrderController.m
//  zrdb
//
//  Created by lili on 16/1/25.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "GoodsOrderController.h"
#import "ListingViewController.h"
#import "OrdershareViewCell.h"
#import "SharedetailController.h"
#import "DateHelper.h"
#import "UIImageView+WebCache.h"
#import "OrdershareModel.h"
#import "PersonalcenterController.h"
#import "CommentController.h"
#import "GoodsDetailsViewController.h"
#import "WinningRecordViewController.h"

@interface GoodsOrderController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,OrdershareViewCellDelegate,UIScrollViewDelegate>
{
    UIImageView*img;
    int iscunzai;//判断图标是否存在
    UIView*_blackview;
     
    UIPageControl*_page;
}
@property (nonatomic, strong) NoDataView *nodataView;

@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NoNetwork *nonetwork;

@end



@implementation GoodsOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"晒单";
    iscunzai=1;
    //    更多－－－－－－－－－
    UIButton *message = [UIButton buttonWithType:UIButtonTypeCustom];
    message.frame = CGRectMake(MSW-100, 20, 30, 30);
    //    [message setTitle:@"中奖记录" forState:UIControlStateNormal];
    message.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    [message setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [message setImage:[UIImage imageNamed:@"addwin"] forState:UIControlStateNormal];
    message.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [message addTarget:self action:@selector(message) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self initData];
    [self refreshData];
    
}

-(void)message
{
    if ([UserDataSingleton userInformation].isLogin == YES)
    {
        //中奖记录
        WinningRecordViewController *win=[[WinningRecordViewController alloc]init];
        win.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:win animated:YES];
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
    
}

#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    
}
#pragma mark - 下拉刷新
- (void)refreshData
{
    self.num = 1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_sid forKey:@"sid"];
    
    if ([UserDataSingleton userInformation].isLogin) {
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        
    }
    [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
    if (_tiaostaty==1) {
        [MDYAFHelp AFPostHost:APPHost bindPath:Goodshare postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"--晒单列表------%@---%@",responseDic,responseDic[@"msg"]);
                        [self refreshSuccessful:responseDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            DebugLog(@"失败:%@",error);
            [self refreshFailure:error];
            
        }];
        
    }
    
    
}

- (void)refreshSuccessful:(id)data
{[self.nonetwork removeFromSuperview];
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            self.tableView.footerView.state = kPRStatePulling;
            
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                OrdershareModel  *model = [[OrdershareModel alloc]initWithDictionary:obj];
                DebugLog(@"----%@",data);
                DebugLog(@"-----%@",model.username);
                [self.dataArray addObject:model];
            }];
        }
    }
    if (_dataArray.count!=0) {
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    [self createTableView];
    }else{
        [self noData];
    
    }
}

- (void)refreshFailure:(NSError *)error
{
    [self nonetworking];
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    self.num = self.num +1;
    if (_tiaostaty==1) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:_sid forKey:@"sid"];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
        [MDYAFHelp AFPostHost:APPHost bindPath:Goodshare postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"刷新！！！%@",responseDic);
            [self loadingSuccessful:responseDic];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            DebugLog(@"失败:%@",error);
            [self loadingFailure:error];
        }];

    }else{
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:_sid forKey:@"sid"];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[NSString stringWithFormat:@"%ld",(long)self.num] forKey:@"p"];
        [MDYAFHelp AFPostHost:APPHost bindPath:Ordershare postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"刷新！！！%@",responseDic);
            [self loadingSuccessful:responseDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self loadingFailure:error];
        }];
    }
    
}

- (void)loadingSuccessful:(id)data
{
    [self.nonetwork removeFromSuperview];
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
                
                OrdershareModel  *model = [[OrdershareModel alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
                if([[NSString stringWithFormat:@"%lu",self.dataArray.count] isEqualToString:data[@"count"]])
                {
                    [UIView animateWithDuration:2 animations:^{
                        
                    } completion:^(BOOL finished) {
                        self.tableView.footerView.state = kPRStateHitTheEnd;
                    }];
                }
                
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
    [img removeFromSuperview];
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)returnhome{
    [img removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
}

#pragma mark - 创建tableView
- (void)createTableView
{
    if (!self.tableView) {
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    }
}
#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [img removeFromSuperview];
    OrdershareModel*model = [self.dataArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SharedetailController *classVC = [[SharedetailController alloc]init];
    classVC.sid=model.sd_id;
    classVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:classVC animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellName = @"OrdershareViewCell.h";
    OrdershareViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[OrdershareViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    OrdershareModel*model = [self.dataArray objectAtIndex:indexPath.row];
    [cell.username setTitle:model.username forState:UIControlStateNormal];
    [cell.userhead sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:DefaultImage]];
    NSString *str=model.sd_time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    cell.sharedate.text=[dateFormatter stringFromDate: detaildate];
    cell.sharetitle.text=model.sd_title;
    cell.sharegoods.text=[NSString stringWithFormat:@"(第%@期)%@",model.qishu,model.title];
    
    cell.sharegoods.font=[UIFont systemFontOfSize:BigFont];
    cell.shareinfo.text=model.sd_content;
    //    //    改变图片尺寸   等比例缩放
    //    cell.goodsimg1.contentMode = UIViewContentModeScaleAspectFit;
    //    cell.goodsimg2.contentMode = UIViewContentModeScaleAspectFit;
    //    cell.goodsimg3.contentMode = UIViewContentModeScaleAspectFit;
    [cell.goodsimg1 setContentMode:UIViewContentModeScaleAspectFill];
    cell.goodsimg1.clipsToBounds = YES;
    [cell.goodsimg2 setContentMode:UIViewContentModeScaleAspectFill];
    cell.goodsimg2.clipsToBounds = YES;
    [cell.goodsimg3 setContentMode:UIViewContentModeScaleAspectFill];
    cell.goodsimg3.clipsToBounds = YES;
    if (model.sd_photolist.count==1) {
        [cell.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        
        
        cell.goodsimg2.image=[UIImage imageNamed:@""];
        cell.goodsimg3.image=[UIImage imageNamed:@""];
    }else if (model.sd_photolist.count==2){
        [cell.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [cell.goodsimg2 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:1]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        cell.goodsimg3.image=[UIImage imageNamed:@""];
        
    }else{
        [cell.goodsimg1 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:0]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [cell.goodsimg2 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:1]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [cell.goodsimg3 sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:2]] placeholderImage:[UIImage imageNamed:DefaultImage]];
    }
    [cell.username addTarget:self action:@selector(gotogerenzhongxin:) forControlEvents:UIControlEventTouchUpInside];
    cell.username.tag=indexPath.row;
    
    cell.lbzan.text=[NSString stringWithFormat:@"攒人品(%@)",model.zan_number];

    cell.lbcomment.text=[NSString stringWithFormat:@"评论(%@)",model.pinglun_number];
    if ([model.sd_type isEqualToString:@"0"]) {
        //没有点赞
        cell.imgzan.image=[UIImage imageNamed:@"good"];
    }else{
        //    点赞
        cell.imgzan.image=[UIImage imageNamed:@"good_selected1"];
    }
    cell.OrderModel=model;
    cell.delegate=self;
    cell.btzan.tag=indexPath.row;
    cell.btcomment.tag=indexPath.row;
    
    [cell.btcomment addTarget:self action:@selector(pinglun:) forControlEvents:UIControlEventTouchUpInside];

    cell.btlook.tag=indexPath.row;
    [cell.btlook addTarget:self action:@selector(lookgoodsimage:) forControlEvents:UIControlEventTouchUpInside];
    cell.tryBtn.tag=indexPath.row;
    [cell.tryBtn addTarget:self action:@selector(tryshouqi:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(void)pinglun:(UIButton *)sender{
    int index=(int)[sender tag];
    OrdershareModel*model = [self.dataArray objectAtIndex:index];
    CommentController *classVC = [[CommentController alloc]init];
    classVC.sid=model.sd_id;
    [self.navigationController pushViewController:classVC animated:YES];
}

#pragma mark - 点赞动画
- (void)clickCell:(OrdershareViewCell *)cell
{
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
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((cell.btzan.frame.size.width/2) - 15 + (cell.btzan.frame.origin.x), cell.frame.size.height - cell.imgzan.frame.size.height-5, 20, 10)];
                label.text = @"+1";
                label.textColor=[UIColor redColor];
                label.font=[UIFont systemFontOfSize:14];
                [cell addSubview:label];
                [UIView animateWithDuration:1 animations:^{
                    label.frame = CGRectMake((cell.btzan.frame.size.width/2) - 15 + (cell.btzan.frame.origin.x), cell.frame.size.height - 50, 20, 10);
                } completion:^(BOOL finished) {
                    [label reloadInputViews];
                    [label removeFromSuperview];
                }];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self loadingFailure:error];
        }];
        
}else{
        }
    
}
-(void)dianzan:(UIButton *)sender{
    
    int index=(int)[sender tag];
    OrdershareModel*model = [self.dataArray objectAtIndex:index];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict1 setValue:[NSString stringWithFormat:@"%@",model.sd_id] forKey:@"sd_id"];
    [MDYAFHelp AFPostHost:APPHost bindPath:ShareZan postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"---%@---%@",responseDic,responseDic[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
        [self loadingFailure:error];
    }];
}
//跳转个人中心
-(void)gotogerenzhongxin:(UIButton *)sender{
    int index=(int)[sender tag];
    OrdershareModel*model = [self.dataArray objectAtIndex:index];
    PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
    classVC.yhid=model.sd_userid;
    classVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:classVC animated:YES];
}


//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"该商品没有晒单!";
        _nodataView.scrolike.hidden=YES;
        _nodataView.lblike.hidden=YES;
        _nodataView.lbline2.hidden=YES;
        _nodataView.textLabel.text=@"";
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.nodataView];
}
-(void)gotoxunbao{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)lookgoodsimage:(UIButton*)sender{
    int index;
    index=(int)sender.tag;
    OrdershareModel*model=[_dataArray objectAtIndex:index];
        _blackview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    _blackview.backgroundColor=[UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_blackview];
    UIButton*btclose=[[UIButton alloc]initWithFrame:CGRectMake(MSW-60, 60, 40, 40)];
    [btclose setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [btclose addTarget:self action:@selector(removeblackview) forControlEvents:UIControlEventTouchUpInside];
    [_blackview addSubview:btclose];
    UIScrollView*scrociew=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 120, MSW-20, MSW-20)];
    scrociew.backgroundColor = [UIColor clearColor];
    scrociew.pagingEnabled = YES;  //设为YES时，会按页滑动
    scrociew.delegate=self;
    scrociew.contentSize = CGSizeMake((MSW-20)*model.sd_photolist.count, MSW-20);
    scrociew.showsHorizontalScrollIndicator = true;
    [_blackview addSubview:scrociew];
    for (int i=0; i<model.sd_photolist.count; i++) {
        UIImageView *imggoods=[[UIImageView alloc]initWithFrame:CGRectMake(i*(MSW-20), 0,  MSW-20,  MSW-20)];
        [imggoods sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:i]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [imggoods setContentMode:UIViewContentModeScaleAspectFill];
        imggoods.clipsToBounds = YES;

        [scrociew addSubview:imggoods];
    }
    _page=[[UIPageControl alloc]initWithFrame:CGRectMake(MSW/2-60, 120+MSW-20, 120, 20)];
    //    page.backgroundColor=[UIColor orangeColor];
    _page.numberOfPages =model.sd_photolist.count;
    
    _page.currentPageIndicatorTintColor = MainColor;
    
    _page.pageIndicatorTintColor = [UIColor whiteColor];
    _page.currentPage = 0;
    [_blackview addSubview:_page];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_page setCurrentPage:offset.x / bounds.size.width];
    DebugLog(@"%f",offset.x / bounds.size.width);
}

-(void)removeblackview{
    
    [_blackview removeFromSuperview];
    
    
}

-(void)tryshouqi:(UIButton *)sender{
    int index=(int)[sender tag];
    OrdershareModel*model = [self.dataArray objectAtIndex:index];
    DebugLog(@"===---%@",model.shopid);
    GoodsDetailsViewController *classVC = [[GoodsDetailsViewController alloc]init];
    classVC.idd=model.shopid;
    classVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:classVC animated:YES];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IPhone4_5_6_6P(210, 215, 230, 240);
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.left.hidden = YES;
      self.hidesBottomBarWhenPushed=YES;
    
}

//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
//
//    DebugLog(@"缩放完毕的时候调用");
//}
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//
// DebugLog(@"正在缩放的时候调用");
//}

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
