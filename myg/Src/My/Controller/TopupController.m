//
//  TopupController.m
//  yyxb
//
//  Created by lili on 15/11/19.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "TopupController.h"
#import "TopUpViewCell.h"
#import "RechargeDto.h"
#import "PayCell.h"

//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayResultController.h"
//微信
#import "WXApi.h"
#import "WXApiObject.h"
#import "TopuprecordController.h"

@interface TopupController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{

    NSMutableArray  *_buttonArray;
    UIView           *_tablefooterView;
    
    UITextField     *_tfmoney;  //其它金额
    UIButton        *moneyBtn;  //金额button
    NSArray         *moneyarr;  //金额数组
    NSMutableArray  *_seletearr;  //选择image
    
    /*   支付宝信息  */
    NSString                        *_notify_url;
    NSString                        *_partnerID;
    NSString                        *_total_fee;
    NSString                        *_subject;
    NSString                        *_body;
    NSString                        *_rsa_private_code;
    NSString                        *_seller_id;
    NSString                        *_out_trade_no;
    NSString                        *_rsa_private;
    NSString                        *_payment_type;
    
    NSString                        *_key;
    NSString *_code;
    /*   微信信息  */
    
    NSString                        *_sign;
    NSString                        *_timestamp;
    NSString                        *_partnerid;
    NSString                        *_noncestr;
    NSString                        *_package;
    NSString                        *_appid;
    NSString                        *_prepayid;
    
    
    NSString *Pay_name;  //支付方式的名字
    NSString *_payClass;  //支付方式的id
    
    int morenLiang; //默认亮
    int _isselete;
    
}
@property (nonatomic, strong) UIView*headview; // 页眉
@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *titleArray;  //支付方式
@property(nonatomic,strong)NSMutableArray *zhifuNameArray; //支付名字
@property (nonatomic,strong)NSMutableArray * iconArray; //支付方式图标
@property (nonatomic,strong)NSMutableArray * tishiArray; //支付方式标题
@property (nonatomic,strong)NSMutableArray * colorArray; //支付颜色

@property (nonatomic, copy) NSString *number; //选择支付金额
@property (nonatomic, strong) UILabel  *tishiLab;  //提示lab
@property (nonatomic, strong) UIButton  *exitBtn;  //立即充值
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,copy)NSString *url;

@end

@implementation TopupController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self getData];
//    [self getTishi];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充值";
//    _payClass=@"alipay";
    
    self.titleArray=[NSMutableArray array];
    self.zhifuNameArray=[NSMutableArray array];
    self.array=[NSMutableArray array];
    self.tishiArray=[NSMutableArray array];
    self.colorArray=[NSMutableArray array];
    
    self.array=[NSMutableArray array];
    
//    self.iconArray = @[@"01",@"02"];
    self.iconArray=[NSMutableArray array];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    _buttonArray = [NSMutableArray array];
    moneyarr=@[@"20",@"50",@"100",@"200",@"500"];
    _seletearr=[NSMutableArray array];
    [_seletearr addObject:@"choose2-2"];
    [_seletearr addObject:@"choose2-1"];
    [_seletearr addObject:@"choose2-1"];
    [_seletearr addObject:@""];
    [self createheadview];
    
  //    添加手势隐藏键盘
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_headview addGestureRecognizer:singleRecognizer];
   
    // 修改的－－－充值－－
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinpayOk:) name:@"WEIXINPAYS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinpayCancel) name:@"WEIXINPAYC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinpayFail) name:@"WEIXINPAYF" object:nil];
    
    
    //支跳
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upPayOk:) name:@"UPPAYSUCCESS" object:nil];
    
    //微跳
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayOk) name:@"WeiPAYSUCCESS" object:nil];
}

#pragma arguments - 获得充值提示
//-(void)getTishi
//{
//    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
//    [MDYAFHelp AFPostHost:APPHost bindPath:infmotion postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
//        DebugLog(@"---%@",responseDic);
//        if ([responseDic[@"code"] isEqualToString:@"200"])
//        {
//            NSDictionary*data=responseDic[@"data"];
//            self.tishiLab.text=data[@"value"];
////            DebugLog(@"!!!!!%@",self.tishiLab.text);
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
//    }];
//}

