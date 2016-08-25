//
//  RefreshView.m
//  yyxb
//
//  Created by lili on 15/11/25.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "RefreshView.h"
#import "DoingViewCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
#import "MyBuyListModel.h"
#import "DidViewCell.h"
#import "NodataViewCell.h"
#import "TreasureNoController.h"
#import "GoodsDetailsViewController.h"
#import "PersonalcenterController.h"
#import "FoundViewCell.h"
@implementation RefreshView

- (id)initWithFrame:(CGRect)frame AndNum:(NSString *)num
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numStr = num;
        [self initData];
        [self refreshData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"huadong" object:nil];
        
    }
    return self;
}

-(void)initData{
    _dataArray=[NSMutableArray array];
    _didArray=[NSMutableArray array];
    _willArray=[NSMutableArray array];
}
- (void)createUI
{

    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-64-44)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.pullingDelegate = self;
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self addSubview:self.tableView];
}

#pragma mark - 下拉刷新
- (void)refreshData
{
    [_dataArray removeAllObjects];
    [_willArray removeAllObjects];
    [_didArray removeAllObjects];
    
    self.num = 1;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:self.numStr forKey:@"type"];
    [MDYAFHelp AFPostHost:APPHost bindPath:MyBuyList postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic[@"code"] isEqualToString:@"200"]) {
            self.tableView.footerView.state = kPRStatePulling;
            NSDictionary*data=responseDic[@"data"];
            NSDictionary*count=data[@"count"];
            _allcount=count[@"all"];
            _jiexiaocount=count[@"jiexiao"];
            _jinxingcount=count[@"jinxing"];
           [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"refreshAction" object:nil userInfo:dict]];
        }else{
        }
         [self refreshSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
}

