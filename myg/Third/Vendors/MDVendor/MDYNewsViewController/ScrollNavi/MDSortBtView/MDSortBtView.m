//
//  MDSortBtView.m
//  MDYNews
//
//  Created by Medalands on 15/3/6.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#define IPhone4_5_6_6P_MDSortBtView(a,b,c,d) (CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) ?(a) :(CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) ? (b) : (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) ?(c) : (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) ?(d) : 0))))


#import "MDSortBtView.h"

#import "MDSortButton.h"

#import "MDYSliderViewController.h"

@implementation MDSortBtView
{
    
    UILabel * _bottomLabel; // 点击添加频道

    UIScrollView * _bottomScrollView; // 可以添加的分类在 scrollView  上
    
    
    CGFloat _topXX; // 记录 上部 横坐标
    
    CGFloat _topYY; // 记录 上部 横坐标
    
    CGFloat _bottomXX; // 记录 下部 横坐标
    
    CGFloat _bottomYY; // 记录 下部 横坐标
    
    NSMutableArray * _topButtonArray;
    
    NSMutableArray * _bottomButtonArray;
    

    BOOL _show; // 是否已经出现
    
    UIView * _bottomBackGroundView; //  点击添加频道一下的 视图都加到这个view
    
    
    NSUInteger _perRowNum;// 每行多少个button
    
    CGFloat _spaceTrail;// button  横向之间的距离
    
    CGFloat _spaceBottom;// button  纵向向之间的距离
    
    CGFloat  _buttonWidth;// button  的宽度
    
    CGFloat _buttonHeight;// button 的高度
    
    CGFloat _beginXX;// 开始布局的xx 坐标
    
    CGFloat  _beginYY;//// 开始布局的yy 坐标
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _show = NO;
        
        _topButtonArray = [NSMutableArray array];
        
        _bottomButtonArray = [NSMutableArray array];
        
        
        self.backgroundColor = [UIColor clearColor];
        
        _bottomBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height)];
        
        _bottomBackGroundView.backgroundColor = [UIColor colorWithRed:1. green:1. blue:1. alpha:.8];
        
        [self addSubview:_bottomBackGroundView];
        
        self.clipsToBounds = YES;
        
        NSLog(@"FRAME=====%@ -- %f",NSStringFromCGRect(self.frame),[UIScreen mainScreen].bounds.size.height);
        
        
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _bottomBackGroundView.frame = CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height);
    
}

-(void)loadSubButtonView
{
    
     _beginXX = 15.;// 开始布局的 横坐标
    
    _beginYY = 20;// 开始布局的纵坐标
    
     _buttonWidth = IPhone4_5_6_6P_MDSortBtView(60, 60, 70,75); // button 宽度
    
     _buttonHeight = IPhone4_5_6_6P_MDSortBtView(30, 30, 30, 30); // button 高度
    
    _perRowNum = 4;
    
   _spaceTrail = (self.frame.size.width - _beginXX * 2 - _buttonWidth * _perRowNum) / (_perRowNum - 1);
    
    _spaceBottom = IPhone4_5_6_6P_MDSortBtView(15, 15, 20, 20);
    
    NSString * title = @"";

    
    for (int i = 0; i <  _sumNumber; i ++)
    {
        _topXX = _beginXX + (_buttonWidth + _spaceTrail) * (i % 4);
        
        _topYY = _beginYY +(_spaceBottom + _buttonHeight) * (i / _perRowNum);
        
        if (_titlesBlock)
        {
            title = _titlesBlock(i);
        }
        
        MDSortButton * button = [self creatButtonWithFrame:CGRectMake(_topXX , _topYY , _buttonWidth, _buttonHeight) title:title];
        
        
        [button setTitle:title forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(topButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomBackGroundView addSubview:button];
        
        if (i == 0)
        {
            [button removeDeleteButton];
        }
        
        [_topButtonArray addObject:button];
    }
    
    

    
    _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _topYY + _buttonHeight + _spaceBottom, self.frame.size.width, 30)];

    _bottomLabel.backgroundColor = [UIColor lightGrayColor];
    
    _bottomLabel.font = [UIFont systemFontOfSize:14.];

    
    _bottomLabel.text = @"   点击添加频道";
    
    [_bottomBackGroundView addSubview:_bottomLabel];
    
    
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _bottomLabel.frame.origin.y + _bottomLabel.frame.size.height, self.frame.size.width, self.frame.size.height -_bottomLabel.frame.origin.y - _bottomLabel.frame.size.height )];
    
    
    _bottomScrollView.backgroundColor = [UIColor clearColor];
    
    [_bottomBackGroundView addSubview:_bottomScrollView];
    
    NSString * bottomButtonTitle ;
    
    for (int i = 0; i < _canAddNum; i ++)
    {
        _bottomXX = _beginXX + (_buttonWidth + _spaceTrail) * (i % 4);
        
        _bottomYY = _beginYY +(_spaceBottom + _buttonHeight) * (i / _perRowNum);
        
        if (_titlesBlockForCanAdd)
        {
            bottomButtonTitle = _titlesBlockForCanAdd(i);
        }
        
         UIButton * button = [self creatButtonWithFrame:CGRectMake(_bottomXX , _bottomYY , _buttonWidth, _buttonHeight) title:bottomButtonTitle];

        [button addTarget:self action:@selector(bottomButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomScrollView addSubview:button];
        
        [_bottomButtonArray addObject:button];
        
    }
    
    
    _bottomScrollView.contentSize  = CGSizeMake(_bottomScrollView.frame.size.width, _bottomYY + _buttonHeight);
    
    
}

