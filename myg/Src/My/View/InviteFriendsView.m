//
//  InviteFriendsView.m
//  myg
//
//  Created by lidan on 16/7/12.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import "InviteFriendsView.h"
#import "FriendsModel.h"
#import "InviteFriendsViewCell.h"
#import "PullingRefreshTableView.h"

@implementation InviteFriendsView


- (id)initWithFrame:(CGRect)frame withType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.type = type;
        [self initData];
        if ([type isEqualToString:@"1"]) {
            [self loadRanking];
        }else{
            [self loadingData];
        }
    }
    return self;
}

-(void)initData{
    
    self.friendArray1 = [NSMutableArray array];
    self.friendArray2 = [NSMutableArray array];
    self.friendArray3 = [NSMutableArray array];
    self.rankingArray = [NSMutableArray array];
}


#pragma mark - 加载数据
- (void)loadingData
{
    if (self.tag==201) {
        [self.friendArray1 removeAllObjects];
    }else if (self.tag==202){
        [self.friendArray2 removeAllObjects];
    }else if(self.tag==203){
        [self.friendArray3 removeAllObjects];
    }


    self.num = 1;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.num] forKey:@"p"];
    
    [dict setValue:self.type forKey:@"type"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:three_distribution postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = responseDic[@"data"][@"friend"];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                FriendsModel *friend = [[FriendsModel alloc] init];
                friend.score = [NSString stringWithFormat:@"%@",obj[@"score"]];
                friend.time = [NSString stringWithFormat:@"%@",obj[@"time"]];
                friend.uid = obj[@"uid"];
                friend.userName = obj[@"username"];
                if ([self.type isEqualToString:@"1"]) {
                    [self.friendArray1 addObject:friend];
                }else if ([self.type isEqualToString:@"2"]){
                    [self.friendArray2 addObject:friend];
                }else if ([self.type isEqualToString:@"3"]){
                    [self.friendArray3 addObject:friend];
                }
                
            }];
            
            if (self.tag==201) {
                if (self.friendArray1.count == 0) {
                    [self noData];
                }else{
                    [self removeSubview:self.nodataView];
                    [self createUI];
                }
            }else if (self.tag == 202){
                if (self.friendArray2.count == 0) {
                    [self noData];
                }else{
                    [self removeSubview:self.nodataView];
                    [self createUI];
                }
            }else if (self.tag == 203){
                if (self.friendArray3.count == 0) {
                    [self noData];
                }else{
                    [self removeSubview:self.nodataView];
                    [self createUI];
                }
            }
            
        }
        [self.tableView tableViewDidFinishedLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

#pragma mark - 上拉加载更多
- (void)loadingMoreData
{
    self.num = self.num +1;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.num] forKey:@"p"];
    [dict setValue:@"1" forKey:@"type"];
    
    if (self.tag==201) {
        [dict setValue:@"1" forKey:@"type"];
    }else if (self.tag==202){
        [dict setValue:@"2" forKey:@"type"];
    }else if(self.tag==203){
        [dict setValue:@"3" forKey:@"type"];
    }
    
    [MDYAFHelp AFPostHost:APPHost bindPath:three_distribution postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = responseDic[@"data"][@"friend"];
            if (array.count == 0) {
                [UIView animateWithDuration:2 animations:^{
                    
                } completion:^(BOOL finished) {
                    self.tableView.footerView.state = kPRStateHitTheEnd;
                }];
            }else{
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    FriendsModel *friend = [[FriendsModel alloc] init];
                    friend.score = [NSString stringWithFormat:@"%@",obj[@"score"]];
                    friend.time = [NSString stringWithFormat:@"%@",obj[@"time"]];
                    friend.uid = obj[@"uid"];
                    friend.userName = obj[@"username"];
                    if ([self.type isEqualToString:@"1"]) {
                        [self.friendArray1 addObject:friend];
                    }else if ([self.type isEqualToString:@"2"]){
                        [self.friendArray2 addObject:friend];
                    }else if ([self.type isEqualToString:@"3"]){
                        [self.friendArray3 addObject:friend];
                    }
                    
                }];
            }
        }
        if([responseDic[@"code"] isEqualToString:@"400"])
        {
            [UIView animateWithDuration:2 animations:^{
                
            } completion:^(BOOL finished) {
                self.tableView.footerView.state = kPRStateHitTheEnd;
            }];
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

#pragma mark - 我的好友数据
-(void)loadRanking{
    
    [self.rankingArray removeAllObjects];
    
    [self createUI];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.num] forKey:@"p"];
    
    [dict setValue:self.type forKey:@"type"];
    
    [MDYAFHelp AFPostHost:APPHost bindPath:three_distribution postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===================%@",responseDic);
        if([responseDic[@"code"] isEqualToString:@"200"])
        {
            NSArray *array = responseDic[@"data"][@"friend"];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                FriendsModel *friend = [[FriendsModel alloc] init];
                friend.score = [NSString stringWithFormat:@"%@",obj[@"score"]];
                friend.time = [NSString stringWithFormat:@"%@",obj[@"time"]];
                friend.uid = obj[@"uid"];
                friend.userName = obj[@"username"];
                if ([self.type isEqualToString:@"1"]) {
                    [self.rankingArray addObject:friend];
//                }else if ([self.type isEqualToString:@"2"]){
//                    [self.friendArray2 addObject:friend];
//                }else if ([self.type isEqualToString:@"3"]){
//                    [self.friendArray3 addObject:friend];
                }
                
            }];
            
