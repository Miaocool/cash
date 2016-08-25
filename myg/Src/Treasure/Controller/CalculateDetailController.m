//
//  CalculateDetailController.m
//  yyxb
//
//  Created by lili on 15/12/9.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "CalculateDetailController.h"
#import "MDHeadView.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "PictureDetailController.h"

#import "CalculateModel.h"
#import "CalculateViewCell.h"
@interface CalculateDetailController ()<UITableViewDataSource,UITableViewDelegate,MDHeadViewDelegate>

{
    NSString       *_tishi;
    int height;
    
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
//当前的分段
@property(nonatomic,assign)NSUInteger currentSection;
//当前的行数
@property(nonatomic,assign)NSUInteger currentRow;
//数组分段头视图
@property(nonatomic,strong)NSMutableArray *headViewArr;

@property(nonatomic,strong)CalculateModel*model;
@property(nonatomic,strong)NSString*url;
@end

@implementation CalculateDetailController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self getUrl];
       [self refreshData];
      [self createData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title=@"计算详情";
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

//获取  彩的url
-(void)getUrl{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [MDYAFHelp AFPostHost:APPHost bindPath:GetUrl postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        DebugLog(@"------%@----%@",responseDic,responseDic[@"msg"]);
        _url=responseDic[@"data"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];

}


#pragma mark - 创建UITableView
-(void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = MainColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
//    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self.view addSubview:self.tableView];
}
#pragma mark - 下拉刷新
- (void)refreshData
{
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
[MDYAFHelp AFPostHost:APPHost bindPath:Tishi postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        
        DebugLog(@"------%@---%@",responseDic,responseDic[@"msg"]);
        NSDictionary*data=responseDic[@"data"];
        NSString*value=data[@"value"];
        _tishi=value;
        DebugLog(@"====---%@",value);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
    
    
}
#pragma mark - 创建一个数据
-(void)createData
{
    _dataArray = [NSMutableArray array];

    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_shopid forKey:@"shopid"];
    [MDYAFHelp AFPostHost:APPHost bindPath:CalResult postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        
        DebugLog(@"------%@----%@",responseDic,responseDic[@"msg"]);
        
        NSDictionary*data=responseDic[@"data"];
        _model=[[CalculateModel alloc]init];
        _model.caipiao_haoma=data[@"caipiao_haoma"];
            _model.q_counttime=data[@"q_counttime"];
        _model.q_user_code=data[@"q_user_code"];
        _model.caipiao_qishu = data[@"caipiao_qishu"];
        _model.q_content=data[@"q_content"];
    
        [self createUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];        
    }];
    
    if(!_headViewArr)
        _headViewArr = [NSMutableArray array];
    for(int i = 0; i < 5; i++)
    {
        //UIView 分段 + 按钮
        MDHeadView *headView = [[MDHeadView alloc] init];
        headView.delegate = self;
        headView.section = i;
        [self.headViewArr addObject:headView];
        
    }
    
}


#pragma mark - 黄金三问  dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (section==0) {
        return 0;
    }else if(section==1){
        
        
        return _model.q_content.count+1;
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.row==0) {
        NSString *cellId=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        } cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.frame = CGRectMake(10, 0, MSW-20, 44);
        cell.textLabel.text=@"参与时间";
        cell.textLabel.font=[UIFont systemFontOfSize:BigFont];
        cell.textLabel.frame=CGRectMake(10, 15, 50, 20);
//        cell.detailTextLabel.frame = CGRectMake(MSW-90, 0, 90, 20);
        
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(MSW-55, MSW-55, MSW-85, MSW-100),0, 60, 44)];
        detailLabel.text = @"用户";
        detailLabel.font = [UIFont systemFontOfSize:BigFont];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:detailLabel];
        
