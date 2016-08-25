//
//  SharedetailController.m
//  yyxb
//
//  Created by lili on 15/11/13.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "SharedetailController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "GoodsDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "OrdershareModel.h"
#import <ShareSDK/ShareSDK.h>
#import "DateHelper.h"
#import "EGOImageLoader.h"
#import "PersonalcenterController.h"
#import "FoundViewCell.h"

#import "ShaidanCommentCell.h"
#import "DateHelper.h"
#import "CommentController.h"
#import "CommentModel.h"
#import "ImageSize.h"

#import "CalculateDetailController.h"
@interface SharedetailController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{

    NSMutableArray*_imgArray;
    OrdershareModel*model;
    UIImageView*img;
    
    NSArray*cellarr;
    
     double cellhight;
    UILabel*sharinfo;
    NSArray*commentarry;
    
    UIView *footview;
    UIImageView*imgzan;
    UILabel *lbzan;
    int iscunzai;//判断图标是否存在
    UIButton *buzan;
    
    double  _imagesize;
    UILabel*lbjisuan;
    
}

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) NSMutableArray *titleArray; //标题
@property (nonatomic, strong) NSMutableArray *imgArray; //图片
@property (nonatomic,strong) UIView *clearView;

@end

@implementation SharedetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"晒单详情";
    
    _imagesize=0.0;
    [self initData];
    
    _imgArray=[NSMutableArray array];
    [_imgArray addObject:@"1"];
    [_imgArray addObject:@"2"];
    [_imgArray addObject:@"3"];
    [_imgArray addObject:@"4"];
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1720);
    _scroll.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:_scroll];
   
    UIView*rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    //分享
    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.frame = CGRectMake(0, 5, 23, 23);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:shareBtn];

//    //更多－－－暂时没用到
    UIImageView*moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 23, 13)];
    moreImg.image = [UIImage imageNamed:@"more"];
    [rightview addSubview:moreImg];
    
    UIButton *callBtn = [[UIButton alloc]init];
    callBtn.frame = CGRectMake(30, 5, 35, 30);
    [callBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:callBtn];
    
//
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    iscunzai=1;
}
-(void)creatview{

    // 底部view
    UIView*lowview=[[UIView alloc]initWithFrame:CGRectMake(0, MSH-114, MSW, 50)];
    lowview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:lowview];
    UILabel *lbline=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSW, 1.5)];
    lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [lowview addSubview:lbline];
    imgzan=[[UIImageView alloc]initWithFrame:CGRectMake(MSW/4-20, 20, 20, 20)];
    if ([model.sd_type isEqualToString:@"0"]) {
        
        imgzan.image=[UIImage imageNamed:@"good"];
    }else{
        imgzan.image=[UIImage imageNamed:@"good_selected1"];

    }
    [lowview addSubview:imgzan];
    UIImageView*imgcomment=[[UIImageView alloc]initWithFrame:CGRectMake(MSW/4*3-20, 20, 20, 20)];
      imgcomment.image=[UIImage imageNamed:@"comments01"];
    [lowview addSubview:imgcomment];
    lbzan=[[UILabel alloc]initWithFrame:CGRectMake(MSW/4+5, 20, 60, 20)];
    lbzan.textColor=[UIColor grayColor];
    lbzan.text=model.zan_number;
    lbzan.font=[UIFont systemFontOfSize:MiddleFont];
    [lowview  addSubview:lbzan];
    UILabel *lbcommet=[[UILabel alloc]initWithFrame:CGRectMake(MSW/4*3+5, 20, 60, 20)];
    lbcommet.textColor=[UIColor grayColor];
    lbcommet.text=model.pinglun_number;
    lbcommet.font=[UIFont systemFontOfSize:MiddleFont];
    [lowview  addSubview:lbcommet];
    buzan=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, MSW/2, 60)];
    buzan.backgroundColor=[UIColor clearColor];
    
    [buzan addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchUpInside];
    [lowview addSubview:buzan];
    
    UIButton *bucomment=[[UIButton alloc]initWithFrame:CGRectMake(MSW/2, 0, MSW/2, 60)];
    bucomment.backgroundColor=[UIColor clearColor];
    
    [bucomment addTarget:self action:@selector(pinglun) forControlEvents:UIControlEventTouchUpInside];
    [lowview addSubview:bucomment];

}

