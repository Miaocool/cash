//
//  HomeViewController.h
//  yyxb
//
//  Created by 杨易 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"

@interface HomeViewController : MaiViewController
@property (nonatomic, strong) NSTimer                               *topImageChangeTimer;
@property (nonatomic,assign) int ms;
@property (nonatomic,assign) int minutes;
@property (nonatomic,assign) int seconds;

@property (nonatomic,assign) int ms2;
@property (nonatomic,assign) int minutes2;
@property (nonatomic,assign) int seconds2;

@property (nonatomic,assign) int ms3;
@property (nonatomic,assign) int minutes3;
@property (nonatomic,assign) int seconds3;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,weak) NSTimer *timer2;
@property (nonatomic,weak) NSTimer *timer3;

- (void)httpGetAwardTip;

@end
