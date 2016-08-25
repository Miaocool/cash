//
//  PayResultController.m
//  yyxb
//
//  Created by lili on 15/12/17.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "PayResultController.h"
#import "PayResultCell.h"

#import "PayResultModel.h"
#import "TopuprecordController.h"
#import "FindTreasureController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
@interface PayResultController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

{
    UIView*_headview;
    NSMutableArray*_Noarray;
    UILabel *lbNo;
    int canyucount;
}
@property (nonatomic, strong) UIView *moreview; //点击更多
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) NSMutableArray *titleArray; //标题
@property (nonatomic, strong) NSMutableArray *imgArray; //图片
@property (nonatomic, strong)UIView *white;
@property (nonatomic, strong) PullingRefreshTableView *tableView;

@end

@implementation PayResultController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD dismiss];

    self.navigationItem.leftBarButtonItem=nil;
    
        UIButton *callBtn = [[UIButton alloc]init];
        callBtn.frame = CGRectMake(0, 0, 20, 25);
        [callBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:callBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    [self initData];
    self.title=@"支付结果";
    [self createTableView];
}

#pragma mark - 创建数据
- (void)initData
{
}

-(void)fanhui{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  ) pullingDelegate:self style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tiaotype==1) {
        return _Payarray.count;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_tiaotype==1) {
        return 170;
    }else{
        return 130;
    }
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self creatview];
    return _headview;
}
-(void)creatview{
    NSDictionary* style1 = @{@"body" : @[[UIFont systemFontOfSize:13],
    [UIColor grayColor]], @"u": @[MainColor,]};
    _headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    _headview.backgroundColor=[UIColor whiteColor];
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2-100, 20, 200, 30)];
    lbtitle.textAlignment=NSTextAlignmentCenter;
    lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
        if (_tiaotype==1) {
            lbtitle.text=@"恭喜您，参与成功！";
    }else{
    lbtitle.text=@"恭喜您，获得2个米币";
    
    }
    lbtitle.font=[UIFont systemFontOfSize:MiddleFont];
    lbtitle.textColor=[UIColor grayColor];
   [_headview addSubview:lbtitle];
    UILabel*lbtitle2=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2-100, 50, 200, 30)];
    lbtitle2.textAlignment=NSTextAlignmentCenter;
    lbtitle2.text=@"请等待系统为您揭晓！";
    lbtitle2.font=[UIFont systemFontOfSize:MiddleFont];
    if (_tiaotype==1) {
        
    }else{
        lbtitle2.hidden=YES;
    }
    lbtitle2.font=[UIFont systemFontOfSize:MiddleFont];
    lbtitle2.textColor=[UIColor grayColor];
    [_headview addSubview:lbtitle2];
    UIButton*jixu=[[UIButton alloc]initWithFrame:CGRectMake(10, 90, MSW/2-20, 30)];
    jixu.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
    [jixu setBackgroundColor:MainColor];
    if (_tiaotype==1) {
           [jixu setTitle:@"继续夺宝" forState:UIControlStateNormal];
    }else{
       [jixu setTitle:@"返回首页" forState:UIControlStateNormal];
    }
    jixu.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    jixu.layer.cornerRadius = 5;
    [jixu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jixu.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_headview addSubview:jixu];
    [jixu addTarget:self action:@selector(jixuxunbao) forControlEvents:UIControlEventTouchUpInside];
    UIButton*btlook=[[UIButton alloc]initWithFrame:CGRectMake(20+MSW/2-20, 90, MSW/2-20, 30)];
    btlook.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
     btlook.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    btlook.layer.cornerRadius = 5;
    [btlook setBackgroundColor:[UIColor grayColor]];
    [btlook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btlook.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_headview addSubview:btlook];
    [btlook addTarget:self action:@selector(lookxunbao) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel*lbtishi=[[UILabel alloc]initWithFrame:CGRectMake(0, 130, MSW, 40)];
    lbtishi.backgroundColor=[UIColor groupTableViewBackgroundColor];
    lbtishi.font=[UIFont systemFontOfSize:11];
    
    for (int i=0; i<_Payarray.count; i++) {
          NSDictionary*dic=[_Payarray objectAtIndex:i];
        NSString* b=dic[@"gonumber"];
        canyucount+=[b intValue];

    }
    lbtishi.attributedText =  [[NSString stringWithFormat:@"  您成功参与了<u>%li</u>件商品共<u>%i</u>人次夺宝，信息如下",_Payarray.count,canyucount] attributedStringWithStyleBook:style1];

    [_headview addSubview:lbtishi];
    if (_tiaotype==1) {
        [btlook setTitle:@"查看夺宝记录" forState:UIControlStateNormal];
    }else{
        [btlook setTitle:@"查看充值记录" forState:UIControlStateNormal];
    
        lbtishi.hidden=YES;
    }
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *ListingCellName = @"PayResultCell.h";
    PayResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!cell)
    {
        cell = [[PayResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
    }
    cell.btmore.tag=indexPath.row;
    [cell.btmore addTarget:self action:@selector(moreduobaono:) forControlEvents:UIControlEventTouchUpInside];
  NSDictionary*dic=[_Payarray objectAtIndex:indexPath.row];
    cell.lbno.text=[NSString stringWithFormat:@"夺宝号码：%@",dic[@"goucode"]];
    cell.lbcount.text=dic[@"gonumber"];
    DebugLog(@"%@--%@",dic[@"goucode"],dic[@"shopname"]);
    [cell.btshopname setTitle:[NSString stringWithFormat:@"(第%@期)%@",dic[@"shopqishu"],dic[@"shopname"]] forState:UIControlStateNormal];
    cell.lbqihao.text=[NSString stringWithFormat:@"商品期号：%@",dic[@"shopqishu"]];
        return cell;
    
}

-(void)jixuxunbao{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(void)lookxunbao{
    
    if (_tiaotype==1) {
        FindTreasureController *userData = [[FindTreasureController alloc]init];
        userData.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:userData animated:YES];

    }else{
    
        TopuprecordController *userData = [[TopuprecordController alloc]init];
        userData.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:userData animated:YES];

    }
    }

