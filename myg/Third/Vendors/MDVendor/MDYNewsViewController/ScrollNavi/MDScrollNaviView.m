//
//  MDScrollNaviView.m
//  MDYNews
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDScrollNaviView.h"

#import "MDScrollButton.h"

#import "MDSortBtView.h"

//-- MD_MULTILINE_TEXTSIZE_ScrollNavi  字体内容多少判断label的size
#define MD_MULTILINE_TEXTSIZE_ScrollNavi(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;


/**
 * 让一个数 不超过 两个数之间 如果超过 等于边界的那个数
 */
CG_INLINE NSInteger MDAbs(NSInteger num)
{
    return (num <= 0 ? -num:num);
}



#define MDBtFont 16.

@interface MDScrollNaviView()

/**
 * 正常颜色的 RGB
 */
@property(nonatomic,assign)CGFloat nomalR;

@property(nonatomic,assign)CGFloat nomalG;

@property(nonatomic,assign)CGFloat nomalB;

/**
 * 选中颜色的 RGB
 */
@property(nonatomic,assign)CGFloat selectR;

@property(nonatomic,assign)CGFloat selectG;

@property(nonatomic,assign)CGFloat selectB;

@property(nonatomic,assign)BOOL isAnimating;// 是否正在进行动画

@property(nonatomic,strong)UILabel * topLabel;// 切换频道

@property(nonatomic,strong)CALayer *arrow;


@property(nonatomic,strong)MDSortBtView * sortBtView;


@property(nonatomic,strong) UIButton * deleteButton;

@end

@implementation MDScrollNaviView
{
    UIScrollView * _scrollView;// 滑动View
    
    CGFloat _XX; // 记录 横坐标
    
    CGFloat _spaceTrail; // button 之间的 距离
 
    NSMutableArray * _buttonArray; // 存放buton的数组
    
    CGFloat _scrollDirection;//  绝对值表示每次滑动产生的差异量 正负表示滑动的方向
    
    
    MDScrollButton * _selectButton;// 记录选中的button
    
    UIButton * _rightButton; // 右侧button
    
    UIView * _superView; // 父 View
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _superView = superView;
        
        _buttonArray = [NSMutableArray array];
        
        _scrollDirection = 0;
        
        _isAnimating = NO;
        
        
        _maxShowNum = 24;
        
        CGFloat rightBtWidth = 44;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - rightBtWidth, frame.size.height)];
        
        _scrollView.backgroundColor = [UIColor clearColor];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        
        [self addSubview:_scrollView];
    
        
       
        
        
        
        
        
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        _topLabel.backgroundColor = [self backgroundColor];
        
        _topLabel.font = [UIFont systemFontOfSize:14.];
        
        _topLabel.text = @"   切换栏目";
        
        _topLabel.userInteractionEnabled = YES; // 防止点击topLabel 点到下一层的button
        
        _topLabel.alpha = 0.;
        
        _topLabel.textColor = [UIColor blackColor];
        
        _topLabel.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_topLabel];
        

        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _rightButton.backgroundColor = [UIColor clearColor];
        
        //        [rightButton setImage:[UIImage imageNamed:@"showDownArrow"] forState:UIControlStateNormal];
        
        [_rightButton setFrame:CGRectMake(self.frame.size.width - rightBtWidth, 0 , rightBtWidth, frame.size.height)];
        
        [_rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [self addSubview:_rightButton];
        
        
        _arrow = [CALayer layer];
        
        
        // 给button 加图片
        UIImage * showDownArrowImage = [UIImage imageNamed:@"showDownArrow.png"];
        
        _arrow.frame = CGRectMake(_rightButton.frame.size.width / 2. - showDownArrowImage.size.width / 2., _rightButton.frame.size.height / 2. - showDownArrowImage.size.height / 2., showDownArrowImage.size.width, showDownArrowImage.size.height);
        
        _arrow.contentsGravity = kCAGravityResizeAspect;
        
        _arrow.contents = (id)[UIImage imageWithCGImage:showDownArrowImage.CGImage scale:1 orientation:UIImageOrientationUp].CGImage;
        
        [_rightButton.layer addSublayer:_arrow];
        
        CGFloat sortBtViewHeght =superView.frame.size.height - frame.size.height - frame.origin.y;
        
        _sortBtView = [[MDSortBtView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height , frame.size.width, sortBtViewHeght)];
        
        _sortBtView.hidden = YES;
        
        
        __weak typeof(self)weakSelf = self;
        
        [_sortBtView setTopDeleteBlock:^(NSUInteger index) {
            [weakSelf deleteAction:index];
        }];
        
        
        [superView addSubview:_sortBtView];
        
        // 删除button
        [self initDeleteButton];
        
    }
    return self;
}


