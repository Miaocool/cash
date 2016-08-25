//
//  OrdershareViewCell.m
//  yyxb
//
//  Created by lili on 15/11/13.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "OrdershareViewCell.h"

@implementation OrdershareViewCell
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
    self.userhead = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.userhead.backgroundColor = [UIColor clearColor];
    self.userhead.layer.masksToBounds = YES;
    self.userhead.layer.cornerRadius = 25;
    [self addSubview:self.userhead];
    
    self.username=[[UIButton alloc]initWithFrame:CGRectMake(80, 10, MSW-210, 30)];
    [self.username setTitle:@"奥特曼" forState:UIControlStateNormal];
    [self.username setTitleColor:[UIColor colorWithRed:106.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1] forState:UIControlStateNormal];
    _username.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _username.contentEdgeInsets = UIEdgeInsetsMake(0,-5, 0, 0);
    _username.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [self addSubview:self.username];
    //    _username.backgroundColor=[UIColor greenColor];
    
    self.background=[[UIImageView alloc]initWithFrame:CGRectMake(60, 40,  [UIScreen mainScreen].bounds.size.width-70, IPhone4_5_6_6P(135, 135, 155, 165))];
    self.background.backgroundColor=[UIColor clearColor];
    self.background.image=[UIImage imageNamed:@"chat02"];
    [self addSubview:self.background];
    
    self.sharedate=[[UILabel alloc]initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width-130, 15,120, 20)];
    self.sharedate.text=@"11-12 22:55";
    _sharedate.textAlignment=NSTextAlignmentRight;
    _sharedate.adjustsFontSizeToFitWidth = YES;
    self.sharedate.font=[UIFont systemFontOfSize:MiddleFont];
    self.sharedate.textColor=RGBCOLOR(139, 140, 142);
    [self addSubview:self.sharedate];
    
    self.sharetitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 10,200, 20)];
    self.sharetitle.text=@"终于又中奖了";
        _sharetitle.font=[UIFont systemFontOfSize:BigFont];
    self.sharetitle.textColor=[UIColor blackColor];
    [_background addSubview:_sharetitle];
    
//    self.sharegoods=[[UILabel alloc]initWithFrame:CGRectMake(20, _sharetitle.frame.size.height+20,230, 20)];
//    self.sharegoods.text=@"(第21101199期）小米note2";
//    self.sharegoods.textColor=RGBCOLOR(145, 146, 146);
//    //    self.sharegoods.font=[UIFont systemFontOfSize:15];
//    [_background addSubview:_sharegoods];
//    
    
    
    
    
    self.shareinfo=[[UILabel alloc]initWithFrame:CGRectMake(20, 30,_background.frame.size.width-30, 20)];
    self.shareinfo.numberOfLines=2;
    self.shareinfo.text=@"我又中奖了，中了一大箱方便面，可以吃好几天了，哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    _shareinfo.font=[UIFont systemFontOfSize:MiddleFont];
    self.shareinfo.textColor=RGBCOLOR(44, 45, 46);
    _shareinfo.backgroundColor=[UIColor clearColor];
    [_background addSubview:_shareinfo];
    
    self.goodsimg1=[[UIImageView alloc]initWithFrame:CGRectMake(20, _shareinfo.frame.origin.y+_shareinfo.frame.size.height+5,_background.frame.size.width/3-20, _background.frame.size.width/3-20)];
    self.goodsimg1.backgroundColor=[UIColor clearColor];
    self.goodsimg1.contentMode =UIViewContentModeScaleAspectFill;
    [self.goodsimg1 setClipsToBounds:YES];
    [_background addSubview:_goodsimg1];
    
    self.goodsimg2=[[UIImageView alloc]initWithFrame:CGRectMake(30+_background.frame.size.width/3-20, _goodsimg1.frame.origin.y,_background.frame.size.width/3-20, _background.frame.size.width/3-20)];
    self.goodsimg2.backgroundColor=[UIColor clearColor];
    [self.goodsimg2 setClipsToBounds:YES];

    self.goodsimg2.contentMode =UIViewContentModeScaleAspectFill;
    [_background addSubview:_goodsimg2];
    
    self.goodsimg3=[[UIImageView alloc]initWithFrame:CGRectMake(30+(_background.frame.size.width/3*2)-30, _goodsimg1.frame.origin.y,_background.frame.size.width/3-20, _background.frame.size.width/3-20)];
    [self.goodsimg3 setClipsToBounds:YES];

    self.goodsimg3.contentMode =UIViewContentModeScaleAspectFill;
    self.goodsimg3.backgroundColor=[UIColor clearColor];
    
    [_background addSubview:_goodsimg3];
    
    
    //点赞button
    _btzan=[[UIButton alloc]initWithFrame:CGRectMake(70, _background.frame.origin.y+_background.frame.size.height+1,(_background.frame.size.width-16)/3, 25)];
    _btzan.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_btzan addTarget:self action:@selector(zan) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btzan];
    
    //评论button
    _btcomment=[[UIButton alloc]initWithFrame:CGRectMake(_btzan.frame.origin.x+_btzan.frame.size.width, _btzan.frame.origin.y,(_background.frame.size.width-16)/3, 25)];
