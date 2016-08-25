//
//  UIAlertView+MDAdditions.h
//  MDYNews
//
//  Created by Medalands on 15/3/4.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);


@interface UIAlertView (MDAdditions)

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;

+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...;


@end