#pragma arguments -- 获取数据
-(void)getData
{
    [self.titleArray removeAllObjects];
    [self.zhifuNameArray removeAllObjects];
    [self.iconArray removeAllObjects];
    [self.tishiArray removeAllObjects];
    [self.colorArray removeAllObjects];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    
    [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict1 setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"ver"];
    [MDYAFHelp AFPostHost:APPHost bindPath:xinchongzhiData postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"---%@",responseDic);
      if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            self.array = responseDic[@"data"];
            // DebugLog(@"++++++%@",self.array);
            [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                _model = [[RechargeDto alloc]initWithDictionary:obj];
                [self.titleArray addObject:_model.pay_class];
                [self.zhifuNameArray addObject:_model.pay_name];
                [self.iconArray addObject:_model.img];
                [self.tishiArray addObject:_model.tishi];
                [self.colorArray addObject:_model.color];
                
//              DebugLog(@"+++%@+++%@ ",_model.pay_class,_model.pay_name);
            }];
            
            [_tableView reloadData];
        }
      else{
          [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
      }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}


#pragma mark - 顶部view  add By liangjun
- (void)createheadview{
    
    _headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW,295)];
    _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UIImageView*headimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MSW, 80)];
    headimg.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    headimg.image=[UIImage imageNamed:@"rechage"];
    [_headview addSubview:headimg];
    
    UILabel *lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, MSW-40, 40)];
    lbtitle.text=@"充值获得米币(1元=1米币),可用于夺宝,充值的款项将无法退回。";
    lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    lbtitle.lineBreakMode=NSLineBreakByCharWrapping;
    lbtitle.numberOfLines=0;
    [headimg addSubview:lbtitle];

    //存放数字view
    UIView*seleteview=[[UIView alloc]initWithFrame:CGRectMake(0, headimg.bottom+5, MSW, 160)];
    seleteview.backgroundColor=[UIColor whiteColor];
    [_headview addSubview:seleteview];
    
    UILabel*lbcount=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, MSW-40, 15)];
    lbcount.text=@"选择充值金额（元）";
    lbcount.font=[UIFont systemFontOfSize:BigFont];
    [seleteview addSubview:lbcount];
    
    
    CGFloat W = ([UIScreen mainScreen].bounds.size.width-50)/3;
    CGFloat H = 45;
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIButton*bt=[[UIButton alloc]initWithFrame:CGRectMake(MSW-70, 0, 70, 40)];
    [bt setTitle:@"完成" forState:UIControlStateNormal];
    bt.titleLabel.font=[UIFont systemFontOfSize:18];
    [bt setTitleColor:MainColor forState:0];
    //    [bt setBackgroundColor:[UIColor redColor]];
    //实现方法
    [bt addTarget:self action:@selector(handleSingleTapFrom) forControlEvents:UIControlEventTouchDown ];
    [view addSubview:bt];
    
    for (int i = 0; i<5; i++) {
        moneyBtn = [[UIButton alloc]initWithFrame:CGRectMake(10+(10+W)*(i%3), 30 + 10 + 10*(i/3)+(i/3) * H, W, H)];
        [moneyBtn setTitle:[moneyarr objectAtIndex:i] forState:UIControlStateNormal];
        [moneyBtn setBackgroundColor:[UIColor whiteColor]];
        [moneyBtn setTitleColor:RGBCOLOR(80, 80, 80) forState:UIControlStateNormal];
        moneyBtn.layer.borderWidth = 1.5;
        moneyBtn.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
        moneyBtn.tag = i;
        [moneyBtn addTarget:self action:@selector(hotBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        _tfmoney=[[UITextField alloc]initWithFrame:CGRectMake(10+(10+W)*(65%3), 30 + 10 + 10*(5/3)+(5/3) * H, W, H)];
        _tfmoney.placeholder=@"其它金额";
        _tfmoney.textAlignment=NSTextAlignmentCenter;
        _tfmoney.textColor=[UIColor grayColor];
        _tfmoney.layer.borderWidth = 1.5;
        _tfmoney.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
        _tfmoney.backgroundColor=[UIColor whiteColor];
        _tfmoney.delegate=self;
        _tfmoney.inputAccessoryView=view;
        _tfmoney.returnKeyType=UIReturnKeyDone;
        _tfmoney.keyboardType=UIKeyboardTypeNumberPad;
        [seleteview addSubview:_tfmoney];
        [seleteview addSubview:moneyBtn];
        
        [_buttonArray addObject:moneyBtn];
    }
    
    UIView * payBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _headview.bottom - 40, MSW, 40)];
    payBgView.backgroundColor = [UIColor whiteColor];
    [_headview addSubview:payBgView];
    
    UILabel*lbpay=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, MSW-40, 30)];
    lbpay.text=@"选择支付方式";
    lbpay.font=[UIFont systemFontOfSize:BigFont];
    [payBgView addSubview:lbpay];
    
    [self initTableView];
}

