//
//  MDScrollButton.m
//  MDYNews
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//


// 颜色 rgb
#define RGBCOLOR_scrolBT(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#import "MDScrollButton.h"

/**
 * 让一个数 不超过 两个数之间 如果超过 等于边界的那个数
 */
CG_INLINE CGFloat setNumAtMiddleMD(CGFloat num,CGFloat sideNuma,CGFloat sideNumb)
{
    
    num = (sideNuma > sideNumb ? (num > sideNuma ? sideNuma:(num < sideNumb  ? sideNumb :num)) : (num > sideNumb ? sideNumb:(num < sideNuma  ? sideNuma :num) ));
    
    return num;
}

@interface MDScrollButton()

@property(nonatomic,assign)CGFloat maxPlus;// 最大 增加的倍数

@property(nonatomic,assign)CGFloat scale;// 初始倍数

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


@end

@implementation MDScrollButton
{
    // 正常颜色和选中颜色之间的差距
    CGFloat _rGap;
    
    CGFloat _gGap;
    
    CGFloat _bGap;
    
    
    // 移动中 RGB 的值
    
    CGFloat _r;
    
    CGFloat _g;
    
    CGFloat _b;

}

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _scale = 1.0;
        
        _maxPlus = .3;
                
    }
    return self;
}

-(void)setPlusTransformScale:(CGFloat)pScale
{
    // 设置 放大缩小
    
    NSLog(@">>>>>>>>>>>>>%f",pScale);
    
    _scale = 1.0 + _maxPlus * pScale;
    
    if (_scale < 1.0)
    {
        _scale = 1.0;
    }else if (_scale > 1.0 + _maxPlus)
    {
        _scale = 1.0 + _maxPlus;
    }
    self.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    
    // 设置字体颜色
    
    
    _r = _nomalR + _rGap * pScale;
    
    
    _r = setNumAtMiddleMD(_r, _nomalR, _selectR);
    
    _g = _nomalG +  _gGap * pScale;
    
    _g = setNumAtMiddleMD(_g, _nomalG, _selectG);
    
    _b  = _nomalB + _bGap * pScale;
    
    _b = setNumAtMiddleMD(_b, _nomalB, _selectB);
    
    [self setTitleColor:RGBCOLOR_scrolBT(_r, _g, _b) forState:UIControlStateNormal];
}


-(void)setMaxPlusScale
{
    self.transform = CGAffineTransformMakeScale(1.0 + _maxPlus, 1.0 + _maxPlus);
}

-(void)setNomalScale
{
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
}


+(id)buttonWithType:(UIButtonType)buttonType
{
    MDScrollButton * button = [super buttonWithType:buttonType];
    
    button.scale = 1.0;
    
    button.maxPlus = .3;

    return button;
}


-(void)setButtonNomalColorR:(CGFloat )r G:(CGFloat)g B:(CGFloat)b
{
    _nomalR = r;
    
    _nomalG = g;
    
    _nomalB = b;
    
    
    _r = _nomalR;
    
    _g = _nomalG;
    
    _b = _nomalB;
    
    [self setTitleColor:RGBCOLOR_scrolBT(r, g, b) forState:UIControlStateNormal];
}


-(void)setButtonSelectColorR:(CGFloat )r G:(CGFloat)g B:(CGFloat)b
{
    _selectR = r;
    
    _selectG = g;
    
    _selectB = b;
    
    
    _rGap =  _selectR - _nomalR;
    
    _gGap =  _selectG - _nomalG;
    
    _bGap =  _selectB - _nomalB;
    
}

-(void)setNomalTitleColor
{
    
    [self setTitleColor:RGBCOLOR_scrolBT(_nomalR, _nomalG, _nomalB) forState:UIControlStateNormal];
}

-(void)setSelectTitleColor
{
    [self setTitleColor:RGBCOLOR_scrolBT(_selectR, _selectG, _selectB) forState:UIControlStateNormal];
}


-(void)setSelectMDBt:(BOOL)selectMDBt
{
        if (selectMDBt)
        {
            
             [self setSelectTitleColor];
            
            [UIView animateWithDuration:.3 animations:^{
                
               [self setMaxPlusScale];
                
            }];
            
           
            
        }else
        {
             [self setNomalTitleColor];
            
            [UIView animateWithDuration:.3 animations:^{
                
                [self setNomalScale];
                
            }];

           
        }
        _selectMDBt = selectMDBt;
   
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
