//
//  MDSortBtView.h
//  MDYNews
//
//  Created by Medalands on 15/3/6.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSortBtView : UIView


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
 *   点击 切换button 事件
 */
@property(nonatomic,copy)void(^topButtonBlock)(NSUInteger index);

/**
 *   点击添加 button 事件
 */

@property(nonatomic,copy)void(^bottomButtonBlock)(NSUInteger index);


@property(nonatomic,copy)void(^closeSortBlock)();

/**
 *  频道添加满了 则调用
 */
@property(nonatomic,copy)void(^alertBlockWhenMaxNum)();

/**
 * YES 进入 删除状态  NO  退出删除状态
 */
@property(nonatomic,assign)BOOL canDelete;



/**
 *   点击删除 button 事件
 */
@property(nonatomic,copy)void(^topDeleteBlock)(NSUInteger index);


/**
 * 出现则隐藏  隐藏则出现
 */
-(void)showOrHide;

/**
 *  出现
 */
-(void)showCompletion:(void(^)(BOOL finished))completion;
/**
 * 隐藏
 */
-(void)hideCompletion:(void(^)(BOOL finished))completion;
/**
 * 加载subView
 */
-(void)loadSubButtonView;





@end
