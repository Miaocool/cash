//
//  TopuprecordController.m
//  yyxb
//
//  Created by lili on 15/11/19.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "TopuprecordController.h"
#import "TopuprecordCell.h"
#import "FoundViewCell.h"

#import "DateHelper.h"
#import "TopupController.h"
#import "GoodsDetailsViewController.h"
#import "NewGoodsModel.h"
@interface TopuprecordController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>



@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *moneyArray; //金钱
@property (nonatomic, strong) NSMutableArray *timeyArray; //时间
@property (nonatomic, strong) NSMutableArray *statusArray; //状态
@property (nonatomic, strong) NSMutableArray *payArray; //支付方式
@property (nonatomic, assign) int statue; //判断状态

@property (nonatomic, strong) NoDataView *nodataView;
@end

@implementation TopuprecordController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充值记录";
    
    UIButton *callBtn = [[UIButton alloc]init];
    callBtn.frame = CGRectMake(0, 0, 50,30);
    [callBtn setTitle:@"充值" forState:(UIControlStateNormal)];
    [callBtn addTarget:self action:@selector(gototopup) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:callBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self initData];
    // 修改的－－－充值记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chongzhitongzhi:) name:@"chongzhi" object:nil];
    
}
-(void)chongzhitongzhi:(NSNotification *)model{
    
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    [self.navigationController pushViewController:goods animated:YES];
    
}

#pragma mark - 创建数据
- (void)initData
{
    _statue=0;
    _moneyArray = [NSMutableArray array];
    _payArray = [NSMutableArray array];
    _statusArray = [NSMutableArray array];
    _timeyArray= [NSMutableArray array];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    DebugLog(@"------%@---%@",[UserDataSingleton userInformation].uid,[UserDataSingleton userInformation].code);
    [MDYAFHelp AFPostHost:APPHost bindPath:UserRecharge postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        NSArray*arr=responseDic[@"data"];
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
                    for (int i=0; i<arr.count;i++ ) {
                        NSDictionary*dic=[arr objectAtIndex:i];
                        [_timeyArray addObject:dic[@"time"]];
                        [_statusArray addObject:dic[@"status"]];
                        [_payArray addObject:dic[@"pay_type"]];
                        [_moneyArray addObject:dic[@"money"]];
                        if ([dic[@"status"] isEqualToString:@"未付款"]) {
                            _statue++;
                        }
                }
        }
        //        修改的－－－判断有无数据
        if (_timeyArray.count==0) {
           [self noData];
        }else{
        
        [self createTableView];
        }
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);
       [self refreshFailure:error];
        
    }];
    
}


- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    DebugLog(@"失败");
    [self.tableView tableViewDidFinishedLoading];
}


#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  ) pullingDelegate:self style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegeta


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*_headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
    _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-40, 60)];
    lbtitle.text=@"充值获得米币（1元＝1米币），可用于夺宝，充值的款项将无法退回。";
    lbtitle.numberOfLines=0;
    lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    [_headview addSubview:lbtitle];
    return _headview;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _payArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 80;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *ListingCellName = @"TopuprecordCell.h";
    
   TopuprecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!cell)
    {
        cell = [[TopuprecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
    }cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lbmoney.numberOfLines=1;
    cell.lbmoney.text=[NSString stringWithFormat:@"%@",[_moneyArray objectAtIndex:indexPath.row]];
    cell.lbstate.text=[_statusArray objectAtIndex:indexPath.row];
    NSString *str=[_timeyArray objectAtIndex:indexPath.row] ;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.lbtime.text=[dateFormatter stringFromDate: detaildate];
     cell.lbzhifu.text=[_payArray objectAtIndex:indexPath.row];
    cell.lbmoney.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-90, 40,100, 30);
    CGSize size = CGSizeMake( cell.lbmoney.frame.size.width,10000);
    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
    CGSize labelsize = [cell.lbmoney.text sizeWithFont:cell.lbmoney.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    //最后根据这个大小设置label的frame即可
    [cell.lbmoney setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-labelsize.width-20,cell.lbmoney.frame.origin.y,labelsize.width,labelsize.height)];
   [cell.lbline setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-labelsize.width-20, cell.lbmoney.frame.origin.y+labelsize.height/2+1,labelsize.width, 1.5)];
    if ([cell.lbstate.text isEqualToString:@"未付款"]) {
        cell.lbline.hidden=NO;
        cell.lbstate.hidden=NO;
     
    }else{
        
          cell.lbmoney.frame=CGRectMake(cell.lbmoney.frame.origin.x, 20, cell.lbmoney.frame.size.width,30);
        cell.lbline.hidden=YES;
        cell.lbstate.hidden=YES;
  }
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*str=[_statusArray objectAtIndex:indexPath.row];
    
    if ([str isEqualToString:@"未付款"]) {
        return 100;
    }else{
        return 70;
    }
}
//去充值
-(void)gototopup{
    TopupController *userData = [[TopupController alloc]init];
       userData.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userData animated:YES];
}


//修改的－－－－－－－－没有信息view
- (void)noData
{
    if (!self.nodataView)
    {
        
        UIView*_headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
        UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-40, 50)];
        lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
        lbtitle.text=@"充值获得米币（1元＝1米币）,可用于夺宝,充值的款项将无法退回。";
        lbtitle.numberOfLines=0;
        [_headview addSubview:lbtitle];
        
        [self.view addSubview:_headview];
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"您还没有充值记录哦！";
        _nodataView.frame=CGRectMake(0, 60, MSW, MSH-80);
        _nodataView.imageView.frame=CGRectMake(MSW / 2 - 60, MSH / 2 - 250, 120, 120);

        _nodataView.titleLabel.frame=CGRectMake(_nodataView.titleLabel.frame.origin.x, _nodataView.imageView.frame.origin.y+130, _nodataView.titleLabel.frame.size.width, _nodataView.titleLabel.frame.size.height);
        
        _nodataView.imageView.hidden=NO;
        _nodataView.textLabel.text=@"";
        _nodataView.type=5;
        _nodataView.btgoto.frame=CGRectMake(MSW/2-100, _nodataView.imageView.frame.origin.y+170,200, 40);
        _nodataView.likeView.frame=CGRectMake(0, _nodataView.imageView.frame.origin.y+IPhone4_5_6_6P(220, 230, 240, 250),MSW, 440);
        _nodataView.scrolike.frame=CGRectMake(0, _nodataView.likeView.frame.origin.y+40, MSW, _nodataView.scrolike.frame.size.height);
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
 
    [self.view addSubview:self.nodataView];
}


-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
