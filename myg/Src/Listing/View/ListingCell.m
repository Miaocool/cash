////
////  ListingCell.m
////  yyxb
////
////  Created by 杨易 on 15/11/12.
////  Copyright (c) 2015年 杨易. All rights reserved.


#import "ListingCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

@implementation ListingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}


- (void)createUI
{
    /*
     @property (nonatomic, strong) UIImageView *headIamgeView; //图片
     @property (nonatomic, strong) UILabel *titleLabel; //标题
     @property (nonatomic, strong) UILabel *needLabel; //总需人数
     @property (nonatomic, strong) UILabel *numLabel; //参与人次
     @property (nonatomic, strong) UIButton *addBtn; //添加
     @property (nonatomic, strong) UIButton *reductionBtn; //减少
     @property (nonatomic, strong) UITextField *textField; //记录寻宝次数
     */
    
    //键盘收回监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //点击按钮收键盘
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, MSW, 70);
    [btn addTarget:self action:@selector(shoujianpan) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    
    //图
    self.headIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(5,20, IPhone4_5_6_6P(80, 80, 100, 100), IPhone4_5_6_6P(80, 80, 100, 100))];
    //    改变图片尺寸   等比例缩放
    _headIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    //  UIViewContentModeScaleAspectFill   横向填充
        [self.contentView addSubview:self.headIamgeView];
    
    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headIamgeView.right +5, 15, MSW - self.headIamgeView.frame.size.width - 25, 55)];
    self.titleLabel.text = @"(第1312期)的撒即可查看见下表v性支出年金额hiu盾hi这循环唱KH露出来了看见我看了血战长空奥斯卡金额开挖了";
    self.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.titleLabel.textColor = RGBCOLOR(86, 87, 88);
    self.titleLabel.numberOfLines = 3;
    [self.contentView addSubview:self.titleLabel];
    //总需
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     ]};
    
    self.needLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.frame.origin.x , self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5, 260, 14)];
    self.needLabel .attributedText =  [@"总需2999人次，剩余<u>1823</u>人次" attributedStringWithStyleBook:style1];
    self.needLabel .textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.needLabel ];
    //参与人数
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headIamgeView.frame.size.width+10,self.needLabel.frame.origin.y + self.needLabel.frame.size.height + 10 , 14 * 4, 14)];
    self.numLabel.text = @"参与人次";
    self.numLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.numLabel.textColor = RGBCOLOR(86, 87, 88);
    [self.contentView addSubview:self.numLabel];
    //view
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(self.numLabel.frame.size.width + self.numLabel.frame.origin.x , self.needLabel.frame.size.height + self.needLabel.frame.origin.y + 5, 120,30)];
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view1.userInteractionEnabled = YES;
    view1.layer.masksToBounds = YES;
    view1.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:view1];
    //倍数
    self.beishuLabel = [[UILabel alloc]initWithFrame:CGRectMake(view1.frame.origin.x, view1.frame.origin.y + view1.frame.size.height + 5, 140, 30)];
    self.beishuLabel.font = [UIFont systemFontOfSize:10];
    self.beishuLabel.text = @"参与人次需是10的倍数";
    self.beishuLabel.textColor = MainColor;
    self.beishuLabel.hidden = YES;
    self.beishuLabel.numberOfLines = 2;
    [self.contentView addSubview:self.beishuLabel];
    
    //添加
    self.reductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reductionBtn.frame = CGRectMake(0, 0, 35, 30);
    [self.reductionBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.reductionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.reductionBtn.layer.borderWidth = 0.5;
    self.reductionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.reductionBtn.userInteractionEnabled = YES;
    self.reductionBtn.tag = 101;
    [self.reductionBtn addTarget:self action:@selector(reduceShopping:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:self.reductionBtn];
    
    //增加
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(view1.frame.size.width - 35, 0, 35, 30);
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addBtn.layer.borderWidth = 0.5;
    self.addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addBtn.tag = 102;
    
    [self.addBtn addTarget:self action:@selector(addShopping:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:self.addBtn];
    
    
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIButton*bt=[[UIButton alloc]initWithFrame:CGRectMake(MSW-70, 0, 70, 40)];
    [bt setTitle:@"完成" forState:UIControlStateNormal];
    bt.titleLabel.font=[UIFont systemFontOfSize:18];
    [bt setTitleColor:MainColor forState:0];
    //    [bt setBackgroundColor:[UIColor redColor]];
    //实现方法
    [bt addTarget:self action:@selector(shoujianpan) forControlEvents:UIControlEventTouchDown ];
    [view addSubview:bt];
    
    
    //记录
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(self.reductionBtn.frame.size.width, 0, 50, 30)];
    self.textField.text = [NSString stringWithFormat:@"%ld",self.num];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    
    self.textField.inputAccessoryView=view;
    [view1 addSubview:self.textField];
    _btbaowei=[[UIButton alloc]initWithFrame:CGRectMake(view1.frame.origin.x+view1.frame.size.width+IPhone4_5_6_6P(7, 7, 25, 45), view1.frame.origin.y-5, IPhone4_5_6_6P(30, 30, 35, 35), IPhone4_5_6_6P(30, 30, 35, 35))];
    [_btbaowei setBackgroundImage:[UIImage imageNamed:@"btn_shopping_cart_all_normal"] forState:UIControlStateNormal];
    [_btbaowei setBackgroundImage:[UIImage imageNamed:@"btn_shopping_cart_all_press"] forState:UIControlStateSelected];
    _btbaowei.layer.masksToBounds = YES;
    _btbaowei.layer.cornerRadius = IPhone4_5_6_6P(15, 15, 17.5,17.5);
    [_btbaowei addTarget:self action:@selector(setbaowei) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btbaowei];
    _lbbaowei=[[UILabel alloc]initWithFrame:CGRectMake(self.headIamgeView.frame.size.width+10, self.needLabel.frame.origin.y + self.needLabel.frame.size.height + 35, 140, 20)];
    _lbbaowei.backgroundColor=[UIColor clearColor];
    _lbbaowei.font=[UIFont systemFontOfSize:SmallFont];
    //    _lbbaowei.text=@"购买人次自动调整为包尾人次！";
    _lbbaowei.textColor=[UIColor redColor];
    [self.contentView addSubview:_lbbaowei];

    _shiyuan=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 34, 26)];
    
    //  _shiyuan.image=[UIImage imageNamed:@"3-1"];
    [self addSubview:_shiyuan];
    _isbaowei=0;
    
    self.listingModel.isbaowei = 0;
    
}

