//
//  ConfirmedWinController.m
//  yyxb
//
//  Created by mac03 on 15/11/25.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ConfirmedWinController.h"
#import "AddShaidanController.h"
#import "RedStatusDto.h"
#import "UserAddressViewController.h"
#import "DateHelper.h"
#import "payController.h"
#import "AddressViewController.h"
#import "GameViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#define Margin 20
@interface ConfirmedWinController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIScrollView      *_scrollView;
    UIImageView    *_LeftImgView;
    UIView         *_line;                      //分隔线
    UILabel                    *_timeLab;       //时间
    UILabel                    *_titleLab;      //标题
    UILabel                    *_numberLab;     //号码
    UILabel                    *_totalLab;      //总需
    UILabel                    *_nowDateLab;    //本次参与
    UILabel                    *_statsLab;       //状态
    
    NSString             *company;    //快递物流
    NSString             *company_code;//快递单号
    NSString             *dizhi_time;   //确定地址时间
    NSString             *piafa_time;   //派发时间
    NSString             *wancheng_time;   //完成订单时间
    NSString             *shouhuoren;   //收货人
    NSString             *mobile;    //收货人手机号
    NSString             *dizhi;    //收货地址
    NSString       *idD;  //记录id
    NSString       *siteid;//地址ID
    UIView     *bgView;
    UIView     *bgView2;
    UIView     *bgView3;
    UIView     *bgView4;
    
}
@property (nonatomic, strong)UILabel *addressLab ;
@property (nonatomic, strong)UILabel *nameLab1;
@property (nonatomic, strong)UILabel *phoneLab;
@property (nonatomic, strong)UILabel *addLab;
@end

@implementation ConfirmedWinController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"中奖确认";
    self.view.backgroundColor=RGBCOLOR(236, 235, 241);
    idD=_model.idD;
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH)];
    _scrollView.contentSize=CGSizeMake(MSW, IPhone4_5_6_6P(MSH+250, MSH+250, MSH+150, MSH+150));
    _scrollView.showsHorizontalScrollIndicator=false;
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_scrollView];
    
//    [self SuregetData];
//    [self accomplishgetData];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self getInfo];
    
}

//确定地址中奖纪录
-(void)getData
{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_redModel.idD forKey:@"id"];
    [dict1 setValue:siteid forKey:@"siteid"];
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
     //    [dict setValue:isget forKey:@"isget"];
    //    DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:SureRecordList postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
//            DebugLog(@"===================%@",responseDic);
//            DebugLog(@"=====%@",responseDic[@"msg"]);
            [self refreshSuccessful:responseDic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)refreshSuccessful:(id)data
{
//    DebugLog(@"**************%@",data);
//    DebugLog(@"++++++++++%@",data[@"msg"]);
    
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
//            _redModel = [[RedStatusDto alloc]initWithDictionary:data[@"data"]];
//            DebugLog(@"!!!!!%@",_redModel.dizhi_time);
            [self getInfo];
        }
    }
    
}

//中奖纪录接口
-(void)getInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_model.idD forKey:@"id"];

//    DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:RecordList postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
//            DebugLog(@"===================%@",responseDic);
//            DebugLog(@"=====%@",responseDic[@"msg"]);
            [self refreshSuccessfulInfo:responseDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"%@",error);
        
    }];

}
-(void)refreshSuccessfulInfo:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
        _redModel = [[RedStatusDto alloc]initWithDictionary:data[@"data"]];
//        DebugLog(@"!!!!!%@",_redModel.dizhi_time);
//        DebugLog(@"=====%@",_redModel.paifa_time);
//        DebugLog(@"++++++%@",_redModel.sdwc_time);
        }
    }
       [self createview];
}
-(void)gotoSure
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要收货吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self accomplishgetData];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//完成订单
-(void)accomplishgetData
{
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict2 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict2 setValue:_redModel.idD forKey:@"id"];
    
    //    [dict setValue:isget forKey:@"isget"];
    //    DebugLog(@"==========%@",dict[@"code"]);
    [MDYAFHelp AFPostHost:APPHost bindPath:AccomplishRecordList postParam:dict2 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        // DebugLog(@"===================%@",responseDic);
        // DebugLog(@"=====%@",responseDic[@"msg"]);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
//            _redModel = [[RedStatusDto alloc]initWithDictionary:responseDic[@"data"]];
            [self getInfo];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
}


