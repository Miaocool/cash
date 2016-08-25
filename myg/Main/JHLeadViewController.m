//
//  JHLeadViewController.m
//  就医助手_患者端
//
//  Created by 杨易 on 15/7/20.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "JHLeadViewController.h"

#import "HomeViewController.h"

#import "LatestAnnouncedViewController.h"

#import "FoundViewController.h"

#import "ListingViewController.h"

#import "MyViewController.h"
#import "OrdershareController.h"
#import "NavViewController.h"


@interface JHLeadViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pagControl;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITabBarItem *tabBar5;
@end

@implementation JHLeadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.

}



#pragma mark - 创建引导界面
- (void) createUI
{
    //设置滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 4, 0);
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (NSInteger i = 0; i < 4; i++)
    {
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"引导页%lu",i+1]]];
        self.imageView.frame = CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        self.imageView.tag = 101 + i ;
      //  self.imageView.backgroundColor = [UIColor greenColor];
        [self.scrollView addSubview:self.imageView];
        
    }
    [self.view addSubview:self.scrollView];
    
//    //设置pagControl
//    self.pagControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height / 1.2,100,30 )];
//    self.pagControl.numberOfPages = 4;
//    self.pagControl.currentPage = 0;
//    self.pagControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    self.pagControl.currentPageIndicatorTintColor = MainColor;
//    [self.view addSubview:self.pagControl];
    
    //创建按钮 260 *64
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.bounds.size.width / 2 - 80, IPhone4_5_6_6P(MSH - 125, MSH - 140, MSH - 145, MSH - 160) , 160, 81);
    btn.layer.cornerRadius = 10;
    btn.backgroundColor = [UIColor clearColor];

//    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn setTitleColor:MainColor forState:UIControlStateNormal];
//    btn.layer.borderWidth = 1;
//    btn.layer.cornerRadius = 5;
//    btn.layer.borderColor = MainColor.CGColor;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.scrollView addSubview:btn];
    if (self.imageView.tag == 104)
    {
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addSubview:btn];
        
    }
}


-(void)buttonClick:(UIButton *)btn
{
    //
    HomeViewController *takeVC = [[HomeViewController alloc]init];
    takeVC.title = @"米云购";
    NavViewController *takeVCNav = [[NavViewController alloc]initWithRootViewController:takeVC];
    UITabBarItem *tabBar1 = [[UITabBarItem alloc]initWithTitle:@"首页" image: [UIImage imageNamed:@"tabbar_cart (3)"]selectedImage: [UIImage imageNamed:@"tabbar_selected (6)"]];
    takeVCNav.tabBarItem = tabBar1;
    
    
    
    LatestAnnouncedViewController *latestVC = [[LatestAnnouncedViewController alloc]init];
    latestVC.title = @"最新揭晓";
    NavViewController *latestNav = [[NavViewController alloc]initWithRootViewController:latestVC];
    UITabBarItem *tabBar2 = [[UITabBarItem alloc]initWithTitle:@"最新揭晓" image: [UIImage imageNamed:@"tabbar_cart (4)"]selectedImage: [UIImage imageNamed:@"tabbar_selected (7)"]];
    latestNav.tabBarItem = tabBar2;
    
    OrdershareController *foundVC = [[OrdershareController alloc]init];
    foundVC.title = @"晒单";
    NavViewController *foundNav = [[NavViewController alloc]initWithRootViewController:foundVC];
    UITabBarItem *tabBar3 = [[UITabBarItem alloc]initWithTitle:@"晒单" image: [UIImage imageNamed:@"tabbar_cart (5)"]selectedImage: [UIImage imageNamed:@"tabbar_selected (8)"]];
    foundNav.tabBarItem = tabBar3;
    
    
    
   ListingViewController *listingVC= [[ListingViewController alloc]init];
    listingVC.title = @"清单";
    NavViewController *listingNav = [[NavViewController alloc]initWithRootViewController:listingVC];
    self.tabBar5 = [[UITabBarItem alloc]initWithTitle:@"清单" image: [UIImage imageNamed:@"tabbar_cart (6)"]selectedImage: [UIImage imageNamed:@"tabbar_selected (9)"]];
    
    listingNav.tabBarItem = self.tabBar5;
    
    MyViewController *myVC = [[MyViewController alloc]init];
    myVC.title = @"我的";
    NavViewController *myNav = [[NavViewController alloc]initWithRootViewController:myVC];
    UITabBarItem *tabBar4 = [[UITabBarItem alloc]initWithTitle:@"我" image: [UIImage imageNamed:@"tabbar_cart (2)"]selectedImage: [UIImage imageNamed:@"tabbar_selected (5)"]];
    myNav.tabBarItem = tabBar4;
    
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    
    [tabBar setViewControllers:@[takeVCNav,latestNav,foundNav,listingNav,myNav]];
    [tabBar.tabBar setTintColor:MainColor];

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = tabBar;
}




#pragma mark - 滚动视图协议
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.pagControl.currentPage = scrollView.contentOffset.x/self.view.bounds.size.width;
    
    
    
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
