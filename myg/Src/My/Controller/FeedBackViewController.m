//
//  FeedBackViewController.m
//  yydg
//
//  Created by mac03 on 16/1/5.
//  Copyright (c) 2016年 杨易. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextView              *_feedBackView;   //意见textView
    UITextField             *_phoneFiled;    //联系方式
    UITapGestureRecognizer *singleRecognizer;
    
    UILabel *infoLab;       //意见lab
    UIButton *clickBtn;     //选择lab
    NSMutableArray  *_buttonArray;   //弹出view数组
    UIView *setview;       //弹出view
    NSString *type;        //类型
}


@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"意见反馈";
    self.view.backgroundColor=RGBCOLOR(242, 242, 242);
    
    _buttonArray = [NSMutableArray array];
    [self initialize];
    
    //    添加手势隐藏键盘
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
}

- (void)initialize
{
    //创建边框(上下左右)
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, MSW - 40, 0.5)];
    line1.backgroundColor = RGBCOLOR(218, 218, 218);
    [self.view addSubview:line1];
    
    UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60.5, MSW - 40, 0.5)];
    line3.backgroundColor = RGBCOLOR(218, 218, 218);
    [self.view addSubview:line3];
    
    UIImageView* line4 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 0.5, 40)];
    line4.backgroundColor = RGBCOLOR(218, 218, 218);
    [self.view addSubview:line4];
    
    UIImageView* line5 = [[UIImageView alloc] initWithFrame:CGRectMake(MSW - 20, 20, 0.5, 40)];
    line5.backgroundColor = RGBCOLOR(218, 218, 218);
    [self.view addSubview:line5];
    //头部view
    UIView* ejectView = [[UIView alloc] initWithFrame:CGRectMake(20.5, 20.5, MSW - 41, 40)];
    ejectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ejectView];
    
    infoLab=[[UILabel alloc]initWithFrame:CGRectMake(ejectView.left+5, ejectView.top+5, 100, 30)];
    infoLab.textColor=[UIColor blackColor];
    infoLab.text=@"投诉与建议";
    infoLab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:infoLab];
    
    clickBtn=[[UIButton alloc]initWithFrame:CGRectMake(ejectView.width-70, ejectView.top+5, 60, 30)];
    [clickBtn setTitle:@"请选择" forState:UIControlStateNormal];
    clickBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
    [clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(choseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(clickBtn.right, ejectView.top+15, 12, 10)];
    imageView.image = [UIImage imageNamed:@"triangle"];
    [self.view addSubview:imageView];
    
    //UITextField背景
    UIButton *buttonImg=[[UIButton alloc]initWithFrame:CGRectMake(20, ejectView.bottom+20, MSW-40, 40)];
    buttonImg.backgroundColor=[UIColor whiteColor];
    buttonImg.layer.cornerRadius = 3;
    [self.view addSubview:buttonImg];
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
    _phoneFiled=[[UITextField alloc]initWithFrame:CGRectMake(20, ejectView.bottom+20, MSW-40, 40)];
    _phoneFiled.clearButtonMode = UITextFieldViewModeAlways;
    _phoneFiled.delegate=self;
    _phoneFiled.borderStyle=UITextAutocorrectionTypeDefault;
    _phoneFiled.placeholder = @"请输入联系手机号码";
     _phoneFiled.inputAccessoryView=view;
    [self.view addSubview:_phoneFiled];
    
   //意见UITextView
    _feedBackView = [[UITextView alloc] initWithFrame:CGRectMake(20,  _phoneFiled.bottom+20, MSW-40, IPhone4_5_6_6P(80,100,130,130))];
    _feedBackView.delegate = self;
    _feedBackView.text=@"请您给我们留下宝贵的意见";
    _feedBackView.textColor=RGBCOLOR(218, 218, 218);
    _feedBackView.font=[UIFont systemFontOfSize:15];
    _feedBackView.textColor=[UIColor lightGrayColor];
    _feedBackView.returnKeyType = UIReturnKeyDone;
    _feedBackView.layer.borderWidth = 1.0;
    _feedBackView.backgroundColor = [UIColor whiteColor];
    _feedBackView.layer.borderColor = RGBCOLOR(206,207,208).CGColor;
    [self.view addSubview:_feedBackView];
    
    _feedBackView.inputAccessoryView=view;
    //提交button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, _feedBackView.bottom + 20, MSW-40, 35);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.backgroundColor = MainColor;
    btn.layer.borderColor = MainColor.CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 5;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
#pragma arguments -选择点击
-(void)choseClick
{
     [setview removeFromSuperview];
    //弹出view
    setview=[[UIView alloc]initWithFrame:CGRectMake(MSW, IPhone4_5_6_6P(MSH-400, MSH-500, MSH-600, MSH-670), MSW-40, 44*3)];
    setview.backgroundColor=[UIColor whiteColor];
    
    for (NSInteger m = 0; m < 3; m ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15,  10+m * 44, setview.width, 23)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = m ;
        button.titleLabel.font = [UIFont systemFontOfSize: 15];
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"投诉与建议" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hotBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        if (m == 1) {
           [button setTitle:@"商品配送" forState:UIControlStateNormal];
        }else if (m == 2){
            [button setTitle:@"售后服务" forState:UIControlStateNormal];
        }
        [_buttonArray addObject:button];
        [setview addSubview:button];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, m * 44+44, setview.width, 0.5)];
        line.backgroundColor=RGBCOLOR(218, 218, 218);
        [setview addSubview:line];
        
     }
    
        [UIView animateWithDuration:0.3 animations:^{
            setview.frame=CGRectMake(20, 70, MSW-40, 44*3);
            
            UIImageView* lineSet = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, setview.width, 0.5)];
            lineSet.backgroundColor = RGBCOLOR(218, 218, 218);
            [setview addSubview:lineSet];
            
            UIImageView* lineSet2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 44*3)];
            lineSet2.backgroundColor = RGBCOLOR(218, 218, 218);
            [setview addSubview:lineSet2];
            
            UIImageView* lineSet3 = [[UIImageView alloc] initWithFrame:CGRectMake(setview.width, 0, 0.5, 44*3)];
            lineSet3.backgroundColor = RGBCOLOR(218, 218, 218);
            [setview addSubview:lineSet3];

        }];
        [self.view addSubview:setview];
    
}

