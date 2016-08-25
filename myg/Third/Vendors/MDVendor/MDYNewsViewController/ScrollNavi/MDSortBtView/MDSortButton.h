//
//  MDSortButton.h
//  MDYNews
//
//  Created by Medalands on 15/3/10.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSortButton : UIButton

@property(nonatomic,copy)void(^deleteAction)(MDSortButton *button);

@property(nonatomic,assign)BOOL canDelete;


-(void)removeDeleteButton;

@end
