//
//  MDBaseRefreshListView.h
//  MDYNewsSon
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullingRefreshTableView.h"


@interface MDBaseRefreshListView : UIView<PullingRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>

/**
 *  上拉刷新 下拉加载的 UITableView
 */
@property(nonatomic,retain)PullingRefreshTableView * baseTableView;

/**
 * 列表的数据源
 */
@property(nonatomic,retain)NSMutableArray * baseDataArray;

/**
 *  暂时数据源
 */
@property(nonatomic,retain)NSArray *tempDataArray;

/**
 * 加载页数 加载自动加 1，刷新自动 == 1 最小是 1
 */
@property(nonatomic,assign)NSInteger dataPage;


/**
 *  每页个数  当新请求页数的数据个数少于 每页个数 或者为 0 时，上拉加载 功能不可用（此时说明已经没有更多数据了）
 
  两种处理方式： 1.禁止上拉功能 ，并隐藏上拉加载动画   [self.baseTableView clearFoorView];  
                 并且有足够数据时 显示此功能   [self.baseTableView canShowFootView];
               2.禁止上拉功能， 上拉提示语 改成 美誉更多信息  self.baseTableView.reachedTheEnd = YES;
 
   2.每页个数  当新请求页数的数据个数少于 每页个数 或者为 0 ，
 
 */

@property(nonatomic,assign)NSUInteger  numberOfEachPage;


/**
 * YES 刷新  ，NO 加载,用于请求结果的判断
 */
@property(nonatomic,assign) BOOL isReFreshing;

/**
 *首页 的 page值 默认为 1
 */
@property(nonatomic,assign)NSUInteger firstPage;

/**
 * 两次刷新 允许的时间差 小于 则不自动刷新 大于 则自动刷新 默认 20分钟
 */

@property(nonatomic,assign)CFAbsoluteTime betweenRefreshTimes;



/**
 * 请求数据
 */
-(void)requestData;

/**
 *  开始请求
 */
-(void)startRequest;

/**
 * 刷新数据为第一页 （直接刷新不进行条件判断）
 */
-(void)refreshTableListData;

/**
 * 刷新  条件是 两次刷新之间的时间差
 */
-(void)refreshTableListDataIfNeed;

/**
 *下载完数据 展示结果  每次请求完 都必须 调用该方法
 */
-(void)showData;

/**
 *  请求失败处理
 */
-(void)failRequest:(NSError *)error;



@end