-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
//    [_topLabel setBackgroundColor:backgroundColor];
}
#pragma mark 加载子view

-(void)loadScollNaviSubview
{
    
    
    // 添加频道 设置
    
    _sortBtView.sumNumber = _sumNumber;
    
    
    __weak typeof(self)weakS = self;
    
    [_sortBtView setTitlesBlock:^NSString *(NSUInteger index) {
       
        if (weakS.titlesBlock)
        {
            return weakS.titlesBlock(index);
        }
        return @"";
        
    }];
    
    _sortBtView.canAddNum = _canAddNum;
    
    
    _sortBtView.maxShowNum = _maxShowNum;
    
    [_sortBtView setTitlesBlockForCanAdd:^NSString *(NSUInteger index) {
     
        if (weakS.titlesBlockForCanAdd) {
            return weakS.titlesBlockForCanAdd(index);
        }
        return @"";
    }];
    
    if (_alertBlockWhenMaxNum)
    {
        [_sortBtView setAlertBlockWhenMaxNum:_alertBlockWhenMaxNum];
    }

    
    [_sortBtView setTopButtonBlock:^(NSUInteger index) {
       
        [weakS sortBtViewTopButtonAction:index];
        
    }];
    
    [_sortBtView setCloseSortBlock:^{
      
        [weakS rightAction:nil];
    }];
    
    [_sortBtView setBottomButtonBlock:^(NSUInteger index) {
        
        if (weakS.bottomButtonBlock)
        {
             weakS.bottomButtonBlock(index);
        }
    }];
    
    
    
    [_sortBtView loadSubButtonView];
    
    _XX = 20; // 第一个button的横坐标
    
    _spaceTrail = 20;
    
    
    if (_sumNumber <= 0 || _titlesBlock == nil)
    {
        NSAssert(NO, @" _sumNumber 必须大于 0 , _titlesBlock  必须实现");
    }
    
    
    for (int i = 0; i < _sumNumber ; i ++)
    {
        
        NSString * title = _titlesBlock(i);
        
        // 根据 分类的标题 确定需要的占据的 宽度
        CGSize size = MD_MULTILINE_TEXTSIZE_ScrollNavi(title, [UIFont systemFontOfSize:MDBtFont], CGSizeMake(1000, self.frame.size.height), 0);
        
        MDScrollButton * button = [self creatButtonWithFrame:CGRectMake(_XX, 0, size.width, self.frame.size.height) text:title];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:MDBtFont]];
        
        if (i == 0)
        {
            button.selectMDBt = YES;
            
            _selectButton  = button;
        }
        
        [_scrollView addSubview:button];
        
        [_buttonArray addObject:button];
        
        _XX += size.width + _spaceTrail;
    }
    
    _scrollView.contentSize = CGSizeMake(_XX, self.frame.size.height);
    
    if (_XX < _scrollView.frame.size.width)
    {
        _scrollView.bounces = NO;
    }
}

#pragma mark sortBtView 点击事件
-(void)sortBtViewTopButtonAction:(NSUInteger )index
{
    
    MDScrollButton * button = [_buttonArray objectAtIndex:index];
    
    [self buttonAction:button];
    
}