#pragma mark - 设置导包尾
-(void)setbaowei{
    //[self.delegate setbaowei:self];
    if (self.btbaowei.selected) {
        //        self.btbaowei.backgroundColor=[UIColor greenColor];
        //        [self.btbaowei setTitle:@"√" forState:UIControlStateNormal];
        self.btbaowei.selected = NO;
        self.textField.text=self.listingModel.shengyurenshu;
        self.isbaowei=1;
    }else{
        self.btbaowei.selected = YES;
        //        self.textField.text=@"1";
        
        //        self.btbaowei.backgroundColor=[UIColor redColor];
        //        [self.btbaowei setTitle:@"包尾" forState:UIControlStateNormal];
        self.isbaowei =0;
    }
}
#pragma mark - 购物车添加
- (void)addShopping:(UIButton *)button
{
  
    if (self.num < [self.listingModel.shengyurenshu intValue])
    {
        [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj.goodsId isEqualToString:self.listingModel.shopid])
            {
                //                if ([self.listingModel.yunjiage isEqualToString:@"1"])
                //                {
                //                    obj.num++;
                //                    self.num ++;
                //                    *stop = YES;
                //                }
                //                else
                //                {
                //                    obj.num = obj.num+10;
                //                   self.num = self.num +10;
                //                    *stop = YES;
                //                }
                if ([self.listingModel.xiangou isEqualToString:@"0"])
                {
                    
                    DebugLog(@"%li---%@",obj.num,self.listingModel.shengyurenshu);
                    
                    obj.num = obj.num + [self.listingModel.yunjiage integerValue];
                    self.num = obj.num;
                    *stop = YES;
                    
                    DebugLog(@"==--%li---%@",self.num,self.textField.text);
                    //
                    if (self.num ==[self.listingModel.shengyurenshu integerValue]) {
                        
                        //                        self.btbaowei.backgroundColor=[UIColor greenColor];
                        //                        [self.btbaowei setTitle:@"√" forState:UIControlStateNormal];
                        _btbaowei.selected = YES;
                        
                        self.lbbaowei.text=@"购买人次自动调整为包尾人次！";
                        
                        self.listingModel.isbaowei=1;
                        
                        
                    }
                    
                }
                if ([self.listingModel.xiangou isEqualToString:@"1"])
                {
                    obj.num = obj.num + [self.listingModel.zongrenshu integerValue];
                    self.num = obj.num;
                    *stop = YES;
                }
                if ([self.listingModel.xiangou isEqualToString:@"2"])
                {
                    if (self.num >= [self.listingModel.xg_number integerValue])
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"购买数量不能大于限购数量" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        
                        
                    }
                    else
                    {
                        obj.num = obj.num + [self.listingModel.yunjiage integerValue];
                        self.num = obj.num;
                        *stop = YES;
                        
                        
                        
                        
                    }
                    
                }
                
                
            }
            [self showOrderNumbers:self.num];
            DebugLog(@"%ld---------%@",(long)obj.num,obj.goodsId);
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"购买数量不能大于参与人数" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"jieSuan" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

