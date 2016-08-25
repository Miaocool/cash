//
//  TreasureNoController.m
//  yyxb
//
//  Created by lili on 15/11/25.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "TreasureNoController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

#import "NumCell.h"

@interface TreasureNoController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray*_Noarray;
    UILabel *lbNo;
    NSString*shopname;
    NSString*gonumber;
    NSString*goucode;
    NSString*shopqishu;
}
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
static NSString *collectionCellName = @"collectionCell";

@implementation TreasureNoController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"夺宝号码";
    
//    UIView*rightview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
//    UIButton *callBtn = [[UIButton alloc]init];
//    callBtn.frame = CGRectMake(30, 10, 23, 13);
//    [callBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
////    [callBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
////    
//    [rightview addSubview:callBtn];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightview];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    
    
    
    
    
    
    
    
    
//    _Noarray=[NSMutableArray array];
//    [_Noarray addObject:@"4567890"];
//     [_Noarray addObject:@"12323290"];
//     [_Noarray addObject:@"41111890"];
//     [_Noarray addObject:@"11111190"];
//    [_Noarray addObject:@"7777770"];
//     [_Noarray addObject:@"8888890"];
//    
    
    [self refreshData];
    
    
}

//
#pragma mark - 下拉刷新
- (void)refreshData
{
   
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_sid forKey:@"id"];
    
    NSLog(@"--%@",_sid);
    
    [MDYAFHelp AFPostHost:APPHost bindPath:Buynumber postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic)  {
        
        NSLog(@"------%@---%@",responseDic,responseDic[@"msg"]);
        
        NSDictionary*data=responseDic[@"data"];
        shopname=data[@"shopname"];
        gonumber=data[@"gonumber"];
        goucode=data[@"goucode"];
        shopqishu=data[@"shopqishu"];
        self.dataArray = [goucode componentsSeparatedByString:@","];
      

        [self creatview];
        
        [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];
}


-(void)creatview{
    UIView*_headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-40, 60)];
    lbtitle.font = [UIFont systemFontOfSize:13];
    lbtitle.text=[NSString stringWithFormat:@"(第%@期)%@",shopqishu,shopname];
    lbtitle.textColor=[UIColor grayColor];
    lbtitle.numberOfLines=0;
    
    
    
    NSLog(@"---%li",lbtitle.text.length);
    
    
    
    [_headview addSubview:lbtitle];
    
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:IPhone4_5_6_6P(6.0, 6.0, 8.0, 10.0)],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
 
    
    
    UILabel*lbcount=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, [UIScreen mainScreen].bounds.size.width-10,40)];
    
    lbcount.attributedText =  [[NSString stringWithFormat:@"本次参与了<u>%@</u>人次" ,gonumber]attributedStringWithStyleBook:style1];
    lbcount.font=[UIFont systemFontOfSize:IPhone4_5_6_6P(14, 14, 15, 15)];
    lbcount.numberOfLines=0;
    [_headview addSubview:lbcount];
    
    
//    
    
//    CGFloat W = ([UIScreen mainScreen].bounds.size.width-50)/4;
//    CGFloat H = 45;
//    
//    for (int i = 0; i<_Noarray.count; i++) {
//        
//        lbcount = [[UILabel alloc]initWithFrame:CGRectMake(10+(10+W)*(i%4), 80 + 50 + 10*(i/4)+(i/4) * H, W, H)];
//        lbcount.text=[_Noarray objectAtIndex:i];
//        lbcount.font=[UIFont systemFontOfSize:14];
////        lbcount.backgroundColor=[UIColor greenColor];
//        
//        [self.view addSubview:lbcount];
//        
//        
//       
//    }
    
//    UIScrollView*scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 110,MSW-20, MSH-180)];
//    
////    scroll.backgroundColor=[UIColor greenColor];
//    scroll.showsHorizontalScrollIndicator=NO;
//    scroll.showsVerticalScrollIndicator=NO;
//    scroll.contentSize = CGSizeMake( self.view.frame.size.width-10, 590);
//    
//    
//    [self.view addSubview:scroll];
//    
//  
//    UILabel*lbtext=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,MSW-20, 80)];
////    lbtext.backgroundColor=[UIColor whiteColor];
//    lbtext.numberOfLines=0;
//    
//    
//    //    根据子的多少宽度自动适应
//    lbtext.text=goucode;
//    
//    
////    lbtext.text=@"ggeu";
//    //设置宽高，其中高为允许的最大高度
//    CGSize size = CGSizeMake(lbtext.frame.size.width,10000);
//    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
//    CGSize labelsize = [lbtext.text sizeWithFont:lbtext.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    //最后根据这个大小设置label的frame即可
//    [lbtext setFrame:CGRectMake(lbtext.frame.origin.x,lbtext.frame.origin.y,labelsize.width,labelsize.height)];
//    lbtext.textColor=[UIColor grayColor];
//    
//    [scroll addSubview:lbtext];
//
//    
//    
//    scroll.contentSize = CGSizeMake(lbtext.width,labelsize.height+20);
    [self.view addSubview:_headview];
//
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake(100, 20);
    if (!self.collectionView)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 110, MSW, MSH - 180) collectionViewLayout:layOut];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[NumCell class] forCellWithReuseIdentifier:collectionCellName];

        self.collectionView.scrollEnabled = YES;
        [self.view addSubview:self.collectionView];
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //有多少个Cell
    // self.collectionView.frame = CGRectMake(0, 0, MSW, self.dataArray.count / 2 * 180);
    return self.dataArray.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];

    
    return cell;
}

- (void)refreshSuccessful:(id)data
{
    //    [self.willArray removeAllObjects];
    //    [self.dataArray removeAllObjects];
    //    if ([data isKindOfClass:[NSDictionary class]])
    //    {
    //        if([data[@"code"] isEqualToString:@"200"])
    //        {
    //            NSArray *array = data[@"data"];
    //            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //
    //                BeforeModel  *model = [[BeforeModel alloc]initWithDictionary:obj];
    //                NSLog(@"------%@",model.status);
    //                if ([model.status isEqualToString:@"0"]) {
    //                    [self.willArray addObject:model];
    //                }else{
    //
    //                    [self.dataArray addObject:model];
    //
    //                }
    //
    //                NSLog(@"-------%li-------%li",_willArray.count,_dataArray.count);
    //                [self createTableView];
    //            }];
    //        }
    //
    //
    //    }
    //
    //    [_tableView reloadData];
    //    [self.tableView tableViewDidFinishedLoading];
    //    [self createTableView];
    
    
    
    
}

- (void)refreshFailure:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不给力" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"失败");
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
