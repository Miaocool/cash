//
//  TopUpViewCell.m
//  yyxb
//
//  Created by lili on 15/11/19.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "TopUpViewCell.h"

@implementation TopUpViewCell
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
    
    self.imgefound=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    
//    self.imgefound.image=[UIImage imageNamed:@"choose2-2"];
    [self addSubview:self.imgefound];
    
    self.lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 180, 30)];
//    self.lbtitle.backgroundColor=[UIColor greenColor];

    [self addSubview:self.lbtitle];
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
