//
//  CommentController.m
//  yyxb
//
//  Created by lili on 15/12/30.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "CommentController.h"
#import "CommentModel.h"
#import "ShaidanCommentCell.h"
#import "DateHelper.h"
#import "UIImageView+WebCache.h"
@interface CommentController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{


UILabel*lable;
 NSArray*cellarr;
    
    UIButton *butt;

    UIView*lowview;
}
@property (nonatomic, assign) NSInteger num; //记录当前页数
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NoDataView *nodataView;

@property (nonatomic, strong) UITextView *textview;
@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"评论";
    
    [self initData];
    
    [self refreshData];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
//    [self creatview];
    
}
#pragma mark - 创建数据
- (void)initData
{
    self.dataArray = [NSMutableArray array];
    

}

-(void)creatview{
    
    // 底部view
    lowview=[[UIView alloc]initWithFrame:CGRectMake(0, MSH-124, MSW, 80)];
    lowview.backgroundColor=[UIColor whiteColor];
    
    
    [self.view addSubview:lowview];
    UILabel *lbline=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSW, 1.5)];
    lbline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [lowview addSubview:lbline];
    _textview=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, MSW-20, 50)];
//    _textview.backgroundColor=[UIColor greenColor];
    _textview.layer.borderColor = UIColor.groupTableViewBackgroundColor.CGColor;
    _textview.layer.borderWidth = 2;
    _textview.layer.cornerRadius = 6;
    _textview.layer.masksToBounds = YES;
    _textview.delegate=self;
    _textview.returnKeyType=UIReturnKeySend;
    [lowview addSubview:_textview];
    
    lable=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, MSW-20, 20)];
    lable.text=@"说两句吧！";
    lable.textColor=[UIColor grayColor];
    lable.font=[UIFont systemFontOfSize:MiddleFont];
    lable.backgroundColor=[UIColor clearColor];
    [lowview addSubview:lable];



}
#pragma mark - 创建tableView
- (void)createTableView
{
    if (!self.tableView) {
        
    
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-64  ) pullingDelegate:self style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.showsHorizontalScrollIndicator = FALSE;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    [self creatview];
}

}

#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}

//

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CommentModel*model=[_dataArray objectAtIndex:indexPath.row];
    
    NSString *str = model.sdhf_content;
    UIFont *font = [UIFont systemFontOfSize:MiddleFont];
    //iOS7 通过属性字符串保存的
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    //返回高度
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    //返回高度值 return sizeText.height + 修正值
    
    if (sizeText.height<20) {
        return IPhone4_5_6_6P(65, 65, 55, 55);
    }else{
        
        return sizeText.height +IPhone4_5_6_6P(65, 65, 50, 50);
    }
    
    
    //    return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *ListingCellName = @"ShaidanCommentCell.h";
    ShaidanCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
    if (!cell)
    {
        cell = [[ShaidanCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
    }
   cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CommentModel*model=[_dataArray objectAtIndex:indexPath.row];
    cell.lbdetail.numberOfLines=0;
    cell.lbdetail.text=model.sdhf_content;
    CGSize size = CGSizeMake(cell.lbdetail.frame.size.width,10000);
    CGSize labelsize = [cell.lbdetail.text sizeWithFont:cell.lbdetail.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [cell.lbdetail setFrame:CGRectMake(70,30, MSW-80,labelsize.height)];
//    cell.lbdetail.backgroundColor=[UIColor redColor];
    cell.lbtitle.text=model.sdhf_username;
    cell.lbtime.text=model.sdhf_time;
    [cell.iamgefound sd_setImageWithURL:[NSURL URLWithString:model.sdhf_img] placeholderImage:[UIImage imageNamed:DefaultImage]];
    return cell;
}



#pragma mark - 下拉刷新
- (void)refreshData
{
    self.num = 1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_sid forKey:@"sd_id"];
        DebugLog(@"==从商品详情跳的");
        [MDYAFHelp AFPostHost:APPHost bindPath:Comment postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
     DebugLog(@"--晒单列表------%@---%@",responseDic,responseDic[@"msg"]);
            [self refreshSuccessful:responseDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
            [self refreshFailure:error];
            
        }];
}

- (void)refreshSuccessful:(id)data
{
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            self.tableView.footerView.state = kPRStatePulling;
            
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CommentModel  *model = [[CommentModel alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
        }
    }
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    [self createTableView];
}

- (void)refreshFailure:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - 上拉加载更多
- (void)loadingData
{
    self.num = self.num +1;
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:_sid forKey:@"sd_id"];
    [dict1 setValue:[NSString stringWithFormat:@"%li",self.num] forKey:@"p"];
  [MDYAFHelp AFPostHost:APPHost bindPath:Comment postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [self loadingSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self loadingFailure:error];
    }];
}