//        cell.detailTextLabel.text=@"用户       ";
//         cell.detailTextLabel.font=[UIFont systemFontOfSize:BigFont];
//        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
//        cell.detailTextLabel.frame=CGRectMake(MSW-150, 10, 50, 20);
        
        return cell;
    }else{
        
        static NSString *cellName = @"CalculateViewCell";
        CalculateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell)
        {
            cell = [[CalculateViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
NSDictionary*dic=[_model.q_content objectAtIndex:indexPath.row-1];
        
        cell.lbname.text=dic[@"username"];
        cell.lbno.textColor = [UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1];
//        cell.lbno.text=[NSString stringWithFormat:@"→%@",dic[@"shijian"]];
//        cell.lbdate.text=[NSString stringWithFormat:@"%@→%@",dic[@"riqi"],dic[@"shijian"]];
        NSString * string1 = [NSString stringWithFormat:@"→%@",dic[@"shijian"]];
        NSString * string2 = [NSString stringWithFormat:@"%@→%@",dic[@"riqi"],dic[@"shijian"]];
        NSString * string3 = dic[@"riqi"];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:string2];;
        [string addAttribute:NSForegroundColorAttributeName
         
                        value:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]
         
                        range:NSMakeRange(string3.length, string1.length)];
        cell.lbdate.attributedText = string;
        //返回cell实例
        return  cell;
        
    }
}

#pragma mark - 委托
-(void)selectdWith:(MDHeadView *)view
{
    view.isOpen = !view.isOpen;
    [self.tableView reloadData];
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MDHeadView *headView = [self.headViewArr objectAtIndex:indexPath.section];
    return headView.isOpen?40:0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==3)
    {
        return 60;
    }
