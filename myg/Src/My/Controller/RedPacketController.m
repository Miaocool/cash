//
//  RedPacketController.m
//  yyxb
//
//  Created by lili on 15/12/14.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "RedPacketController.h"
#import "MyRedViewController.h"
#import "MyRedCell.h"
#import "RedBoxDto.h"
#import "GroupRedViewController.h"
#import "MJRefresh.h"
#import "DidViewCell.h"
#import "ExchangeRedViewController.h"
#import "RedPacketView.h"
#import "RefreshView.h"
#import "NewGoodsModel.h"
#import "GoodsDetailsViewController.h"
@interface RedPacketController ()<PullingRefreshTableViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    UIView*_blackview;
    
  
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

@property (nonatomic, strong) RedPacketView *tableView;

@property (nonatomic, strong) UIView *normalview;

@property (nonatomic, strong) NSString *allcount;
@property (nonatomic, strong) NSString *doingcount;
@property (nonatomic, strong) NSString *didcount;


@property (nonatomic, assign) int butype;
@end

@implementation RedPacketController
{
    int _i;
    
    NSMutableArray *_arrall;
    NSMutableArray *_arr1;
    NSMutableArray *_arr2;
    int _hongbaotype;
    
    int arrcount;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self colorReset:0];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    if (_tiaozhuan==1) {
    }else{
        [self setButtoncolor];
        [self colorReset:_butype];
    }
    _tiaozhuan=0;
}
-(void)setButtoncolor{
    if (_butype==0) {
        UIButton*button1=[_buttonArray objectAtIndex:0];
        UIButton*button2=[_buttonArray objectAtIndex:1];
        [button1 setTitleColor:MainColor forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (_butype==1)
        
    {
        UIButton*button1=[_buttonArray objectAtIndex:0];
        UIButton*button2=[_buttonArray objectAtIndex:1];
        [button2 setTitleColor:MainColor forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的红包";
    if (_isxinshou==1) {
        [self creatxinshou];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoxunbao) name:@"gotoxunbao" object:nil];
//    查看我的号码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchBtn:) name:@"hongbao" object:nil];
    [self initData];
    UIButton *exchangeBtn = [[UIButton alloc]init];
    exchangeBtn.frame = CGRectMake(0, 0, 80,20);
    exchangeBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [exchangeBtn setTitle:@"兑换红包" forState:(UIControlStateNormal)];
    [exchangeBtn addTarget:self action:@selector(gototoExchange) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:exchangeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xdcfvgbhnjmk:) name:@"wushuju" object:nil];
  
}
-(void)xdcfvgbhnjmk:(NSNotification *)model{
    
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    NewGoodsModel*mymodel=[[NewGoodsModel alloc]init];
    mymodel=model.userInfo[@"model"];
    GoodsDetailsViewController*goods=[[GoodsDetailsViewController alloc]init];
    goods.idd=mymodel.idd;
    goods.tiaozhuantype=1;
    [self.navigationController pushViewController:goods animated:YES];
    }
-(void)gototoExchange
{
    ExchangeRedViewController *red=[[ExchangeRedViewController alloc]init];
    [self.navigationController pushViewController:red animated:YES];
}

#pragma mark - 数据
- (void)initData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:@"1" forKey:@"status"];
    [MDYAFHelp AFPostHost:APPHost bindPath:RedBao postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"====++++%@",responseDic);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
    self.titleArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.titleArray = @[[NSString stringWithFormat:@"可使用"],[NSString stringWithFormat:@"已使用／过期"]];
    self.buttonArray = [NSMutableArray array];
    _i = 0;
     [self createUI];
}
-(void)gotoxunbao{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - UI
- (void)createUI
{
    //    //按钮的view
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
    [self.view addSubview:self.buttonView];
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0,50, self.view.frame.size.width , 4)];
    bjView.backgroundColor = RGBCOLOR(220, 220, 221);
    [self.view addSubview:bjView];
    //选择view
    self.selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width /2, 4)];
    self.selectedView.backgroundColor = MainColor;
    [self.view addSubview:self.selectedView];
    
    for (NSInteger i = 0; i < self.titleArray.count; i ++)
    {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        // self.button.layer.borderWidth = 1;
        self.button.frame = CGRectMake(self.buttonView.frame.size.width / 2 * i, 0, self.buttonView.frame.size.width /2, 30);
        self.button.tag = 101+i;
        //self.button.backgroundColor = [UIColor redColor];
        [self.button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:18];
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
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 54, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    for (NSInteger i = 0; i < 2; i++)
    {
        
        self.tableView = [[RedPacketView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 40)AndNum:[NSString stringWithFormat:@"%li",i + 1]];
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
    
    self.selectedView.frame = CGRectMake(scrollView.contentOffset.x / 2, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width / 2, 4);
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
            self.selectedView.frame = CGRectMake(self.scrollView.contentOffset.x /2, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width / 2, 4);
            DebugLog(@"1");
            _butype=0;
        }
            break;
            
        case 102:
        {
            [self colorReset:1];
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0.0);
            self.selectedView.frame = CGRectMake(self.scrollView.contentOffset.x / 2, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width /2, 4);
            
            
            _butype=1;
            
        }
            DebugLog(@"2");
            
            break;
            
            
    }
}
//红包点击
-(void)touchBtn:(NSNotification *)model
{
    DebugLog(@"===---%@",model.userInfo[@"model"]);
    RedBoxDto*mymodel=[[RedBoxDto alloc]init];
    mymodel=model.userInfo[@"model"];
    GroupRedViewController *group=[[GroupRedViewController alloc]init];
    [self.navigationController pushViewController:group animated:YES];
}
-(void)creatxinshou{
    _blackview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    _blackview.backgroundColor=[UIColor blackColor];
    _blackview.alpha=0.8;
    [self.navigationController.view addSubview:_blackview];
    UIButton*btclose=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,MSW, MSH)];
//    [btclose setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    //    btclose.backgroundColor=[UIColor whiteColor];
    [btclose addTarget:self action:@selector(removeblackview) forControlEvents:UIControlEventTouchUpInside];
    [_blackview addSubview:btclose];
    UIImageView*imgxinshou=[[UIImageView alloc]initWithFrame:CGRectMake(30, 100, MSW-60,MSW-60)];
    imgxinshou.image=[UIImage imageNamed:@"imgxinshou"];
    [_blackview addSubview:imgxinshou];

}
-(void)removeblackview{
    [_blackview removeFromSuperview];
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
