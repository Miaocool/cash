//
//  MDBaseRefreshListView.m
//  MDYNewsSon
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 MM. All rights reserved.
//

#import "MDBaseRefreshListView.h"

@interface MDBaseRefreshListView()

/**
 * YES 刷新  ，NO 加载  用于请求数据方法的判断
 */
@property(nonatomic,assign) BOOL refreshing;

@end

@implementation MDBaseRefreshListView
{
     CFAbsoluteTime _lastRefreshTime;//上次刷新的时间

    CFAbsoluteTime _currentTime;// 当前时间
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _lastRefreshTime = 0;// 只有在刷新成功后才进行赋值
        
        _currentTime = CFAbsoluteTimeGetCurrent();
        
        _baseDataArray = [[NSMutableArray alloc] init];
        
        _tempDataArray = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
    
        _firstPage =  1;
        
        _betweenRefreshTimes = 20 * 60;
       
        
        [self initSubViews];

    }
    return self;
}


-(void)initSubViews
{
    _baseTableView = [[PullingRefreshTableView alloc] initWithFrame:self.bounds pullingDelegate:self style:UITableViewStylePlain];
    
    _baseTableView.backgroundColor = [UIColor clearColor];
    
    //    _baseTableView ->_footerView.emptyDataText = @"没有找到符合条件的酒店！";
    
    if ([_baseTableView canPerformAction:@selector(setSeparatorInset:) withSender:nil])
    {
        _baseTableView.separatorInset = UIEdgeInsetsZero;
    }
    
    _baseTableView.delegate = self;
    
    _baseTableView.dataSource = self;
    
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 去掉横线
    
    [_baseTableView clearFoorView];// 初始化 不允许加载
    
    [self addSubview: _baseTableView];

}

#pragma mark 数据请求相关


-(void)startRequest
{
    [self refreshTableListData];
    
}

-(void)refreshTableListData
{
    
    self.refreshing = YES;
    
    [_baseTableView launchRefreshing];
    
}

-(void)refreshTableListDataIfNeed
{
    _currentTime = CFAbsoluteTimeGetCurrent();
    
    
    if (_currentTime - _lastRefreshTime  > _betweenRefreshTimes)
    {
        [self refreshTableListData];
    }
}



-(void)requestData
{
    self.tempDataArray = [[NSArray alloc]initWithArray:self.baseDataArray];

    _dataPage++;

    
    if (self.refreshing) {
    
        _dataPage = _firstPage;

    }
    
    
}

-(void)showData
{
    NSLog(@" 页数 %ld",(long)_dataPage);
    
    //请求下来的数据个数
    NSUInteger fromNetDataCount = (int)(self.baseDataArray.count - self.tempDataArray.count);
    
    if (!self.refreshing)
    {
        if (fromNetDataCount==0)
        {
            _dataPage--;
        }
        
    }else if(_refreshing)
    {
        _lastRefreshTime = CFAbsoluteTimeGetCurrent(); //更新刷新时间
        
        for (int i=0; i<self.tempDataArray.count; i++)
        {
            if (self.baseDataArray.count >0) {
                
                [self.baseDataArray removeObjectAtIndex:0];
            }
            
        }
        self.refreshing = NO;
    }
    
    NSLog(@" 请求下来的数据个数 %ld  总数 %ld",(unsigned long)fromNetDataCount,(unsigned long)_baseDataArray.count);
    
    if (fromNetDataCount==0)
    {
        [_baseTableView tableViewDidFinishedLoading];
        [self.baseTableView reloadData];
        //         [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:NO];
        _baseTableView.reachedTheEnd  = YES;
        
        
        if (self.baseDataArray.count==0)
        {
            
            NSLog(@"无数据");
            
            
        }else
        {
//            _baseTableView.reachedTheEnd = YES; // 没有更多数据
        }
        
        
    }else
    {
        
        //   [self.baseTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:NO];
        
        [self.baseTableView reloadData];
        
        [_baseTableView tableViewDidFinishedLoading];
        
        _baseTableView.reachedTheEnd  = NO;
        
    }
    
    // 第一种处理没有更多数据
    if (fromNetDataCount < _numberOfEachPage || fromNetDataCount == 0)
    {
        [self.baseTableView clearFoorView];
    }else
    {
        [self.baseTableView canShowFootView];
    }
    
    // 第二种 处理没有更多数据
    
//    if ((fromNetDataCount < _numberOfEachPage || fromNetDataCount == 0) && self.baseDataArray.count > 0)
//    {
//        [self.baseTableView setReachedTheEnd:YES];
//    }
    
    
    
    
}


//   ing 失败掉的 方法
-(void)failRequest:(NSError *) error{
    
    if (self.dataPage > _firstPage) // 加载 下一页失败 页数 -1
    {
        self.dataPage --;
    }
    
    [_baseTableView tableViewDidFinishedLoading];
    
//    [self.baseTableView reloadData];
    
    //    kCFURLErrorCannotFindHost = -1003, // 找不到服务器
    //    kCFURLErrorCannotConnectToHost = -1004, // 链接不上服务器
    //   kCFURLErrorNotConnectedToInternet = -1009 // 网络断开
    //kCFURLErrorCancelled = -999 取消下载  （operation cancel）
    
    //    if(error.code == -1009)
    //    {
    //        // 网络断开链接
    //    }else if (error.code == -1003 || error.code == - 1004)
    //    {
    //        // 服务器异常
    //    }else if (error.code == -1001)
    //    {
    //        // 网络超时
    //    }else if (error.code == 3848)// 这种情况 是在 开发时 用的 上线时 这种情况不用处理 可以归为网络异常 或别的 上线之后 出现情况 找写接口的那口子  让他改
    //    {
    //        // 转换json 格式错误
    //    }else
    //    {
    //        //
    //        NSLog(@" 未处理 %ld error.code",(long)error.code);
    //    }
    //
    //    // 实际开发 时可能处理的情况 都是几种合在一起的 比如网易新闻  请求失败 都是 网络不给力 一种处理方式
    
}


#pragma mark tableView 代理方法
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baseDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];

    }

    
    return cell;
}



#pragma mark 刷新 加载 代理方法
#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:_baseTableView])
    {
        [_baseTableView tableViewDidScroll:scrollView];
    }
}
// 停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ([scrollView isEqual:_baseTableView]) {
        
        [_baseTableView tableViewDidEndDragging:scrollView];
    }
}

//刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    if (_baseTableView.canRefresh)
    {
        self.refreshing = YES;
        
        _baseTableView.canRefresh=NO;
    
        __weak typeof(self)weakS = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakS requestData];
        });
    }
    
}
//加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    
    if (_baseTableView.canGetMore) {
        
        self.refreshing = NO;
        
        self.isReFreshing = NO;
        
        _baseTableView.canGetMore=NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            __weak typeof(self)weakS = self;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakS requestData];
            });

            
        });
    }
}
// 日期
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    
    return [NSDate date];
    
}


-(void)setRefreshing:(BOOL)refreshing
{
    
    if (refreshing) {
        self.isReFreshing = YES;
    }
    _refreshing = refreshing;
}




@end
