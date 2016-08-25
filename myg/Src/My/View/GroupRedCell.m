//
//  GroupRedCell.m
//  yyxb
//
//  Created by mac03 on 15/11/24.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "GroupRedCell.h"

@interface GroupRedCell(){
    UIView        *_bgView;
    
    UIImageView   *_LeftImgView;
    UILabel                    *_titleLab;     //名字
    UILabel                    *_timeLab;     //时间
    UILabel                    *_moneyLab;       //状态
}

@end

@implementation GroupRedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithHex:@"#F8F8F8"];
        
        [self initSta];
        
    }
    return self;
}

-(void)initSta
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _LeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    _LeftImgView.backgroundColor = [UIColor clearColor];
    _LeftImgView.contentMode = UIViewContentModeScaleAspectFill;
    _LeftImgView.layer.cornerRadius=10;
    _LeftImgView.image=[UIImage imageNamed:@"4-2"];
    _LeftImgView.clipsToBounds = YES;
    _LeftImgView.userInteractionEnabled=YES;
    [_bgView addSubview:_LeftImgView];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, 5, 100, 20)];
    _titleLab.text=@"苑";
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:BigFont];
    [_bgView addSubview:_titleLab];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5,_titleLab.bottom+5, 100, 20)];
    _timeLab.text=@"11-19 20：38";
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textColor = [UIColor blackColor];
    _timeLab.font = [UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_timeLab];

}


-(void)setGroupRedDto:(GroupRedDto *)dto
{
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
