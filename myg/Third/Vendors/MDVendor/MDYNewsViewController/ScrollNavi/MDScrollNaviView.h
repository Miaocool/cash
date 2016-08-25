//
//  MDScrollNaviView.h
//  MDYNews
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDScrollNaviView : UIView

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;

/**
 * 可以显示的分类数
 */
@property(nonatomic,assign)NSUInteger sumNumber;

/**
 * 可以添加的分类数
 */
@property(nonatomic,assign)NSUInteger canAddNum;


/**
 *  最多可以显示的分类数 默认 24
*/
@property(nonatomic,assign)NSUInteger maxShowNum;


/**
 *  返回 每个可以显示的分类的标题
 */
@property(nonatomic,copy)NSString * (^titlesBlock)(NSUInteger index);


/**
 *  返回 每个不可以添加的分类的标题
 */
@property(nonatomic,copy)NSString * (^titlesBlockForCanAdd)(NSUInteger index);


/**
 *   点击添加 button 事件
 */
@property(nonatomic,copy)void(^bottomButtonBlock)(NSUInteger index);




/**
 * 点击 每个分类
 */
@property(nonatomic,copy)void(^buttonActionBlock)(NSUInteger tag);


/**
 *  频道添加满了 则调用
 */
@property(nonatomic,copy)void(^alertBlockWhenMaxNum)();


/**
 *   点击删除 分类 事件 index 0 开始
 */
@property(nonatomic,copy)void(^topDeleteBlock)(NSUInteger index);



/**
 *  加载 子View
 */
-(void)loadScollNaviSubview;

/**
 * 列表的 scrollview  在滚动的时候 调用这个方法 并传入 scrollview
 */
-(void)scrollListDidScroll:(UIScrollView *)scrollView;


/**
 *   设置正常字体颜色
 */
-(void)setButtonNomalColorR:(CGFloat )r G:(CGFloat)g B:(CGFloat)b;

/**
 *   设置选中字体颜色
 */
-(void)setButtonSelectColorR:(CGFloat )r G:(CGFloat)g B:(CGFloat)b;


/**
 * 使选中得分类 显示在中间
 */
-(void)scrollToCategoryFormIndex:(NSUInteger )Index;


/**
 * 增加 分类bt title
 */
-(void)addButtonWithTitle:(NSString *)title;

@end
