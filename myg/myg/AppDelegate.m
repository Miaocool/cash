//
//  AppDelegate.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AppDelegate.h"
#import "BootPageViewController.h"
#import "TakeTreasureViewController.h"
#import "LatestAnnouncedViewController.h"
#import "FoundViewController.h"
#import "ListingViewController.h"
#import "MyViewController.h"
#import "HomeViewController.h"
//分享SDK
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

//微信
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
//#import "WeiboSDK.h"

//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "DataVerifier.h"
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import "OrdershareController.h"

#import "HomeViewController.h"
#import "BPush.h"  //推送

#import "JHLeadViewController.h"

#import "UITabBar+badge.h"

#import "NavViewController.h"
#import "LogisticInfoVC.h"
@interface AppDelegate ()<WXApiDelegate>
{
    NSString *Newurl;
    NSString *Renew;
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
    //修改启动页停留时间
    [NSThread sleepForTimeInterval:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNumber) name:@"shoppingNum" object:nil];

    /////微信
    [WXApi registerApp:@"wx2eaf4239965c0191" withDescription:@"demo 2.0"];

    [ShareSDK registerApp:@"14eca0399414a"];//shareSDK的AppKey
    
//  //  添加新浪微博应用 注册网址
//    [ShareSDK connectSinaWeiboWithAppKey:@"4035171944"
//                            appSecret:@"6a7bce06fc94a62a97a3c2b7be67cfbf"
//                             redirectUri:XinLang];
//    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:@"4035171944"
//                        appSecret:@"6a7bce06fc94a62a97a3c2b7be67cfbf"
//                            redirectUri:XinLang
//                            weiboSDKCls:[WeiboSDK class]];
    
      //添加QQ空间应用  注册网址
    [ShareSDK connectQZoneWithAppKey:@"1105468241"
                           appSecret:@"7r9wpNa9X47imQeK"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址
    [ShareSDK connectQQWithQZoneAppKey:@"1105468241"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx2eaf4239965c0191"
                           appSecret:@"404cd515368aee705cb8f73bd976cb10"
                           wechatCls:[WXApi class]];
    
    
    // iOS8 上需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    //从服务器动态获取推送key
    [self httpGetPromptWithLaunchOptions:launchOptions];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [self userLogin];
    //检测版本更新
    [self checkVersion];

    [self.window makeKeyAndVisible];
    
    // 判断引导是否第一次加载
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"])
    {
        JHLeadViewController *boot = [[JHLeadViewController alloc]init];
        
        self.window.rootViewController = boot;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    else
    {
        [self setTabBar];
    }

    //改变状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}



#pragma mark 从服务器动态获取推送key
- (void)httpGetPromptWithLaunchOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@"2" forKey:@"type"];
    [dict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"ver"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Prompt postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"res = %@",responseDic);
        if ([EncodeFormDic(responseDic, @"code") isEqualToString:@"200"]) {
            
            NSDictionary *dataDic = responseDic[@"data"];
            
            NSString *bPushKey = EncodeFormDic(dataDic, @"bd_pushkey");
            
            //#warning 上线 AppStore 时需要修改 pushMode 需要修改Apikey为自己的Apikey
            // 在 App 启动时注册百度云推送服务，需要提供 Apikey
            //  企业 60pDiM16ye7CwbZRWMbuNffZ    商店 j9jDdNOKYySHgl8MXCUf8kiI
            [BPush registerChannel:launchOptions apiKey:bPushKey pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
            // App 是用户点击推送消息启动
            NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (userInfo) {
                //  DebugLog(@"从消息启动:%@",userInfo);
                [BPush handleNotification:userInfo];
            }
            
            //角标清0
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            /*
             // 测试本地通知
             [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
             */
            
            //是否开启一键加群
            [UserDataSingleton userInformation].is_qq = EncodeFormDic(dataDic, @"is_qq");
            //一键加群的key
            [UserDataSingleton userInformation].qq_groupkey = EncodeFormDic(dataDic, @"qq_groupkey");
            //是否开启推送
            [UserDataSingleton userInformation].is_push = EncodeFormDic(dataDic, @"is_push");

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma -判断是否升级
-(void)checkVersion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
//    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
//    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [dict setValue:@"2" forKey:@"type"];

    DebugLog(@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:GoOnVersion postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);

        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            [self refreshSuccessful:responseDic];
        }
        else if([responseDic[@"code"] isEqualToString:@"201"])
        {
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"" message:responseDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView1 show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];

}
-(void)refreshSuccessful:(id)data{
    
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *dic = data[@"data"];
            Newurl=dic[@"newurl"];
            // 获取 是否要强制升级的字段
            NSString * verFlag=dic[@"renew"];
            if ([verFlag isEqualToString:@"1"]) {
                
            }
            else if ([verFlag isEqualToString:@"2"])
            {
                // 可选择是否升级
                UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"发现新版本！" message:nil delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立即下载", nil];
                alert.tag = 1234;
                [alert show];
            }
            else if ([verFlag isEqualToString:@"3"])
            {
                // 强制升级
                UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"发现新版本！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即下载", nil];
                alert.tag = 5678;
                [alert show];
                
            }
            
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //可选择的代理方法
    if (alertView.tag ==1234)
    {
        // buttonIndex ==1 用户选择了去下载
        if (buttonIndex ==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Newurl]];
        }
    }
    else if (alertView.tag ==5678)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Newurl]];
    }
}


#pragma mark - 分栏
- (void)setTabBar
{
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
    
    
    self.listingVC= [[ListingViewController alloc]init];
    self.listingVC.title = @"清单";
    NavViewController *listingNav = [[NavViewController alloc]initWithRootViewController:self.listingVC];
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
   
    self.window.rootViewController = tabBar;
    


}

