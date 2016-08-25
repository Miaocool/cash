//
//  SettlementViewController.m
//  yyxb
//
//  Created by 杨易 on 15/12/4.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "SettlementViewController.h"
#import "SettlementView.h"
#import "PayCell.h"
#import "DiscountCell.h"
#import "HongbaoModel.h"
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "WXApiObject.h"

#import "PayResultController.h"
@interface SettlementViewController ()<UITableViewDataSource,UITableViewDelegate,SettlementViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源
@property (nonatomic, strong) SettlementView *settView1; // 自定义view
@property (nonatomic, strong) SettlementView *settView2; // 自定义view
@property (nonatomic, strong) SettlementView *settView3; // 自定义view
@property (nonatomic, strong) SettlementView *settView4; // 自定义view
@property (nonatomic, strong) UILabel *numLabel; //余额数量
@property (nonatomic, strong) NSArray *titleArray; //标题
@property (nonatomic, strong) NSArray *payIconArray; //支付方式图标
@property (nonatomic, strong) NSMutableArray *settViewArray; //view 数组
@property (nonatomic ,strong) NSMutableArray *strArray;  //拼接标题等
@property (nonatomic ,strong) NSMutableArray *numStrArray;  //拼接人次
@property (nonatomic, strong) UIButton *settlementBtn;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) NSMutableArray *hongbaoArray; //红包
@property (nonatomic, strong)HongbaoModel *model; //通知传回来的model
@property (nonatomic, copy) NSString *hongbaoPrice; //红包价格
@property (nonatomic, copy) NSString *payClass; //选择支付类型
@property(nonatomic,copy)NSString *url;

/** 其他支付所需要的钱 */
@property(nonatomic,assign)NSInteger otherMoney;

@end

@implementation SettlementViewController
{
    BOOL _isSelected; //是否选中
    
    //    BOOL _isYue; //余额
    NSInteger _hongbaoAdd; //红包 + 余额 判断。
    
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
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self initTableView];
    self.title = @"支付订单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinpayOk:) name:@"WEIXINPAYS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinpayCancel) name:@"WEIXINPAYC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinpayFail) name:@"WEIXINPAYF" object:nil];
    
    //支
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upPayOk:) name:@"UPPAYSUCCESS" object:nil];
    //微
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PayOk) name:@"WeiPAYSUCCESS" object:nil];
    
    //先判断是否显示余额支付
    if ([self.totalYue isEqualToString:@"0"]) {
        //不显示余额支付
        _isSelected = NO;
        self.otherMoney = [self.settModel.jiage integerValue] - [self.hongbaoPrice integerValue];
    }else{
        //再判断是否有余额
        if ([self.settModel.money integerValue] > 0) {
            //有余额，余额支付默认被选中
            _isSelected = YES;
            self.otherMoney = [self.settModel.jiage integerValue] - [self.settModel.money integerValue] - [self.hongbaoPrice integerValue];
        }else{
            _isSelected = NO;
            self.otherMoney = [self.settModel.jiage integerValue] - [self.hongbaoPrice integerValue];
        }
    }
    
}

