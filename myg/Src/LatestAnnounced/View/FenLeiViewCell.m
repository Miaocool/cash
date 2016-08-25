//
//  FenLeiViewCell.m
//  myg
//
//  Created by lili on 16/3/24.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "FenLeiViewCell.h"

@implementation FenLeiViewCell
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
    
    
    _imgview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
//    _imgview.backgroundColor=MainColor;
    _imgview.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imgview];
    _title=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 90, 30)];
    _title.textColor=[UIColor grayColor];
    _title.font=[UIFont systemFontOfSize:MiddleFont];
    [self addSubview:_title];





}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
