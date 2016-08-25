//
//  HeadlineScrollview.m
//  yyxb
//
//  Created by mac03 on 15/11/30.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "HeadlineScrollview.h"

@interface HeadlineScrollview()<UIScrollViewDelegate>{
    CGFloat         _width;
    CGFloat         _height;
    
    NSInteger         _currentPage;
    NSInteger         _totalPage;
    NSInteger         _num;
    
    NSMutableArray    *_headlineArray;   //获取数组
    NSMutableArray    *_imgsArray;
    UILabel           *_noHeadlinelabel;
}

@property (nonatomic, strong) UIScrollView             *headScrollView;      //头条滚动新闻
@end


@implementation HeadlineScrollview
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 1;
        _headlineArray = [NSMutableArray array];
        _imgsArray = [NSMutableArray array];
        _width = frame.size.width;
        _height = frame.size.height;
        if ([_headlineArray count] == 0 || IsArrEmpty(_headlineArray)) {
            _noHeadlinelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
            _noHeadlinelabel.text = @"暂无信息";
            _noHeadlinelabel.textAlignment = NSTextAlignmentCenter;
            _noHeadlinelabel.textColor =RGBCOLOR(88, 89, 90);
            _noHeadlinelabel.font = [UIFont systemFontOfSize:MiddleFont];
            [self addSubview:_noHeadlinelabel];
        }
        
    }
    return self;
}

-(void)updateError{
    _headScrollView.hidden = YES;
    _noHeadlinelabel.hidden = NO;
}

-(void)setHeadlineView:(NSMutableArray *)headlineArray{
    _headlineArray = headlineArray;
    if (IsArrEmpty(_headlineArray) || !_headlineArray) {
        return;
    }
    _currentPage = 1;
    _totalPage = [_headlineArray count];
    
    NSArray *subViews = [_headScrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (!_headScrollView) {
        _headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        _headScrollView.contentSize = CGSizeMake(_width, 3 * _height);
        _headScrollView.showsHorizontalScrollIndicator = false;
        _headScrollView.showsVerticalScrollIndicator = false;
        _headScrollView.pagingEnabled = YES;
        /////////////////////////////////
        _headScrollView.delegate = self;
        [self addSubview:_headScrollView];
    }
    [self refreshHeadlineData];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _num = scrollView.contentOffset.y / 35;
    DebugLog(@"x = %f",scrollView.contentOffset.x);
    DebugLog(@"y = %f",scrollView.contentOffset.y);
}

-(void)refreshHeadlineData{
    NSArray *subViews = [_headScrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_currentPage];
    
    if ([_imgsArray count] == 0 || IsArrEmpty(_imgsArray)) {
        _noHeadlinelabel.hidden = NO;
        _headScrollView.hidden = YES;
        return;
    }
    _noHeadlinelabel.hidden = YES;
    _headScrollView.hidden = NO;
    
    for (int i = 0; i < 3; i++) {   //图片宽度40
        //恭喜label
        UILabel *gongxi=[[UILabel alloc]initWithFrame:CGRectMake(45, 1 + i * _height, 25, _height)];
        gongxi.text=@"恭喜";
        gongxi.textColor=RGBCOLOR(88, 89, 90);
        gongxi.font=[UIFont systemFontOfSize:MiddleFont];
        gongxi.backgroundColor=[UIColor clearColor];
        [_headScrollView addSubview:gongxi];
        
        //昵称label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(gongxi.right, 1 + i * _height, 50, _height)];
        label.backgroundColor = [UIColor clearColor];
        NotifyDto *dto = [_imgsArray objectAtIndex:i];
//      DebugLog(@"%@,%@",_imgsArray[i],dto.title);
        label.text = dto.username;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = MainColor;
        label.font = [UIFont systemFontOfSize:MiddleFont];
        //高度固定不折行，根据字的多少计算label的宽度
        NSString *str = label.text;
        CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
//        DebugLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        [label setFrame:CGRectMake(gongxi.right, 1 + i * _height, size.width, _height)];
        label.text = str;
        [_headScrollView addSubview:label];
        
        //获得期数
        UILabel *numberLab=[[UILabel alloc]initWithFrame:CGRectMake(label.right, 1 + i * _height, 50, _height)];
        numberLab.text=[NSString stringWithFormat:@"获得第[%@期]",dto.qishu];
//        numberLab.text=@"获得第[100期]";
        numberLab.textColor=RGBCOLOR(88, 89, 90);
        numberLab.textAlignment = NSTextAlignmentLeft;
        numberLab.font=[UIFont systemFontOfSize:MiddleFont];
        //高度固定不折行，根据字的多少计算label的宽度
        NSString *str1 = numberLab.text;
        CGSize size1 = [str1 sizeWithFont:numberLab.font constrainedToSize:CGSizeMake(MAXFLOAT, numberLab.frame.size.height)];
        //        DebugLog(@"size.width=%f, size.height=%f", size.width, size.height);
        //根据计算结果重新设置UILabel的尺寸
        [numberLab setFrame:CGRectMake(label.right, 1 + i * _height, size1.width, _height)];
        numberLab.text = str1;
        [_headScrollView addSubview:numberLab];
        
        //标题label
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(numberLab.right, 1 + i * _height, _width-170, _height)];
        label2.backgroundColor = [UIColor clearColor];
        NotifyDto *dto2 = [_imgsArray objectAtIndex:i];
        label2.text = dto2.title;
        label2.textAlignment = NSTextAlignmentLeft;
        label2.textColor = RGBCOLOR(88, 89, 90);
        label2.font = [UIFont systemFontOfSize:MiddleFont];
        [_headScrollView addSubview:label2];
        
        //点击事件
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 1 + i * _height, _width-80, _height)];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(headlineTouch) forControlEvents:UIControlEventTouchUpInside];
        [_headScrollView addSubview:btn];
    }
    
}

//点击头条代理
-(void)headlineTouch{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeadline:)]) {
        if (_imgsArray!=nil ||_num!=0) {
//          DebugLog(@"!!!!!%ld",_num);
            NotifyDto *dto = [_imgsArray objectAtIndex:_num];
//            DebugLog(@"dto!!!=================%@",dto);
            [self.delegate selectHeadline:dto];
        }
        
    }
}

- (NSArray *)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:_currentPage-1];
    NSInteger last = [self validPageValue:_currentPage+1];
    
    if([_imgsArray count] != 0)
    {
        [_imgsArray removeAllObjects];
    }
    
    [_imgsArray addObject:[_headlineArray objectAtIndex:pre-1]];
    [_imgsArray addObject:[_headlineArray objectAtIndex:_currentPage-1]];
    [_imgsArray addObject:[_headlineArray objectAtIndex:last-1]];
    return _imgsArray;
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == 0) value = _totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == _totalPage + 1) value = 1;
    
    return value;
}

-(void)changeHeadlinePage{
    if (_currentPage == _totalPage) {
        _currentPage = 1;
    }else{
        _currentPage ++;
    }
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35f];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [_headScrollView.layer addAnimation:animation forKey:nil];
    
    if (IsArrEmpty(_headlineArray) || !_headlineArray ) {
        return;
    }
    
    [self refreshHeadlineData];
}





@end
