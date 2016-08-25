//
//  UserAddressViewController.h
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"
#import "PassValueDelegate.h"

@interface UserAddressViewController : MaiViewController<PassValueDelegate>

@property (nonatomic, assign) id<PassValueDelegate>  delegate;
@property (nonatomic, strong) NSString       *index;


@end