#pragma mark - 奖品状态
- (void)createview{
    
    
    if ((bgView !=nil) || (bgView4!=nil) || (bgView3 !=nil) ||(bgView2 !=nil)) {
        [bgView removeFromSuperview];
        [bgView2 removeFromSuperview];
        [bgView3 removeFromSuperview];
        [bgView4 removeFromSuperview];
    }
    
    //第一个view
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, _scrollView.width, 235)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    label5.backgroundColor = [UIColor clearColor];
    label5.textAlignment = NSTextAlignmentLeft;
    label5.textColor = [UIColor blackColor];
    label5.font = [UIFont systemFontOfSize:BigFont];
    label5.text = @"奖品状态";
    [bgView addSubview:label5];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, label5.bottom, MSW, 0.8)];
    line.backgroundColor=RGBCOLOR(217, 217, 217);
    [bgView addSubview:line];
    //线条状态
    UIImageView *stateImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, line.bottom+10, 20, 180)];
    stateImg.backgroundColor=[UIColor clearColor];
    [bgView addSubview:stateImg];
    if ([_redModel.dizhi_time isEqualToString:@""]) {
        stateImg.image=[UIImage imageNamed:@"states02"];
    }
    else if ([_redModel.paifa_time isEqualToString:@""]){
        stateImg.image=[UIImage imageNamed:@"states03"];
    }
    else if ([_redModel.wancheng_time isEqualToString:@""]){
        stateImg.image=[UIImage imageNamed:@"states04"];
    }
    else if([_redModel.sdwc_time isEqualToString:@""]|| (_redModel.sdwc_time !=nil)){
        stateImg.image=[UIImage imageNamed:@"states05"];
    }
    
    //时间
    for (NSInteger m = 0; m < 5; m ++) {
        UIButton *btshaidan;
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(60, 40 + m * 40, 150, 30)];
        button.layer.cornerRadius=3.0;
        [button setBackgroundColor:[UIColor clearColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:BigFont];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(MSW - 200 -15, 40 + m * 40, 200, 30)];
        label.font = [UIFont systemFontOfSize:BigFont];
        label.textAlignment = NSTextAlignmentRight;
        
        //字符串转换时间
        NSString *str=_model.Time;//时间戳
        NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [button setTitle:@"获得奖品" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        label.text = [dateFormatter stringFromDate: detaildate];
        
        if (m == 1) {
            if (IsStrEmpty(_redModel.dizhi_time)) {
                button.frame=CGRectMake(MSW -100 - 15, 40 + 1* 40, 100, 30);
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [button setBackgroundColor:MainColor];
                [button setTitle:@"确认地址" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(gotoAddress) forControlEvents:UIControlEventTouchUpInside];
                label.text = @"";
                
            }
            else{
                //字符串转换时间
                NSString *str=_redModel.dizhi_time;//时间戳
                NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [button setTitle:@"确认收货地址" forState:UIControlStateNormal];
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                label.text = [dateFormatter stringFromDate: detaildate];
                
                [self createThiredView];
                
            }
        }else if (m == 2){
            if (IsStrEmpty(_redModel.dizhi_time)) {
                if (IsStrEmpty(_redModel.paifa_time)) {
                    [button setTitle:nil forState:UIControlStateNormal];
                }else{
                    [button setTitle:@"奖品派发"forState:UIControlStateNormal];
                }
                label.text = @"";
            }
            else{
                if (IsStrEmpty(_redModel.paifa_time)){
                    [button setTitle:@"奖品派发"forState:UIControlStateNormal];
                    label.text = @"待发货...";
                }else{
                    NSString *str=_redModel.paifa_time;//时间戳
                    DebugLog(@"----%@",_redModel.paifa_time);
                    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
                    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    [button setTitle:@"奖品派发"forState:UIControlStateNormal];
                    
                    label.text = [dateFormatter stringFromDate: detaildate];
                    
                    
                    [self createTwoView];
                }
            }
            
        }else if (m==3){
            if (IsStrEmpty(_redModel.paifa_time)) {
                [button setTitle:nil forState:UIControlStateNormal];
                label.text = @"";
            }
            else{
                
                if (IsStrEmpty(_redModel.wancheng_time)) {
                    button.frame=CGRectMake(MSW - 100 -15, 40 + 3* 40, 100, 30);
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [button setBackgroundColor:MainColor];
                    [button setTitle:@"确认收货" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(gotoSure) forControlEvents:UIControlEventTouchUpInside];
                    label.text = @"";
                }else{
                    //字符串转换时间
                    NSString *str=_redModel.wancheng_time;//时间戳
                    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
                    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //设定时间格式,这里可以设置成自己需要的格式
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [button setTitle:@"确认收货" forState:UIControlStateNormal];
                    label.text = [dateFormatter stringFromDate: detaildate];
                    
                }
            }
        }else if (m==4){
            if (IsStrEmpty(_redModel.wancheng_time)) {
                [button setTitle:nil forState:UIControlStateNormal];
                label.text = @"";
            }
            else{
                if (IsStrEmpty(_redModel.sdwc_time)) {
                    [button setTitle:@"完成" forState:UIControlStateNormal];
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                    [button setTitleColor:MainColor forState:UIControlStateNormal];
                    
                    btshaidan=[[UIButton alloc]initWithFrame:CGRectMake(MSW -100-15, 200, 100, 30)];
                    btshaidan.layer.cornerRadius=3.0;
                    [btshaidan setBackgroundColor:MainColor];
                    btshaidan.titleLabel.font = [UIFont systemFontOfSize:BigFont];
                    [btshaidan setTitle:@"去晒单" forState:UIControlStateNormal];
                    [btshaidan addTarget:self action:@selector(gotoshaidan) forControlEvents:UIControlEventTouchUpInside];
                    label.text = @"";
                }else{
                    [button setTitle:@"完成" forState:UIControlStateNormal];
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                    [button setTitleColor:MainColor forState:UIControlStateNormal];
                    label.text = @"";
                }
            }
        }
        [bgView addSubview:button];
        [bgView addSubview:label];
        [bgView addSubview:btshaidan];
        //分隔线
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(60, button.bottom+5, MSW, 0.8)];
        line2.backgroundColor=RGBCOLOR(217, 217, 217);
        [bgView addSubview:line2];
    }
    [self createFourView];
    
    //   －－－－－－－－－－－－－－－－－－－－－ 王可伟添加的
   //   －－－－－－－－－－－－－－－－－－－ 王可伟添加的
    
}