-(void)dianzan{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    
    [dict1 setValue:[NSString stringWithFormat:@"%@",model.sd_id] forKey:@"sd_id"];
    
    if([UserDataSingleton userInformation].isLogin == YES)
    {
        [MDYAFHelp AFPostHost:APPHost bindPath:ShareZan postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                lbzan.text=[NSString stringWithFormat:@"%i",[model.zan_number intValue]+1];
                imgzan.image=[UIImage imageNamed:@"good_selected1"];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((buzan.frame.size.width/2) - 15 + (buzan.frame.origin.x), self.view.frame.size.height - imgzan.frame.size.height, 20, 10)];
                label.text = @"+1";
                label.textColor=[UIColor redColor];
                label.font=[UIFont systemFontOfSize:MiddleFont];
               [self.view addSubview:label];
                [UIView animateWithDuration:1 animations:^{
                    label.frame = CGRectMake((buzan.frame.size.width/2) - 15 + (buzan.frame.origin.x), self.view.frame.size.height - 50, 20, 10);
                } completion:^(BOOL finished) {
                    [label reloadInputViews];
                    [label removeFromSuperview];
                }];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
            
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

-(void)pinglun{
    if([UserDataSingleton userInformation].isLogin == YES)
    {
        CommentController *classVC = [[CommentController alloc]init];
        classVC.sid=model.sd_id;
        [self.navigationController pushViewController:classVC animated:YES];
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
  
}

#pragma mark - 创建数据
- (void)initData
{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [dict1 setValue:_sid forKey:@"sd_id"];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:Ordersharedetail postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"%@",responseDic);
        NSDictionary*data1=[responseDic objectForKey:@"data"];
        NSDictionary*data=[data1 objectForKey:@"shaidan"];
        commentarry=[data1 objectForKey:@"huifu"];
        model=[[OrdershareModel alloc]init];
        model.sd_content=[data objectForKey:@"sd_content"];
        model.username=[data objectForKey:@"username"];
        model.sd_id=[data objectForKey:@"sd_id"];
        model.sd_photolist=[data objectForKey:@"sd_photolist"];
        model.sd_shopid=[data objectForKey:@"sd_shopid"];
        model.sd_time=[data objectForKey:@"sd_time"];
        model.q_end_time=[data objectForKey:@"q_end_time"];
        model.status=[data objectForKey:@"status"];
        model.sd_title=[data objectForKey:@"sd_title"];
        model.qishu=[data objectForKey:@"qishu"];
        model.q_user_code=[data objectForKey:@"q_user_code"];
        model.gonumber=[data objectForKey:@"gonumber"];
        model.sd_userid=[data objectForKey:@"sd_userid"];
        model.title=[data objectForKey:@"title"];
        model.fxurl=[data objectForKey:@"fxurl"];
        model.thumb=[data objectForKey:@"thumb"];
        model.zan_number=[data objectForKey:@"zan_number"];
        model.pinglun_number=[data objectForKey:@"pinglun_number"];
        model.sd_type=[data objectForKey:@"sd_type"];
        model.sd_zhan=[data objectForKey:@"sd_zhan"];
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD dismiss];
            model.img = data1[@"img"];
            [self addViews];
        }
        
           }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
              [SVProgressHUD showErrorWithStatus:@"网络不给力"];

   }];
}

