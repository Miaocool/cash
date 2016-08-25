//
//  HonorRollViewCell.m
//  myg
//
//  Created by lili on 16/3/28.
//  Copyright © 2016年 杨易. All rights reserved.
//

#import "HonorRollViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"


@implementation HonorRollViewCell
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


    UIImageView*imgjiangbei=[[UIImageView alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(16, 16, 20, 20), 10, 25, 25)];
    imgjiangbei.image=[UIImage imageNamed:@"trophy"];
//    imgjiangbei.backgroundColor=[UIColor greenColor];
    [self addSubview:imgjiangbei];

    UILabel*lbrongyu=[[UILabel alloc]initWithFrame:CGRectMake(IPhone4_5_6_6P(53, 53, 60, 60), 10, 80 , 25)];
    lbrongyu.text=@"荣誉榜";
    lbrongyu.font=[UIFont systemFontOfSize:BigFont];
    lbrongyu.textColor=[UIColor blackColor];
    [self addSubview:lbrongyu];
    _btguize=[[UIButton alloc]initWithFrame:CGRectMake(MSW-80, 10, 70, 30)];
    [_btguize setTitle:@"上榜规则>" forState:0];
    [_btguize setTitleColor:RGBCOLOR(59, 164, 250) forState:0];
    _btguize.titleLabel.font=[UIFont systemFontOfSize:BigFont];
    [self addSubview:_btguize];
    
    _imghead1=[[UIImageView alloc]initWithFrame:CGRectMake(MSW/6-30, 40, 60, 60)];
    _imghead1.layer.cornerRadius = 30;
    _imghead1.layer.masksToBounds = YES;
//    _imghead1.backgroundColor=[UIColor grayColor];
    [self addSubview:_imghead1];
    
    
    _imghead2=[[UIImageView alloc]initWithFrame:CGRectMake(MSW/6-30+MSW/3, 40, 60, 60)];
    _imghead2.layer.cornerRadius = 30;
    _imghead2.layer.masksToBounds = YES;
//    _imghead2.backgroundColor=[UIColor grayColor];
    [self addSubview:_imghead2];

    _imghead3=[[UIImageView alloc]initWithFrame:CGRectMake(MSW/6-30+MSW/3*2, 40, 60, 60)];
    _imghead3.layer.cornerRadius = 30;
    _imghead3.layer.masksToBounds = YES;
//    _imghead3.backgroundColor=[UIColor grayColor];
    [self addSubview:_imghead3];
    
    
    _lbtitle1=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-20, 40+5+_imghead1.frame.size.height, 40, 20)];
    _lbtitle1.textAlignment=UITextAlignmentCenter;
    _lbtitle1.textColor=[UIColor whiteColor];
    _lbtitle1.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtitle1.backgroundColor=RGBCOLOR(59, 164, 250);
    _lbtitle1.text=@"土豪";
    [self addSubview:_lbtitle1];
    
    
    _lbtitle2=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-20+MSW/3, 40+5+_imghead1.frame.size.height, 40, 20)];
    _lbtitle2.textAlignment=UITextAlignmentCenter;
    _lbtitle2.textColor=[UIColor whiteColor];
    _lbtitle2.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtitle2.backgroundColor=RGBCOLOR(59, 164, 250);
    _lbtitle2.text=@"沙发";
    [self addSubview:_lbtitle2];
    
    _lbtitle3=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-20+MSW/3*2, 40+5+_imghead1.frame.size.height, 40, 20)];
    _lbtitle3.textAlignment=UITextAlignmentCenter;
    _lbtitle3.textColor=[UIColor whiteColor];
    _lbtitle3.font=[UIFont systemFontOfSize:MiddleFont];
    _lbtitle3.backgroundColor=RGBCOLOR(59, 164, 250);
    _lbtitle3.text=@"包尾";
    [self addSubview:_lbtitle3];
    
    _lbname1=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-40, 40+5+_imghead1.frame.size.height+20, 80, 20)];
    _lbname1.textAlignment=UITextAlignmentCenter;
    _lbname1.textColor=RGBCOLOR(59, 164, 250);
    _lbname1.font=[UIFont systemFontOfSize:MiddleFont];
    
    _lbname1.text=@"哈哈哈哈哈哈";
    [self addSubview:_lbname1];
    
    _lbname2=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-40+MSW/3, 40+5+_imghead1.frame.size.height+20, 80, 20)];
    _lbname2.textAlignment=UITextAlignmentCenter;
    _lbname2.textColor=RGBCOLOR(59, 164, 250);
    _lbname2.font=[UIFont systemFontOfSize:MiddleFont];
    
    _lbname2.text=@"哈哈哈哈哈哈";
    [self addSubview:_lbname2];

    _lbname3=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-40+MSW/3*2, 40+5+_imghead1.frame.size.height+20, 80, 20)];
    _lbname3.textAlignment=UITextAlignmentCenter;
    _lbname3.textColor=RGBCOLOR(59, 164, 250);
    _lbname3.font=[UIFont systemFontOfSize:MiddleFont];
    
    _lbname3.text=@"哈哈哈哈哈哈";
    [self addSubview:_lbname3];

    _lbcanyu1=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-40, 40+5+_imghead1.frame.size.height+20+20, 80, 20)];
    _lbcanyu1.textAlignment=UITextAlignmentCenter;
    _lbcanyu1.textColor=[UIColor grayColor];
    _lbcanyu1.font=[UIFont systemFontOfSize:MiddleFont];
    _lbcanyu1.text=@"哈哈哈哈哈哈";
    [self addSubview:_lbcanyu1];

    _lbcanyu2=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-40+MSW/3, 40+5+_imghead1.frame.size.height+20+20, 80, 20)];
    _lbcanyu2.textAlignment=UITextAlignmentCenter;
    _lbcanyu2.textColor=[UIColor grayColor];
    _lbcanyu2.font=[UIFont systemFontOfSize:MiddleFont];
    _lbcanyu2.text=@"第一个参与";
    [self addSubview:_lbcanyu2];
    _lbcanyu3=[[UILabel alloc]initWithFrame:CGRectMake(MSW/6-40+MSW/3*2, 40+5+_imghead1.frame.size.height+20+20, 80, 20)];
    _lbcanyu3.textAlignment=UITextAlignmentCenter;
    _lbcanyu3.textColor=[UIColor grayColor];
    _lbcanyu3.font=[UIFont systemFontOfSize:MiddleFont];
    _lbcanyu3.text=@"最后一个参与";
    [self addSubview:_lbcanyu3];

    _user1=[[UIButton alloc]initWithFrame:CGRectMake(MSW/6-40, 40, 80, 120)];