#pragma mark - 物流信息
-(void)createTwoView
{
    //第二个view
    if (IsStrEmpty(_redModel.paifa_time)) {
        if ([_redModel.dizhi_time isEqualToString:@""]) {
            bgView2.hidden=YES;
        }else{
            
        }
     }
    else{
        if ([self.model.status isEqualToString:@"1"]) {
            bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.bottom + 10, _scrollView.width, 150)];
        }
        else if([self.model.status isEqualToString:@"2"] || [self.model.status isEqualToString:@"3"]){
            bgView2.hidden = YES;
        }
        
    }
   
    bgView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView2];
    
    UILabel *titLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    titLab.text=@"物流信息";
    titLab.textColor=[UIColor blackColor];
    titLab.font=[UIFont systemFontOfSize:BigFont];
    titLab.backgroundColor=[UIColor clearColor];
    [bgView2 addSubview:titLab];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(10, titLab.bottom, MSW, 0.8)];
    line3.backgroundColor=RGBCOLOR(217, 217, 217);
    [bgView2 addSubview:line3];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(20, line3.bottom, MSW-40, 20)];
    nameLab.text=_redModel.shopname;
    nameLab.textColor=[UIColor blackColor];
    nameLab.font=[UIFont systemFontOfSize:MiddleFont];
    nameLab.backgroundColor=[UIColor clearColor];
    [bgView2 addSubview:nameLab];
    
    UILabel *logisticsLab=[[UILabel alloc]initWithFrame:CGRectMake(20, nameLab.bottom, MSW - 40, 20)];
    logisticsLab.text=[NSString stringWithFormat:@"物流公司：%@",_redModel.company];
    logisticsLab.textColor=[UIColor blackColor];
    logisticsLab.font=[UIFont systemFontOfSize:MiddleFont];
    logisticsLab.backgroundColor=[UIColor clearColor];
    [bgView2 addSubview:logisticsLab];
    
    UILabel *numberLab=[[UILabel alloc]initWithFrame:CGRectMake(20, logisticsLab.bottom, MSW -40, 20)];
    numberLab.text=[NSString stringWithFormat:@"运单号码：%@",_redModel.company_code];
    numberLab.textColor=[UIColor blackColor];
    numberLab.font=[UIFont systemFontOfSize:MiddleFont];
    numberLab.backgroundColor=[UIColor clearColor];
    [bgView2 addSubview:numberLab];
    bgView2.frame = CGRectMake(0, bgView.bottom + 10, MSW, numberLab.bottom + 5);
}

