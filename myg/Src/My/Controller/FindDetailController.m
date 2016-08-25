//
//  FindDetailController.m
//  yyxb
//
//  Created by lili on 15/12/15.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "FindDetailController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "FindDetailViewCell.h"
#import "DateHelper.h"


#import "TreasureNoController.h"
#import "BaoDetailModel.h"
@interface FindDetailController ()<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIView*_headview;
    NSMutableArray*_Noarray;
    UILabel *lbNo;
    
}


@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) NSMutableArray *titleArray; //标题
@property (nonatomic, strong) NSMutableArray *imgArray; //图片

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@end

@implementation FindDetailController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
self.title=@"夺宝详情";

    [self refreshData];
}
//
#pragma mark - 下拉刷新
- (void)refreshData
{
    _dataArray=[NSMutableArray array];
    
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_sid forKey:@"shopid"];
    
    if (_tiaotype==1) {
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];

    }else{
    
        [dict1 setValue:_yhid forKey:@"yhid"];

    }
[MDYAFHelp AFPostHost:APPHost bindPath:BuyDetail postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
}
#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height  ) pullingDelegate:self style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    _tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];

    [self.view addSubview:self.tableView];
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
    
                    BaoDetailModel  *model = [[BaoDetailModel alloc]initWithDictionary:obj];
                  
                     [self.dataArray addObject:model];
                    [_tableView reloadData];
                    [self.tableView tableViewDidFinishedLoading];
                    [self createTableView];
                    
                }];
            }else{
            }
            }
}
#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 140;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self creatview];
    return _headview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *ListingCellName = @"FindDetailViewCell.h";
    FindDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!cell)
    {
        cell = [[FindDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BaoDetailModel  *model=[_dataArray objectAtIndex:indexPath.row];
    
    NSString *str=model.time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    cell.lbdata.text=[dateFormatter stringFromDate: detaildate];
    cell.lbtime.text=[dateFormatter1 stringFromDate: detaildate];
    
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    cell.lbcount.attributedText =  [[NSString stringWithFormat:@"<u>%@</u>人次",model.gonumber ] attributedStringWithStyleBook:style1];
    
    cell.btlook.tag=indexPath.row;
    
    if (_tiaotype==1) {
        [cell.btlook setTitle:@"查看夺宝号>" forState:(UIControlStateNormal)];
    }
    
    
    [cell.btlook addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
      return cell;
}

-(void)creatview{
      BaoDetailModel  *model=[_dataArray objectAtIndex:0];
   _headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-40, 60)];
    lbtitle.textColor=[UIColor grayColor];
    lbtitle.font=[UIFont systemFontOfSize:BigFont];
    lbtitle.text=[NSString stringWithFormat:@"(第%@期)%@",model.shopqishu,model.shopname];
    lbtitle.numberOfLines=0;
    [_headview addSubview:lbtitle];
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
        UILabel*lbcount=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, [UIScreen mainScreen].bounds.size.width-10,40)];
    lbcount.attributedText =  [[NSString stringWithFormat:@"本次参与了<u>%@</u>人次",model.gonumber ] attributedStringWithStyleBook:style1];
    lbcount.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(14, 14, 15, 15)];
    lbcount.numberOfLines=0;
    [_headview addSubview:lbcount];
    UIView*_view=[[UIView alloc]initWithFrame:CGRectMake(0, 100, MSW, 40)];
    _view.backgroundColor=[UIColor whiteColor];
    [_headview addSubview:_view];
    UILabel*line=[[UILabel alloc]initWithFrame:CGRectMake(0, 0.5, MSW, 0.5)];
    line.backgroundColor=[UIColor grayColor];
    [_view addSubview:line];
    
    UILabel*line1=[[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, MSW, 0.5)];
    line1.backgroundColor=[UIColor grayColor];
    [_view addSubview:line1];
    
    UILabel*lbduobao=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 20)];
    lbduobao.text=@"夺宝时间";
    lbduobao.font = [UIFont systemFontOfSize:13];
    lbduobao.textColor=[UIColor grayColor];
    [_view addSubview:lbduobao];
    UILabel*canyu=[[UILabel alloc]initWithFrame:CGRectMake(MSW-100, 10, 90, 20)];
    canyu.text=@"参与人次";
    canyu.textAlignment = NSTextAlignmentRight;
    canyu.font = [UIFont systemFontOfSize:13];
    canyu.textColor=[UIColor grayColor];
    [_view addSubview:canyu];
    
    
    
}

-(void)editClick:(UIButton *)sender{
    int index=(int)[sender tag];
    BaoDetailModel  *model=[_dataArray objectAtIndex:index];
    TreasureNoController *detailsVC = [[TreasureNoController alloc]init];
    detailsVC.sid=model.idd;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
- (void)refreshFailure:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    DebugLog(@"失败");
    //    [self.tableView tableViewDidFinishedLoading];
}

//


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