- (void)changeNumber
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//    UITabBar *tabBar = tabBarController.tabBar;
//    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:3];
//
//    tabBarItem1.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
//    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
//    {
//        tabBarItem1.badgeValue = nil;
//    }
    
    //显示
    [tabBarController.tabBar showBadgeOnItemIndex:3 withNum:[NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count]];
    
    if ([UserDataSingleton userInformation].shoppingArray.count == 0)
    {
        //隐藏
        [tabBarController.tabBar hideBadgeOnItemIndex:3];
    }

}

#pragma mark - 判断用户是否登陆
- (void)userLogin
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    if ([[userDefaultes objectForKey:@"uid"] length] > 0 && [userDefaultes objectForKey:@"code"])
    {
        [UserDataSingleton userInformation].uid = [userDefaultes objectForKey:@"uid"];
        [UserDataSingleton userInformation].code = [userDefaultes objectForKey:@"code"];
        [UserDataSingleton userInformation].isLogin = YES;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    DebugLog(@"!!!!!!!!!!!!!!!!!!!code:%@------uid:%@",[UserDataSingleton userInformation].code,[UserDataSingleton userInformation].uid);
    [MDYAFHelp AFPostHost:APPHost
                 bindPath:UserData
                postParam:dict
                 getParam:nil
                  success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"responseDic==============%@",responseDic[@"msg"]);
        DebugLog(@"responseDic==============%@",responseDic[@"code"]);

        if ([responseDic[@"code"] isEqualToString:@"400"] || [responseDic[@"code"] isEqualToString:@"302"])
        {
            [UserDataSingleton userInformation].uid = nil;
            [UserDataSingleton userInformation].code = nil;
            [UserDataSingleton userInformation].isLogin = NO;
        }
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            
            if ([[userDefaultes objectForKey:@"uid"] length] > 0 && [userDefaultes objectForKey:@"code"])
            {
                [UserDataSingleton userInformation].uid = [userDefaultes objectForKey:@"uid"];
                [UserDataSingleton userInformation].code = [userDefaultes objectForKey:@"code"];
                [UserDataSingleton userInformation].isLogin = YES;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    if([urlStr hasPrefix:@"wx2eaf4239965c0191://pay"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    DebugLog(@"%@,%@,%@,%@",application,url,sourceApplication,annotation);
    DebugLog(@"URL:===================%@",url);
    
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DebugLog(@"result = %@",resultDic);
        }];
    }
    else  if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            DebugLog(@"result = %@",resultDic);
        }];
    }

   else
   {
       NSString *strurl = [NSString stringWithFormat:@"%@",url];
       if([strurl hasPrefix:@"openAlipayH5.com.bxsapp.myg://"])
       {
           NSString  *a = [NSString stringWithFormat:@"%@",url];
           NSString *b=[a substringWithRange:NSMakeRange(30, 3)];
           DebugLog(@"---////--%@",b);
           
           NSString  *c = [NSString stringWithFormat:@"%@",url];
           NSString *d=[c substringWithRange:NSMakeRange(34, 18)];
           DebugLog(@"---////--%@",d);
           
           [[NSNotificationCenter defaultCenter] postNotificationName:@"UPPAYSUCCESS" object:nil userInfo:@{@"code":b,@"ordernumber":d}];
       }
       else
       {
           
           NSString *urlStr = [NSString stringWithFormat:@"%@",url];
           
           if([urlStr hasPrefix:@"wx2eaf4239965c0191://pay"])
           {
               return [WXApi handleOpenURL:url delegate:self];
           }
           else
           {
               [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiPAYSUCCESS" object:nil userInfo:nil];
               
               return [ShareSDK handleOpenURL:url
                            sourceApplication:sourceApplication
                                   annotation:annotation
                                   wxDelegate:self];
           }
           
       }

   }
    
       return YES;
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DebugLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYS" object:nil];
            }
                break;
            default:
            {
                DebugLog(@"retcode=%d",resp.errCode);
                if (resp.errCode == -2) {
                    DebugLog(@"用户取消");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYC" object:nil];
                }else if (resp.errCode == -1){
                    DebugLog(@"支付失败");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINPAYF" object:nil];
                    
                }
            }
                break;
        }
    }
}


#pragma mark custom methods
+ (AppDelegate *)currentAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DebugLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        
        //    DLog(@"%@",result)
        NSDictionary *dic = result;
        NSString *channelId1 = EncodeFormDic(dic, @"channel_id");
        NSDictionary *response_params = dic[@"response_params"];
        NSString *channelId3 = EncodeFormDic(response_params, @"channel_id");
        [UserDataSingleton userInformation].channelId = [channelId1 isEqualToString:@""]?channelId3:channelId1;
        DebugLog(@"%@",[UserDataSingleton userInformation].channelId);
        
        //EncodeFormDic(response_params, @"appid"),
        //EncodeFormDic(response_params, @"channel_id"),
        //EncodeFormDic(response_params, @"user_id")
        
    }];
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DebugLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // App 收到推送的通知
    DebugLog(@"%@",userInfo);
    [BPush handleNotification:userInfo];
    DebugLog(@"收到通知:%@", [self logDic:userInfo]);
//    HomeViewController *home=(HomeViewController *)[[[self.tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
//    [home getAPNS:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    DebugLog(@"%@",userInfo);
    [BPush handleNotification:userInfo];
    DebugLog(@"收到通知:%@", [self logDic:userInfo]);
    
    //    [self.tabBarController getAPNS:userInfo];
//    HomeViewController *home = (HomeViewController *)[UITabBarController objectAtIndex:0];
//    HomeViewController *home=[[HomeViewController alloc]init];
//    [home getAPNS:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
    DebugLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return [str stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}










@end
