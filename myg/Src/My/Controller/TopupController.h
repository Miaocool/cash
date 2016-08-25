//
//  TopupController.h
//  yyxb
//
//  Created by lili on 15/11/19.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "MaiViewController.h"
#import "RechargeDto.h"
@interface TopupController : MaiViewController
{
    
    UITapGestureRecognizer *singleRecognizer;
}
@property(nonatomic,strong)RechargeDto *model;
@end
