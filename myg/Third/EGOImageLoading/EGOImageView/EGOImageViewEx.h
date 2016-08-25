//
//  EGOImageViewEx.h
//  RabbitTiger
//
//  Created by Chenxi Cai on 14-10-29.
//  Copyright (c) 2014年 RabbitTiger. All rights reserved.
//

#import "EGOImageView.h"

@protocol EGOImageViewExDelegate;

@interface EGOImageViewEx : EGOImageView {

	id <EGOImageViewExDelegate> __unsafe_unretained exDelegate_;
    
}

@property (nonatomic, unsafe_unretained) id <EGOImageViewExDelegate> exDelegate;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;


@end



@protocol EGOImageViewExDelegate <NSObject>
@optional
- (void)imageExViewDidOk:(EGOImageViewEx *)imageViewEx;
@end
