//
//  BootPageViewController.m
//  BaoZhen
//
//  Created by lili on 15/9/25.
//  Copyright (c) 2015年 JuHuiTuan. All rights reserved.
//

#import "BootPageViewController.h"
#import "AppDelegate.h"

@interface BootPageViewController ()<UIScrollViewDelegate>{
    UIScrollView        *_scrollView;
    UIPageControl       *_pageControl;
}

@end

@implementation BootPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake( MSW * 3, MSH);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"引导页1",@"引导页2",@"引导页3",nil];
    for (NSInteger k = 0; k < [array count]; k ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0 * k, 0, MSW, MSH)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.image = [UIImage imageNamed:array[k]];
        [_scrollView addSubview:imgView];
    }
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MSW * 2 + 30, MSW - 80, MSW - 60, 50)];
    btn.backgroundColor = MainColor;
    [btn setTitle:@"开始夺宝" forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(bootPageTouch) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    
     
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, MSW - 50, MSW - 20, 30)];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self.view addSubview:_pageControl];
}

-(void)bootPageTouch{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    DLog(@"%f",scrollView.contentOffset.x)
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        
    }else{
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        _pageControl.currentPage = index;
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