#pragma mark 点击上方button

-(void)topButtonsAction:(MDSortButton *)button
{
    
    if (button.canDelete)
    {
        return;
    }
    
    NSUInteger index = [_topButtonArray indexOfObject:button];
    
    
    if (_topButtonArray.count <= index)
    {        
        NSAssert(NO, @"数组超出界限");
    }
    
    
    NSLog(@"点击了上部的第%lu个button ",index + 1);

    
    if (_topButtonBlock)
    {
        _topButtonBlock(index);
    }
    
    if (_closeSortBlock)
    {
        _closeSortBlock();
    }
    
}

#pragma mark 点击下方button

-(void)bottomButtonsAction:(UIButton *)button
{
    
    if (_topButtonArray.count >= _maxShowNum) //  如果超出最大数量
    {
        
        if (self.alertBlockWhenMaxNum)
        {
            self.alertBlockWhenMaxNum();
        }else
        {
            [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已经添加满了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
        
        return;
    }

    
    NSUInteger index = [_bottomButtonArray indexOfObject:button];
    
    if (_bottomButtonBlock)
    {
        _bottomButtonBlock(index);
    }
    
    
    
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+ _bottomScrollView.contentOffset.y + _bottomScrollView.frame.origin.y, button.frame.size.width, button.frame.size.height);
    
    [_bottomBackGroundView addSubview:button];
    
    [_topButtonArray addObject:button];
    
    [_bottomButtonArray removeObject:button];
    
    [button removeTarget:self action:@selector(bottomButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self action:@selector(topButtonsAction:) forControlEvents:UIControlEventTouchUpInside];

    
    _topXX = _beginXX + (_buttonWidth + _spaceTrail) * ((_topButtonArray.count - 1) % 4);
    
    _topYY = _beginYY +(_spaceBottom + _buttonHeight) * ((_topButtonArray.count - 1) / _perRowNum);

    
    [UIView animateWithDuration:.3 animations:^{
     
        
        
        for (NSUInteger i = index; i < _bottomButtonArray.count; i ++)
        {
            _bottomXX = _beginXX + (_buttonWidth + _spaceTrail) * (i % 4);
            
            _bottomYY = _beginYY +(_spaceBottom + _buttonHeight) * (i / _perRowNum);
            
            UIButton * bottomButton = [_bottomButtonArray objectAtIndex:i];

            [bottomButton setFrame:CGRectMake(_bottomXX , _bottomYY , _buttonWidth, _buttonHeight)];
            
            
        }
        
       
        
        button.frame = CGRectMake(_topXX , _topYY , _buttonWidth, _buttonHeight);
        
        CGFloat bottomLYY = _topYY + _buttonHeight + _spaceBottom;
        
        if (_bottomLabel.frame.origin.y != bottomLYY)
        {
            _bottomLabel.frame = CGRectMake(0, bottomLYY, self.frame.size.width, 30);

            
            _bottomScrollView.frame =  CGRectMake(0, _bottomLabel.frame.origin.y + _bottomLabel.frame.size.height, self.frame.size.width, self.frame.size.height -_bottomLabel.frame.origin.y - _bottomLabel.frame.size.height );
            
            _bottomScrollView.contentSize  = CGSizeMake(_bottomScrollView.frame.size.width, _bottomYY + _buttonHeight);

            
            
        }
        

        
    }];
    
    
    NSLog(@"点击了下部的第%lu个button ",index + 1);
}


-(void)showOrHide
{
    
}


-(void)showCompletion:(void(^)(BOOL finished))completion
{
    
    [MDYSliderViewController sharedSliderController] .canShowLeft= NO;
    
    [MDYSliderViewController sharedSliderController] .canShowRight= NO;
    
    self.hidden = NO;
    
    __weak typeof(_bottomBackGroundView)weakBottom = _bottomBackGroundView;
    
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:.6 animations:^{
        
        weakBottom.transform = CGAffineTransformMakeTranslation(0, _bottomBackGroundView.frame.size.height);

        
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion(finished);
        }
        
         weakSelf.userInteractionEnabled = YES;
        
    }];
    

}