//    else if (section == 4)
//    {
//        return height;
//    }
//    else if (section == 0)
//    {
//        return IPhone4_5_6_6P(90, 90, 110, 115);
//    }
    else{
        return 100;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSDictionary* style2 = @{@"body" :
                                 @[[UIFont systemFontOfSize:BigFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    
    
    
    if (section==0)
    {
        UIView*_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
//        _view.backgroundColor=RGBACOLOR(234, 234, 235, 1);
        _view.backgroundColor = [UIColor clearColor];
        UIImageView*imggs=[[UIImageView alloc]initWithFrame:CGRectMake(5,IPhone4_5_6_6P(10, 10, 10, 10), MSW-10, (MSW-10)/4.46)];
        imggs.image=[UIImage imageNamed:@"公式"];
        imggs.backgroundColor=[UIColor clearColor];
        [_view addSubview:imggs];
        

        return _view;
        
    }
    else if(section==1)
    {
       
        ((MDHeadView *)self.headViewArr[1]).lbcount.attributedText =  [[NSString stringWithFormat:@"=<u>%@</u>",_model.q_counttime]attributedStringWithStyleBook:style2];
     
        return  [self.headViewArr objectAtIndex:section];
    }
    else if(section==2){
        
        
        UIView*_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 110)];
        _view.backgroundColor=[UIColor whiteColor];
        
        UIImageView * imgB = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 21, 21)];
        imgB.image = [UIImage imageNamed:@"b"];
        [_view addSubview:imgB];
        
//        UILabel*numB=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
//        numB.text=@"数值B";
//        numB.textColor=[UIColor blackColor];
//        numB.font=[UIFont systemFontOfSize:16];
//        [_view addSubview:numB];
        UILabel*lbcountstyle=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,[UIScreen mainScreen].bounds.size.width-20, 20)];
        lbcountstyle.text=@"=最近一期中国福利彩票的“老时时彩”的开奖结果";
        lbcountstyle.textColor=[UIColor grayColor];
        lbcountstyle.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(12, 12, 15, 15)];
        [_view addSubview:lbcountstyle];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, MSW, 1)];
        lineLabel.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        [_view addSubview:lineLabel];
        
        UILabel*lbcount=[[UILabel alloc]initWithFrame:CGRectMake(40, 65,[UIScreen mainScreen].bounds.size.width-120, 20)];
        
        if ([_model.caipiao_haoma isEqualToString:@""]) {
         
            lbcount.attributedText = [[NSString stringWithFormat: @"=<u>正在等待开奖...</u>(第%@期)",self.model.caipiao_qishu]attributedStringWithStyleBook:style2];
        }else {
            lbcount.attributedText=[[NSString stringWithFormat: @"=<u>%@</u>(第%@期)",_model.caipiao_haoma,_model.caipiao_qishu]attributedStringWithStyleBook:style2];
        }
        
    
        lbcount.font=[UIFont systemFontOfSize:BigFont];
        [_view addSubview:lbcount];
        
        UIButton *btlook=[[UIButton alloc]initWithFrame:CGRectMake(20+lbcount.frame.size.width+10, 60, 80, 30)];
        [btlook setTitleColor:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1]forState:0];
        [btlook setTitle:@"开奖查询" forState:0];
         btlook.titleLabel.font=[UIFont systemFontOfSize:16];
        [btlook addTarget:self action:@selector(lookkaijiang) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:btlook];
        
        UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(0, 98, [UIScreen mainScreen].bounds.size.width, 12)];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [_view addSubview:line];
        return _view;
    }
    else if(section==3)
    {
        UIView*_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        _view.backgroundColor=[UIColor whiteColor];
        //        UILabel*lbjieguo=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
        //        lbjieguo.text=@"计算结果";
        //        lbjieguo.textColor=[UIColor blackColor];
        //        lbjieguo.font=[UIFont systemFontOfSize:MiddleFont];
        //        [_view addSubview:lbjieguo];
        //
        
        NSDictionary* style1 = @{@"body" :
                                     @[[UIFont systemFontOfSize:20],
                                       MainColor],
                                 @"u": @[MainColor,
                                         
                                         ]};
        
        
        UILabel*lbluckno=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-120, 10, 240, 30)];
        
        if ([_model.q_user_code isEqualToString:@""]) {
            lbluckno.attributedText =  [[NSString stringWithFormat:@"计算结果：<u>等待揭晓...</u>"]attributedStringWithStyleBook:style1];
//            lbluckno.font =[UIFont systemFontOfSize:20];
        }else{
            lbluckno.attributedText =  [[NSString stringWithFormat:@"计算结果：<u>%@</u>",_model.q_user_code]attributedStringWithStyleBook:style1];
        }
        //        lbjieguo.textAlignment=NSTextAlignmentCenter;
        //        lbluckno.font=[UIFont systemFontOfSize:MiddleFont];
        
        [_view addSubview:lbluckno];
        UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(0, 48, [UIScreen mainScreen].bounds.size.width, 12)];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [_view addSubview:line];
        return _view;
        
    }
    else
    {
        UIView*_view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        _view.backgroundColor=[UIColor whiteColor];
        
        UILabel*lbzhushi=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, MSW-20, 80)];
        lbzhushi.text=@"dcfvgbhjnkml,额外娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃娃fgvhbjnkmvb n";
        lbzhushi.textColor=[UIColor grayColor];
        lbzhushi.font=[UIFont systemFontOfSize:MiddleFont];
        lbzhushi.numberOfLines=0;

        lbzhushi.text=_tishi;
        //设置宽高，其中高为允许的最大高度
        CGSize size = CGSizeMake(lbzhushi.frame.size.width,10000);
        //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
        CGSize labelsize = [lbzhushi.text sizeWithFont:lbzhushi.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        //最后根据这个大小设置label的frame即可
        [lbzhushi setFrame:CGRectMake(lbzhushi.frame.origin.x,lbzhushi.frame.origin.y,labelsize.width,labelsize.height)];
        [_view addSubview:lbzhushi];
        UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(0, lbzhushi.frame.origin.y+10+lbzhushi.frame.size.height, [UIScreen mainScreen].bounds.size.width, 2)];
        line.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [_view addSubview:line];

        return _view;
    }
    
}

-(void)lookkaijiang{

    PictureDetailController *classVC = [[PictureDetailController alloc]init];
    
    classVC.style=1;
    classVC.fromurl=_url;
    [self.navigationController pushViewController:classVC animated:YES];
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
