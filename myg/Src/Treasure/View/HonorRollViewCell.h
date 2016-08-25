//
//  HonorRollViewCell.h
//  myg
//
//  Created by lili on 16/3/28.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HonorRollViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imghead1;
@property (nonatomic, strong) UILabel *lbtitle1;
@property (nonatomic, strong) UILabel *lbname1;
@property (nonatomic, strong) UILabel *lbcanyu1;


@property (nonatomic, strong) UIImageView *imghead2;
@property (nonatomic, strong) UILabel *lbtitle2;
@property (nonatomic, strong) UILabel *lbname2;
@property (nonatomic, strong) UILabel *lbcanyu2;

@property (nonatomic, strong) UIImageView *imghead3;
@property (nonatomic, strong) UILabel *lbtitle3;
@property (nonatomic, strong) UILabel *lbname3;
@property (nonatomic, strong) UILabel *lbcanyu3;

@property (nonatomic, strong) UIButton *btguize;

@property (nonatomic, copy) NSArray *honorArray;

@property (nonatomic, strong) UIButton *user1;

@property (nonatomic, strong) UIButton *user2;

@property (nonatomic, strong) UIButton *user3;


@end