//    _user1.backgroundColor=[UIColor greenColor];
    _user1.tag=101;
    [self addSubview:_user1];
    
    _user2=[[UIButton alloc]initWithFrame:CGRectMake(MSW/6-40+MSW/3, 40, 80, 120)];
//    _user2.backgroundColor=[UIColor greenColor];
    _user2.tag=102;
    [self addSubview:_user2];
    
    _user3=[[UIButton alloc]initWithFrame:CGRectMake(MSW/6-40+MSW/3*2, 40, 80, 120)];
//    _user3.backgroundColor=[UIColor greenColor];
    _user3.tag=103;
    [self addSubview:_user3];
    
    
    
    
}

-(void)setHonorArray:(NSArray *)honorArray{
    _honorArray=honorArray;
    
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:MiddleFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor
                                     
                                     ]};

    
    if (_honorArray.count==0) {
        _imghead1.image=[UIImage imageNamed:@"xuwei"];
        _lbname1.text=@"虚位以待";
        _lbtitle1.backgroundColor=[UIColor grayColor];
        _lbname1.textColor=[UIColor grayColor];
        _lbcanyu1.text=@"参与0人次";
        
        _imghead2.image=[UIImage imageNamed:@"xuwei"];
        _lbtitle2.backgroundColor=[UIColor grayColor];
        _lbname2.text=@"虚位以待";
        _lbname2.textColor=[UIColor grayColor];
        
        _imghead3.image=[UIImage imageNamed:@"xuwei"];
         _lbtitle3.backgroundColor=[UIColor grayColor];
        _lbname3.text=@"虚位以待";
        _lbname3.textColor=[UIColor grayColor];
  
    }else if (honorArray.count==1)
    {
        NSDictionary*dic=[_honorArray objectAtIndex:0];
        [_imghead1 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:DefaultImage]];

        _lbname1.text=dic[@"username"];
//        _lbtitle1.backgroundColor=[UIColor grayColor];
        _lbname1.textColor=[UIColor grayColor];
        _lbcanyu1.attributedText =  [[NSString stringWithFormat:@"参与<u>%@</u>人次",dic[@"sum"]] attributedStringWithStyleBook:style1];

        
        _imghead2.image=[UIImage imageNamed:@"xuwei"];
        _lbtitle2.backgroundColor=[UIColor grayColor];
        _lbname2.text=@"虚位以待";
        _lbname2.textColor=[UIColor grayColor];
        
        _imghead3.image=[UIImage imageNamed:@"xuwei"];
        _lbtitle3.backgroundColor=[UIColor grayColor];
        _lbname3.text=@"虚位以待";
        _lbname3.textColor=[UIColor grayColor];
    
    }else if (_honorArray.count==2){
    
        NSDictionary*dic=[_honorArray objectAtIndex:0];
        NSDictionary*dic1=[_honorArray objectAtIndex:1];

        [_imghead1 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [_imghead2 sd_setImageWithURL:[NSURL URLWithString:dic1[@"img"]] placeholderImage:[UIImage imageNamed:DefaultImage]];

        _lbname1.text=dic[@"username"];
     _lbcanyu1.attributedText =  [[NSString stringWithFormat:@"参与<u>%@</u>人次",dic[@"sum"]] attributedStringWithStyleBook:style1];
        _lbname2.text=dic1[@"username"];
        
        _imghead3.image=[UIImage imageNamed:@"xuwei"];
        _lbtitle3.backgroundColor=[UIColor grayColor];
        _lbname3.text=@"虚位以待";
        _lbname3.textColor=[UIColor grayColor];
    
    
    }else{
        
        NSDictionary*dic=[_honorArray objectAtIndex:0];
        NSDictionary*dic1=[_honorArray objectAtIndex:1];
        NSDictionary*dic2=[_honorArray objectAtIndex:2];
        [_imghead1 sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [_imghead2 sd_setImageWithURL:[NSURL URLWithString:dic1[@"img"]] placeholderImage:[UIImage imageNamed:DefaultImage]];
        [_imghead3 sd_setImageWithURL:[NSURL URLWithString:dic2[@"img"]] placeholderImage:[UIImage imageNamed:DefaultImage]];

        _lbname1.text=dic[@"username"];

    _lbcanyu1.attributedText =  [[NSString stringWithFormat:@"参与<u>%@</u>人次",dic[@"sum"]] attributedStringWithStyleBook:style1];
        
        _lbname2.text=dic1[@"username"];
        
        _lbname3.text=dic2[@"username"];
        
    
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