#pragma mark - 收货信息
-(void)createThiredView
{
    
    
    //第三个view
    if (IsStrEmpty(_redModel.dizhi_time)) { //无值
        bgView3.hidden=YES;
    }
    else{ //有值
        if (IsStrEmpty(_redModel.paifa_time)  ) {
            if([self.model.status isEqualToString:@"3"])
            {
                bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.bottom + 10, _scrollView.width, 200)];
            }
            else if ([self.model.status isEqualToString:@"2"]){
                 bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.bottom + 10, _scrollView.width, 120)];
            }
            
            else{
                bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView2.bottom + 10, _scrollView.width, 120)];
            }
            
            
        }else{
            if ([self.model.status isEqualToString:@"2"] )
            {
                
                bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.bottom + 10, _scrollView.width, 120)];
            }
            else if([self.model.status isEqualToString:@"3"])
            {
                bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.bottom + 10, _scrollView.width, 200)];
            }
            else
            {
                bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView2.bottom +  10, _scrollView.width, 80)];
            }
            
        }
    }
    UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    self.addressLab = addressLab;
    bgView3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView3];
    
    
    addressLab.text=@"收货信息";
    addressLab.textColor=[UIColor blackColor];
    addressLab.font=[UIFont systemFontOfSize:BigFont];
    addressLab.backgroundColor=[UIColor clearColor];
    [bgView3 addSubview:addressLab];
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(10, addressLab.bottom, MSW, 0.8)];
    line4.backgroundColor=RGBCOLOR(217, 217, 217);
    [bgView3 addSubview:line4];
    
    UILabel *nameLab1=[[UILabel alloc]initWithFrame:CGRectMake(15, line4.bottom, (MSW - 30) * 0.5, Margin)];
    self.nameLab1 = nameLab1;
    nameLab1.text=_redModel.shouhuoren;
    nameLab1.textColor=[UIColor blackColor];
    nameLab1.font=[UIFont systemFontOfSize:MiddleFont];
    nameLab1.backgroundColor=[UIColor clearColor];
    [bgView3 addSubview:nameLab1];
    
    UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(nameLab1.right, line4.bottom, (MSW - 30) * 0.5, Margin)];
    self.phoneLab = phoneLab;
    phoneLab.text=_redModel.mobile;
    phoneLab.textColor=[UIColor blackColor];
    phoneLab.font=[UIFont systemFontOfSize:MiddleFont];
    phoneLab.textAlignment = UITextAlignmentLeft;
    phoneLab.backgroundColor=[UIColor clearColor];
    [bgView3 addSubview:phoneLab];
    
    UILabel *addLab=[[UILabel alloc]initWithFrame:CGRectMake(15, nameLab1.bottom, MSW-30, Margin)];
    self.addLab = addLab;
    addLab.numberOfLines = 0;
    addLab.text=_redModel.dizhi;
    addLab.textColor=[UIColor blackColor];
    addLab.font=[UIFont systemFontOfSize:MiddleFont];
    addLab.backgroundColor=[UIColor clearColor];
    [bgView3 addSubview:addLab];
    
    
    CGSize size1 = [_redModel.remark sizeWithFont:[UIFont systemFontOfSize:MiddleFont] constrainedToSize:CGSizeMake(MSW - 30,300) lineBreakMode:NSLineBreakByCharWrapping];
    
    UILabel * buyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, addLab.bottom, MSW - 30, Margin)];
    buyNameLabel.text = @"买家备注：";
    [buyNameLabel sizeToFit];
    buyNameLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [bgView3 addSubview:buyNameLabel];
    
    UILabel * buyerLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, addLab.bottom, MSW - 70 -15, size1.height +20)];
    buyerLabel.numberOfLines = 0;
    buyerLabel.text = _redModel.remark;
    buyerLabel.textColor = [UIColor blackColor];
    buyerLabel.font = [UIFont systemFontOfSize:MiddleFont];
    buyerLabel.backgroundColor = [UIColor clearColor];
    CGRect rect = [buyerLabel.text boundingRectWithSize:CGSizeMake(MSW - 184, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: buyerLabel.font} context:nil];
    [bgView3 addSubview:buyerLabel];
    
    
    
    //商家留言
    
    CGSize size = [_redModel.ad_remark sizeWithFont:[UIFont systemFontOfSize:MiddleFont] constrainedToSize:CGSizeMake(MSW - 30,300) lineBreakMode:NSLineBreakByCharWrapping];
    
    UILabel * sellerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, buyerLabel.bottom, MSW - 30, Margin)];
    sellerNameLabel.text = @"商家留言：";
    [sellerNameLabel sizeToFit];
    sellerNameLabel.font = [UIFont systemFontOfSize:MiddleFont];
    [bgView3 addSubview:sellerNameLabel];
    
    
    UILabel *sellerLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, buyerLabel.bottom, MSW - 70 -50, size.height+ 10)];
    sellerLabel.text = _redModel.ad_remark;
    sellerLabel.textColor = [UIColor redColor];
    sellerLabel.font = [UIFont systemFontOfSize:MiddleFont];
    sellerLabel.backgroundColor = [UIColor clearColor];
    sellerLabel.numberOfLines = 0;
    
    CGRect rect1 = [_redModel.ad_remark boundingRectWithSize:CGSizeMake(MSW - 184, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: sellerLabel.font} context:nil];
    
    [bgView3 addSubview:sellerLabel];
  
    self.nameLab1.text = [NSString stringWithFormat:@"电话：%@",self.redModel.mobile];
    if ([self.redModel.status isEqualToString:@"1"])
    {
        self.phoneLab.text = [NSString stringWithFormat:@"姓名：%@",self.redModel.shouhuoren];
        
        CGSize size3 = [self.redModel.dizhi sizeWithFont:[UIFont systemFontOfSize:MiddleFont] constrainedToSize:CGSizeMake(MSW - 30,300) lineBreakMode:NSLineBreakByCharWrapping];
        self.addLab.frame = CGRectMake(15, nameLab1.bottom, MSW-30, size3.height +10);
        self.addLab.text = [NSString stringWithFormat:@"地址：%@",self.redModel.dizhi];
        buyNameLabel.frame = CGRectMake(15, addLab.bottom, MSW - 30, Margin);
        buyerLabel.frame = CGRectMake(70, addLab.bottom, MSW - 70 -15, size1.height +20);
        sellerNameLabel.frame = CGRectMake(15, buyerLabel.bottom, MSW - 30, Margin);
        sellerLabel.frame = CGRectMake(70, buyerLabel.bottom, MSW - 70 -50, size.height+ 10);


        
    }
    else if ([self.redModel.status isEqualToString:@"2"])
    {
        self.phoneLab.text = [NSString stringWithFormat:@"qq：%@",self.redModel.qq];
        buyNameLabel.frame = CGRectMake(15, phoneLab.bottom, MSW - 30, Margin);
        buyerLabel.frame = CGRectMake(70, phoneLab.bottom + 2, MSW - 185, rect1.size.height);
        sellerNameLabel.frame = CGRectMake(15, buyerLabel.bottom, MSW - 30, Margin);
        sellerLabel.frame = CGRectMake(70, buyerLabel.bottom + 2, MSW - 185, rect1.size.height);
        
    }
    else if ([self.redModel.status isEqualToString:@"3"])
    {
        self.phoneLab.text = [NSString stringWithFormat:@"游戏名称：%@",self.redModel.game_name];
        self.phoneLab.frame = CGRectMake(15, self.nameLab1.bottom, MSW - 30, Margin);
        
        self.addLab.frame = CGRectMake(15, self.phoneLab.bottom, MSW-30, Margin);
        self.addLab.text = [NSString stringWithFormat:@"游戏区/服：%@",self.redModel.game_zone];
        UILabel * game_numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,self.addLab.bottom , MSW-30, Margin)];
        game_numberLabel.text = [NSString stringWithFormat:@"游戏账号：%@",self.redModel.game_number];
        game_numberLabel.textAlignment = NSTextAlignmentLeft;
        game_numberLabel.font = [UIFont systemFontOfSize:MiddleFont];
        [bgView3 addSubview:game_numberLabel];
        
        UILabel * game_nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, game_numberLabel.bottom, MSW - 30, Margin)];
        game_nicknameLabel.text = [NSString stringWithFormat:@"游戏昵称：%@",self.redModel.game_nickname];
        game_nicknameLabel.font = [UIFont systemFontOfSize:MiddleFont];
        [bgView3 addSubview:game_nicknameLabel];
       
        buyNameLabel.frame = CGRectMake(15, game_nicknameLabel.bottom, MSW - 30, Margin);
         buyerLabel.frame = CGRectMake(70, game_nicknameLabel.bottom + 2, MSW - 185, rect.size.height);
        sellerNameLabel.frame = CGRectMake(15, buyerLabel.bottom, MSW - 30, Margin);
        sellerLabel.frame = CGRectMake(70, buyerLabel.bottom + 2, MSW - 185, rect1.size.height);
        
    }
    
    UIButton * copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(MSW - 60 -15, sellerLabel.top -5,60, 20)];
    [copyBtn setTitle:@"复制留言" forState:UIControlStateNormal];
    copyBtn.titleLabel.textColor = [UIColor blackColor];
    copyBtn.backgroundColor = RGBCOLOR(27, 166, 255);
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
    copyBtn.layer.cornerRadius = 4;
    [copyBtn addTarget:self action:@selector(copyContent) forControlEvents:UIControlEventTouchUpInside];
    [bgView3 addSubview:copyBtn];

    
    if (IsStrEmpty(_redModel.paifa_time)) {
        bgView3.frame = CGRectMake(0,bgView.bottom + 10, _scrollView.width, buyerLabel.bottom + 5);
        sellerLabel.hidden = YES;
        sellerNameLabel.hidden = YES;
        copyBtn.hidden = YES;

    }
    else{
        if (IsStrEmpty(_redModel.ad_remark)) {
            
            sellerNameLabel.hidden = YES;
            copyBtn.hidden = YES;
            
            bgView3.frame = CGRectMake(0,355, _scrollView.width, buyerLabel.bottom +10);
            
            
        }
        
        if (![self.model.status isEqualToString:@"3"] && ![self.model.status isEqualToString:@"2"]) {
            bgView3.frame = CGRectMake(0,355, _scrollView.width, sellerLabel.bottom +15);
        }
        else{
            bgView3.frame = CGRectMake(0,bgView.bottom + 10, _scrollView.width, sellerLabel.bottom + 15);
        }
        
    }
    