//    [_btcomment setTitle:@"评论" forState: UIControlStateNormal];
//    _btcomment.titleLabel.font = [UIFont systemFontOfSize:SmallFont];
    _btcomment.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    _btcomment.backgroundColor=[UIColor greenColor];
    [self addSubview:_btcomment];
    
    //试试手气
    _tryBtn=[[UIButton alloc]initWithFrame:CGRectMake(_btcomment.frame.origin.x+_btzan.frame.size.width, _btzan.frame.origin.y,(_background.frame.size.width-16)/3, 25)];
    _tryBtn.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_tryBtn setTitle:@"试试手气>" forState:UIControlStateNormal];
    _tryBtn.titleLabel.font=[UIFont systemFontOfSize:MiddleFont];
    [_tryBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [self addSubview:_tryBtn];
    
    //点赞图片
    _imgzan=[[UIImageView alloc]initWithFrame:CGRectMake(_btzan.frame.size.width/3-5,5, 15, 15)];
    _imgzan.image=[UIImage imageNamed:@"good"];
    //    _imgzan.backgroundColor=[UIColor greenColor];
    [_btzan addSubview:_imgzan];
    
    //评论图片
    _imgcomment=[[UIImageView alloc]initWithFrame:CGRectMake(_btcomment.frame.size.width/3-5,5, 15, 15)];
    _imgcomment.image=[UIImage imageNamed:@"comments01"];
    //    _imgcomment.backgroundColor=[UIColor greenColor];
    [_btcomment addSubview:_imgcomment];
    
    
    
    _lbzan=[[UILabel alloc]initWithFrame:CGRectMake(70+_btzan.frame.size.width/2+3,_background.frame.origin.y+_background.frame.size.height+6, 50, 15)];
    _lbzan.text=@"10";
    _lbzan.textColor=[UIColor grayColor];
    _lbzan.backgroundColor=[UIColor clearColor];
    _lbzan.font=[UIFont systemFontOfSize:SmallFont];
    [self addSubview:_lbzan];
    
    
    _lbcomment=[[UILabel alloc]initWithFrame:CGRectMake(_btcomment.frame.size.width/2+3,5, 80, 15)];
    _lbcomment.text=@"30";
    _lbcomment.textColor=[UIColor grayColor];
    _lbcomment.font = [UIFont systemFontOfSize:SmallFont];
    [_btcomment addSubview:_lbcomment];
    
    _btlook=[[UIButton alloc]initWithFrame:CGRectMake(_background.frame.origin.x+10, _background.frame.origin.y+ _goodsimg1.frame.origin.y, _background.frame.size.width-20, _background.frame.size.width/3-20)];
    _btlook.backgroundColor=[UIColor clearColor];
    _btlook.userInteractionEnabled=YES;
    [self addSubview:_btlook];
    

    
    
}

- (void)zan
{
    [self.delegate clickCell:self];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
