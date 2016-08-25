//
//  AwardTipView.h
//  hlyyg
//
//  Created by liwenzhi on 16/6/12.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CloseTipViewDelegate <NSObject>

- (void)showTipView;

@end

@interface AwardTipView : UIView

/** 期数 */
@property (nonatomic, strong) UILabel  *periodLbl;
/** 奖品 */
@property (nonatomic, strong) UILabel  *awardLbl;
/** 查看 */
@property (nonatomic, strong) UIButton *lookBtn;
/** 分享 */
@property (nonatomic, strong) UIButton *shareBtn;


@property (nonatomic, weak)id <CloseTipViewDelegate> delegate;

- (void)show;

- (void)hidden;

@end
