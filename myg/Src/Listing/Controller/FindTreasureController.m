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

#import "RefreshView.h"

@interface FindTreasureController ()<PullingRefreshTableViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

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
@end

@implementation FindTreasureController
{
    NSInteger _i;
    
    NSMutableArray *_arrall;
    NSMutableArray *_arr1;
    NSMutableArray *_arr2;
    
    int arrcount;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"寻宝记录";
    
    
    _arr1=[NSMutableArray array];
    _arr2=[NSMutableArray array];
    _arrall=[NSMutableArray array];
    
    
    [self initData];
    [self createUI];
    
}

#pragma mark - 数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    self.titleArray = @[@"全部（3）",@"进行中（1）",@"已揭晓（2）"];
    self.buttonArray = [NSMutableArray array];
    _i = 0;
}

#pragma mark - UI
- (void)createUI
{
    //按钮的view
    self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
    
    [self.view addSubview:self.buttonView];
    
    UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width , 4)];
    bjView.backgroundColor = RGBCOLOR(220, 220, 221);
    [self.view addSubview:bjView];
    //选择view
    self.selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width /3, 4)];
    self.selectedView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.selectedView];
    
    for (NSInteger i = 0; i < self.titleArray.count; i ++)
    {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        // self.button.layer.borderWidth = 1;
        self.button.frame = CGRectMake(self.buttonView.frame.size.width / 3 * i, 0, self.buttonView.frame.size.width /3, 30);
        self.button.tag = 101+i;
        //self.button.backgroundColor = [UIColor redColor];
        [self.button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:18];
        // self.button.backgroundColor = [UIColor yellowColor];
        [self.button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        if (self.button.tag == 101)
        {
            [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        [self.buttonView addSubview:self.button];
        [self.buttonArray addObject:self.button];
        
        
    }
    //滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.selectedView.frame.size.height + self.selectedView.frame.origin.y , self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 3, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    for (NSInteger i = 0; i < 3; i++)
    {
        
        
        self.tableView = [[RefreshView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 40)];
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
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
            
        }
            break;
            
        case 102:
        {
            [self colorReset:1];
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0.0);
            self.selectedView.frame = CGRectMake(self.scrollView.contentOffset.x / 3, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width /3, 4);
            
        }
            DebugLog(@"2");
            
            break;
        case 103:
        {
            [self colorReset:2];
            self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*2, 0.0);
            self.selectedView.frame = CGRectMake(self.scrollView.contentOffset.x / 3, self.buttonView.frame.size.height + self.buttonView.frame.origin.y, self.view.frame.size.width /3, 4);
            
            
        }
            DebugLog(@"2fredwsa");
            
            break;
            
    }
    
    //    [self.tableView reloadData];
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
