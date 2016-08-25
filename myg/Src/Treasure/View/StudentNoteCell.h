//
//  StudentNoteCell.h
//  kl1g
//
//  Created by lili on 16/2/18.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentNoteCell : UITableViewCell
@property (nonatomic, strong) UILabel *lbname;

@property (nonatomic, strong) UILabel *lbtime;

@property (nonatomic, strong) UIImageView *imguser;

@property (nonatomic, strong) UILabel *lbstatu;

@property (nonatomic, strong)UIProgressView* progressView;

@end
