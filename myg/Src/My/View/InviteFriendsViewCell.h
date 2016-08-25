//
//  InviteFriendsViewCell.h
//  myg
//
//  Created by lidan on 16/7/8.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsModel;

@interface InviteFriendsViewCell : UITableViewCell
@property (nonatomic, strong) UILabel * lbID;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UILabel *lbNickname;
@property (nonatomic, strong) UIView * line2;
@property (nonatomic, strong) UILabel *lbTime;
@property (nonatomic, strong) UIView * line3;
@property (nonatomic, strong) UILabel *lbJifen;

-(void)setModel:(FriendsModel *)model;
-(void)setRankingModel:(FriendsModel*)model;
@end
