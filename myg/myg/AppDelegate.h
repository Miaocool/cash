//
//  AppDelegate.h
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) ListingViewController *listingVC;
@property (nonatomic, strong) UITabBarItem *tabBar5;
+ (AppDelegate *)currentAppDelegate;

@end

