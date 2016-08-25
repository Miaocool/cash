//
//  SearchViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/10.
//  Copyright (c) 2015年 杨易. All rights reserved.
//搜索

#import "SearchViewController.h"

#import "GoodsModel.h"

#import "TagsView.h"

#import "ClassificationGoodsViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,TagsViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITextField *searchFied;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TagsView *tagsView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;  //热门搜索
@property (nonatomic, strong) NSMutableArray *searchArray;  //历史记录
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self requestData];
    [self setNav];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view removeAllSubviews];
    [self initData];
    [self requestData];
}

#pragma mark - 设置导航
- (void)setNav
{
    UIView*search=[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPhone4_5_6_6P(230, 230, 280, 280), 30)];
    search.backgroundColor = [UIColor clearColor];
    search.layer.cornerRadius = 5;
    
    self.searchFied = [[UITextField alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(-10, -10, -35, -35), 0, IPhone4_5_6_6P(220, 220, 270, 270), 30)];
    self.searchFied.backgroundColor = [UIColor whiteColor];
    self.searchFied.layer.cornerRadius = 5;
    self.searchFied.clearButtonMode = UITextFieldViewModeAlways;
    self.searchFied.placeholder = @" 搜索感兴趣的商品";
    self.searchFied.returnKeyType = UIReturnKeySearch;
    self.searchFied.delegate = self;
    [search addSubview:_searchFied];
    self.navigationItem.titleView = search;
}

- (void)initData
{
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
}


- (void)requestData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //热门搜索
    [MDYAFHelp AFPostHost:APPHost bindPath:SearchData postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"%@",responseDic);
        [SVProgressHUD dismiss];
        [self.dataArray removeAllObjects];
        if ([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = responseDic[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.dataArray addObject:obj[@"name"]];
            }];

        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        
        //历史记录
        [MDYAFHelp AFPostHost:APPHost bindPath:find_search_record postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"历史记录--%@",responseDic);
            [SVProgressHUD dismiss];
            [self.searchArray removeAllObjects];
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                NSArray *array = responseDic[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    DebugLog(@"%@",obj[@"content"]);
                    [self.searchArray addObject:obj[@"content"]];
                    
                }];
                
            }
            
            if (self.searchArray.count == 0 ) {//没有历史记录
                
                [self initTagsView];
                
            }else{
                [self initTableView];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];

    }];
    

}




#pragma mark 有历史记录时上方view
-(UIView* )topView{
    _headView = nil;
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 50)];
    _headView.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    // 是否分页
    _scrollView.pagingEnabled = NO;
    // 是否滚动
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_headView addSubview:_scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17, 10, 80, 30)];
    label.text = @"热门搜索";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:label];
    
    _tagsView = [[TagsView alloc] init];
    _tagsView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tagsView.contentInsets = UIEdgeInsetsZero;
    _tagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
//    _tagsView.tagBorderWidth = 0.5;
    _tagsView.tagcornerRadius = 11;
    _tagsView.tagBorderColor = [UIColor lightGrayColor];
    _tagsView.tagSelectedBorderColor = [UIColor lightGrayColor];
    _tagsView.tagBackgroundColor = [UIColor groupTableViewBackgroundColor];
    _tagsView.lineSpace = 15;
    _tagsView.interitemSpace = 12;
    _tagsView.tagFont = [UIFont systemFontOfSize:14];
    _tagsView.tagTextColor = [UIColor grayColor];
    _tagsView.tagSelectedBackgroundColor = _tagsView.tagBackgroundColor;
    _tagsView.tagSelectedTextColor = _tagsView.tagTextColor;
    _tagsView.delegate = self;
    
    _tagsView.tagsArray = self.dataArray;
    
    [_scrollView addSubview:_tagsView];
    
    _tagsView.frame = CGRectMake(label.right, 10, (70+_tagsView.interitemSpace) * self.dataArray.count, 30);
    
    _scrollView.contentSize = CGSizeMake((70+_tagsView.interitemSpace) * self.dataArray.count +100, 50);
    
    return _headView;
}