#pragma mark 初始化数据
- (void)initData
{
    //    _isYue = YES;
//    self.titleArray = @[@{@"支付宝":@"推荐拥有支付宝的用户使用"},@{@"微信支付":@"微信支付"},@"其它"];
    self.payIconArray = @[@"01",@"02"];
    
    if (!self.settView1)
    {
        self.settView1 = [[SettlementView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    }
    if (!self.settView2)
    {
        self.settView2 = [[SettlementView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    }
    if (!self.settView3)
    {
        self.settView3 = [[SettlementView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    }
    if (!self.settView4)
    {
        self.settView4 = [[SettlementView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    }
    self.strArray = [NSMutableArray array];
    self.numStrArray = [NSMutableArray array];
    self.hongbaoArray = [NSMutableArray array];
    
}

#pragma mark - 创建tableview
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSW, MSH - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.settView1.isOpen)
        {
            return self.settModel.shop.count;
        }
        else
        {
            return 0;
        }
    }
    else if (section == 1)
    {
        if (self.settModel.hongbao.count == 0) {
            return 0;
        }else{
            if (self.settView2.isOpen)
            {
                return 1;
            }
            return 0;
        }
    }
    else if (section == 2)
    {
        return 0;
    }
    else if(section == 3)
    {
        if (_isSelected){//选择了余额支付
            if (self.otherMoney > 0) {
                //选择了余额支付，但是余额不够，还要显示其他支付
                return self.zhifuNameArray.count;
            }else{
                //选择了余额支付，余额够了，就不显示其他支付了
                return 0;
            }
        }else{//没有选择余额支付
            return self.zhifuNameArray.count;
        }
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    static NSString *payCellName = @"PayCell";
    static NSString *discountCellName = @"DiscountCell";
    
    if (indexPath.section == 3)
    {
        PayCell *payCell = [tableView dequeueReusableCellWithIdentifier:payCellName];
        if (!payCell)
        {
            payCell = [[PayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payCellName];
        }

        payCell.titleLabel.text = [self.zhifuNameArray objectAtIndex:indexPath.row];
        payCell.littleTitleLabel.text=[self.zhifuTishiArray objectAtIndex:indexPath.row];
        
        [payCell.iconImg sd_setImageWithURL:[self.zhifuImgArray objectAtIndex:indexPath.row]];
        
        payCell.littleTitleLabel.textColor = [UIColor colorWithHex:[self.zhifuColorArray objectAtIndex:indexPath.row]];
        
        return payCell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        DiscountCell *discountCell = [tableView dequeueReusableCellWithIdentifier:discountCellName];
        if (!discountCell)
        {
            discountCell = [[DiscountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:discountCellName];
        }
        if (self.hongbaoArray.count == 0)
        {
            [self.settModel.hongbao enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                HongbaoModel *model = [[HongbaoModel alloc]initWithDictionary:obj];
                [self.hongbaoArray addObject:model];
                
            }];
            
        }
        discountCell.hongbaoArray = self.hongbaoArray;
        discountCell.isOpen = self.settView2.isOpen;
        return discountCell;
    }
    else if(indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        }
        cell.userInteractionEnabled = NO;
        [self.settModel.shop enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            NSString *str = [NSString stringWithFormat:@"%@",obj[@"title"]];
            if (str.length > 20) {
                str = [str substringToIndex:20];
            }
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attStr addAttribute:NSForegroundColorAttributeName value:MainColor range:[str rangeOfString:[NSString stringWithFormat:@"%@",obj[@"nu"]]]];
            
            [self.strArray addObject:attStr];
            
            NSString *str2 = [NSString stringWithFormat:@"%@人次",obj[@"num"]];
            
            NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc]initWithString:str2];
            [attStr2 addAttribute:NSForegroundColorAttributeName value:MainColor range:[str2 rangeOfString:[NSString stringWithFormat:@"%@",obj[@"nu"]]]];
            [self.numStrArray addObject:attStr2];
        }];
        
        cell.textLabel.attributedText = self.strArray[indexPath.row];
        cell.detailTextLabel.attributedText = self.numStrArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:MiddleFont];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:MiddleFont];
        //        cell.textLabel.numberOfLines = 2;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击清空所在的section的状态
    DebugLog(@"点击：%ld-----%ld", (long)indexPath.section,(long)indexPath.row);
    if (indexPath.section == 1 && indexPath.row == 0)
    {
//        DebugLog(@"1111");
    }
    else
    {
        for (int i=0; i<[tableView numberOfRowsInSection:indexPath.section]; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            PayCell *unchechCell = (PayCell*)[tableView cellForRowAtIndexPath:path];
            unchechCell.isChoose = NO;
            PayCell *cell = (PayCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.isChoose = YES;
            
        }
    }
    if (indexPath.section == 3)
    {
        if (_isSelected && self.otherMoney <= 0)
        {//选择了余额支付，并且不需要其他支付
            self.payClass=@"";
        }
        else
        {
            self.payClass = [self.classArray objectAtIndex:indexPath.row]; //支付宝
            DebugLog(@"%@",self.payClass);
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        self.settView1.jiangpinBtn.tag = 101;
        [self.settView1.jiangpinBtn addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        self.settView1.textLabel.text = [NSString stringWithFormat:@"%@元米币",self.settModel.totalPrice];
        return self.settView1;
    }
    else if(section == 1)
    {
        self.settView2.titleLabel.text = @"红包抵扣";
        self.settView2.textLabel.textColor = MainColor;
        self.settView2.backgroundColor=[UIColor clearColor];
        
        if (self.settModel.hongbao.count == 0)
        {
            self.settView2.textLabel.text = @"无可用红包";
            self.settView2.textLabel.textColor = [UIColor grayColor];
            self.settView2.titleLabel.textColor = [UIColor grayColor];
            self.settView2.jiangpinBtn.userInteractionEnabled = NO;
        }
        else
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remainingNum:) name:@"remaining" object:nil];
        }
        self.settView2.textLabel.textColor = [UIColor grayColor];
        self.settView2.tag = 101;
        self.settView2.imageView.frame = CGRectMake(MSW - 19 - 10, self.settView2.jiangpinBtn.frame.size.height / 2 , 20, 9);
        //        self.settView2.imageView.image = [UIImage imageNamed:@"choose2"];
        
        [self.settView2.jiangpinBtn addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        
        return self.settView2;
    }
    else if (section == 2)
    {
        self.settView3.titleLabel.text = @"支付余额";
        self.settView3.titleLabel.frame = CGRectMake(5, self.settView3.jiangpinBtn.frame.size.height / 2 - 10, 15 * 4, 20);
        //设置余额数量
        if (!self.numLabel)
        {
            self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.settView3.titleLabel.frame.size.width + 5, self.settView2.jiangpinBtn.frame.size.height / 2 - 10, 150, 20)];
        }
        self.numLabel.font = [UIFont systemFontOfSize: 10];
        self.numLabel.text = [NSString stringWithFormat:@"(账户余额：%@米币)",self.settModel.money];
        [self.settView3.jiangpinBtn addSubview:self.numLabel];
        self.settView3.imageView.hidden = YES;
        self.settView3.textLabel.hidden = YES;
        [self.settView3.jiangpinBtn  addTarget:self action:@selector(tupian:) forControlEvents:UIControlEventTouchDown];
        
        //添加按钮 是否选中
        UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = CGRectMake(MSW - 10 - 19, self.settView3.jiangpinBtn.frame.size.height / 2 - 9, 19, 19);
        [selectedBtn addTarget:self action:@selector(tupian:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_isSelected)
        {
            [selectedBtn setBackgroundImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
        }
        else
        {
            [selectedBtn setBackgroundImage:[UIImage imageNamed:@"choose2"] forState:UIControlStateNormal];
            
        }
        
        [self.settView3.jiangpinBtn addSubview:selectedBtn];
        //判断如果余额为0，就让该行（即余额支付）不可点
        if ([self.settModel.money isEqualToString:@"0"]) {
            self.settView3.userInteractionEnabled = NO;
            selectedBtn.userInteractionEnabled = NO;
            self.settView3.titleLabel.textColor = [UIColor grayColor];
            self.numLabel.textColor = [UIColor grayColor];
        }else{
            self.settView3.userInteractionEnabled = YES;
            selectedBtn.userInteractionEnabled = YES;
            self.settView3.titleLabel.textColor = [UIColor blackColor];
            self.numLabel.textColor = [UIColor blackColor];
        }
        
        return self.settView3;
    }
    else if (section == 3)
    {
        self.settView4.titleLabel.text = @"其它支付";
        NSString *str = @"";
        if (_isSelected) {
            self.otherMoney = [self.settModel.jiage integerValue] - [self.settModel.money integerValue] - [self.hongbaoPrice integerValue];
            str = [NSString stringWithFormat:@"￥%ld",[self.settModel.jiage integerValue] - [self.settModel.money integerValue] - [self.hongbaoPrice integerValue]];
        }else{
            self.otherMoney = [self.settModel.jiage integerValue] - [self.hongbaoPrice integerValue];
            str = [NSString stringWithFormat:@"￥%ld",[self.settModel.jiage integerValue] - [self.hongbaoPrice integerValue]];
        }
        self.settView4.textLabel.text = str;
        self.settView4.imageView.hidden = YES;
        return self.settView4;
    }
    else
    {
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, MSW, 100)];
        
        self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.payBtn.layer.cornerRadius = 10;
        self.payBtn.frame = CGRectMake(10, 20, MSW - 20, 40);
        self.payBtn.backgroundColor = MainColor;
        [self.payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [self.payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:self.payBtn];
        
        return btnView;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"111";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.settModel.totalPrice integerValue] <= ([self.hongbaoPrice integerValue] + [self.settModel.money integerValue]))
    {
        if (section == 3)
        {
            if (_isSelected) {
                return 0;
            }else{
                return 40;
            }
        }
        
    }
    if  ([self.settModel.totalPrice intValue] <= [self.hongbaoPrice intValue])
    {
        if (section == 2)
        {
            return 0;
        }
    }
    if (section == 2) {
        if ([self.totalYue isEqualToString:@"0"] || [self.settModel.money isEqualToString:@"0"]) {
            //不显示余额支付
            return 0;
        }else{
            return 40;
        }
    }
    if (section == 1) {
        if (self.settModel.hongbao.count == 0) {
            return 0;
        }else{
            return 40;
        }
    }
    if(section ==4)
    {
        return 100;
    }
    else
        return 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.settModel.totalPrice integerValue] <= ([self.hongbaoPrice integerValue] + [self.settModel.money integerValue]))
    {
        if (indexPath.section == 1 && indexPath.row == 0)
        {
            return 130;
        }
        else if(indexPath.section ==4 && indexPath.row == 0)
        {
            return 100;
        }
        else if (indexPath.section == 3)
        {
            if (_isSelected) {
                return 0;
            }else{
                return 50;
            }
        }else{
            return 40;
        }
    }
    else
    {
        if (indexPath.section == 1 && indexPath.row == 0)
        {
            return 130;
        }
        else if(indexPath.section ==4 && indexPath.row == 0)
        {
            return 100;
        }
        else if (indexPath.section == 3)
        {
            return 50;
        }
        else
            return 40;
        
    }
    
    
    
}