-(void)hideCompletion:(void(^)(BOOL finished))completion
{
    [MDYSliderViewController sharedSliderController] .canShowLeft= YES;
    
    [MDYSliderViewController sharedSliderController] .canShowRight= YES;
    
    self.userInteractionEnabled = NO;
    
    __weak typeof(_bottomBackGroundView)weakBottom = _bottomBackGroundView;
    
    __weak typeof(self)weakS = self;
    
    [UIView animateWithDuration:.6 animations:^{
        
        weakBottom.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion(finished);
            
            weakS.hidden = YES;
        }
        
    }];

    
}


-(MDSortButton *)creatButtonWithFrame:(CGRect )frame title:(NSString *)title
{
    
    MDSortButton * button = [MDSortButton buttonWithType:UIButtonTypeSystem];
    
    [button setFrame:frame];
    
    button.layer.cornerRadius = IPhone4_5_6_6P_MDSortBtView(15, 15, 15, 15);
    
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    button.layer.borderWidth = .5;
    
    [button setBackgroundColor:[UIColor whiteColor]];

    [button.titleLabel setFont:[UIFont systemFontOfSize:IPhone4_5_6_6P_MDSortBtView(14, 14, 16, 16)]];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    __weak typeof(self)weakS = self;
    
    [button setDeleteAction:^(MDSortButton * button) {
    
        [weakS deleteButtonAction:button];
    }];
    
    
    return button;
}


#pragma mark 删除相关


-(void)deleteButtonAction:(MDSortButton *)button
{
    NSUInteger index = [_topButtonArray indexOfObject:button];
    
    if (_topDeleteBlock)
    {
        _topDeleteBlock(index);
    }
    
      [_topButtonArray removeObject:button];
    
    for (NSUInteger i = index; i < _topButtonArray.count; i ++)
    {
 
        _topXX = _beginXX + (_buttonWidth + _spaceTrail) * (i % 4);
        
        _topYY = _beginYY +(_spaceBottom + _buttonHeight) * (i / _perRowNum);
        
        
        UIButton *  tButton = [_topButtonArray objectAtIndex:i];
        
        [tButton addTarget:self action:@selector(topButtonsAction:) forControlEvents:UIControlEventTouchUpInside];

        
        __weak typeof(tButton)weakTb = tButton;
        [UIView animateWithDuration:.3 animations:^{
           
            [weakTb setFrame:CGRectMake(_topXX , _topYY , _buttonWidth, _buttonHeight)];

            
        }];
        
       

        
    
        
    }
    
    
    
  
    
    [_bottomButtonArray addObject:button];
    
    
    
    
    //  重新布置  点击添加频道的frame Frame
    
    
    if(_bottomLabel.frame.origin.y != _topYY + _buttonHeight + _spaceBottom)
    {
        _bottomLabel.frame =CGRectMake(0, _topYY + _buttonHeight + _spaceBottom, self.frame.size.width, 30);
        
        
        
        _bottomScrollView.frame =CGRectMake(0, _bottomLabel.frame.origin.y + _bottomLabel.frame.size.height, self.frame.size.width, self.frame.size.height -_bottomLabel.frame.origin.y - _bottomLabel.frame.size.height );
    }

    
    
    
   
    NSUInteger i = _bottomButtonArray.count - 1;
    
    _bottomXX = _beginXX + (_buttonWidth + _spaceTrail) * (i % 4);
        
    _bottomYY = _beginYY +(_spaceBottom + _buttonHeight) * (i / _perRowNum);
    
    
    
    [button setFrame:CGRectMake(_bottomXX , _bottomYY , _buttonWidth, _buttonHeight)];
        
    [button addTarget:self action:@selector(bottomButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        
    [_bottomScrollView addSubview:button];
    
    [button setCanDelete:NO];

    _bottomScrollView.contentSize  = CGSizeMake(_bottomScrollView.frame.size.width, _bottomYY + _buttonHeight);

    
}



-(void)setCanDelete:(BOOL)canDelete
{
    
    if (canDelete)
    {
        
        [self canDeleteButton];
        
    }else
    {
        [self cannotDeleteButton];
    }
    
    
    _canDelete = canDelete;
}


-(void)canDeleteButton
{
    
    
    _bottomLabel.hidden = YES;
    
    _bottomScrollView.hidden = YES;
    
    for (int i = 0;i < _topButtonArray.count; i ++)
    {
    MDSortButton * button = [_topButtonArray objectAtIndex:i];
        
        button.canDelete = YES;
        
    }
    

    
}

-(void)cannotDeleteButton
{
    
    _bottomLabel.hidden = NO;
    
    _bottomScrollView.hidden = NO;
    
    for (int i = 0;i < _topButtonArray.count; i ++)
    {
        MDSortButton * button = [_topButtonArray objectAtIndex:i];
        
        button.canDelete = NO;
        
    }

}







@end