- (void)loadingSuccessful:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if ([data[@"code"] isEqualToString:@"400"])
        {
            DebugLog(@"%@",data[@"msg"]);
            
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                self.num = 0;
                self.tableView.footerView.state = kPRStateHitTheEnd;
            }];
        }

        if([data[@"code"] isEqualToString:@"200"])
        {
            self.tableView.footerView.state = kPRStatePulling;
            
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CommentModel  *model = [[CommentModel alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
            }];
            
            if([[NSString stringWithFormat:@"%lu",self.dataArray.count] isEqualToString:data[@"count"]])
            {
                [UIView animateWithDuration:2 animations:^{
                    
                } completion:^(BOOL finished) {
                    self.num = 0;
                    self.tableView.footerView.state = kPRStateHitTheEnd;
                }];
            }

        }
    }
    
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)loadingFailure:(NSError *)error
{
   [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    self.num = self.num -1;
    [self.tableView tableViewDidFinishedLoading];
}

#pragma mark - tableview继承滚动试图的协议
//滚动视图已经滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果滚动视图是Tableview的话 就执行方法
    if ([scrollView isEqual:self.tableView])
    {
        //tab已经滚动的时候调用
        [self.tableView tableViewDidScroll:self.tableView];
    }
}

//已经结束拖拽 将要减速
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.tableView])
    {
        //停止拖拽调用
        [self.tableView tableViewDidEndDragging:self.tableView];
    }
}

#pragma mark - 继承刷新的tableview方法
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
    });
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //延迟 0.5秒刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadingData];
    });
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

//[self.tableView endEditing:YES];
////
    butt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-64-275)];
    butt.backgroundColor=[UIColor clearColor];
    [butt addTarget:self action:@selector(handleSingleTapFrom) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
    return YES;
}
//手势触发事件，键盘隐藏
-(void)handleSingleTapFrom{
    [butt removeAllSubviews];
    [_textview resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [lowview setFrame:CGRectMake(0, MSH-124, lowview.frame.size.width, lowview.frame.size.height)];
    [UIView commitAnimations];
}
#pragma mark  当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [lowview setFrame:CGRectMake(0, MSH-124-height, lowview.frame.size.width, lowview.frame.size.height)];
    [UIView commitAnimations];
    
}


- (void) textViewDidChange:(UITextView *)textView{
    
    if ([_textview.text length] == 0) {
        [lable setHidden:NO];
    }else{
        [lable setHidden:YES];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [self gotocomment];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)gotocomment{
    if ([UserDataSingleton userInformation].isLogin==YES) {
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setValue:_sid forKey:@"sd_id"];
        [dict1 setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict1 setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        [dict1 setValue:_textview.text forKey:@"content"];
        [MDYAFHelp AFPostHost:APPHost bindPath:AddComment postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"--晒单列表------%@---%@",responseDic,responseDic[@"msg"]);
            
            _textview.text=@"";
            [lable setHidden:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self refreshFailure:error];
            
        }];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:0.2f];
        [lowview setFrame:CGRectMake(0, MSH-124, lowview.frame.size.width, lowview.frame.size.height)];
        [UIView commitAnimations];
        
    }else{
        
        DebugLog(@"没有登录");
        
        LoginViewController *login = [[LoginViewController alloc]init];
        login.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:login animated:YES];
        
    }
    [self refreshData];
    
}
- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        _nodataView.titleLabel.text=@"没有评论！";
        _nodataView.textLabel.text=@"";
        [_nodataView.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:self.nodataView];
}
-(void)gotoxunbao{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:0.2f];
    [lowview setFrame:CGRectMake(0, MSH-124, lowview.frame.size.width, lowview.frame.size.height)];
    [UIView commitAnimations];
    
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
