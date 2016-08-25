//
//  HeadlineScrollview.h
//  yyxb
//
//  Created by mac03 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyDto.h"

@protocol HeadlineScrollviewDelegate <NSObject>
-(void)selectHeadline:(NotifyDto *)dto;

@end

@interface HeadlineScrollview : UIView

@property(nonatomic, assign) id<HeadlineScrollviewDelegate>     delegate;

-(void)setHeadlineView:(NSMutableArray *)headlineArray;
-(void)changeHeadlinePage;
-(void)updateError;

@end