#pragma mark -           点击更多的视图
-(void)moreduobaono:(UIButton *)sender{

    int index=(int)[sender tag];
    NSDictionary*dic=[_Payarray objectAtIndex:index];
    
    _moreview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    _moreview.alpha=0.5;
    _moreview.backgroundColor=[UIColor blackColor];
    [self.navigationController.view addSubview:_moreview];
    
    _white=[[UIView alloc]initWithFrame:CGRectMake((MSW - 250)/2, (MSH - 240)/2, 250, 240)];
    _white.backgroundColor=[UIColor whiteColor];
    _white.layer.cornerRadius = 10;
    _white.layer.masksToBounds = YES;
    [self.navigationController.view addSubview:_white];
    UILabel*lbduobao=[[UILabel alloc]initWithFrame:CGRectMake(_white.frame.size.width/2-30, 0,  _white.frame.size.width, 40)];
    lbduobao.text=@"夺宝号";
    
    UILabel * canyuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, _white.frame.size.width, 20)];
    canyuLabel.textColor = MainColor;
    canyuLabel.font = [UIFont systemFontOfSize:15];
    canyuLabel.text = [NSString stringWithFormat:@"本期参与了%@人次:",dic[@"gonumber"]];
    [_white addSubview:canyuLabel];
    
    [_white addSubview:lbduobao];
    
    UIScrollView*scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(5,70,  _white.frame.size.width-10,  120)];
    NSString*str=dic[@"goucode"];
    NSArray * arr = [str componentsSeparatedByString:@","];
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.showsVerticalScrollIndicator=YES;
    scroll.contentSize = CGSizeMake( _white.frame.size.width-10, (arr.count/3));
    
    [_white addSubview:scroll];
    for (int i = 0;  i < arr.count/3 + 1; i ++)
    {
        int item = 3;
        if (i == arr.count / 3)
        {
            item = arr.count % 3;
        }
        for (int j = 0; j < item; j ++)
        {
            UILabel *lbno = [[UILabel alloc]initWithFrame:CGRectMake(5 + j * 80, 10 + i * 30, 70, 20)];
            lbno.font = [UIFont systemFontOfSize:12];
            lbno.text = arr[i*3+j];
            scroll.contentSize = CGSizeMake(lbno.width,30* (arr.count/3+1));
            [scroll addSubview:lbno];
        }
    }
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 199, MSW, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1];
    [_white addSubview:lineLabel];
    UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 250, 40)];
    [sureBtn setTitle:@"确定" forState: UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:BigFont];
    //    sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sureBtn setTitleColor:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(closelook) forControlEvents:UIControlEventTouchUpInside];
    [_white addSubview:sureBtn];
    
}

-(void)closelook{
    [_moreview removeFromSuperview];
    [_white removeFromSuperview];
    
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