- (void)initTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, MSW,MSH-64) pullingDelegate:self style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView=self.tablefooterView;
    
    self.tableView.backgroundColor = RGBCOLOR(237, 238, 239);
    [self.view addSubview:self.tableView];
   
}
- (UIView *)tablefooterView
{
    if (!_tablefooterView) {
        _tablefooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 170)];
        _tablefooterView.backgroundColor = [UIColor clearColor];
        _tablefooterView.tag = 1;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, MSW-20, 170)];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.layer.cornerRadius=5;
        [_tablefooterView addSubview:bgView];
        
        
        self.exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 50)];
        self.exitBtn.backgroundColor = MainColor;
        self.exitBtn.layer.cornerRadius = 5;
        self.exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.exitBtn setTitle:@"立刻充值" forState:UIControlStateNormal];
        [self.exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.exitBtn addTarget:self action:@selector(rechare) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:self.exitBtn];
        
//        _tishiLab = [[UILabel alloc] initWithFrame:CGRectMake(10,self.exitBtn.bottom-30, MSW-20,120)];
//        _tishiLab.textAlignment = NSTextAlignmentLeft;
//        _tishiLab.font = [UIFont systemFontOfSize:15];
//        _tishiLab.backgroundColor = [UIColor clearColor];
//        _tishiLab.textColor = [UIColor redColor];
//        _tishiLab.numberOfLines = 0;
//        _tishiLab.lineBreakMode = NSLineBreakByWordWrapping;
//        [bgView addSubview:self.tishiLab];
        
    }
    return _tablefooterView;
}

