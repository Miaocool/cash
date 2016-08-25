//
//  MDHeadView.h
//  QQ分组抽屉效果
//
//  Created by Medalands on 15/1/28.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDHeadView;

@protocol MDHeadViewDelegate <NSObject>
-(void)selectdWith:(MDHeadView *)view;
@end

@interface MDHeadView : UIView<MDHeadViewDelegate>
@property(nonatomic,weak)id<MDHeadViewDelegate> delegate;
@property(nonatomic,assign)NSUInteger section;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton*zhankai;

@property(nonatomic,strong) UILabel*lbcount;
@end
