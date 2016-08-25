//
//  UserAddressCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/16.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "UserAddressCell.h"
#import "MyLable.h"


@interface UserAddressCell()
{
    UIView         *_bgView;
    NSString       *_default;

}


@end

@implementation UserAddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}




- (void)createUI
{
    self.contentView.backgroundColor = RGBCOLOR(240, 239, 241);
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MSW, 175)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    UIImageView * topImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MSW, 5)];
    topImg.image = [UIImage imageNamed:@"pic_address_stripe"];
    [_bgView addSubview:topImg];
    
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
    _iconImg.image = [UIImage imageNamed:@"pic_address_local_blue"];
    [_bgView addSubview:_iconImg];
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(_iconImg.right +5, 10, 130, 30)];
    _lbTitle.textColor = FontBlue;
    _lbTitle.text =@"";
    _lbTitle.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:_lbTitle];
    
    //状态
    self.stateButton = [[UIButton alloc] initWithFrame: CGRectMake(_lbTitle.right, 10, 30, 25)];
    self.stateButton.backgroundColor = RGBCOLOR(209, 18, 59);
    [self.stateButton setTitle:@"默认" forState:UIControlStateNormal];
    [self.stateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.stateButton.layer.cornerRadius = 5;
    self.stateButton.layer.masksToBounds = YES;
    self.stateButton.titleLabel.font = [UIFont boldSystemFontOfSize:MiddleFont];
    [_bgView addSubview:self.stateButton];
    
    
    _editButton = [[UIButton alloc] initWithFrame:CGRectMake(MSW - 10 -50, 10, 50, 30)];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_editButton addTarget:self action:@selector(changeController) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_editButton];
    
    //分割线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, _iconImg.bottom +5, MSW -30, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_bgView addSubview:line];
    
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, line.bottom +5, MSW -30, 20)];
    self.nameLabel.text = @"易哥";
    self.nameLabel.textColor=[UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:BigFont];
    [_bgView addSubview:self.nameLabel];
    
    //电话
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,_nameLabel.bottom +5,MSW -30, 20)];
    self.phoneLabel.text = @"1888888888";
    self.phoneLabel.font = [UIFont systemFontOfSize:BigFont];
    [_bgView addSubview:self.phoneLabel];
    
    
    
    //地址
    self.proviceLabel = [[MyLable alloc]initWithFrame:CGRectMake(15,_phoneLabel.bottom+5 ,MSW -30,20)];
    self.proviceLabel.text = @"北京市宣武区姚家井小区";
    self.proviceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.proviceLabel.font = [UIFont systemFontOfSize:BigFont];
    [self.proviceLabel setVerticalAlignment:VerticalAlignmentTop];
    self.proviceLabel.numberOfLines = 2;
    [_bgView addSubview:self.proviceLabel];
    
    
    //备注
    self.remarkLabel = [[MyLable alloc]initWithFrame:CGRectMake(60, _proviceLabel.bottom + 5, MSW - 45-30, 20)];
    self.remarkLabel.font = [UIFont systemFontOfSize:BigFont];
    self.remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.remarkLabel setVerticalAlignment:VerticalAlignmentTop];
    self.remarkLabel.numberOfLines = 0;
    self.remarkLabel.textColor = [UIColor blackColor];
    [_bgView addSubview:self.remarkLabel];

    
    
    
}
- (void)changeController{
    
    if ([self.delegate respondsToSelector:@selector(changController:)]) {
        [self.delegate changController:self];
    }
}


