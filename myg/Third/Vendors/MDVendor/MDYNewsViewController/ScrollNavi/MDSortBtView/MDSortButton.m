//
//  MDSortButton.m
//  MDYNews
//
//  Created by Medalands on 15/3/10.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSortButton.h"

@interface MDSortButton()

@property(nonatomic,strong)UIButton * deleteButton;

@end

@implementation MDSortButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(id)buttonWithType:(UIButtonType)buttonType
{
    MDSortButton * button = [super buttonWithType:buttonType];
    
    button.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button.deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    
    [button.deleteButton setBackgroundColor:[UIColor lightGrayColor]];
    
    [button.deleteButton setFrame:CGRectMake(-1, -1, 13, 13)];
    
    [button.deleteButton addTarget:button action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.deleteButton.layer.cornerRadius = 8.;
    
    [button addSubview:button.deleteButton];
    
    button.canDelete = NO;
    
    return button;
}


-(void)deleteAction:(UIButton *)button
{
    if (self.deleteAction)
    {
        self.deleteAction(self);
    }
    NSLog(@"点击删除");
}


-(void)setCanDelete:(BOOL)canDelete
{
    if (canDelete)
    {
        self.deleteButton.hidden = NO;
    }else
    {
        self.deleteButton.hidden = YES;
    }
    
    _canDelete = canDelete;
}

-(void)removeDeleteButton
{
    
    [self.deleteButton removeFromSuperview];
    self.deleteButton = nil;
    
}

@end
