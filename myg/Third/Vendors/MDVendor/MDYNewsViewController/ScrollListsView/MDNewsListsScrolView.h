//
//  MDNewsListsScrolView.h
//  MDYNews
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDNewsListsScrolView : UIView


/**
 * 总共的分类数
 */
@property(nonatomic,assign)NSInteger sumNumber;


/**
 *  返回 每个分类的 View
 */
@property(nonatomic,copy)UIView * (^viewsBlock)(NSUInteger index);


/**
 * 滑到这个View
 */
@property(nonatomic,copy)void(^scrollToViewBlock)(UIView * view,NSUInteger index);


/**
 * 滑动的时候调用
 */
@property(nonatomic,copy)void(^scrollViewDidScrollOnList)(UIScrollView * scrollView);




/**
 *  加载 子View
 */
-(void)loadListsSubview;

/**
 * 取得 对应 index 的 View
 */
-(UIView *)getViewFromIndex:(NSInteger)index;


/**
 *  获得当前页
 */
-(UIView *)getCurrentView;

/**
 * 滑动到 对应页 index 从 1 开始
 */
-(void)scrollToPage:(NSUInteger )index;



/**
 * 增加 分类列表View
 */
-(void)addListView:(UIView *)listView;


/**
 *  删除该 索引下得 列表
 */
-(void)deleteListViewFromIndex:(NSUInteger )index;


@end
