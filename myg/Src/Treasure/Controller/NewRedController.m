//
//  NewRedController.m
//  kl1g
//
//  Created by lili on 16/2/24.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "NewRedController.h"
#import "MyScoreViewController.h"

#import "PWWebViewController.h"
#import "ExtenShareViewController.h"
#import "TopupController.h"
#import "RedPacketController.h"

#import "TudiJiluModel.h"
@interface NewRedController ()<UIScrollViewDelegate>
{
    NSArray*tishiArray;
    
    UIImageView*headimg;
    UIImageView*_imagenum1;
    UIImageView*_imagenum2;
    UIImageView*_imagenum3;
    UIImageView*_imagenum4;
    UIImageView*_imagenum5;
    
    int _isselete;//如果等于1代表第一的完成
    int _isselete2;
    int _isselete3;
    int _isselete4;
    int _isselete5;
    int _isfirst;

}
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UserDataModel *model;

@property (nonatomic)UIScrollView    *mainScrollView;


@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *willArray; //数据源
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation NewRedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"新手红包";
    _isfirst=1;
    _buttonArray=[NSMutableArray array];
    _imageArray=[NSMutableArray array];
    [self refreshData];
    if (_isselete==1) {
        UIButton*btgo=[_buttonArray objectAtIndex:0];
        btgo.hidden=YES;

    }else{
        _imagenum1.image=[UIImage imageNamed:@"red01"];
    }
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    self.num = 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Newbag postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        DebugLog(@"------%@----%@",responseDic,responseDic[@"msg"]);
                NSDictionary*data=responseDic[@"data"];
        NSString*about=data[@"about"];
        if ([about isEqualToString:@"0"]) {
            _isselete=0;
        }else{
            _isselete=1;
        }
        
        NSString*addmoney=data[@"qiandao"];
        if ([addmoney isEqualToString:@"0"]) {
            _isselete2=0;
        }else{
            _isselete2=1;
        }
        
        NSString*qiandao=data[@"tuiguang"];
        if ([qiandao isEqualToString:@"0"]) {
            _isselete3=0;
        }else{
            _isselete3=1;
        }
        
        NSString*tuiguang=data[@"addmoney"];
        if ([tuiguang isEqualToString:@"0"]) {
            _isselete4=0;
        }else{
            _isselete4=1;
        }
        NSString*lingqu=data[@"lingqu"];
        if ([lingqu isEqualToString:@"0"]) {
            _isselete5=0;
        }else{
            _isselete5=1;
        }
        
        [self creatUI];
        
        [self seleteviewpage];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
}

- (void)refreshSuccessful:(id)data
{
   
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
                      NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

            }];
        }
        if ([data[@"code"] isEqualToString:@"400"])
        {
            
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
               
            }];
            
        }
    }
}

- (void)refreshFailure:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    DebugLog(@"失败");
   
}
#pragma mark - 设置滑动时view的状态
-(void)seleteviewpage{


    if (_isselete==1) {
        _imagenum1.image=[UIImage imageNamed:@"orange01"];
        
        UIButton*btgo=[_buttonArray objectAtIndex:0];
        btgo.hidden=YES;
        
        
        
    }else{
        UIImageView*img=[_imageArray objectAtIndex:0];
        img.hidden=YES;
     _imagenum1.image=[UIImage imageNamed:@""];
    }
    if (_isselete2==1) {
        _imagenum2.image=[UIImage imageNamed:@"orange02"];
        UIButton*btgo=[_buttonArray objectAtIndex:1];
        btgo.hidden=YES;
        
    }else{
        UIImageView*img=[_imageArray objectAtIndex:1];
        img.hidden=YES;
        _imagenum2.image=[UIImage imageNamed:@""];
    }
    if (_isselete3==1) {
        _imagenum3.image=[UIImage imageNamed:@"orange03"];
        UIButton*btgo=[_buttonArray objectAtIndex:2];
        btgo.hidden=YES;
        
    }else{
        
        UIImageView*img=[_imageArray objectAtIndex:2];
        img.hidden=YES;
        _imagenum3.image=[UIImage imageNamed:@""];
    }
    if (_isselete4==1) {
        _imagenum4.image=[UIImage imageNamed:@"orange04"];
        
        UIButton*btgo=[_buttonArray objectAtIndex:3];
        btgo.hidden=YES;
    }else{
        
        
        UIImageView*img=[_imageArray objectAtIndex:3];
        img.hidden=YES;
        _imagenum4.image=[UIImage imageNamed:@""];
    }
    if (_isselete5==1) {
        _imagenum5.image=[UIImage imageNamed:@"orange06"];
        
        UIButton*btgo=[_buttonArray objectAtIndex:4];
//        btgo.hidden=YES;
        [btgo setTitle:@"已领取" forState:UIControlStateNormal];
        btgo.userInteractionEnabled=NO;
        btgo.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [btgo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else{
        
        UIImageView*img=[_imageArray objectAtIndex:4];
        img.hidden=YES;
        _imagenum5.image=[UIImage imageNamed:@""];
    }
    
   
    //判断是否第一次进入页面
    if (_isfirst==1) {
        _imagenum1.image=[UIImage imageNamed:@"red01"];

        _isfirst=2;
    }else{
    
    }
    
    
    
}

#pragma mark -创建UI
-(void)creatUI{
    
    tishiArray=@[@"查看［关于我们］\n浏览至少30秒钟获得奖励",@"签到页面选择签到方式进行签到",@"点击弹出分享对话框，微信朋友圈，微信好友圈，QQ空间，QQ好友，新浪微博任选一",@"点击跳转到充值界面，充值任意金额完成即可",@"马上领取1米币红包"];
    _mainScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,70, [UIScreen mainScreen].bounds.size.width, MSH-64-70)];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.showsHorizontalScrollIndicator=NO;
    _mainScrollView.showsVerticalScrollIndicator=NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.scrollEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    
    _mainScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*5, MSH-64-70);
    [self.view addSubview:_mainScrollView];
    
    
   
    
    headimg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 20, MSW-80, 40)];
    headimg.backgroundColor=[UIColor clearColor];
     headimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"headred1"]];
    [self.view addSubview:headimg];
