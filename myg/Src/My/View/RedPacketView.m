//
//  RedPacketView.m
//  yyxb
//
//  Created by lili on 15/12/14.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "RedPacketView.h"
#import "MyRedCell.h"
#import "RedBoxDto.h"
#import "GroupRedViewController.h"
#import "MJRefresh.h"
#import "DidViewCell.h"
#import "ExchangeRedViewController.h"
#import "NodataViewCell.h"
@implementation RedPacketView
- (id)initWithFrame:(CGRect)frame AndNum:(NSString *)num
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.numStr = num;
        [self initData];
        [self refreshData];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
        
    }
    return self;
}
-(void)initData{
    _couldarray=[NSMutableArray array];
    _didArray=[NSMutableArray array];
  }
- (void)createUI
{
    if (!self.tableView) {

    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-64-50)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.pullingDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:self.tableView];
    }
}
#pragma mark - 下拉刷新
- (void)refreshData
{
    self.num = 1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:[NSString stringWithFormat:@"%ld",self.num] forKey:@"p"];
  //  if (self.tag==101)
 //   {
        [dict setValue:self.numStr forKey:@"status"];

//    }
//    if (self.tag == 102)
//    {
//        [dict setValue:self.numStr forKey:@"status"];
//    }
      [MDYAFHelp AFPostHost:APPHost bindPath:RedBao postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"%@",responseDic);
        [self refreshSuccessful:responseDic];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self refreshFailure:error];
    }];
    
}
- (void)refreshSuccessful:(id)data
{
    [_couldarray removeAllObjects];
    [_didArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            self.tableView.footerView.state = kPRStatePulling; 
            NSArray *array = data[@"data"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                RedBoxDto *model = [[RedBoxDto alloc]initWithDictionary:obj];
                if (self.tag==101) {
                    [_couldarray addObject:model];
                }
                else{
                    [_didArray addObject:model];
                }
            }];
        }
    }
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    [self createUI];
    }
#pragma mark - tableViewDelegeta

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tag==101) {
        
        if (_couldarray.count!=0) {
            return _couldarray.count;

        }else{
            return 1;
        }
        
    }else{
        if (_didArray.count!=0) {
            return _didArray.count;

        }else{
            return 1;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tag==101) {
        if (_couldarray.count!=0) {
             return 100;
        }else{
        return MSH-100;
        }
    }else{
        if (_didArray.count!=0) {
            return 100;
        }else{
            return MSH-100;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    if (self.tag==101)
    {
        if (_couldarray.count==0)
        {//没有数据
            static   NSString *ListingCellName = @"NodataViewCell";
            
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
            
            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel1.text=@"您还没有可以使用的红包哦!";
            cell.textLabel1.text=@"";
            cell.type=1;
            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
            cell.btgoto.frame=CGRectMake(MSW/2-100, cell.imageView1.frame.origin.y+180,200, 40);
            cell.likeView.frame=CGRectMake(0, MSH - 40-200 - IPhone4_5_6_6P(60, 60, 90, 110) , MSW, 40);
            cell.scrolike.frame=CGRectMake(0, cell.likeView.bottom, MSW, 200);
            return cell;
        }
        else
        {
    
    static   NSString *cellIndentifer =@"cellIndenfier";
        
    MyRedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell)
    {
        cell = [[MyRedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
            cell.redModel=_couldarray[indexPath.row];
            cell.statusImg.hidden=YES;
            
   return cell;
        }
    }
    else
    {
        if (_didArray.count==0)
        {//没有数据
            static   NSString *ListingCellName2 = @"NodataViewCell123";
            
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName2];
            
            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName2];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel1.text=@"您还没有已使用／过期的红包哦!";
            cell.textLabel1.text=@"";
            cell.type=1;
            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btgoto.frame=CGRectMake(MSW/2-100, cell.imageView1.frame.origin.y+180,200, 40);
            cell.likeView.frame=CGRectMake(0, MSH - 40-200 - IPhone4_5_6_6P(60, 60, 90, 110) , MSW, 40);
            cell.scrolike.frame=CGRectMake(0, cell.likeView.bottom, MSW, 200);

            return cell;
            
        }else{
            static   NSString *cellIndentifer =@"cellIndenfier";
            MyRedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
            if (!cell)
            {
                cell = [[MyRedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
               cell.redModel=_didArray[indexPath.row];
            if ([cell.redModel.type isEqualToString:@"1"]) {
//                已过期
                   cell.statusImg.image=[UIImage imageNamed:@"11"];
            }
            if ([cell.redModel.isuse isEqualToString:@"1"]) {
//                已使用
                   cell.statusImg.image=[UIImage imageNamed:@"10"];
            }
              cell.statusImg.frame=CGRectMake(MSW-80, 20, 53,35) ;
         
            cell.statusImg.hidden=NO;
            
          return cell;
        }
    }
}



-(void)gotoxunbao{
NSNotification *gotoxunbao2 =[NSNotification notificationWithName:@"gotoxunbao" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:gotoxunbao2];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:[NSString stringWithFormat:@"%ld",self.num] forKey:@"p"];
    
    //  if (self.tag==101)
    //   {
    [dict setValue:self.numStr forKey:@"status"];
    
    //    }
    //    if (self.tag == 102)
    //    {
    //        [dict setValue:self.numStr forKey:@"status"];
    //    }
    [MDYAFHelp AFPostHost:APPHost bindPath:RedBao postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        
        DebugLog(@"====++++%@---%@",responseDic,responseDic[@"msg"]);
        
        
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
                        self.tableView.footerView.state = kPRStateHitTheEnd;
                    }];
                
            }
            if ([data[@"code"] isEqualToString:@"200"])
            {
                NSArray *array = data[@"data"];
                DebugLog(@"****%@",array);   //有值
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    RedBoxDto *model = [[RedBoxDto alloc]initWithDictionary:obj];
                    
                    if (self.tag==101) {
                        [_couldarray addObject:model];
                        RedBoxDto *model = [_couldarray objectAtIndex:0];
                        DebugLog(@"---===%@----%@",model.type_name,model.type_money);
                    }
                    else{
                        [_didArray addObject:model];
                    }
                    
                }];

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




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