-(void)more
{
    
    _clearView =[[UIView alloc]initWithFrame:self.view.bounds];
    _clearView.backgroundColor =[UIColor clearColor];
    [self.view.window addSubview:_clearView];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(removeAC)];
    [_clearView addGestureRecognizer:tap];
    if (iscunzai==1) {
        
        img=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-130,64, 120, 82)];
        img.image=[UIImage imageNamed:@"chat01"];
        img.userInteractionEnabled = YES;
        [_clearView addSubview:img];
        
        UIImageView*carimg=[[UIImageView alloc]initWithFrame:CGRectMake(10,13, 30, 30)];
        carimg.image=[UIImage imageNamed:@"cart-white"];
        [img addSubview:carimg];
        UIButton*btncar=[[UIButton alloc]initWithFrame:CGRectMake(6,15,110, 30)];
        btncar.backgroundColor=[UIColor clearColor];
        btncar.titleLabel.font=[UIFont systemFontOfSize:16];
        [btncar setTitle:@"清单" forState:UIControlStateNormal];
        [btncar addTarget:self action:@selector(qingdan) forControlEvents:UIControlEventTouchUpInside];
        
        [btncar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [img addSubview:btncar];
        
        UIImageView*redimg=[[UIImageView alloc]initWithFrame:CGRectMake(80,10, 20, 20)];
        //        redimg.image=[UIImage imageNamed:@"dot"];
        redimg.layer.cornerRadius = 10;
        redimg.layer.masksToBounds = YES;
        redimg.backgroundColor=MainColor;
        [img addSubview:redimg];
        
        UILabel*lbcount=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 20, 20)];
        lbcount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[UserDataSingleton userInformation].shoppingArray.count];
        lbcount.textColor=[UIColor whiteColor];
        lbcount.textAlignment=NSTextAlignmentCenter;
        [redimg addSubview:lbcount];
        
        if ([lbcount.text isEqualToString:@"0"]) {
            redimg.hidden=YES;
            lbcount.hidden=YES;
        }
        
        
        UIImageView*homeimg=[[UIImageView alloc]initWithFrame:CGRectMake(10,47, 30, 30)];
        homeimg.image=[UIImage imageNamed:@"home-white"];
        [img addSubview:homeimg];
        
        
        UIButton*btnhome=[[UIButton alloc]initWithFrame:CGRectMake(6,47,110, 35)];
        btnhome.titleLabel.font=[UIFont systemFontOfSize:16];
        
        [btnhome setTitle:@"首页" forState:UIControlStateNormal];
        [btnhome addTarget:self action:@selector(returnhome) forControlEvents:UIControlEventTouchUpInside];
        
        [btnhome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [img addSubview:btnhome];
        
        iscunzai=2;
    }else{
        
        [img removeFromSuperview];
        iscunzai=1;
        
    }
}
-(void)removeAC{
    
    [img removeFromSuperview];
    [_clearView removeFromSuperview];
    iscunzai=1;
}
- (void)addViews{
//   头像
    UIImageView * iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 40, 40)];
    iconImg.layer.cornerRadius = 20;
    iconImg.layer.masksToBounds = YES;
    iconImg.backgroundColor = [UIColor orangeColor];
    [iconImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:DefaultImage]];
    [_scroll addSubview:iconImg];
        //昵称
    UIButton *username=[[UIButton alloc]initWithFrame:CGRectMake(70, 25, MSW - 70 - 140, 20)];
    [username setTitle:model.username forState:UIControlStateNormal];
    [username setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    username.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [username setBackgroundColor:[UIColor clearColor]];
    username.titleLabel.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(13, 13, 14, 14)];
    [_scroll addSubview:username];
    [username addTarget:self action:@selector(gotogerenzhongxin) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, MSW, 1)];
    lineLabel.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    [_scroll addSubview:lineLabel];
        //日期
    UILabel *sharedate=[[UILabel alloc]initWithFrame:CGRectMake(MSW-130 - 10, 20, 130, 30)];
    sharedate.textAlignment = NSTextAlignmentRight;
    sharedate.font=[UIFont systemFontOfSize:MiddleFont];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.sd_time floatValue]];
//    NSString *str = [DateHelper formatDate:date];
    
    NSString *str=model.sd_time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    sharedate.text=[dateFormatter stringFromDate: detaildate];
    sharedate.textColor=[UIColor grayColor];
    [_scroll addSubview:sharedate];
    
    UIView*bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, 130+30)];
