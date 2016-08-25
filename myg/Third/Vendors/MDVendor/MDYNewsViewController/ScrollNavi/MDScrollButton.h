//
//  MDScrollButton.h
//  MDYNews
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDScrollButton : UIButton

/**
 * YES 选中状态  NO 正常状态
 */
@property(nonatomic,assign)BOOL selectMDBt;


/**
 *   要增加的 改变量
 */
-(void)setPlusTransformScale:(CGFloat)pScale;

/**
 *   最大的增加量
 */
-(void)setMaxPlusScale;

/**
 *  正常的 大小
 */
-(void)setNomalScale;


/**
 *   设置正常字体颜色
 */
-(void)setButtonNomalColorR:(CGFloat )r G:(CGFloat)g B:(CGFloat)b;

/**
 *   设置选中字体颜色
 */
-(void)setButtonSelectColorR:(CGFloat )r G:(CGFloat)g B:(CGFloat)b;

/**
 * 设置 为 正常颜色
 */
-(void)setNomalTitleColor;

/**
 * 设置为 选中颜色
 */
-(void)setSelectTitleColor;




@end