-(void)showOrderNumbers:(NSUInteger)count
{
    
    self.textField.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.num];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"1" object:nil];
}

#pragma mark - 减少购物车商品
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.textField.text.length >= 9)
    {
        [SVProgressHUD showErrorWithStatus:@"输入数量已超出"];
        return NO;
    }
    if (range.location == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}



- (void)reduceShopping:(UIButton *)button
{
    
    [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj.goodsId isEqualToString:self.listingModel.shopid])
        {
            
            if (obj.num <= [self.listingModel.yunjiage integerValue])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能小于商品起步价格" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                obj.num = obj.num - [self.listingModel.yunjiage integerValue];
                self.num = obj.num;
                *stop = YES;
                //                self.btbaowei.backgroundColor=MainColor;
                //                [self.btbaowei setTitle:@"包尾" forState:UIControlStateNormal];
                _btbaowei.selected = NO;
                
                self.lbbaowei.text=@"";
                
                self.listingModel.isbaowei=0;
            }
            
            
        }
        [self showOrderNumbers:self.num];
        
        DebugLog(@"%ld---------%@",(long)obj.num,obj.goodsId);
    }];
    
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"jieSuan" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
#warning 解决输入问题
#pragma mark - 用户改变textFied时
- (void)textFieldDidChange:(UITextField *)textField
{
    self.num = [textField.text integerValue];
//    [self showOrderNumbers:self.num];
     
}

#pragma mark 手键盘
- (void)shoujianpan
{
    [self.textField resignFirstResponder];
    
}