-(void)setAddressModel:(AddressDto *)addressModel{
    
    _addressModel = addressModel;
    
    NSDictionary* style3 = @{@"body" :
                                 @[RGBCOLOR(150, 150, 150)],
                             @"u": @[[UIColor blackColor]]};
    
    if (!IsStrEmpty(self.addressModel.sheng)) {

        
        _iconImg.image = [UIImage imageNamed:@"pic_address_local_blue"];
        
        _lbTitle.text = @"实物收货地址";
        
        self.nameLabel.attributedText = [[NSString stringWithFormat:@"收货人：<u>%@</u>",addressModel.shouhuoren]attributedStringWithStyleBook:style3] ;
        
        self.phoneLabel.attributedText = [[NSString stringWithFormat:@"联系方式：<u>%@</u>",addressModel.mobile]attributedStringWithStyleBook:style3];
        
        self.proviceLabel.text= [NSString stringWithFormat:@"%@%@%@%@",addressModel.sheng,addressModel.shi,addressModel.xian,addressModel.jiedao];
        
        if (IsStrEmpty(addressModel.remark)) {
            self.remarkLabel.text = @"";
        }else{
            self.remarkLabel.text = addressModel.remark;
        }
        
        
        
        CGSize size = [self.proviceLabel.text sizeWithFont:[UIFont systemFontOfSize:BigFont] constrainedToSize:CGSizeMake(MSW -30,300) lineBreakMode:NSLineBreakByCharWrapping];
        
        CGSize size2 = [self.remarkLabel.text sizeWithFont:[UIFont systemFontOfSize:BigFont] constrainedToSize:CGSizeMake(MSW -30,300) lineBreakMode:NSLineBreakByCharWrapping];
        
        
        UILabel * lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(15, _phoneLabel.bottom + 5, 75, 15)];
        lbAddress.font = [UIFont systemFontOfSize:BigFont];
        lbAddress.text = @"收货地址：";
        lbAddress.textColor = RGBCOLOR(150, 150, 150);
        [_bgView addSubview:lbAddress];
        
        self.proviceLabel.frame = CGRectMake(lbAddress.right,_phoneLabel.bottom+5 ,MSW -lbAddress.width-30, size.height + 3 );
        
        UILabel * lbRemark = [[UILabel alloc] initWithFrame:CGRectMake(15, _proviceLabel.bottom + 5, 45, 15)];
        lbRemark.font = [UIFont systemFontOfSize:BigFont];
        lbRemark.text = @"备注：";
        lbRemark.textColor = RGBCOLOR(150, 150, 150);
        [_bgView addSubview:lbRemark];
        
        self.remarkLabel.frame = CGRectMake(lbRemark.right, _proviceLabel.bottom +5 , MSW -lbRemark.width - 30, size2.height +5);
        
        _bgView.frame = CGRectMake(0, 10, MSW, 140 + size2.height +5);
  
        
    }
    else if (!IsStrEmpty(self.addressModel.qq)){
        
        _lbTitle.text = @"充值账号";
        _lbTitle.textColor = RGBCOLOR(253, 121, 32);
        
        _iconImg.image = [UIImage imageNamed:@"icon_phone_chongzhi"];

        
        self.nameLabel.attributedText = [[NSString stringWithFormat:@"手机号：<u>%@</u>",addressModel.mobile]attributedStringWithStyleBook:style3];
        
        self.phoneLabel.attributedText = [[NSString stringWithFormat:@"QQ号码：<u>%@</u>",addressModel.qq]attributedStringWithStyleBook:style3];
        
        CGSize size = [addressModel.remark sizeWithFont:[UIFont systemFontOfSize:BigFont] constrainedToSize:CGSizeMake(MSW -30,300) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel * lbRemark = [[UILabel alloc] initWithFrame:CGRectMake(15, _phoneLabel.bottom + 5, 45, 15)];
        lbRemark.font = [UIFont systemFontOfSize:BigFont];
        lbRemark.text = @"备注：";
        lbRemark.textColor = RGBCOLOR(150, 150, 150);
        [_bgView addSubview:lbRemark];
        
        self.proviceLabel.frame = CGRectMake(lbRemark.right,_phoneLabel.bottom+5 ,MSW-lbRemark.width -30, size.height +5);
        self.proviceLabel.numberOfLines = 0;
        self.proviceLabel.text = addressModel.remark;
        
        _bgView.frame = CGRectMake(0, 10, MSW, 105 + size.height +5);

    }
    else if (!IsStrEmpty(self.addressModel.game_name)){
        
        _iconImg.image = [UIImage imageNamed:@"icon_game_chongzhi"];

        _lbTitle.text = @"游戏充值";
        _lbTitle.textColor = RGBCOLOR(28, 207, 151);

        
        self.nameLabel.attributedText = [[NSString stringWithFormat:@"联系方式：<u>%@</u>",addressModel.mobile]attributedStringWithStyleBook:style3];
        
        self.phoneLabel.attributedText = [[NSString stringWithFormat:@"游戏名称：<u>%@</u>",addressModel.game_name] attributedStringWithStyleBook:style3];
        
        self.proviceLabel.attributedText = [[NSString stringWithFormat:@"所在区/服：<u>%@</u>",addressModel.game_zone]attributedStringWithStyleBook:style3];
        
        UILabel * game_zoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.proviceLabel.bottom + 5,MSW - 30, 20)];
        game_zoneLabel.attributedText = [[NSString stringWithFormat:@"游戏账号：<u>%@</u>",addressModel.game_number]attributedStringWithStyleBook:style3];
        game_zoneLabel.font = [UIFont systemFontOfSize:BigFont];
        [_bgView addSubview:game_zoneLabel];
        
        UILabel * game_nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,game_zoneLabel.bottom + 5, MSW - 30, 20)];
        game_nicknameLabel.attributedText = [[NSString stringWithFormat:@"游戏昵称：<u>%@</u>",addressModel.game_nickname]attributedStringWithStyleBook:style3];
        game_nicknameLabel.font = [UIFont systemFontOfSize:BigFont];
        [_bgView addSubview:game_nicknameLabel];
        
        CGSize size = [addressModel.remark sizeWithFont:[UIFont systemFontOfSize:BigFont] constrainedToSize:CGSizeMake(MSW -30,300) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel * lbRemark = [[UILabel alloc] initWithFrame:CGRectMake(15, game_nicknameLabel.bottom + 5, 45, 15)];
        lbRemark.font = [UIFont systemFontOfSize:BigFont];
        lbRemark.text = @"备注：";
        lbRemark.textColor = RGBCOLOR(150, 150, 150);
        [_bgView addSubview:lbRemark];
       
        MyLable * remarkLabel = [[MyLable alloc]initWithFrame:CGRectMake(lbRemark.right, game_nicknameLabel.bottom + 5, MSW - lbRemark.width-30, size.height + 5)];
        
        remarkLabel.numberOfLines = 0;
        remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [remarkLabel setVerticalAlignment:VerticalAlignmentTop];
        remarkLabel.text = addressModel.remark;
        remarkLabel.font = [UIFont systemFontOfSize:BigFont];
        [_bgView addSubview:remarkLabel];
        
        _bgView.frame = CGRectMake(0, 10, MSW, 180+size.height + 5);

        
    }else{
        
    }
    
    
    
    _default=addressModel.moren;
    if ([_default isEqualToString:@"Y"]) {
        self.stateButton.hidden = NO;
        
    }else if ([_default isEqualToString:@"N"]){
        self.stateButton.hidden = YES;
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