//    if([self.model.status isEqualToString:@"3"])
//    {
//        bgView3 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.bottom + 10, _scrollView.width, 200)];
//    }
   
}

#pragma mark - 点击按钮复制
- (void)copyContent{
    UIPasteboard * pad = [UIPasteboard generalPasteboard];
    NSString * string = _redModel.ad_remark;
    [pad setString:string];
    if (pad == nil) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"复制失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"商家留言已复制进剪贴板" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


#pragma mark 商品信息
-(void)createFourView
{
    //第4个view
    if (IsStrEmpty(_redModel.dizhi_time)) { //无值
        bgView4 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView.bottom+10, _scrollView.width, 160)];
    }
    else{
        if (IsStrEmpty(_redModel.paifa_time)) {
            bgView4 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView3.bottom + 30, _scrollView.width, 160)];
        }
        bgView4 = [[UIView alloc] initWithFrame:CGRectMake(0,bgView3.bottom + 10, _scrollView.width, 160)];
    }
    bgView4.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bgView4];
    //商品信息标题
    UILabel *goodsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    goodsNameLabel.text=@"商品信息";
    goodsNameLabel.textColor=[UIColor blackColor];
    goodsNameLabel.font=[UIFont systemFontOfSize:BigFont];
    goodsNameLabel.backgroundColor=[UIColor clearColor];
    [bgView4 addSubview:goodsNameLabel];
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(10, goodsNameLabel.bottom, MSW, 0.8)];
    line4.backgroundColor=RGBCOLOR(217, 217, 217);
    [bgView4 addSubview:line4];

    
    _LeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 38, 110, 120)];
    _LeftImgView.backgroundColor = [UIColor clearColor];
    [_LeftImgView sd_setImageWithURL:[NSURL URLWithString:_model.Uphoto] placeholderImage:[UIImage imageNamed:DefaultImage]];
    _LeftImgView.contentMode = UIViewContentModeScaleAspectFit;
    _LeftImgView.layer.cornerRadius=5;
    _LeftImgView.clipsToBounds = YES;
    _LeftImgView.userInteractionEnabled=YES;
    [bgView4 addSubview:_LeftImgView];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, 38, MSW - 10 - 10-_LeftImgView.width, 20)];
    _titleLab.text=_model.shopname;
    _titleLab.textColor=[UIColor blackColor];
    _titleLab.numberOfLines=0;
    _titleLab.font=[UIFont systemFontOfSize:BigFont];
    [bgView4 addSubview:_titleLab];
    
    _totalLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _titleLab.bottom+5, 200, 20)];
    _totalLab.text=[NSString stringWithFormat:@"总需：%@次",_model.Zongrenshu];
    _totalLab.textColor=RGBCOLOR(100, 100, 100);
    _totalLab.font=[UIFont systemFontOfSize:MiddleFont];
    [bgView4 addSubview:_totalLab];
    
    _numberLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _totalLab.bottom+5, 80, 20)];
    _numberLab.text=@"幸运号码：";
        _numberLab.textColor=RGBCOLOR(100, 100, 100);;
    _numberLab.font=[UIFont systemFontOfSize:MiddleFont];
    [bgView4 addSubview:_numberLab];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(_numberLab.right-20, _totalLab.bottom+5, 260, 20)];
    lab.text=_model.Huode;
    lab.textColor=MainColor;
    lab.font=[UIFont systemFontOfSize:MiddleFont];
    [bgView4 addSubview:lab];
    
    _nowDateLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _numberLab.bottom+5, 260, 20)];
    _nowDateLab.text=[NSString stringWithFormat:@"本期参与：%@人次",_model.Gonumber];
    _nowDateLab.textColor=RGBCOLOR(100, 100, 100);;
    _nowDateLab.font=[UIFont systemFontOfSize:MiddleFont];
    [bgView4 addSubview:_nowDateLab];
    
    NSString *str=_model.Time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _nowDateLab.bottom+5, 260, 20)];
    _timeLab.text=[dateFormatter stringFromDate: detaildate];
    _timeLab.textColor=RGBCOLOR(100, 100, 100);;
    _timeLab.font=[UIFont systemFontOfSize:MiddleFont];
    [bgView4 addSubview:_timeLab];
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(10, bgView4.bottom - 0.5, MSW, 0.5)];
    _line.backgroundColor=RGBCOLOR(217, 217, 217);
    [bgView4 addSubview:_line];
    
   

}
#pragma mark - 点击确认地址按钮