- (void)open:(UIButton *)button
{
    
    if (button.tag == 101)
    {
        self.settView1.isOpen = !self.settView1.isOpen;
        if (self.settView1.isOpen)
        {
            self.settView1.imageView.image = [UIImage imageNamed:@"arrow_up"];
            //            [self.tableView reloadData];
        }
        else
        {
            self.settView1.imageView.image = [UIImage imageNamed:@"arrow_down"];
            //            [self.tableView reloadData];
        }
    }
    else
    {
        self.settView2.isOpen = !self.settView2.isOpen;
        if (self.settView2.isOpen)
        {
            self.settView2.imageView.image = [UIImage imageNamed:@"arrow_up"];
            //            [self.tableView reloadData];
        }
        else
        {
            self.settView2.imageView.image = [UIImage imageNamed:@"arrow_down"];
            self.settView2.textLabel.text = @"";
            self.hongbaoPrice = nil;
            //通知红包选中状态
            BOOL isOpen = self.settView2.isOpen;
            
            NSNumber *num = [NSNumber numberWithBool:isOpen];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: num,@"bool", nil];
            NSNotification *modelNotification =[NSNotification notificationWithName:@"isOpen" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:modelNotification];
            
            self.model = nil;
            
            if (_isSelected) {
                self.otherMoney = [self.settModel.jiage integerValue] - [self.settModel.money integerValue] - [self.hongbaoPrice integerValue];
            }else{
                self.otherMoney = [self.settModel.jiage integerValue] - [self.hongbaoPrice integerValue];
            }
        }
    }
    
    DebugLog(@"ifReadOnly value: %@" ,self.settView1.isOpen?@"YES":@"NO");
    [self.tableView reloadData];
}