#pragma mark  button   相关
// 因为涉及到 增加和删除分类 用 tag 做标记  每次的增加删除 都需要重新计算tag 值 所以 弃用 根据 数组的 接口 来查找 是第几个
-(MDScrollButton *)creatButtonWithFrame:(CGRect)frame text:(NSString *)text
{
    MDScrollButton * button = [MDScrollButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:frame];
    
    [button setTitle:text forState:UIControlStateNormal];
    
    [button setButtonNomalColorR:_nomalR G:_nomalG B:_nomalB];
    
    [button setButtonSelectColorR:_selectR G:_selectG B:_selectB];
    
    button.backgroundColor = [UIColor clearColor];
    
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return button;
}


-(void)rightAction:(UIButton *)button
{
    NSLog(@" scrollNavi 右侧按钮点击事件 ");
    
    
    if (_isAnimating)
    {
        return;
    }
    
    [_superView bringSubviewToFront:_sortBtView];
    
    _isAnimating = YES;
    
    __weak typeof(self)weakS = self;
    
    
    if (_topLabel.alpha == 1.0)
    {
        
        
        
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.5];
        _arrow.transform = CATransform3DIdentity;
        [CATransaction commit];

        
        [UIView animateWithDuration:.3 animations:^{
            
            weakS.topLabel.alpha = 0.;
            
            weakS.deleteButton.alpha = 0.0;
            
            
        } completion:^(BOOL finished) {
            
            
        }];
    
        [weakS.sortBtView hideCompletion:^(BOOL finished) {
            
            weakS.isAnimating = NO;
            
        }];

        
    }else
    {
        
        if ([_deleteButton.titleLabel.text isEqualToString:@"完成" ]) // 如果是在 删除状态 那么 调用该方法 退出删除状态
        {
            [self deleteStateAction:_deleteButton];
        }

        
        
        // button  图片翻转
                [CATransaction begin];
                [CATransaction setAnimationDuration:.5];
                    _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                [CATransaction commit];
        
        
        [weakS.sortBtView showCompletion:^(BOOL finished) {
            
            weakS.isAnimating = NO;
            
            
        }];

        //  点击选择频道
        [UIView animateWithDuration:.3 animations:^{
            
            weakS.topLabel.alpha = 1.;
            
            weakS.deleteButton.alpha = 1.;
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        
        

    }
}


-(void)buttonAction:(MDScrollButton *)button
{
    
    
    NSUInteger tag = [_buttonArray indexOfObject:button] + 1;

    NSUInteger indexSelect = [_buttonArray indexOfObject:_selectButton];
    

    if(![_selectButton isEqual:button])
    {
    
        NSInteger gapIndex = tag - 1 - indexSelect;
        
       
        if (MDAbs(gapIndex) > 1)
        {
            [_selectButton setSelectMDBt:NO];
           
        }
        
        NSLog(@" 绝对值 %ld 选中button 是 第%ld个 将要选中button是 第%ld个",MDAbs(gapIndex),[_buttonArray indexOfObject:_selectButton],[_buttonArray indexOfObject:button]);
        
    }
    
    _selectButton = button;
    
    _selectButton.selectMDBt = YES;
    
    
    NSLog(@"点击了 第 %ld 几个 button",(unsigned long)tag );
    

    

    if(self.buttonActionBlock)
    {
        self.buttonActionBlock(tag);
    }
    
    // 使点击的分类 显示 在 中间
    CGFloat offsetX = button.center.x - _scrollView.frame.size.width / 2.;
    
    [self scrollToOffsetX:offsetX];// 滑动 到 该 偏移量
}



-(void)scrollToCategoryFormIndex:(NSUInteger )Index
{
    if (_buttonArray.count > Index)
    {
        MDScrollButton * button = _buttonArray[Index];
     
        _selectButton = button;
        // 滑动 以 适应选中的分类
        CGFloat offsetX = button.center.x - _scrollView.frame.size.width / 2.;
        
        [self scrollToOffsetX:offsetX];// 滑动 到 该 偏移
        
    }
}

-(void)scrollToOffsetX:(CGFloat )offsetX
{
    if (offsetX < 0 )
    {
        if (_scrollView.contentOffset.x != 0)
        {
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
        
        
    }else if(offsetX > _scrollView.contentSize.width - _scrollView.frame.size.width )
    {
        if (_scrollView.contentOffset.x != _scrollView.contentSize.width - _scrollView.frame.size.width) {
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0) animated:YES];
            
        }
        
        
    }else if(_scrollView.contentOffset.x != offsetX)
    {
        
        
        [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    

}



#pragma mark 和列表的联动
-(void)scrollListDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width)// 超出屏幕的滑动数据 不要
    {
        return;
    }
    
    
    NSLog(@"=()()()()()()()=%f==%f",scrollView.contentOffset.x,scrollView.contentSize.width - scrollView.frame.size.width);

    
    _scrollDirection = scrollView.contentOffset.x - _scrollDirection;// 每次移动 差生的 差异量

    CGFloat widthScale; // button width(宽度的比例)
    
    MDScrollButton * nextButton; // 即将移动到的button
    
    MDScrollButton * beforeButton;// 前一个button
    
    //每个列表相对的偏移量
    CGFloat offsetXForListView ;
    
    if (_scrollDirection > 0) // 左滑
    {
        
        // 计算 width 的变化比例
        
        
        NSUInteger nextButtonIndex = (NSUInteger)scrollView.contentOffset.x / (NSUInteger)scrollView.frame.size.width + 1;
        
        offsetXForListView =(NSUInteger)scrollView.contentOffset.x % (NSUInteger)scrollView.frame.size.width;
        
    
        if ((NSUInteger)scrollView.contentOffset.x % (NSUInteger)scrollView.frame.size.width == 0) // 宽度的整数倍时 nextButton 是当前选中Button
        {
            offsetXForListView = scrollView.frame.size.width;
            
            nextButtonIndex --;
        }
        
        
        widthScale =  offsetXForListView/scrollView.frame.size.width;

    
        if(_buttonArray.count > nextButtonIndex)
        {
            nextButton =  [_buttonArray objectAtIndex:nextButtonIndex];

            [nextButton setPlusTransformScale:widthScale];

        }
        
        
        if (_buttonArray.count > nextButtonIndex - 1)
        {
            beforeButton = [_buttonArray objectAtIndex:nextButtonIndex - 1];

            [beforeButton setPlusTransformScale:1-widthScale];
        }
        
    }else // 右滑
    {

        
        NSUInteger nextButtonIndex = (NSUInteger)scrollView.contentOffset.x / (NSUInteger)self.frame.size.width;

        offsetXForListView = scrollView.frame.size.width - (NSUInteger)scrollView.contentOffset.x % (NSUInteger)scrollView.frame.size.width;

        
        // 计算 width 的变化比例
        widthScale =  offsetXForListView/scrollView.frame.size.width;

        
        if (_buttonArray.count > nextButtonIndex)
        {
            nextButton =  [_buttonArray objectAtIndex:nextButtonIndex];

            NSLog(@"右滑倍数==%f buttonIndex= %ld ",widthScale,(unsigned long)nextButtonIndex);
            
            [nextButton setPlusTransformScale:widthScale];
        }
        
        if (_buttonArray.count > nextButtonIndex + 1)
        {
            beforeButton = [_buttonArray objectAtIndex:nextButtonIndex + 1];
            
            [beforeButton setPlusTransformScale:1-widthScale];
        }
    }
    _scrollDirection = scrollView.contentOffset.x;
}


