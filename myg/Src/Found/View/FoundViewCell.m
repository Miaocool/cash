//
//  FoundViewCell.m
//  yyxb
//
//  Created by lili on 15/11/18.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "FoundViewCell.h"

@implementation FoundViewCell
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
    
    self.iamgefound=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 50, 50)];
    
    self.iamgefound.backgroundColor=[UIColor clearColor];
    [self addSubview:self.iamgefound];
    
    self.lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(80, 15, MSW-100, 30)];
    self.lbtitle.text=@"晒单分享";
    self.lbtitle. font=[UIFont systemFontOfSize:BigFont];
    self.lbtitle.textColor=[UIColor blackColor];
    [self addSubview:self.lbtitle];
    
    self.lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(80, 40, 200, 30)];
    self.lbdetail.text=@"没错，就是我中的！来咬我啊";
    self.lbdetail. font=[UIFont systemFontOfSize:MiddleFont];
    self.lbdetail.textColor=[UIColor grayColor];
    [self addSubview:self.lbdetail];
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