#pragma mark - 立即充值
-(void)rechare
{
    if (IsStrEmpty(_number)&&IsStrEmpty(_tfmoney.text)) {
        if (IsStrEmpty(_tfmoney.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入充值金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            _number = _tfmoney.text;
        }
    }
    else{
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        if (IsStrEmpty(_number)) {
            [dict1 setValue:_tfmoney.text forKey:@"money"];
            
        }else{
            [dict1 setValue:_number forKey:@"money"];
            
        }
        [dict1 setValue:_payClass forKey:@"zhifu"];
        
        if ([_payClass isEqualToString:@"wapalipay"])
        {
            [MDYAFHelp AFPostHost:APPHost bindPath:WebRecharge postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                DebugLog(@"---%@",responseDic);
                if ([responseDic[@"code"] isEqualToString:@"400"])
                {
                    [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                }
                if ([responseDic[@"code"] isEqualToString:@"201"])
                {
                    [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                }
                if ([responseDic[@"code"] isEqualToString:@"200"]) {
                    
                    [SVProgressHUD dismiss];
                    
                    if ([_payClass isEqualToString:@"wapalipay"])
                    {
                        _url=responseDic[@"data"];
                        [self gotoZhifubaoPay2];
                        
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                        return ;
                    }
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }];
            
        }
        else
        {
            [MDYAFHelp AFPostHost:APPHost bindPath:Recharge postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
                DebugLog(@"---%@",responseDic);
                if ([responseDic[@"code"] isEqualToString:@"400"])
                {
                    [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                }
                if ([responseDic[@"code"] isEqualToString:@"201"])
                {
                    [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                }
                if ([responseDic[@"code"] isEqualToString:@"200"]) {
                    
                    [SVProgressHUD dismiss];
                    if ([_payClass isEqualToString:@"alipay"])
                    {
                        //                        [self gotoZhifubaoBendi];
                        //支付宝支付
                        NSDictionary *dataDic = responseDic[@"data"];
                        NSDictionary *objDic = dataDic[@"obj"];
                        _key = EncodeFormDic(objDic, @"key");
                        
                        NSDictionary *data = responseDic[@"data"];
                        NSDictionary *alipayObj = data[@"alipayobj"];
                        
                        _notify_url = EncodeFormDic(alipayObj, @"notify_url");
                        DebugLog(@"+++++++++++%@",_notify_url);
                        _partnerID = EncodeFormDic(alipayObj, @"partner");
                        _body = EncodeFormDic(alipayObj, @"body");
                        _total_fee = EncodeFormDic(alipayObj, @"total_fee");
                        _subject = EncodeFormDic(alipayObj, @"subject");
                        _rsa_private_code = EncodeFormDic(alipayObj, @"rsa_private_code");
                        _seller_id = EncodeFormDic(alipayObj, @"seller_id");
                        _out_trade_no = EncodeFormDic(alipayObj, @"out_trade_no");
                        _payment_type = EncodeFormDic(alipayObj, @"payment_type");
                        _rsa_private = EncodeFormDic(alipayObj, @"rsa_private");
                        
                        DebugLog(@"~!!!!!!%@",_key);
                        [self gotoZhifubao];
                    }
                    else if ([_payClass isEqualToString:@"app_wxpay"])
                    {
                        //                        [self PayOk];
                        NSDictionary *dataDic = responseDic[@"data"];
                        NSDictionary *objDic = dataDic[@"obj"];
                        _key = EncodeFormDic(objDic, @"key");
                        
                        //微信支付
                        NSDictionary *data = responseDic[@"data"];
                        NSDictionary *weixinObj = data[@"weChatObj"];
                        _sign = EncodeFormDic(weixinObj, @"sign");
                        _timestamp = EncodeFormDic(weixinObj, @"timestamp");
                        _partnerid = EncodeFormDic(weixinObj, @"partnerid");
                        _noncestr = EncodeFormDic(weixinObj, @"noncestr");
                        _package = EncodeFormDic(weixinObj, @"package");
                        _appid = EncodeFormDic(weixinObj, @"appid");
                        _prepayid = EncodeFormDic(weixinObj, @"prepayid");
                        
                        [self weixinPay];
                        
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
                        return ;
                    }
                    
                }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }];
            
        }
        
    }
}
#pragma mark   -网页
-(void)gotoZhifubaoPay2
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
}

#pragma mark 支付宝赋值
- (void)gotoZhifubao
{
    Order *order = [[Order alloc] init];
    order.partner = _partnerID;
    order.seller = _seller_id;
    order.tradeNO = _out_trade_no;               //订单Id
    order.productName = _body; //商品标题
    order.productDescription = _subject; //商品描述
    order.amount = _total_fee; //商品价格
    order.notifyURL =  _notify_url;//回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    //order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = @"openAlipayH5.com.bxsapp.myg";
    
    NSString *orderSpec = [order description];
    DebugLog(@"orderSpec = %@",orderSpec);
    
    id<DataSigner> signer = CreateRSADataSigner(_rsa_private);  //私钥－－－－－－－
    NSString *signedString = [signer signString:orderSpec];
    
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSDictionary *dic = resultDic;
            DebugLog(@"！！！！！！%@",resultDic);
            NSString *resultStr = EncodeFormDic(dic, @"resultStatus");
            
            [self paymentResult:resultStr];
        }];
    }
}

- (void)upPayOk:(NSNotification *)noti
{
    _code = [noti.userInfo objectForKey:@"code"];
    _key = [noti.userInfo objectForKey:@"ordernumber"];
    
    DebugLog(@"===%@",_key);
    
    if ([_code isEqualToString:@"200"]) {
        [self payOrdCallback:@"1"];
    }
    else{
//        [SVProgressHUD showErrorWithStatus:@"充值失败"];
    }
    
}

#pragma mark --微信支付
-(void)weixinPay
{
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = _appid;
    req.partnerId           = _partnerid;
    req.prepayId            = _prepayid;
    req.nonceStr            = _noncestr;
    req.timeStamp           = _timestamp.intValue;
    req.package             = _package;
    req.sign                = _sign;
    
    [WXApi sendReq:req];
}

