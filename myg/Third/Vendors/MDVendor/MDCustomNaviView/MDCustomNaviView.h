//
//  MDCustomNaviView.h
//  MDYNews
//
//  Created by Medalands on 15/3/3.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCustomNaviView : UIImageView

@property(nonatomic,strong)UIView * titleView;

/**
 * 和系统 navi 所占大小 保持一致
 */
+(instancetype)creatWithDefaultFrame;

/**
 * 左侧 自定义方法
 */
-(UIButton *)setCustomNaviLeftBarButtonItemImageWithController:(UIViewController *)controller action:(SEL)sel  tag:(NSInteger)tag imageName:(NSString *)imageName;


/**
 * 右侧 自定义方法
 */
-(UIButton *)setCustomNaviRightBarButtonItemImageWithController:(UIViewController *)controller action:(SEL)sel  tag:(NSInteger)tag imageName:(NSString *)imageName;




@end
