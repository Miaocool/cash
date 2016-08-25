//
//  MDNewsListsScrolView.m
//  MDYNews
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDNewsListsScrolView.h"



#import "MDYSliderViewController.h"

@interface MDNewsListsScrolView()<UIScrollViewDelegate>

@end

@implementation MDNewsListsScrolView
{
    UIScrollView * _scrollView;// 滑动View
    
    CGFloat _maxScrollOffsetx;// 在手指对scrollView进行的一次滑动中 最大的横向偏移量   只要在视觉上能看到 scrollView 向左滑动了 那么再向右就不出现左侧View
    
    
    CGFloat _beforeScrollOffset;// 每次滑动前的 偏移量
    CGFloat _beginScrollDirection;// scrollView 在手指的一次拖动中 刚开始的 拖动的方向 > 0 左滑 < 0 右滑
    
    
    
    
    BOOL _beginChangeScrollOffset;// scrollView 的偏移量 是否 是刚刚开始改变
    
    NSMutableArray * _ListViewArray; //  列表View  加在数组
    
    NSInteger _lastScrollToPage;// 上一次滑到的页面
    
    
    

}

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _ListViewArray = [NSMutableArray array];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.backgroundColor = [UIColor clearColor];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.pagingEnabled = YES;
        
        _scrollView.delegate = self;
        
        [_scrollView.panGestureRecognizer addTarget:self action:@selector(scrollPanGes:)];
        
        _beginScrollDirection = 0;
        
        _beginChangeScrollOffset = YES;
        
        [self addSubview:_scrollView];
        
        
        __weak typeof(_scrollView)weakScroll = _scrollView;
        
        [MDYSliderViewController sharedSliderController].showMiddleVc = ^{
            
            weakScroll.scrollEnabled = YES;
            
        };
        
        
        _lastScrollToPage = 0;
        
        _beforeScrollOffset = 0;
        
        
        __weak typeof(_scrollView)weakScro = _scrollView;
        
        [[MDYSliderViewController sharedSliderController] setShowMiddleVc:^{
            
            weakScro.bounces = YES;
            
        }];
        
        
    }
    
    return self;
}

-(void)loadListsSubview
{
    if (_sumNumber <= 0 || _viewsBlock == nil)
    {
          NSAssert(NO, @" _sumNumber 必须大于 0 , _viewsBlock  必须实现");
    }
    
    for (NSInteger i = 0; i < _sumNumber; i ++)
    {
        UIView * view = _viewsBlock(i);
        
        [_scrollView addSubview:view];
        
        [_ListViewArray addObject:view];
    }
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * _sumNumber, self.frame.size.height);
}


#pragma mark scrollView.panGestureRecognizer 的 相应方法
-(void)scrollPanGes:(UIPanGestureRecognizer *)pan
{    
    NSLog(@"max==%f,Bool %d DDDDD%f",_maxScrollOffsetx,[MDYSliderViewController sharedSliderController].showingLeft ,_beginScrollDirection);
    
    //不是从两边开始 滑动的  不进行下面的调用
    if (_beforeScrollOffset >0 && _beforeScrollOffset < _scrollView.contentSize.width - self.frame.size.width) {
    
        return;
    }

    if(_scrollView.contentSize.width > _scrollView.frame.size.width && ((_beforeScrollOffset == 0 && _beginScrollDirection > 0) || (_beforeScrollOffset == _scrollView.contentSize.width - _scrollView.frame.size.width && _beginScrollDirection < 0)))
    {
        return;
    }

    if (_scrollView.contentOffset.x <= 0 || [MDYSliderViewController sharedSliderController].showingLeft)
    {
        
        [[MDYSliderViewController sharedSliderController] moveViewWithGesture:pan];
        
        _scrollView.contentOffset = CGPointMake(0, _scrollView.contentOffset.y);
        
//        _scrollView.scrollEnabled = NO; // 需要测试
        
        
        if ([MDYSliderViewController sharedSliderController].showingLeft)
        {
//            _scrollView.contentOffset = CGPointMake(0, _scrollView.contentOffset.y);
            
            NSLog(@"左");
            
        } else
        {
            NSLog(@"右");
        }
        
        
        
    }else if(_scrollView.contentOffset.x >= _scrollView.contentOffset.x - _scrollView.frame.size.width || [MDYSliderViewController sharedSliderController].showingRight)
    {
        [[MDYSliderViewController sharedSliderController] moveViewWithGesture:pan];
        
        _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - self.frame.size.width, _scrollView.contentOffset.y);
    }
    
    NSLog(@"============== XXX==%f",_scrollView.contentOffset.x);
}



#pragma mark ScrollView  Deleagte