//            if (self.tag==201) {
//                if (self.friendArray1.count == 0) {
//                    [self noData];
//                }else{
//                    [self removeSubview:self.nodataView];
//                    [self createUI];
//                }
//            }else if (self.tag == 202){
//                if (self.friendArray2.count == 0) {
//                    [self noData];
//                }else{
//                    [self removeSubview:self.nodataView];
//                    [self createUI];
//                }
//            }else if (self.tag == 203){
//                if (self.friendArray3.count == 0) {
//                    [self noData];
//                }else{
//                    [self removeSubview:self.nodataView];
//                    [self createUI];
//                }
//            }
//
            [self.tableView reloadData];
            DebugLog(@"%zd",self.rankingArray.count);
        }
        [self.tableView tableViewDidFinishedLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];

    
    
//    [MDYAFHelp AFPostHost:APPHost bindPath:distribution_ranking postParam:nil getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
//        DebugLog(@"===================%@",responseDic);
//        if([responseDic[@"code"] isEqualToString:@"200"])
//        {
//            NSArray *array = responseDic[@"data"];
//            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                NSDictionary *dict = [self changeType:obj];
//                FriendsModel *friend = [[FriendsModel alloc] init];
//                friend.uid = dict[@"uid"];
//                friend.userName = dict[@"username"];
//                friend.friendsCount = [NSString stringWithFormat:@"%@",dict[@"count"]];
//                [self.rankingArray addObject:friend];
//            }];
//            [self createUI];
//        }
//        [self.tableView tableViewDidFinishedLoading];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
//    }];
}

-(void)loadMoreRanking{
    
    [UIView animateWithDuration:2 animations:^{
        
    } completion:^(BOOL finished) {
        self.tableView.footerView.state = kPRStateHitTheEnd;
    }];
    [self.tableView tableViewDidFinishedLoading];
}