-(void)setButtonNomalColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
    _nomalR = r;
    
    _nomalG = g;
    
    _nomalB = b;
}

-(void)setButtonSelectColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
    _selectR = r;
    
    _selectG = g;
    
    _selectB = b;
}


-(void)addButtonWithTitle:(NSString *)title
{
    // 根据 分类的标题 确定需要的占据的 宽度
    CGSize size = MD_MULTILINE_TEXTSIZE_ScrollNavi(title, [UIFont systemFontOfSize:MDBtFont], CGSizeMake(1000, self.frame.size.height), 0);
    
    MDScrollButton * button = [self creatButtonWithFrame:CGRectMake(_XX, 0, size.width, self.frame.size.height) text:title];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:MDBtFont]];
    

    [_scrollView addSubview:button];
    
    [_buttonArray addObject:button];
    
    _XX += size.width + _spaceTrail;


_scrollView.contentSize = CGSizeMake(_XX, self.frame.size.height);

}


-(void)setAlertBlockWhenMaxNum:(void (^)())alertBlockWhenMaxNum
{
    if (_sortBtView)
    {
        [_sortBtView setAlertBlockWhenMaxNum:alertBlockWhenMaxNum];
    }
    _alertBlockWhenMaxNum = alertBlockWhenMaxNum;
}