//    for (int i=0; i<5; i++) {
//        UIImageView*imgnum=[[UIImageView alloc]initWithFrame:CGRectMake(headimg.frame.size.width/9*i+2, 0, (headimg.frame.size.width/9)-1, 40)];
//        imgnum.backgroundColor=[UIColor greenColor];
//        [headimg addSubview:imgnum];
//
//    }
//
    
    _imagenum1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headimg.frame.size.width/8+5, 40)];
    _imagenum1.backgroundColor=[UIColor clearColor];
    _imagenum1.image=[UIImage imageNamed:@"red01"];
    [headimg addSubview:_imagenum1];
    
    _imagenum2=[[UIImageView alloc]initWithFrame:CGRectMake(headimg.frame.size.width/8*2-8, 0, headimg.frame.size.width/8+5, 40)];
    _imagenum2.backgroundColor=[UIColor clearColor];
    _imagenum2.image=[UIImage imageNamed:@"orange02"];
    [headimg addSubview:_imagenum2];
    
    _imagenum3=[[UIImageView alloc]initWithFrame:CGRectMake(headimg.frame.size.width/8*4-19, 0, headimg.frame.size.width/8+IPhone4_5_6_6P(6, 6, 5, 5), 40)];
    _imagenum3.backgroundColor=[UIColor clearColor];
    _imagenum3.image=[UIImage imageNamed:@"orange03"];
    [headimg addSubview:_imagenum3];
    
    _imagenum4=[[UIImageView alloc]initWithFrame:CGRectMake(headimg.frame.size.width/8*6-IPhone4_5_6_6P(30, 30, 33, 33), 0, headimg.frame.size.width/8+IPhone4_5_6_6P(6, 6, 5, 5), 40)];
    _imagenum4.backgroundColor=[UIColor clearColor];
    _imagenum4.image=[UIImage imageNamed:@"orange04"];
    [headimg addSubview:_imagenum4];
    
    
    _imagenum5=[[UIImageView alloc]initWithFrame:CGRectMake(headimg.frame.size.width-IPhone4_5_6_6P(39, 39, 44, 44), 0, headimg.frame.size.width/8+IPhone4_5_6_6P(6, 6, 5, 5), 40)];
    _imagenum5.backgroundColor=[UIColor clearColor];
    _imagenum5.image=[UIImage imageNamed:@"orange06"];
    [headimg addSubview:_imagenum5];
    
    
    
    
    for (int i=0; i<5; i++) {
        
        UIImageView*imglook=[[UIImageView alloc]initWithFrame:CGRectMake(MSW*i+40, 0, MSW-80, MSH-IPhone4_5_6_6P(230, 260, 260, 260))];
        imglook.backgroundColor=[UIColor clearColor];
        imglook.image=[UIImage imageNamed:[NSString stringWithFormat:@"newred%i.jpg",i]];
        [_mainScrollView addSubview:imglook];
        
        UIImageView*imgyinzhang=[[UIImageView alloc]initWithFrame:CGRectMake(imglook.frame.size.width/2-77, imglook.frame.size.height/2-61, 155, 123)];
        imgyinzhang.backgroundColor=[UIColor clearColor];
        imgyinzhang.image=[UIImage imageNamed:@"印章"];
        [_imageArray addObject:imgyinzhang];
        [imglook addSubview:imgyinzhang];
        
        
        
        
        UILabel *lbtishi=[[UILabel alloc]initWithFrame:CGRectMake(MSW*i+40, imglook.frame.origin.y+imglook.frame.size.height+5, MSW-80, IPhone4_5_6_6P(40, 50, 50, 50))];
        
        lbtishi.numberOfLines=0;
        lbtishi.backgroundColor=[UIColor clearColor];
        lbtishi.font=[UIFont systemFontOfSize:MiddleFont];
        lbtishi.textAlignment=UITextAlignmentCenter;
        lbtishi.text=[tishiArray objectAtIndex:i];
        [_mainScrollView addSubview:lbtishi];
        
        
        UIButton*btgoto=[[UIButton alloc]initWithFrame:CGRectMake(MSW*i+40, MSH-74-70-IPhone4_5_6_6P(40, 50, 50, 50), MSW-80, IPhone4_5_6_6P(40, 50, 50, 50))];
        
        if (i==4) {
            [btgoto setTitle:@"立即领取" forState:UIControlStateNormal];
            
        }else{
            [btgoto setTitle:@"立即完成" forState:UIControlStateNormal];
            
        }
        [btgoto addTarget:self action:@selector(lijiwancheng:) forControlEvents:UIControlEventTouchUpInside];
        [btgoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btgoto.layer.masksToBounds=YES;
        btgoto.layer.cornerRadius = 5;
        btgoto.tag=i;
        
        btgoto.backgroundColor=MainColor;
        [_mainScrollView addSubview:btgoto];
        
        [_buttonArray addObject:btgoto];
    }
    
//    [self setbuttonarrayhidden];
}