-(void)weixinpayOk:(NSNotification *)noti
{
    [self payOrdCallback:@"1"];

}

-(void)weixinpayCancel
{

    [SVProgressHUD showErrorWithStatus:@"取消支付"];
}

-(void)weixinpayFail{
    [self payOrdCallback: @"0"];
}
#pragma mark - 结果处理

-(void)paymentResult:(NSString *)resultd
{
    // DLog(@" = %@",resultd)
    //结果处理
    if ([resultd isEqualToString:@"9000"]) {
        
        [self payOrdCallback:@"1"];
    }else if ([resultd isEqualToString:@"6001"]){
         //交易取消
        [self payOrdCallback:@"0"];
    }else{
 
        //交易失败
        [self payOrdCallback: @"0"];
    }
    
}
#pragma mark -支付回调
- (void)payOrdCallback:(NSString *)status
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:status forKey:@"status"];
    [dict setValue:_key forKey:@"order"];
//    [dict setValue:_key forKey:@"key"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:appCallBack postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"+++++%@",responseDic[@"msg"]);
        DebugLog(@"------%@",responseDic);
        if ([responseDic[@"code"] isEqualToString:@"200"]) {

//            [SVProgressHUD showSuccessWithStatus:@"充值成功"];

            TopuprecordController *userData = [[TopuprecordController alloc]init];
            userData.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userData animated:YES];
            
        }
        else{
          [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark - 循环点击金额
- (void)hotBtnTouched:(UIButton *)button
{
    _tfmoney.text=@"";
   [_tfmoney resignFirstResponder];
    _tfmoney.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
    for (UIButton *btn in _buttonArray) {
    
        if (button.tag == btn.tag) {
            btn.layer.borderColor = RGBCOLOR(201, 36, 43).CGColor;
           _number=button.titleLabel.text;
           _tfmoney.text=@"";
            DebugLog(@"-----%@",_tfmoney.text);
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            btn.layer.borderColor =  RGBCOLOR(213, 213, 213).CGColor;            [btn setTitleColor:RGBCOLOR(80, 80, 80) forState:UIControlStateNormal];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    for (UIButton *btn in _buttonArray) {
    btn.layer.borderColor =  RGBCOLOR(213, 213, 213).CGColor;
    [btn setTitleColor:RGBCOLOR(80, 80, 80) forState:UIControlStateNormal];
    }
    _tfmoney.layer.borderColor = RGBCOLOR(201, 36, 43).CGColor;
    _number=_tfmoney.text;
    
//    self.tableView.contentOffset = CGPointMake(0, 300);

    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ((_tfmoney=textField)) {
        _number=_tfmoney.text;
    }
//    self.tableView.contentOffset = CGPointMake(0, 0);

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //    if ([textField isEqualToString:@"\n"])
    //    {
    //        [self handleSingleTapFrom];
    
    
    [_tfmoney resignFirstResponder];
    return NO;
    //    }
}


#pragma mark - 创建表UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return _headview;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 295;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.zhifuNameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _tableView.tableFooterView = [[UIView alloc] init];
    static   NSString *ListingCellName = @"PayCell";
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!cell)
    {
        cell = [[PayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.titleLabel.text = [_zhifuNameArray objectAtIndex:indexPath.row];
    //    cell.iconImg.image = [UIImage imageNamed:[self.iconArray objectAtIndex:indexPath.row]];
    [cell.iconImg sd_setImageWithURL:[self.iconArray objectAtIndex:indexPath.row]];
    cell.littleTitleLabel.text=[self.tishiArray objectAtIndex:indexPath.row];
    cell.littleTitleLabel.textColor = [UIColor colorWithHex:[self.colorArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i=0; i<[tableView numberOfRowsInSection:indexPath.section]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        PayCell *unchechCell = (PayCell*)[tableView cellForRowAtIndexPath:path];
        unchechCell.isChoose = NO;
        PayCell *cell = (PayCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.isChoose = YES;
    }

    if (self.titleArray.count >0  )
    {
        _payClass=[self.titleArray objectAtIndex:indexPath.row];  //支付宝
        
    }

    [self.tableView reloadData];
}


//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom{
    [_tfmoney resignFirstResponder];
    
     _tfmoney.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
