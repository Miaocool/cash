//
//  GameViewController.h
//  yydz
//
//  Created by mac02 on 16/4/22.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "MaiViewController.h"
#import "PassValueDelegate.h"

@interface GameViewController : MaiViewController
@property (nonatomic, assign) id<PassValueDelegate>  delegate;
@property (nonatomic, strong) NSString       *index;
@property (nonatomic, copy) NSString * status;
@end