-(void)gotoAddress
{
    if ([self.redModel.status isEqualToString:@"3"]) {
        GameViewController * game = [[GameViewController alloc]init];
        [self.navigationController pushViewController:game animated:YES];
            game.delegate=self;
            game.index=@"1234";
        
    }
    else if ([self.redModel.status isEqualToString:@"2"]){
        payController * pay = [[payController alloc]init];
        pay.delegate=self;
        pay.index=@"4567";

        [self.navigationController pushViewController:pay animated:YES];
    }
    else{
        AddressViewController * address = [[AddressViewController alloc]init];
        [self.navigationController pushViewController:address animated:YES];
        address.delegate=self;
        address.index=@"8901";
    }
}

-(void)passAddressDto:(AddressDto *)dto tag:(NSString *)tag{
    if ([tag isEqualToString:@"0"]){
        siteid=[NSString stringWithFormat:@"%@",dto.idd];
        [self getData];
        
    }
}

//---------------------以下是王可伟添加的

#pragma mark 去晒单
-(void)gotoshaidan{
    DebugLog(@"去晒单");
    DebugLog(@"---%@",_model.shopid);
    AddShaidanController *con=[[AddShaidanController alloc]init];
    con.shopid=_model.shopid;
    con.idD=_redModel.idD;
    [self.navigationController pushViewController:con animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
