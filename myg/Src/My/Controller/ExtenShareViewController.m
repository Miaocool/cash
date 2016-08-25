//
//  ExtenShareViewController.m
//  yyxb
//
//  Created by mac03 on 15/11/26.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ExtenShareViewController.h"
#import "PWWebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "EGOImageLoader.h"

@interface ExtenShareViewController ()<UITextViewDelegate>{
    UITextView              *_shareView;  //分享推广内容
    UILabel                 *_lab;    //文字lab
    UILabel                 *_shouyiLab;  //下方推广收益label
    NSString                *_url;      //下载页url
    NSString                *_title;    //推广标题
    NSString                *_content;   //推广内容
    NSString                *_imgurl;  //头像url
}

@end

@implementation ExtenShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"邀请好友";
    self.view.backgroundColor=RGBCOLOR(236, 235, 241);
    [self getShareData];
    [self initialize];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    
}
//获取分享请求
-(void)getShareData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
//    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    DebugLog(@"=====%@",dict);
    [MDYAFHelp AFPostHost:APPHost bindPath:Share postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"==============%@=====%@",responseDic[@"msg"],responseDic);
         if ([responseDic[@"code"] isEqualToString:@"200"])
        {
             NSDictionary*data=responseDic[@"data"];
            _shareView.text=data[@"content"];
            _shouyiLab.text=data[@"shouyi"];
            _url=data[@"url"];
            _title=data[@"title"];
            _content=data[@"content"];
            _imgurl=data[@"imgurl"];
//            DebugLog(@"==%@==%@==%@==%@==%@==%@",_shareView.text,_url,_title,_shouyiLab.text,_content,_imgurl);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
}

-(void)initialize
{
    _shareView = [[UITextView alloc] initWithFrame:CGRectMake(20, 15, MSW-40, 100)];
    _shareView.delegate = self;
    _shareView.returnKeyType = UIReturnKeyDone;
    _shareView.layer.borderWidth = 1.0;
    _shareView.layer.cornerRadius=5.0;
//    _shareView.text=@"推荐号码:88888史上最强的众筹抢购APP！";
    _shareView.textColor=RGBCOLOR(65, 65, 65);
    _shareView.backgroundColor = [UIColor whiteColor];
    _shareView.layer.borderColor = [UIColor colorWithHex:@"#CECFD0"].CGColor;
    [self.view addSubview:_shareView];
    
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake((MSW-200)/2, _shareView.bottom+40, 200, 40)];
    [shareBtn setBackgroundColor:MainColor];
    shareBtn.layer.cornerRadius=5.0;
    [shareBtn setTitle:@"选择分享平台" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
    [self.view addSubview:shareBtn];
    
    _lab=[[UILabel alloc]initWithFrame:CGRectMake(20, shareBtn.bottom+10, MSW-40, 90)];
    _lab.text=@"每天分享到朋友圈和QQ空间，用户注册即可获得1000积分，新用户注册时填写的推广人为您徒弟，徒弟邀请好友注册或充值，系统将会赠送您相应的积分。";
    _lab.textColor=RGBCOLOR(65, 65, 65);
    _lab.numberOfLines=0;
    _lab.lineBreakMode = NSLineBreakByCharWrapping;
    _lab.backgroundColor=[UIColor clearColor];
    _lab.font=[UIFont systemFontOfSize:15];
//    [self.view addSubview:_lab];
    
    _shouyiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, shareBtn.bottom+30, MSW-40, 150)];
//    _shouyiLab.text=@"徒弟越多收益越多 1.一级徒弟收益5%  2.二级徒弟收益3%  3.三级徒弟收益1%  4.推广送积分1000   您的分享页被新用户浏览时可获得1000积分";
    _shouyiLab.textColor=MainColor;
    _shouyiLab.numberOfLines=0;
    _shouyiLab.lineBreakMode = NSLineBreakByCharWrapping;
    _shouyiLab.backgroundColor=[UIColor clearColor];
    _shouyiLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_shouyiLab];
    
}
//点击分享
-(void)shareClick
{
//    DebugLog(@"hhh %@",_shareView.text);
    UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:_imgurl] shouldLoadWithObserver:nil];
    
    //构造分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",_content]
   
                                            defaultContent:nil
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:_title
                                                  url:_url
                                          description:_shareView.text
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
                                    [self sharessuccess];
                                    
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:_shareView.text]) {
        textView.text = @"";
        textView.textColor=[UIColor blackColor];
    }
    
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_shareView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"";
    }
    [_shareView resignFirstResponder];
}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{   if(textView==_shareView)
//   {
//       [_shareView resignFirstResponder];
//     }
//    return YES;
//}


-(void)sharessuccess{

    DebugLog(@"分享成功＝＝＝＝＝");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     [dict setValue:@"1" forKey:@"status"];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
   
    //    [dict setValue:_url forKey:@"url"];
    //     DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:AddTuiGuang postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"====%@-----%@",responseDic,responseDic[@"msg"]);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];

}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