#pragma arguments -弹出button点击
- (void)hotBtnTouched:(UIButton *)button
{
    for (UIButton *btn in _buttonArray)
    {
        if (button.tag == btn.tag)
        {
            infoLab.text=button.titleLabel.text;
//            clickBtn.userInteractionEnabled=NO;
            setview.hidden=YES;
            
            if (button.tag==0) {
                type=@"1";
            }else if (button.tag==1){
                type=@"2";
            }else{
                type=@"3";
            }
        }
    }
}

#pragma arguments -提交反馈
- (void)commitAction
{
    DebugLog(@"====%@",type);
    if (IsStrEmpty(_phoneFiled.text) || _phoneFiled.text.length != 11) {
        //  反馈不能为空
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        //return;
    }
    else if (IsStrEmpty(_feedBackView.text))
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
//    else if ([UserDataSingleton userInformation].isLogin==NO){
//        LoginViewController *login = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:login animated:YES];
//        
//    }
    else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        
        [dict setValue:type forKey:@"type"];
        [dict setValue:_phoneFiled.text forKey:@"mobile"];
        [dict setValue:_feedBackView.text forKey:@"content"];
        DebugLog(@"=====%@",type);
        [MDYAFHelp AFPostHost:APPHost bindPath:feedback postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"======%@",responseDic[@"msg"]);
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"反馈成功" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:responseDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom{
    [_feedBackView resignFirstResponder];
    [_phoneFiled resignFirstResponder];
}

#pragma  mark -UITextView的编辑
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:_feedBackView.text]) {
        textView.text = @"";
        textView.textColor=[UIColor blackColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_feedBackView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"";
    }
    [_feedBackView resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_phoneFiled)
    {
      [textField resignFirstResponder];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