#pragma mark - textFiedDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchFied.text != nil && [self.searchFied.text length] > 0)
    {
      
        ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
        classVC.dataString = self.searchFied.text;
//        classVC.title = @"搜索结果";
        
         classVC.titlestr= self.searchFied.text;
        classVC.nameString=self.searchFied.text;
        classVC.isSarch=YES;
        classVC.isSection=NO;
        
        [self.navigationController pushViewController:classVC animated:YES];
    }
    return YES;
}

#pragma mark - 收键盘
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.searchFied resignFirstResponder];

}

#pragma mark - 创建TagsView
- (void)initTagsView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 30)];
    _headView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    label.text = @"热门搜索";
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [_headView addSubview:label];
    
    
    _tagsView = [[TagsView alloc] initWithFrame:CGRectMake(10, _headView.bottom, MSW-20, MSH - _headView.height)];
    _tagsView.backgroundColor = [UIColor whiteColor];
    _tagsView.contentInsets = UIEdgeInsetsZero;
    _tagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
//    _tagsView.tagBorderWidth = 0.5;
    _tagsView.tagcornerRadius = 11;
    _tagsView.tagBorderColor = [UIColor lightGrayColor];
    _tagsView.tagSelectedBorderColor = [UIColor lightGrayColor];
    _tagsView.tagBackgroundColor = [UIColor groupTableViewBackgroundColor];
    _tagsView.lineSpace = 15;
    _tagsView.interitemSpace = 12;
    _tagsView.tagFont = [UIFont systemFontOfSize:14];
    _tagsView.tagTextColor = [UIColor grayColor];
    _tagsView.tagSelectedBackgroundColor = _tagsView.tagBackgroundColor;
    _tagsView.tagSelectedTextColor = _tagsView.tagTextColor;
    _tagsView.delegate = self;
    _tagsView.tagsArray = _dataArray;
    [self.view addSubview:_tagsView];
    
}

#pragma mark --TagsViewDelegate

- (void)tagsView:(TagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index {
    
    self.searchFied.text = self.dataArray[index];
    
    ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
    classVC.dataString = self.dataArray[index];
    classVC.isSarch=YES;
    classVC.isSection=NO;
    classVC.titlestr= self.dataArray[index];
    classVC.nameString=self.searchFied.text;
    
    [self.navigationController pushViewController:classVC animated:YES];
}


#pragma mark - 创建TableView
- (void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
}

-(UIView *)headerView{
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, MSW, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * lbHistory = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 100, 30)];
    lbHistory.text = @"历史搜索";
    lbHistory.textAlignment = NSTextAlignmentLeft;
    lbHistory.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:lbHistory];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom - 0.5, MSW, 0.5)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0) {
        return self.searchArray.count;
    }
    return 0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"CellName";
    self.tableView.tableFooterView = [[UIView alloc] init];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, MSW - 30, cell.height)];
    label.textColor = [UIColor grayColor];;
    label.text = self.searchArray[indexPath.row];
    [cell.contentView addSubview:label];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }else{
        return 40;
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self topView];
    }else{
        return [self headerView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 500;
    }
 
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 500)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(40, 30, MSW - 80, 35)];
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 0.6;
        button.layer.borderColor = [[UIColor grayColor] CGColor];
        [button setTitle:@"清空历史搜索" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteHistoryList) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
}

#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchFied.text = self.searchArray[indexPath.row];
    ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
    classVC.dataString = self.searchArray[indexPath.row];
    classVC.isSarch=YES;
    classVC.isSection=NO;
    classVC.titlestr= self.searchArray[indexPath.row];
    classVC.nameString=self.searchFied.text;
    
    [self.navigationController pushViewController:classVC animated:YES];
}

#pragma mark 清空历史搜索
-(void)deleteHistoryList{
    
    UIAlertView *alearView = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要清空历史搜索吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alearView show];
    
}
#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
        [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
        
        //历史记录
        [MDYAFHelp AFPostHost:APPHost bindPath:delete_search_record postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
            DebugLog(@"历史记录--%@",responseDic);
            [SVProgressHUD dismiss];
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                [self.view removeAllSubviews];
                [self initTagsView];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            
        }];
    }
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
