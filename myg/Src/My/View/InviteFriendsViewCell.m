//
//  InviteFriendsViewCell.m
//  myg
//
//  Created by lidan on 16/7/8.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import "InviteFriendsViewCell.h"
#import "FriendsModel.h"

@implementation InviteFriendsViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}

-(void)createUI{
    
    self.lbID = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, MSW/4 - 20 -0.5, 30)];
    self.lbID.text = @"ID";
    self.lbID.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.lbID.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lbID];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(self.lbID.right, 0, 0.5, self.height)];
    self.line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.line];
    
    self.lbNickname = [[UILabel alloc] initWithFrame:CGRectMake(self.line.right, 5, MSW/4 +30 -0.5, 30)];
    self.lbNickname.text = @"昵称";
    self.lbNickname.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.lbNickname.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lbNickname];
    
    self.line2 = [[UIView alloc] initWithFrame:CGRectMake(self.lbNickname.right, 0, 0.5, self.height)];
    self.line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.line2];
    
    self.lbTime= [[UILabel alloc] initWithFrame:CGRectMake(self.line2.right, 5, MSW/4 +5 - 0.5, 30)];
    self.lbTime.text = @"日期";
    self.lbTime.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.lbTime.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lbTime];
    
    self.line3 = [[UIView alloc] initWithFrame:CGRectMake(self.lbTime.right, 0, 0.5, self.height)];
    self.line3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.line3];
    
    self.lbJifen= [[UILabel alloc] initWithFrame:CGRectMake(self.line3.right, 5, MSW/4 -0.5 - 15, 30)];
    self.lbJifen.text = @"积分";
    self.lbJifen.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(13, 15, 16, 16)];
    self.lbJifen.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lbJifen];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom - 1, MSW, 1)];
    bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:bottomLine];
    
}

-(void)setModel:(FriendsModel *)model{
    self.lbID.text = model.uid;
    self.lbJifen.text = model.score;
    self.lbNickname.text = model.userName;
    self.lbTime.text = model.time;
}

-(void)setRankingModel:(FriendsModel*)model{
    
    self.lbID.frame = CGRectMake(0, 5, MSW/4 - 30 -0.5, 30);
    self.line.frame = CGRectMake(self.lbID.right, 0, 0.5, self.height);
    self.lbNickname.frame = CGRectMake(self.line.right, 5, MSW/4 - 20 -0.5, 30);
    self.line2.frame = CGRectMake(self.lbNickname.right, 0, 0.5, self.height);
    self.lbTime.frame = CGRectMake(self.line2.right, 5, MSW/4 +30 -0.5, 30);
    self.line3.frame = CGRectMake(self.lbTime.right, 0, 0.5, self.height);
    self.lbJifen.frame = CGRectMake(self.line3.right, 5, MSW/4 + 20 - 0.5, 30);

    self.lbNickname.text = model.uid;
    self.lbTime.text = model.userName;
    self.lbJifen.text = model.friendsCount;
}

@end