- (void)createUI
{
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.pullingDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor=[UIColor redColor];
    [self addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.tag == 200) {
//        if (self.rankingArray.count !=0) {
//            return self.rankingArray.count +1;
//        }
//    }else if (self.tag == 201) {
//        if (self.friendArray1.count != 0 ) {
//            return self.friendArray1.count +1;
//        }
//    }else if (self.tag == 202){
//        if (self.friendArray2.count != 0 ) {
//            return self.friendArray2.count +1;
//        }
//    }else if (self.tag == 203){
//        if (self.friendArray3.count != 0 ) {
//            return self.friendArray3.count +1;
//        }
//    }
//    NSLog(@"%zd",self.rankingArray.count);

    return self.rankingArray.count;
   }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"CellName";
    
    InviteFriendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell = [[InviteFriendsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.row == 0) {
//        if (self.tag == 200) {
//            
//            cell.lbID.frame = CGRectMake(0, 5, MSW/4 - 30 -0.5, 30);
//            cell.line.frame = CGRectMake(cell.lbID.right, 0, 0.5, self.height);
//            cell.lbNickname.frame = CGRectMake(cell.line.right, 5, MSW/4 - 20 -0.5, 30);
//            cell.line2.frame = CGRectMake(cell.lbNickname.right, 0, 0.5, self.height);
//            cell.lbTime.frame = CGRectMake(cell.line2.right, 5, MSW/4 +30 -0.5, 30);
//            cell.line3.frame = CGRectMake(cell.lbTime.right, 0, 0.5, self.height);
//            cell.lbJifen.frame = CGRectMake(cell.line3.right, 5, MSW/4 + 20 - 0.5, 30);
//            
//            cell.lbID.text = @"排名";
//            cell.lbNickname.text = @"ID";
//            cell.lbTime.text = @"昵称";
//            cell.lbJifen.text = @"好友数";
//        }else{
//            cell.lbID.text = @"ID";
//            cell.lbNickname.text = @"昵称";
//            cell.lbTime.text = @"日期";
//            cell.lbJifen.textColor = [UIColor blackColor];
//            cell.lbJifen.text = @"积分";
//        }
//    }
//
//    if (indexPath.row > 0  ) {
//        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//        cell.lbJifen.textColor = MainColor;
//        if (self.tag == 200) {
//            cell.lbJifen.textColor = [UIColor blackColor];
    FriendsModel * model = self.rankingArray[indexPath.row];
//    [_rankingArray objectAtIndex:indexPath.row - 1];
            cell.lbID.text = [NSString stringWithFormat:@"%li",(long)indexPath.row];
            [cell setRankingModel:model];
//        }else if (self.tag == 201) {
//            FriendsModel * model = [_friendArray1 objectAtIndex:indexPath.row - 1];
//            [cell setModel:model];
//        }else if (self.tag == 202){
//            FriendsModel * model = [_friendArray2 objectAtIndex:indexPath.row - 1];
//            [cell setModel:model];
//        }else if (self.tag == 203){
//            FriendsModel * model = [_friendArray3 objectAtIndex:indexPath.row - 1];
//            [cell setModel:model];
//        }
//
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row != 0 ) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FriendsModel * model;
        if (self.tag == 201) {
            model = _rankingArray[indexPath.row] ;
        }else if (self.tag == 201) {
//            model = [_friendArray1 objectAtIndex:indexPath.row - 1];
        }else if (self.tag == 202){
//            model = [_friendArray2 objectAtIndex:indexPath.row - 1];
        }else if (self.tag == 203){
//            model = [_friendArray3 objectAtIndex:indexPath.row - 1];
        }
        
        [self.delegate shouldPushControllerWithUid:model.uid];
//    }
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
    //延迟 0.5秒刷新   下拉刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tag == 200) {
            [self loadRanking];
        }else{
            [self loadingData];
        }
    });
    
}


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //延迟 0.5秒刷新   上拉加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tag != 200) {
            [self loadingMoreData];
        }else{
            [self loadMoreRanking];
        }
    });
}


- (void)noData
{
    if (!self.nodataView)
    {
        self.nodataView = [[NoDataView alloc]init];
        if (self.tag == 201) {
            _nodataView.titleLabel.text = @"还没有一级好友";
        }else if (self.tag == 202){
            _nodataView.titleLabel.text = @"还没有二级好友";
        }else if (self.tag == 203){
            _nodataView.titleLabel.text = @"还没有三级好友";
        }
        [_nodataView.btgoto setTitle:@"邀请好友" forState:UIControlStateNormal];
        _nodataView.textLabel.text = @"";
        [_nodataView.btgoto addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.nodataView];
}

-(void)clickButton{
    [self.delegate shouldPushInstructionsView];
}

/*--------------------Null转换@""-------------------*/

//将NSDictionary中的Null类型的项目转化成@""
-(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSArray中的Null类型的项目转化成@""
-(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
-(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
-(NSString *)nullToString
{
    return @"";
}

//类型识别:将所有的NSNull类型转化成@""
-(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