#pragma mark 删除按钮 相关


-(void)initDeleteButton
{
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_deleteButton setFrame:CGRectMake(self.frame.size.width - 100, _topLabel.frame.size.height / 2 - 10, 45, 20)];
    
//    [deleteButton setCenter:CGPointMake(deleteButton.center.x, self.center.y)];
    
    _deleteButton.layer.cornerRadius = 10;
    
    _deleteButton.layer.borderColor = [UIColor redColor].CGColor;
    
    _deleteButton.layer.borderWidth = .5;
    
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [_deleteButton setBackgroundColor:[UIColor clearColor]];
    
    [_deleteButton setAlpha:0.0];
    
    [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12.]];
    
    [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_deleteButton addTarget:self action:@selector(deleteStateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_deleteButton];
    
}


// 进入删除状态
-(void)deleteStateAction:(UIButton *)button
{
    
    if ([button.titleLabel.text isEqualToString:@"删除"])
    {
        NSLog(@"进入删除状态");
        
        [_sortBtView setCanDelete:YES];
        
        [button setTitle:@"完成" forState:UIControlStateNormal];
        
    }else
    {
        [button setTitle:@"删除" forState:UIControlStateNormal];
        
        [_sortBtView setCanDelete:NO];
    }
    NSLog(@"");
    
}

// 删除 该索引的 类别
-(void)deleteAction:(NSUInteger)index
{
    
    if (_buttonArray.count > index)
    {
        if(_topDeleteBlock)
        {
            _topDeleteBlock(index);
        }
        
        
       MDScrollButton * button = [_buttonArray objectAtIndex:index];

        //  如果删除的是 选中的button
        if ([_selectButton isEqual:button])
        {
            if (_buttonArray.count > index - 1)
            {
                MDScrollButton * beforeButton = [_buttonArray objectAtIndex:index - 1];
                
                [beforeButton setSelectMDBt:YES]; // 前一个button 设为 选中
                
            }else
            {
                NSAssert(NO, @"index 超出界限");
            }
        }
        
        
        [button removeFromSuperview];// 移除button
        
        [_buttonArray removeObject:button]; // 数组里 移除button
        
        CGFloat deleteX = button.frame.size.width + _spaceTrail;
        
        for (NSUInteger i = index;i < _buttonArray.count ; i ++)
        {
            UIButton * afterButton = [_buttonArray  objectAtIndex:i];
            
            
            [afterButton setCenter:CGPointMake(afterButton.center.x - deleteX, afterButton.center.y)];
            
        }

        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width - deleteX, _scrollView.contentSize.height)]; // ContentSize 适应新的button个数
        
    }else
    {
        NSAssert(NO, @"index 超出界限");
    }
    
   
    
    
    
    
    
    
}




@end
