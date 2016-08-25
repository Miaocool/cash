//
//  PayResultCell.m
//  yyxb
//
//  Created by lili on 15/12/17.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "PayResultCell.h"

@implementation PayResultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}
- (void)createUI{
    _btshopname=[[UIButton alloc]initWithFrame:CGRectMake(10, 10,MSW-30, 20)];
  
    [_btshopname setTitle:@"(第7654期)小米插线板" forState:UIControlStateNormal];
    _btshopname.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
    _btshopname.titleLabel.textAlignment=NSTextAlignmentLeft;
   
    _btshopname.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btshopname.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    
    [_btshopname setTitleColor:[UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self addSubview:_btshopname];
    
    _lbno=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 150, 20)];
    _lbno.text=@"夺宝号码：090099889";
    _lbno.font=[UIFont systemFontOfSize:MiddleFont];
    
    
    _lbqihao=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 150, 20)];
    _lbqihao.text=@"商品期号：090099889";
    _lbqihao.font=[UIFont systemFontOfSize:MiddleFont];
    _lbqihao.textColor=[UIColor grayColor];
    [self addSubview:_lbqihao];
    
    
    
    
    
    _lbno=[[UILabel alloc]initWithFrame:CGRectMake(10, 50,MSW -50, 20)];
    _lbno.text=@"夺宝号码：090099889";
    _lbno.font=[UIFont systemFontOfSize:MiddleFont];
    _lbno.textColor=[UIColor grayColor];
    [self addSubview:_lbno];
    
    _lbcount=[[UILabel alloc]initWithFrame:CGRectMake(MSW-130, 10, 120, 20)];
    _lbcount.text=@"888人次";
    _lbcount.textAlignment=NSTextAlignmentRight;
    _lbcount.font=[UIFont systemFontOfSize:MiddleFont];
    _lbcount.textColor=[UIColor grayColor];
    [self addSubview:_lbcount];
//    
    _btmore=[[UIButton alloc]initWithFrame:CGRectMake(MSW-40, 50, 40, 20)];
    [_btmore setTitle:@"更多" forState:UIControlStateNormal];
    _btmore.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
    _btmore.titleLabel.textAlignment=NSTextAlignmentRight;
    [_btmore setTitleColor:[UIColor colorWithRed:72.0/255.0 green:127.0/255.0 blue:243.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self addSubview:_btmore];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