//    bgview.backgroundColor=RGBCOLOR(245, 246, 247);
    bgview.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:bgview];
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                   [UIColor grayColor]],
                             @"u": @[RGBACOLOR(106, 192, 255, 1),
                                     
                                     ]};
    UILabel*sharetitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
    sharetitle.text=model.sd_title;
    sharetitle.textColor=RGBCOLOR(2, 2, 2);
    sharetitle.font=[UIFont systemFontOfSize:16];
    [bgview addSubview:sharetitle];
    
    UIButton *goodname1=[[UIButton alloc]initWithFrame:CGRectMake(10, 5+20,MSW-20, 30)];
    [goodname1 setTitle:model.title forState:UIControlStateNormal];
    goodname1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentFill ;
    [goodname1 setTitleColor:RGBACOLOR(106, 192, 255, 1) forState:UIControlStateNormal];
    goodname1.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    [goodname1 addTarget:self action:@selector(gotogoodsdetail) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:goodname1];
    UILabel *sharecount=[[UILabel alloc]initWithFrame:CGRectMake(10, 35+20, 200, 30)];
    sharecount.attributedText=[[NSString stringWithFormat:@"本期参与: <u>%@</u>人次",model.gonumber] attributedStringWithStyleBook:style1];
    sharecount.font = [UIFont boldSystemFontOfSize:MiddleFont];
    [bgview addSubview:sharecount];
    DebugLog(@"==---%f",_imagesize);
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, 130+20)];
    button.backgroundColor=[UIColor clearColor];
    
    [button addTarget:self action:@selector(gotogoodsdetail) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:button];
    
    UILabel *lbtime=[[UILabel alloc]initWithFrame:CGRectMake(10, 60+20, 300, 20)];
    
    NSString *str1=model.q_end_time;//时间戳
    NSTimeInterval time1=[str1 doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate1=[NSDate dateWithTimeIntervalSince1970:time1];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    lbtime.text=[NSString stringWithFormat:@"揭晓时间: %@" ,[dateFormatter1   stringFromDate: detaildate1]];
    lbtime.textColor=RGBCOLOR(143, 145, 145);
    lbtime.font = [UIFont boldSystemFontOfSize:MiddleFont];
    [bgview addSubview:lbtime];
    
    UIView*redview=[[UIView alloc]initWithFrame:CGRectMake(10, bgview.frame.size.height-40, bgview.frame.size.width-20, 40)];
    redview.backgroundColor=MainColor;
    [bgview addSubview:redview];
    UILabel * lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, bgview.frame.size.height-40+40+10, MSW, 1)];
    lineLabel1.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    [bgview addSubview:lineLabel1];
    UILabel *luckno=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 30)];
    luckno.attributedText=[[NSString stringWithFormat:@"中奖号码:<u>%@</u>",model.q_user_code] attributedStringWithStyleBook:style1];
    luckno.textColor=[UIColor whiteColor];
    luckno.font = [UIFont boldSystemFontOfSize:16];
    [redview addSubview:luckno];
    UIButton *btlook=[[UIButton alloc]initWithFrame:CGRectMake(redview.frame.size.width-110, 5, 100, 30)];
    [btlook setTitle:@"查看计算详情>" forState:0];
    btlook.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    [btlook setTitleColor:[UIColor whiteColor] forState:0];
    
    [btlook addTarget:self action:@selector(gotopicdetail) forControlEvents:UIControlEventTouchUpInside];
    [redview addSubview:btlook];
    sharinfo=[[UILabel alloc]initWithFrame:CGRectMake(20, 230+20,[UIScreen mainScreen].bounds.size.width-40, 40)];
    sharinfo.text=model.sd_content;
    sharinfo.numberOfLines=0;
    sharinfo.font=[UIFont systemFontOfSize:BigFont];
    //设置宽高，其中高为允许的最大高度
    CGSize size = CGSizeMake(sharinfo.frame.size.width,10000);
    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
    CGSize labelsize = [sharinfo.text sizeWithFont:sharinfo.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    //最后根据这个大小设置label的frame即可
    [sharinfo setFrame:CGRectMake(sharinfo.frame.origin.x,sharinfo.frame.origin.y,labelsize.width,labelsize.height)];
    [_scroll addSubview:sharinfo];
 
    for (int i=0; i<model.sd_photolist.count; i++) {
        UIImageView*imgview=[[UIImageView alloc]initWithFrame:CGRectMake(10, sharinfo.frame.origin.y+sharinfo.frame.size.height+20+(_imagesize+10*i), MSW-20, MSW-20)];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        [imgview sd_setImageWithURL:[NSURL URLWithString:[model.sd_photolist objectAtIndex:i]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        imgview.clipsToBounds = YES;
        double width;
        width=[ImageSize getImageSizeWithURL:[model.sd_photolist objectAtIndex:i]].width;
        double height;
        height=[ImageSize getImageSizeWithURL:[model.sd_photolist objectAtIndex:i]].height;
        //       判断图片是否加载成功
        if (height==0.0) {
            DebugLog(@"加载失败");
            imgview.height=imgview.width;

        }else{
            DebugLog(@"加载成功");
            imgview.height=imgview.width/(width/height);

        }
        double  size1;
        size1=imgview.height;
     _imagesize=_imagesize+size1;
        imgview.backgroundColor=[UIColor clearColor];
        [_scroll addSubview:imgview];
    }
    for (int i=0; i<commentarry.count; i++) {
        NSDictionary*dic=[commentarry objectAtIndex:i];
        NSString *str = dic[@"sdhf_content"];
        UIFont *font = [UIFont systemFontOfSize:MiddleFont];
        //iOS7 通过属性字符串保存的
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        //返回高度
        CGSize sizeText = [str boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        cellhight+=sizeText.height+ IPhone4_5_6_6P(65, 65, 50, 50);
    }
    [self createTableView];
    [self creatview];
    
    _scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, sharinfo.frame.origin.y+sharinfo.frame.size.height+_imagesize+100+cellhight);
  
}






#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, sharinfo.frame.size.height+sharinfo.frame.origin.y+_imagesize+20, self.view.bounds.size.width,cellhight+150  ) pullingDelegate:self style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled =NO;  //设置tableview 不能滚动
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    self.tableView.tableHeaderView = [[UIView alloc]init];
    
    self.tableView.backgroundColor=[UIColor clearColor];
    [_scroll addSubview:self.tableView];
}

#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (commentarry.count >= 5) {
           return 6;
    }else{
        return commentarry.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5)
    {
        return 40;
        
    }else{
        NSDictionary*dic=[commentarry objectAtIndex:indexPath.row];
        NSString *str = dic[@"sdhf_content"];
        UIFont *font = [UIFont systemFontOfSize:MiddleFont];
        //iOS7 通过属性字符串保存的
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        //返回高度
        CGSize sizeText = [str boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        DebugLog(@"==-=--fff-%f",sizeText.height);
        if (sizeText.height<20) {
            return IPhone4_5_6_6P(65, 65, 55, 55);
        }else{
        return sizeText.height +IPhone4_5_6_6P(65, 65, 50, 50);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *ListingCellName = @"ShaidanCommentCell.h";
    static  NSString *cellName = @"Cell";
    if (indexPath.row == 5)
    {
        UITableViewCell *btCell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!btCell)
        {
            btCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 5, MSW-20, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(allpinglun) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"点击显示全部" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btCell addSubview:btn];
        btCell.backgroundColor=[UIColor groupTableViewBackgroundColor];
        return btCell;

    }
    else
    {
    ShaidanCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!cell)
    {
        cell = [[ShaidanCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary*dic=[commentarry objectAtIndex:indexPath.row];
       NSString *str = dic[@"sdhf_content"];
        cell.lbdetail.text=str;
        cell.lbtitle.text= dic[@"sdhf_username"];
        cell.lbtime.text=dic[@"sdhf_time"];
        [cell.iamgefound sd_setImageWithURL:[NSURL URLWithString:dic[@"sdhf_img"]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        cell.lbdetail.numberOfLines = 0;
        CGSize size = CGSizeMake(cell.lbdetail.frame.size.width,10000);
        CGSize labelsize = [cell.lbdetail.text sizeWithFont:cell.lbdetail.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        [cell.lbdetail setFrame:CGRectMake(cell.lbdetail.frame.origin.x,cell.lbdetail.frame.origin.y,labelsize.width,labelsize.height)];
          return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 5)
    {
        CommentController *classVC = [[CommentController alloc]init];
        classVC.sid=model.sd_id;
        classVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:classVC animated:YES];
    }
}

-(void)allpinglun{
    CommentController *classVC = [[CommentController alloc]init];
    classVC.sid=model.sd_id;
    classVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:classVC animated:YES];
    
}

#pragma mark - 跳转计算详情
-(void)gotopicdetail{
    CalculateDetailController *classVC = [[CalculateDetailController alloc]init];
    classVC.shopid=model.sd_shopid;
    classVC.qishu=model.qishu;
    [self.navigationController pushViewController:classVC animated:YES];
}
//跳转个人中心
-(void)gotogerenzhongxin{
    [img removeFromSuperview];
    PersonalcenterController *classVC = [[PersonalcenterController alloc]init];
     classVC.yhid=model.sd_userid;
//    classVC.
    [self.navigationController pushViewController:classVC animated:YES];
 
}
//跳转到商品详情
-(void)gotogoodsdetail{
    [img removeFromSuperview];
    GoodsDetailsViewController *classVC = [[GoodsDetailsViewController alloc]init];
     classVC.idd=model.sd_shopid;
    [self.navigationController pushViewController:classVC animated:YES];
}
//点击清单
-(void)qingdan
{
    [img removeFromSuperview];
    [_clearView removeFromSuperview];
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)returnhome{
    [img removeFromSuperview];
    //    DebugLog(@"--首页");
    [_clearView removeFromSuperview];

    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/*********add by liangjun *****/
#pragma mark - 分享
-(void)share
{
    //    DebugLog(@"分享");
    UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:model.thumb] shouldLoadWithObserver:nil];
    
    //构造分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@",model.sd_content]

                                       defaultContent:@""
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:model.title
                                                  url:model.fxurl
                                          description:model.sd_content
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