- (void)tupian:(UIButton *)btn
{
    if (_isSelected)
    {
        _isSelected = NO;
        self.settView3.imageView.image = [UIImage imageNamed:@"choose2"];
        self.otherMoney = [self.settModel.jiage integerValue] - [self.hongbaoPrice integerValue];
    }
    else
    {
        _isSelected = YES;
        self.settView3.imageView.image = [UIImage imageNamed:@"choose1"];
        self.otherMoney = [self.settModel.jiage integerValue] - [self.settModel.money integerValue] - [self.hongbaoPrice integerValue];
    }
    
    [self.tableView reloadData];
}

#pragma mark 选中余额支付
- (void)selected:(UIButton *)button
{
    if (_isSelected == YES)
    {
        [button setImage:[UIImage imageNamed:@"choose1"] forState:UIControlStateNormal];
        _isSelected = NO;
        
        
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"choose2"] forState:UIControlStateNormal];
        _isSelected = YES;
    }
    [self.tableView reloadData];
}

#pragma mark 通知更新米币
- (void)remainingNum:(NSNotification *)text
{
    
    self.model = text.userInfo[@"model"];
    self.settView2.textLabel.text =[NSString stringWithFormat:@"%@米币",self.model.type_money];
    self.hongbaoPrice = self.model.type_money;
    
    
    if (_isSelected) {
        self.otherMoney = [self.settModel.jiage integerValue] - [self.settModel.money integerValue] - [self.hongbaoPrice integerValue];
    }else{
        self.otherMoney = [self.settModel.jiage integerValue] - [self.hongbaoPrice integerValue];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark  确认支付
- (void)pay
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    //支付宝测试
    NSMutableArray *array = [NSMutableArray array];
    [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
        [array addObject:obj.goodsId];
    }];
    //NSString * str = [array componentsJoinedByString:@","];
    if ([_payClass isEqualToString:@"wapalipay"])
    {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict setValue:self.goods forKey:@"cart"];
        [dict setValue:self.payClass forKey:@"zhifu"];  //  4 ---- 支付宝  10 ------ 微信支付
        [dict setValue:self.model.type_id forKey:@"hid"]; //红包 id 可选
        if (_isSelected){//选择了余额支付
            
            [dict setValue:@"100" forKey:@"mid"]; //用户余额  可选
            
            if (self.otherMoney <= 0) {
                //并且不需要其他支付
                [dict setValue:@"" forKey:@"zhifu"];
                
                self.payClass = @"";
                
            }else{//还需要其他支付
                
                if (IsStrEmpty(self.payClass)) {
                    [SVProgressHUD showErrorWithStatus:@"请选择支付平台"];
                    return;
                }
            }
        }else{
            if (IsStrEmpty(self.payClass)) {
                [SVProgressHUD showErrorWithStatus:@"请选择支付平台"];
                return;
            }
        }
        [MDYAFHelp AFPostHost:APPHost bindPath:WebPay postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            
            DebugLog(@"responseDic：-----------------%@",responseDic);
            if ([responseDic[@"code"] isEqualToString:@"400"])
            {
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                [SVProgressHUD dismiss];
                
                if ([self.payClass isEqualToString:@"wapalipay"])
                {
                    _url=responseDic[@"data"];
                    [self gotoZhifubaoPay2];
                    
                }

                else
                {
                    NSDictionary*data=responseDic[@"data"];
                    NSDictionary*obj=data[@"obj"];
                    DebugLog(@"--%@--",obj[@"title"]);
                    NSDictionary *dataDic = responseDic[@"data"];
                    NSDictionary *objDic = dataDic[@"obj"];
                    _key = EncodeFormDic(objDic, @"key");
                    _out_trade_no=_key;
                    
                    [self payOrdCallback:@"1"];
                    
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            
        }];
        
    }
    else if([_payClass isEqualToString:@"alipay"])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict setValue:self.goods forKey:@"cart"];
        [dict setValue:@"4" forKey:@"pid"];  //  4 ---- 支付宝  10 ------ 微信支付
        [dict setValue:self.model.type_id forKey:@"hid"]; //红包 id 可选
       
        

        if (_isSelected){//选择了余额支付
            [dict setValue:@"100" forKey:@"mid"]; //用户余额  可选
            
            if (self.otherMoney <= 0) {
                //并且不需要其他支付
                [dict setValue:@"" forKey:@"zhifu"];
                
                self.payClass = @"";
                
            }else{//还需要其他支付
                
                if (IsStrEmpty(self.payClass)) {
                    [SVProgressHUD showErrorWithStatus:@"请选择支付平台"];
                    return;
                }
            }
        }else{
            if (IsStrEmpty(self.payClass)) {
                [SVProgressHUD showErrorWithStatus:@"请选择支付平台"];
                return;
            }
        }
        [MDYAFHelp AFPostHost:APPHost bindPath:Pay postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            
            DebugLog(@"responseDic：------------%@",responseDic);
            if ([responseDic[@"code"] isEqualToString:@"400"])
            {
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                [SVProgressHUD dismiss];
                
                if ([self.payClass isEqualToString:@"alipay"])
                {
                    //                     [self gotozhifubao];
                    NSDictionary *dataDic = responseDic[@"data"];
                    NSDictionary *objDic = dataDic[@"obj"];
                    _key = EncodeFormDic(objDic, @"key");
                    
                    //支付宝支付
                    NSDictionary *data = responseDic[@"data"];
                    NSDictionary *alipayObj = data[@"alipayobj"];
                    
                    _notify_url = EncodeFormDic(alipayObj, @"notify_url");
                    _partnerID = EncodeFormDic(alipayObj, @"partner");
                    _body = EncodeFormDic(alipayObj, @"body");
                    _total_fee = EncodeFormDic(alipayObj, @"total_fee");
                    _subject = EncodeFormDic(alipayObj, @"subject");
                    _rsa_private_code = EncodeFormDic(alipayObj, @"rsa_private_code");
                    _seller_id = EncodeFormDic(alipayObj, @"seller_id");
                    _out_trade_no = EncodeFormDic(alipayObj, @"out_trade_no");
                    _payment_type = EncodeFormDic(alipayObj, @"payment_type");
                    _rsa_private = EncodeFormDic(alipayObj, @"rsa_private");
                    
                    DebugLog(@"%@======",_rsa_private);
                    DebugLog(@"%@!!!!!!!",_notify_url);
                    DebugLog(@"%@______",_partnerID);
                    DebugLog(@"%@--------",_body);
                    DebugLog(@"~!!!!!!%@",_key);
                    
                    [self gotoZhifubaoPay];
                }
                else
                {
                    NSDictionary*data=responseDic[@"data"];
                    NSDictionary*obj=data[@"obj"];
                    DebugLog(@"--%@--",obj[@"title"]);
                    NSDictionary *dataDic = responseDic[@"data"];
                    NSDictionary *objDic = dataDic[@"obj"];
                    _key = EncodeFormDic(objDic, @"key");
                    _out_trade_no=_key;
                    
                    [self payOrdCallback:@"1"];
                    
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            
        }];
        
    }
    else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict setValue:self.goods forKey:@"cart"];
        [dict setValue:@"10" forKey:@"pid"];  //  4 ---- 支付宝  10 ------ 微信支付
        [dict setValue:self.model.type_id forKey:@"hid"]; //红包 id 可选
        
        if (IsStrEmpty(_model.type_id)) {
            
        }else{
            _isSelected=YES;
            [dict setValue:@"" forKey:@"pid"];
        }
        
        DebugLog(@"==---%@",_model.type_id);
        
        if (_isSelected){//选择了余额支付
            
            [dict setValue:@"100" forKey:@"mid"]; //用户余额  可选

//            [dict setValue:@"" forKey:@"pid"];
            if (self.otherMoney <= 0) {
                //并且不需要其他支付
                [dict setValue:@"" forKey:@"zhifu"];
                
                self.payClass = @"";
                
            }else{//还需要其他支付
                
                if (IsStrEmpty(self.payClass)) {
                    [SVProgressHUD showErrorWithStatus:@"请选择支付平台"];
                    return;
                }
            }
        }else{
            if (IsStrEmpty(self.payClass)) {
                [SVProgressHUD showErrorWithStatus:@"请选择支付平台"];
                return;
            }
        }
        [MDYAFHelp AFPostHost:APPHost bindPath:Pay postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"responseDic：------------------------%@",responseDic);
            if ([responseDic[@"code"] isEqualToString:@"400"])
            {
                [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            }
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                [SVProgressHUD dismiss];
                if ([self.payClass isEqualToString:@"app_wxpay"])
                {
                    //  [self PayOk];
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
                    NSDictionary*data=responseDic[@"data"];
                    NSDictionary*obj=data[@"obj"];
                    DebugLog(@"--%@--",obj[@"title"]);
                    NSDictionary *dataDic = responseDic[@"data"];
                    NSDictionary *objDic = dataDic[@"obj"];
                    _key = EncodeFormDic(objDic, @"key");
                    _out_trade_no=_key;
                    
                    [self payOrdCallback:@"1"];
                    
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
    }
}
#pragma mark - 支付 网页
-(void)gotoZhifubaoPay2
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
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
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
    
}
#pragma mark 支付宝赋值
- (void)gotoZhifubaoPay
{
    Order *order = [[Order alloc] init];
    order.partner = _partnerID;
    order.seller = _seller_id;
    order.tradeNO = _out_trade_no;               //订单Id
    order.productName = _body; //商品标题
    order.productDescription = _subject; //商品描述
    order.amount = _total_fee; //商品价格
    order.notifyURL =  _notify_url;//回调URL
    DebugLog(@"回调URL：%@",order.notifyURL);
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    //    order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = @"openAlipayH5.com.bxsapp.myg";
    
    NSString *orderSpec = [order description];
    DebugLog(@"orderSpec = %@",orderSpec);
    
    id<DataSigner> signer = CreateRSADataSigner(_rsa_private);  //私钥－－－－－－－－－－－
    
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

#pragma mark 微信支付
-(void)weixinPay{
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

-(void)weixinpayOk:(NSNotification *)noti{
    [self payOrdCallback:@"1"];
    
}

-(void)weixinpayCancel{
    
    [SVProgressHUD showErrorWithStatus:@"取消支付"];
}

-(void)weixinpayFail{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
}

-(void)paymentResult:(NSString *)resultd
{
    // DLog(@" = %@",resultd)
    //结果处理
    if ([resultd isEqualToString:@"9000"]) {
        
        [self payOrdCallback:@"1"];
    }else if ([resultd isEqualToString:@"6001"]){
        
        //交易取消
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取消支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        //        [self payOrdCallback:@"0"];
    }else{
        
        [self payOrdCallback: @"0"];
    }
    
}

#pragma mark -支付回调
- (void)payOrdCallback:(NSString *)status
{
    //支付宝测试
    NSMutableArray *array = [NSMutableArray array];
    [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
        [array addObject:obj.goodsId];
    }];
    
    NSString * str = [array componentsJoinedByString:@","];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:status forKey:@"status"];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:_key forKey:@"ordernumber"];
    [dict setValue:str forKey:@"id"];
    
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Callback postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"------%@",responseDic);
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            
            NSArray*data=responseDic[@"data"];
            
            PayResultController *userData = [[PayResultController alloc]init];
            userData.tiaotype=1;
            userData.Payarray=data;
            userData.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userData animated:YES];
            
            
            [[UserDataSingleton userInformation].shoppingArray removeAllObjects];
            
            //通知 改变徽标个数
            NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:responseDic[@"msg"]];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

#pragma mark 确认支付弹话框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.payBtn.userInteractionEnabled=YES;
    //    [SVProgressHUD showErrorWithStatus:@"交易失败"];
    
    [[UserDataSingleton userInformation].shoppingArray removeAllObjects];
    self.tabBarController.selectedIndex = 0;
    
    // 通知 改变徽标个数
    NSNotification *notification =[NSNotification notificationWithName:@"shoppingNum" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DebugLog(@"回调：%@",NSStringFromClass([delegate.window.rootViewController class]));
    DebugLog(@"位置%@",self.tabBarController);
    DebugLog(@"位置！%ld",self.tabBarController.selectedIndex);
    DebugLog(@"有多少视图！%@",self.tabBarController.viewControllers);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