// 此 方法 在scrollPanGes: 之前 调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollViewDidScrollOnList)// 把 滚动的情况传出去 用做 联动
    {
        _scrollViewDidScrollOnList(scrollView);
    }
    
    
    if (_beginChangeScrollOffset)
    {
        _beginScrollDirection = scrollView.contentOffset.x - _beginScrollDirection; // 刚开始改变偏移量时 记录滑动方向
        
        _beginChangeScrollOffset = NO; // 设为NO 在一次滑动中 只设置一次 停止拖拽并滑动时 再设为 YES
    }
    
    
    if(_maxScrollOffsetx < scrollView.contentOffset.x)
    {
        _maxScrollOffsetx = scrollView.contentOffset.x;
    }
}

// 停止 scrollView 减速代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewEndScrollAndDragged];
}

// 停止拖拽 scrollView 代理方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate) // 停止拖拽 并 停止减速
    {
        [self scrollViewEndScrollAndDragged];
    }else if ( [[MDYSliderViewController sharedSliderController] showingRight] == YES|| [[MDYSliderViewController sharedSliderController] showingLeft] == YES)
    {
        
        scrollView.bounces = NO;
    
    }
}


/**
 *  停止拖拽 并且停止滑动 进行的设置
 */
-(void)scrollViewEndScrollAndDragged
{
    
    _beginScrollDirection = _scrollView.contentOffset.x;
    
    _maxScrollOffsetx = 0;
    
    _beginChangeScrollOffset  = YES;
    
    _beforeScrollOffset = _scrollView.contentOffset.x;
    
    if([[MDYSliderViewController sharedSliderController] showingLeft] || [[MDYSliderViewController sharedSliderController] showingRight])
    {
        return;
    }

    
    
    
    
    //  停止滑动 找出当前滑到的页面
    NSInteger index = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    

    
//    if (_lastScrollToPage == index) // 当前页 滑动到了 当前页 不调用
//    {
//        return;
//    }
    
    [self refRefreshPageView:index];
}

-(void)refRefreshPageView:(NSUInteger )index
{
    UIView * view = _ListViewArray[index];
    
    _lastScrollToPage = index;
    
    if (self.scrollToViewBlock)
    {
        self.scrollToViewBlock(view,index);
    }

    
    NSLog(@"刷新index:::%ld个页面",index);
    
    
}



-(UIView *)getViewFromIndex:(NSInteger)index
{
    
    if (_ListViewArray.count > index)
    {
        return _ListViewArray[index];
    }
    return nil;
}


-(void)scrollToPage:(NSUInteger)index
{
    if (index < 1)
    {
        NSAssert(NO, @" index 必须大于 1");
    }
    
    CGFloat offsetX  = (index - 1) * _scrollView.frame.size.width;
    
    
    // 停止滑动
    if (offsetX >= 0 && offsetX <= _scrollView.contentSize.width - _scrollView.frame.size.width && _scrollView.dragging == NO && _scrollView.decelerating == NO && _scrollView.contentOffset.x != offsetX)
    {
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)animated:NO];
     
        //  停止滑动 找出当前滑到的页面 刷新当前页面
        NSInteger index = offsetX / _scrollView.frame.size.width;
        
        [self refRefreshPageView:index];
        
        _beginScrollDirection = _scrollView.contentOffset.x;
        
        _maxScrollOffsetx = 0;
        
        _beginChangeScrollOffset  = YES;
        
        _beforeScrollOffset = offsetX;
    }
}

-(void)addListView:(UIView *)listView
{
    
    listView.frame = CGRectMake(_ListViewArray.count * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    [_scrollView addSubview:listView];
    
    [_ListViewArray addObject:listView];
    
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width * _ListViewArray.count, self.frame.size.height)];

    
}


-(void)deleteListViewFromIndex:(NSUInteger)index
{
    
    if (_ListViewArray.count > index)
    {
        UIView * currentView = _ListViewArray[index];
        
        [currentView removeFromSuperview];// 要删除的View 移除 父视图
        
        
        [_ListViewArray removeObject:currentView];

        
        if(_lastScrollToPage == index)
        {
            [self scrollToPage:index - 1 + 1]; // 滑动到 上一个页面
        }
        
        
//        return;
        for (NSUInteger i = index; i < _ListViewArray.count; i ++)
        {
            
            UIView * afterView = _ListViewArray[i];
        
            [afterView setCenter:CGPointMake(afterView.center.x - currentView.frame.size.width, afterView.center.y)];
            
        }
        
        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width - currentView.frame.size.width, _scrollView.contentSize.height)];// scrollView  重新适应 listView的个数
        
        [self scrollViewEndScrollAndDragged]; // 初始化 记录状态
        
    }
    else
    {
        NSAssert(NO, @"索引超出界限");
    }
}



-(UIView *)getCurrentView
{
    
    NSUInteger currentIndex = (NSUInteger)_scrollView.contentOffset.x /(NSUInteger) _scrollView.frame.size.width;
    
    if (_ListViewArray.count > currentIndex)
    {
    
        UIView * view = [_ListViewArray objectAtIndex:currentIndex];
        
        return view;
    }
    
    return nil;
    
}



@end