-(void)setbuttonarrayhidden{
    
    UIButton*btgo=[_buttonArray objectAtIndex:_isselete-1];
    btgo.hidden=YES;


}

#pragma mark - 滚动视图监听事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    int page=_mainScrollView.contentOffset.x/MSW+1;
//    DebugLog(@"===---第%i页",page);
    [self seleteviewpage];
    headimg.image=[UIImage imageNamed:[NSString stringWithFormat:@"headred%i",page]];
    

    if (page==1) {
        _imagenum1.image=[UIImage imageNamed:@"red01"];
    }
    else if (page==2){
     _imagenum2.image=[UIImage imageNamed:@"red02"];

    }
    else if (page==3){
        _imagenum3.image=[UIImage imageNamed:@"red03"];
        
    }
    else if (page==4){
        _imagenum4.image=[UIImage imageNamed:@"red04"];
        
    }else{
    
        _imagenum5.image=[UIImage imageNamed:@"red05"];
        

    }
    
 
}
-(void)lijiwancheng:(UIButton*)sender{
    if (sender.tag==0) {

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
            [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
            //    [dict setValue:_url forKey:@"url"];
            //     DebugLog(@"==========%@",dict[@"code"]);
            [MDYAFHelp AFPostHost:APPHost bindPath:AboutUs postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                DebugLog(@"===================%@",responseDic);
                if([responseDic[@"code"] isEqualToString:@"200"])
                {
                    PWWebViewController *web = [[PWWebViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseDic[@"data"]]]];
                    web.showToolBar = NO;
                    web.hidesBottomBarWhenPushed = YES;
                    //  关于我们
                    web.navtitle = @"关于我们";
                    [self.navigationController pushViewController:web animated:YES];
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               [SVProgressHUD showErrorWithStatus:@"网络不给力"];
                
            }];
            
      
    }else if (sender.tag==1){
        if ([UserDataSingleton userInformation].isLogin == YES)
        {
            MyScoreViewController *score=[[MyScoreViewController alloc]init];
            score.hidesBottomBarWhenPushed=YES;
            score.model = _model;
            [self.navigationController pushViewController:score animated:YES];            }
        else
        {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else if (sender.tag==2){
        ExtenShareViewController *share=[[ExtenShareViewController alloc]init];
        [self.navigationController pushViewController:share animated:YES];
    }else if (sender.tag==3){
        
        if ([UserDataSingleton userInformation].isLogin == YES)
        {
        TopupController *userData = [[TopupController alloc]init];
        userData.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userData animated:YES];
        }
        else
        {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        

    }else {
        
        if ([UserDataSingleton userInformation].isLogin == YES)
        {
//            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
            [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
            //    [dict setValue:@"99" forKey:@"cateid"];
            
            [MDYAFHelp AFPostHost:APPHost bindPath:Gethongbao postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
                DebugLog(@"------%@----%@",responseDic,responseDic[@"msg"]);
                NSDictionary*data=responseDic[@"data"];
                RedPacketController *red=[[RedPacketController alloc]init];
                //                self.hidesBottomBarWhenPushed = NO;
                red.hidesBottomBarWhenPushed=YES;
                red.tiaozhuan=1;
                red.isxinshou=1;
                [self.navigationController pushViewController:red animated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
               [SVProgressHUD showErrorWithStatus:@"网络不给力"];
                
            }];
 }
        else
        {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }

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
