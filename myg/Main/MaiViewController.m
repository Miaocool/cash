//
//  JHMaiViewController.m
//  就医助手_患者端
//
//  Created by 杨易 on 15/7/23.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"
#import "MBProgressHUD.h"


@interface MaiViewController ()
   


@end

@implementation MaiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    //兼容IOS7

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNaviWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:20],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self addLeftItem];
    
    
    

}


- (void)addLeftItem
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPhone4_5_6_6P(60, 60, 85, 100), 44)];
    view.backgroundColor = [UIColor clearColor];
    
    
     self.left = [UIButton buttonWithType:UIButtonTypeCustom];
     self.left.frame = CGRectMake(0, 0, IPhone4_5_6_6P(60, 60, 85, 100), 44);
     self.left.backgroundColor = [UIColor clearColor];
    [self.left addTarget:self action:@selector(backForePage) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview: self.left];
    
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back-1.png"]];
    arrow.frame = CGRectMake(15,(44 - 20) / 2.0, 13, 20);
    arrow.backgroundColor = [UIColor clearColor];
    
    [self.left addSubview:arrow];
    
    //    if (self.isNeedBackIcon) {
    //        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    //        icon.frame = CGRectMake(30, 9.5, 60, 25);
    //        icon.backgroundColor = [UIColor clearColor];
    //        [left addSubview:icon];
    //    }
    
    //   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -16;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    
}

- (void)backForePage
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)getViewWidth
{
    return CGRectGetWidth(self.view.bounds);
}

- (CGFloat)getViewHeight;
{
    return CGRectGetHeight(self.view.bounds);
}




+ (UIColor *)colorFromHex:(NSString *)hexString {
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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