- (void)refreshSuccessful:(id)data
{
     [self.willArray removeAllObjects];
    [self.didArray removeAllObjects];
    [self.dataArray removeAllObjects];
    if ([data isKindOfClass:[NSDictionary class]])
    {
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *data1 = data[@"data"];
            
            NSArray*array=data1[@"list"];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          MyBuyListModel  *model = [[MyBuyListModel alloc]initWithDictionary:obj];
                if (self.tag==101) {
                    [self.dataArray addObject:model];
                
                }else if (self.tag==102){
                 
                    [_willArray addObject:model];
                
                }else{
                
                    [_didArray addObject:model];
                }
             }];
        }
   }
    
    [_tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    if (!self.tableView) {
        [self createUI];
    }
}
#pragma mark - tableViewDelegeta
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tag==101) {
        
        if (_dataArray.count!=0) {
            return _dataArray.count;
        }else{
            return 1;
        }
    }else if (self.tag==102){
        if (_willArray.count!=0) {
             return _willArray.count;
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
      
      if (_dataArray.count!=0) {
          if ([self.model.type isEqualToString:@"0"]) {
              return 130;
          }else{
              return 190;
              
          }
      }else{
      
          return MSH-100;
      
      }
      
  }else if (self.tag==102){
      if (_willArray.count!=0) {
          return 130;
      }else{
          return MSH-100;

      }
     
  
  }else{
      if (_didArray.count!=0) {
          return 190;
      }else{
      return MSH-100;
      }
}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    if (self.tag==101)
    {
        if (_dataArray.count==0) {//没有数据
            static   NSString *ListingCellName = @"NodataViewCell";
            
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
            
            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel1.text=@"你还没有夺宝记录哦！";
            cell.type=3;
            
            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
            cell.btgoto.frame=CGRectMake(MSW/2-100, cell.imageView1.frame.origin.y+180,200, 40);
            cell.likeView.frame=CGRectMake(0, MSH - 40-200 - IPhone4_5_6_6P(60, 60, 90, 110) , MSW, 40);
            cell.scrolike.frame=CGRectMake(0, cell.likeView.bottom, MSW, 200);
            return cell;
        }else{
            _model=[_dataArray objectAtIndex:indexPath.row];
            if ([_model.type isEqualToString:@"0"])
            {
                static   NSString *ListingCellName = @"DidViewCell";
                DidViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
                if (!cell)
                {
                    cell = [[DidViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                    
                }
                cell.model=_model;
                int a;
                a=[_model.zongrenshu intValue]-[_model.canyurenshu intValue];
                cell.btadd.titleLabel.font=[UIFont systemFontOfSize:12];
                
                if (a==0) {
                    [cell.btadd setTitle:@"揭晓中" forState:UIControlStateNormal];
                    cell.btadd.userInteractionEnabled=NO;
                }else{
                    [cell.btadd setTitle:@"追加" forState:UIControlStateNormal];
                    
                }
                return cell;
            }
            else
            {
                static   NSString *ListingCellName = @"DoingViewCell";
                DoingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
                if (!cell)
                {
                    cell = [[DoingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                    
                }
                cell.progressView.hidden=YES;
                cell.lbline.hidden=YES;
                cell.btadd.hidden=YES;
                cell.lbshengyu.hidden=YES;
                cell.lbcount.frame=CGRectMake(90, 45, 150, 20);
                cell.lbplay.frame=CGRectMake(90, 60 , 150, 30);
                cell.btlook.frame=CGRectMake(MSW-120, 60, 130, 30);
                cell.blackview.frame=CGRectMake(10, 100, MSW - 20, 75);
                cell.lbtitle.frame=CGRectMake(90, 5,MSW-110, 50);
                cell.model=_model;
                cell.lbplaycount.attributedText=  [[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",_model.number]  attributedStringWithStyleBook:style1];
                return cell;
            }
            
        }
    }else if (self.tag==102){
        
        if (_willArray.count==0) {//没有数据
            static   NSString *ListingCellName = @"NodataViewCell";
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                
            }cell.selectionStyle = UITableViewCellSelectionStyleNone;
               cell.type=3;
            
            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
            cell.titleLabel1.text=@"你还没有夺宝记录哦！";
            cell.btgoto.frame=CGRectMake(MSW/2-100, cell.imageView1.frame.origin.y+180,200, 40);
            cell.likeView.frame=CGRectMake(0, MSH - 40-200 - IPhone4_5_6_6P(60, 60, 90, 110) , MSW, 40);
            cell.scrolike.frame=CGRectMake(0, cell.likeView.bottom, MSW, 200);
            return cell;
        }else{
            static   NSString *ListingCellName = @"DoingViewCell";
            DoingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
            if (!cell)
            {
                cell = [[DoingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
            }
        _model=[_willArray objectAtIndex:indexPath.row];
            cell.blackview.hidden=YES;
            int a;
            a=[_model.zongrenshu intValue]-[_model.canyurenshu intValue];
            cell.btadd.titleLabel.font=[UIFont systemFontOfSize:12];
            if (a==0) {
                [cell.btadd setTitle:@"揭晓中" forState:UIControlStateNormal];
                cell.btadd.userInteractionEnabled=NO;
            }else{
                [cell.btadd setTitle:@"追加" forState:UIControlStateNormal];
            }
            cell.model=_model;
            cell.lbplaycount.attributedText=  [[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",_model.number]  attributedStringWithStyleBook:style1];
            return cell;
        }
    }else{
        if (_didArray.count!=0) {//如果有数据的话
            static   NSString *ListingCellName = @"DoingViewCell";
            
            DoingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
            
            if (!cell)
            {
                cell = [[DoingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                
            }
            _model=[_didArray objectAtIndex:indexPath.row];
            cell.progressView.hidden=YES;
            cell.lbline.hidden=YES;
            cell.btadd.hidden=YES;
            cell.lbshengyu.hidden=YES;
            cell.lbcount.frame=CGRectMake(90, 45, 150, 20);
            cell.lbplay.frame=CGRectMake(90,60 , 150, 30);
            cell.btlook.frame=CGRectMake(MSW-120, 60, 130, 30);
            cell.blackview.frame=CGRectMake(10, 100, MSW -20, 75);
            cell.lbtitle.frame=CGRectMake(90, 5,MSW-110, 50);
            cell.lbtitle.text=_model.shopname;
            [cell.imgegood sd_setImageWithURL:[NSURL URLWithString:_model.thumb ] placeholderImage:[UIImage imageNamed:DefaultImage]];
            cell.lbplaycount.attributedText=  [[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",_model.number]  attributedStringWithStyleBook:style1];
            cell.lbcount.text=[NSString stringWithFormat:@"总需%@",_model.zongrenshu];
            int a;
            a=[_model.zongrenshu intValue]-[_model.canyurenshu intValue];
            //            cell.lbshengyu.text=[NSString stringWithFormat:@"剩余%i",a];
            cell.lbshengyu.attributedText=[[NSString stringWithFormat:@"剩余<u>%i</u>",a]attributedStringWithStyleBook:style1];
            float b;
            b=[_model.canyurenshu floatValue]/[_model.zongrenshu floatValue];
            cell.progressView.progress=b;
            NSString *str=_model.q_end_time;//时间戳
            NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            cell.lbtime.text=[NSString stringWithFormat:@"揭晓时间：%@",[dateFormatter stringFromDate: detaildate]];
            cell.lbluckno.attributedText=  [[NSString stringWithFormat:@"中奖号码：<u>%@</u>",_model.q_user_code] attributedStringWithStyleBook:style1];
            [cell.btname setTitle:_model.username forState:UIControlStateNormal];
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:_model.img ] placeholderImage:[UIImage imageNamed:@"head"]];
            [cell.btadd setTitle:@"追加" forState:UIControlStateNormal];
            cell.model=_model;
            return cell;
            }else{
            static   NSString *ListingCellName = @"NodataViewCell";
            NodataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListingCellName];
            if (!cell)
            {
                cell = [[NodataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListingCellName];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type=3;
            cell.titleLabel1.text=@"你还没有夺宝记录哦！";
            [cell.btgoto addTarget:self action:@selector(gotoxunbao) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btgoto.frame=CGRectMake(MSW/2-100, cell.imageView1.frame.origin.y+180,200, 40);
            cell.likeView.frame=CGRectMake(0, MSH - 40-200 - IPhone4_5_6_6P(60, 60, 90, 110) , MSW, 40);
            cell.scrolike.frame=CGRectMake(0, cell.likeView.bottom, MSW, 200);
            return cell;
        }
    }
    }
-(void)gotoxunbao{
        NSNotification *gotoxunbao2 =[NSNotification notificationWithName:@"gotoxunbao2" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:gotoxunbao2];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tag==101) {
        if (_dataArray.count==0) {
        }else{
        _model=[_dataArray objectAtIndex:indexPath.row];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_model,@"model", nil];
            
            NSNotification *xiangqing =[NSNotification notificationWithName:@"xiangqing" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:xiangqing];
        }
   
    }else if (self.tag==102){
        if (_willArray.count==0) {
            
        }else{
          _model=[_willArray objectAtIndex:indexPath.row];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_model,@"model", nil];
            
            NSNotification *xiangqing =[NSNotification notificationWithName:@"xiangqing" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:xiangqing];
        }
  
    }else{
        if (_didArray.count==0) {
            
        }else{
               _model=[_didArray objectAtIndex:indexPath.row];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_model,@"model", nil];
            
            NSNotification *xiangqing =[NSNotification notificationWithName:@"xiangqing" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:xiangqing];
        }
}
}
//查看他的号码
-(void)looktreasureno{
   NSNotification *shaidan =[NSNotification notificationWithName:@"lookno" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:shaidan];
}
- (void)refreshFailure:(NSError *)error
{
   [self.tableView tableViewDidFinishedLoading];
}
#pragma mark - 上拉加载更多
- (void)loadingData
{
    self.num = self.num +1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[UserDataSingleton userInformation].uid forKey:@"yhid"];
    [dict setValue:[UserDataSingleton userInformation].code forKey:@"code"];
    [dict setValue:@"1" forKey:@"type"];
    if (self.tag==101) {
        [dict setValue:@"1" forKey:@"type"];
    }else if (self.tag==102){
        
        [dict setValue:@"2" forKey:@"type"];
    }else if(self.tag==103){
        [dict setValue:@"3" forKey:@"type"];
    }
   [dict setValue:[NSString stringWithFormat:@"%i",self.num] forKey:@"p"];
    [MDYAFHelp AFPostHost:APPHost bindPath:MyBuyList postParam:dict getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"成功：%@",responseDic);
        [self loadingSuccessful:responseDic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"失败:%@",error);

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
        
        if([data[@"code"] isEqualToString:@"200"])
        {
            NSDictionary *data1 = data[@"data"];
            NSArray*array=data1[@"list"];
            if([[NSString stringWithFormat:@"%lu",self.dataArray.count] isEqualToString:data[@"count"]])
            {
                [UIView animateWithDuration:2 animations:^{
                    
                } completion:^(BOOL finished) {
                    self.tableView.footerView.state = kPRStateHitTheEnd;
                }];
            }
            
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                //
                MyBuyListModel  *model = [[MyBuyListModel alloc]initWithDictionary:obj];
                
           
                if (self.tag==101) {
                    [self.dataArray addObject:model];
                    
                }else if (self.tag==102){
                    [_willArray addObject:model];
                    
                }else{
                    
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




@end