- (void)keyboardWillHide:(NSNotification *)notif
{
    [[UserDataSingleton userInformation].shoppingArray enumerateObjectsUsingBlock:^(ShoppingModel *obj, NSUInteger idx, BOOL *stop) {
        //            obj.num = self.num;
        
        if ([self.listingModel.shopid isEqualToString:obj.goodsId])
        {
            
            if ([self.textField.text integerValue] < [self.listingModel.yunjiage integerValue])
            {
                self.textField.text = self.listingModel.yunjiage;
                self.num = [self.listingModel.yunjiage integerValue];
                obj.num = [self.listingModel.yunjiage integerValue];
            }
            else
            {
                if ([self.listingModel.xiangou isEqualToString:@"2"]||[self.listingModel.xiangou isEqualToString:@"1"])
                {
                    if ([self.textField.text integerValue] > [self.listingModel.xg_number integerValue])
                    {
                        self.textField.text = self.listingModel.xg_number;
                        self.num = [self.listingModel.xg_number integerValue];
                        obj.num = [self.listingModel.xg_number integerValue];
                    }
                    else
                    {
                        NSInteger i = [self.textField.text integerValue] %[self.listingModel.yunjiage integerValue];
                        self.textField.text = [NSString stringWithFormat:@"%d",[self.textField.text integerValue] - i];
                        self.num = [self.textField.text integerValue];
                        obj.num = [self.textField.text integerValue];
                    }
                }
                else
                {
                    NSInteger i = [self.textField.text integerValue] %[self.listingModel.yunjiage integerValue];
                    self.textField.text = [NSString stringWithFormat:@"%d",[self.textField.text integerValue] - i];
                    self.num = [self.textField.text integerValue];
                    obj.num = [self.textField.text integerValue];
                }
            }
            
            if ([self.textField.text integerValue] >= [self.listingModel.shengyurenshu integerValue])
            {
                self.textField.text = self.listingModel.shengyurenshu;
                self.num = [self.listingModel.shengyurenshu integerValue];
                obj.num = [self.textField.text integerValue];
                
            }
        }
    }];
    
    DebugLog(@"==-%@------%@-",self.textField.text,_listingModel.shengyurenshu);
    if ([self.textField.text isEqualToString:_listingModel.shengyurenshu]) {
        //        self.btbaowei.backgroundColor=[UIColor greenColor];
        //        [self.btbaowei setTitle:@"√" forState:UIControlStateNormal];
        self.btbaowei.selected = YES;
        self.lbbaowei.text=@"购买人次自动调整为包尾人次！";
        
        self.listingModel.isbaowei=1;
        
    }else{
        //        self.btbaowei.backgroundColor=MainColor;
        //        [self.btbaowei setTitle:@"包尾" forState:UIControlStateNormal];
        self.btbaowei.selected = NO;
        self.lbbaowei.text=@"";
        
        self.listingModel.isbaowei=0;
    }
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"jieSuan" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}
- (void)setListingModel:(ListingModel *)listingModel
{
    _listingModel = listingModel;
    if ([_listingModel.xiangou isEqualToString:@"1"])
    {
        if ([listingModel.xg_number integerValue] <= 0)
        {
            self.beishuLabel.text = [NSString stringWithFormat:@"当前限购%@个期数,不能再进行购买",listingModel.xg_number];
            _shiyuan.hidden=NO;
            _shiyuan.image = [UIImage imageNamed:@"xiangou"];
            self.addBtn.userInteractionEnabled = NO;
            self.reductionBtn.userInteractionEnabled = NO;
            self.textField.userInteractionEnabled = NO;
            self.beishuLabel.hidden = NO;
        }
        else
        {
            _shiyuan.hidden=NO;
            _shiyuan.image = [UIImage imageNamed:@"xiangou"];
            self.addBtn.userInteractionEnabled = NO;
            self.reductionBtn.userInteractionEnabled = NO;
            self.textField.userInteractionEnabled = NO;
            self.beishuLabel.hidden = NO;
            self.beishuLabel.text = [NSString stringWithFormat:@"该商品为限购人次商品，您还能购买%@个期数",listingModel.xg_number];
            _shiyuan.image = [UIImage imageNamed:@"xiangou"];
            
        }
        
        _btbaowei.hidden = YES;
        _lbbaowei.hidden = YES;
        
    }
    else if ([_listingModel.xiangou isEqualToString:@"2"])
    {
        _shiyuan.hidden=NO;
        _shiyuan.image = [UIImage imageNamed:@"xiangou"];
        self.addBtn.userInteractionEnabled = YES;
        self.reductionBtn.userInteractionEnabled = YES;
        self.textField.userInteractionEnabled = YES;
        self.beishuLabel.hidden = NO;
        self.beishuLabel.text = [NSString stringWithFormat:@"该商品为限购人次商品，您还能购买:%@人次",listingModel.xg_number];
        _shiyuan.image = [UIImage imageNamed:@"xiangou"];
        
        _btbaowei.hidden = YES;
        _lbbaowei.hidden = YES;
    }
    else
    {
        if ([_listingModel.yunjiage isEqualToString:@"10"]) {
            
            _shiyuan.hidden = NO;
            _shiyuan.image = [UIImage imageNamed:@"3-1"];
        }else{
            _shiyuan.hidden = YES;
        }
        self.beishuLabel.hidden = YES;
        self.addBtn.userInteractionEnabled = YES;
        self.reductionBtn.userInteractionEnabled = YES;
        self.textField.userInteractionEnabled = YES;
        
        _btbaowei.hidden = NO;
        _lbbaowei.hidden = NO;
    }
 self.titleLabel.text = listingModel.title;
    [self.headIamgeView sd_setImageWithURL:[NSURL URLWithString:listingModel.thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    self.needLabel.font = [UIFont systemFontOfSize:MiddleFont];
    self.needLabel.textAlignment = NSTextAlignmentLeft;
    self.needLabel .attributedText =  [[NSString stringWithFormat:@"总需<u>%@</u>人次       剩余<u>%@</u>人次",listingModel.zongrenshu,listingModel.shengyurenshu] attributedStringWithStyleBook:style1];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

