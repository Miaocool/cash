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
    
    
    NSLog(@"---%@",_Payarray);


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
    return 60;
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
    NSDictionary* style1 = @{@"body" : @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
    [UIColor grayColor]], @"u": @[[UIColor orangeColor],]};
    
    _headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    _headview.backgroundColor=[UIColor whiteColor];
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2-100, 20, 200, 30)];
    lbtitle.textAlignment=NSTextAlignmentCenter;

    
    
    if (_tiaotype==1) {
            lbtitle.text=@"恭喜您，参与成功！";
    }else{
    lbtitle.text=@"恭喜您，获得2个寻宝币";
    
    }
    
    
    
    
    
    lbtitle.textColor=[UIColor grayColor];
   [_headview addSubview:lbtitle];
    UILabel*lbtitle2=[[UILabel alloc]initWithFrame:CGRectMake(MSW/2-100, 50, 200, 30)];
    lbtitle2.textAlignment=NSTextAlignmentCenter;
    lbtitle2.text=@"请等待系统为您揭晓！";
    if (_tiaotype==1) {
        
    }else{
    
    
        lbtitle2.hidden=YES;
    }
    
    
    
    lbtitle2.textColor=[UIColor grayColor];
    [_headview addSubview:lbtitle2];
    
    
    UIButton*jixu=[[UIButton alloc]initWithFrame:CGRectMake(10, 90, MSW/2-20, 30)];
 
    [jixu setBackgroundColor:[UIColor orangeColor]];
    
    if (_tiaotype==1) {
           [jixu setTitle:@"继续寻宝" forState:UIControlStateNormal];
    }else{
       [jixu setTitle:@"返回首页" forState:UIControlStateNormal];
    }
    
    
    
    jixu.layer.cornerRadius = 5;
    [jixu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jixu.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_headview addSubview:jixu];
    [jixu addTarget:self action:@selector(jixuxunbao) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton*btlook=[[UIButton alloc]initWithFrame:CGRectMake(20+MSW/2-20, 90, MSW/2-20, 30)];
   
    
    
      btlook.layer.cornerRadius = 5;
    [btlook setBackgroundColor:[UIColor grayColor]];
    [btlook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btlook.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_headview addSubview:btlook];
    [btlook addTarget:self action:@selector(lookxunbao) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel*lbtishi=[[UILabel alloc]initWithFrame:CGRectMake(0, 130, MSW, 40)];
    lbtishi.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    lbtishi.attributedText =  [[NSString stringWithFormat:@"  您成功参与了<u>%li</u>件商品供<u>2</u>人次夺宝，信息如下",_Payarray.count] attributedStringWithStyleBook:style1];

    [_headview addSubview:lbtishi];
    if (_tiaotype==1) {
        [btlook setTitle:@"查看寻宝纪录" forState:UIControlStateNormal];
    }else{
        [btlook setTitle:@"查看充值纪录" forState:UIControlStateNormal];
    
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
    
        NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                   [UIColor grayColor]],
                             @"u": @[[UIColor orangeColor],
                                     
                                     ]};
    
    
    [cell.btmore addTarget:self action:@selector(moreduobaono) forControlEvents:UIControlEventTouchUpInside];
    
  NSDictionary*dic=[_Payarray objectAtIndex:indexPath.row];

//   cell.btshopname.titleLabel.text=[NSString stringWithFormat:@"(第%@期)%@",dic[@"shopqishu"],dic[@"shopname"]]; //商品名
    cell.lbno.text=dic[@"goucode"];
    cell.lbcount.text=dic[@"gonumber"];
    NSLog(@"%@--%@",dic[@"goucode"],dic[@"shopname"]);
    [cell.btshopname setTitle:[NSString stringWithFormat:@"(第%@期)%@",dic[@"shopqishu"],dic[@"shopname"]] forState:UIControlStateNormal];
 
    
    return cell;
    
    
}

-(void)jixuxunbao{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];

    NSLog(@"继续寻宝");
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
    
    
    
    
        NSLog(@"查看寻宝");
}





#pragma mark -           点击更多的视图
-(void)moreduobaono{
    _moreview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    _moreview.alpha=0.8;
    _moreview.backgroundColor=[UIColor grayColor];
    [self.view addSubview:_moreview];
    
    _white=[[UIView alloc]initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height/2-90, [UIScreen mainScreen].bounds.size.width-80, 180)];
    _white.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_white];
    UILabel*lbduobao=[[UILabel alloc]initWithFrame:CGRectMake(_white.frame.size.width/2-30, 0,  _white.frame.size.width, 60)];
    lbduobao.text=@"夺宝号码";
    
    [_white addSubview:lbduobao];
    UIButton *close=[[UIButton alloc]initWithFrame:CGRectMake(_white.frame.size.width-40, 5, 20, 20)];
    [close setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closelook) forControlEvents:UIControlEventTouchUpInside];
    [_white addSubview:close];
    
    UIScrollView*scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(5,50,  _white.frame.size.width-10,  _white.frame.size.height-60)];
    
    
    //    scroll.backgroundColor=[UIColor greenColor];
    
    
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.contentSize = CGSizeMake( _white.frame.size.width-10, 590);
    
    [_white addSubview:scroll];
    
    
    
    UILabel*lbno=[[UILabel alloc]initWithFrame:CGRectMake(5,50,  _white.frame.size.width-10,  _white.frame.size.height-60)];
    
    
//    NSString*str=_model.goucode;
    
    lbno.text=@"10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,10000083898,";
    lbno.numberOfLines=0;
    
    
    CGSize size = CGSizeMake(lbno.frame.size.width,10000);
    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
    CGSize labelsize = [lbno.text sizeWithFont:lbno.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    //最后根据这个大小设置label的frame即可
    [lbno setFrame:CGRectMake(lbno.frame.origin.x,lbno.frame.origin.y,lbno.width,labelsize.height)];
    //    lbno.backgroundColor=[UIColor greenColor];
    lbno.textColor=[UIColor grayColor];
    
    
    scroll.contentSize = CGSizeMake(lbno.width,labelsize.height+60);
    
    [scroll addSubview:lbno];
    
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
