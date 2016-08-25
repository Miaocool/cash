//
//  RecordCell.m
//  yyxb
//
//  Created by mac03 on 15/11/25.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "RecordCell.h"
#import "UIImageView+WebCache.h"

@interface RecordCell() {
    UIView         *_bgView;
    UIImageView    *_LeftImgView;
    UIView         *_line;                      //分隔线
    UILabel                    *_timeLab;       //时间
    UILabel                    *_titleLab;      //标题
    UILabel                    *_numberLab;     //号码
    UILabel                    *_totalLab;      //总需
    UILabel                    *_nowDateLab;    //本次参与
    UILabel                    *_statsLab;       //状态
    UILabel                    *_initLabl;    //参与七号
}

@end
@implementation RecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithHex:@"#F8F8F8"];
        
        [self initSta];
        
    }
    return self;
}

-(void)initSta
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 190)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _LeftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 110, 120)];
    _LeftImgView.backgroundColor = [UIColor clearColor];
    _LeftImgView.contentMode = UIViewContentModeScaleAspectFit;
    _LeftImgView.image=[UIImage imageNamed:@"4-4"];
    _LeftImgView.layer.cornerRadius=5;
    _LeftImgView.clipsToBounds = YES;
    _LeftImgView.userInteractionEnabled=YES;
    [_bgView addSubview:_LeftImgView];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, 5, MSW - 10 -10 -_LeftImgView.width, 20)];
    _titleLab.text=@"（20117期）中国黄金 10g";
    _titleLab.textColor=[UIColor blackColor];
    _titleLab.numberOfLines=0;
    _titleLab.font=[UIFont systemFontOfSize:BigFont];
    [_bgView addSubview:_titleLab];
    
    //    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _titleLab.bottom+5, 50, 20)];
    //    label.text=@"总需:";
    //    label.textColor=[UIColor blackColor];
    //    label.font=[UIFont systemFontOfSize:MiddleFont];
    //    [_bgView addSubview:label];
    
    _totalLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _titleLab.bottom+5, 200, 20)];
    _totalLab.text=@"总需:100次";
    _totalLab.textColor=[UIColor blackColor];
    _totalLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_totalLab];
    
    //    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _totalLab.bottom+5, 80, 20)];
    //    label2=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _totalLab.bottom+5, 200, 20)];
    //    label2.text=@"参与期号:";
    //    label2.textColor=[UIColor blackColor];
    //    label2.font=[UIFont systemFontOfSize:MiddleFont];
    //    [_bgView addSubview:label2];
    
    _initLabl=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _totalLab.bottom+5, 200, 20)];
    _initLabl.text=@"1";
    _initLabl.textColor=[UIColor blackColor];
    _initLabl.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_initLabl];
    
    //    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _initLabl.bottom+5, 80, 20)];
    //    label3.text=@"幸运号码:";
    //    label3.textColor=[UIColor blackColor];
    //    label3.font=[UIFont systemFontOfSize:MiddleFont];
    //    [_bgView addSubview:label3];
    
    _numberLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _initLabl.bottom+5, 200, 20)];
    _numberLab.text=@"1000066";
    _numberLab.textAlignment = NSTextAlignmentLeft;
    _numberLab.textColor=RGBCOLOR(255, 81, 15);
    _numberLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_numberLab];
    
    _nowDateLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _numberLab.bottom+5, MSW - 10 -10 -_LeftImgView.width, 20)];
    _nowDateLab.text=@"本期参与:5人次";
    _nowDateLab.textColor=[UIColor blackColor];
    _nowDateLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_nowDateLab];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(_LeftImgView.right+5, _nowDateLab.bottom+5, MSW - 10 -10 -_LeftImgView.width, 20)];
    _timeLab.text=@"揭晓时间:2015-11-17 16：04：00";
    _timeLab.textColor=[UIColor blackColor];
    _timeLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_timeLab];
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(0, _timeLab.bottom+5, MSW, 0.8)];
    _line.backgroundColor=RGBCOLOR(217, 217, 217);
    [_bgView addSubview:_line];
    
    _statsLab=[[UILabel alloc]initWithFrame:CGRectMake(MSW-50, _line.bottom+5, 50, 20)];
    _statsLab.font=[UIFont systemFontOfSize:BigFont];
    [_bgView addSubview:_statsLab];

    
}

-(void)setRecordModel:(RecordDto *)recordModel
{
    NSDictionary* style = @{@"body" :
                                @[[UIFont systemFontOfSize:MiddleFont],
                                  [UIColor blackColor]],
                            @"u": @[MainColor, ]};
    
    
    _recordModel=recordModel;
    [_LeftImgView sd_setImageWithURL:[NSURL URLWithString:recordModel.Uphoto] placeholderImage:[UIImage imageNamed:DefaultImage]];
    _titleLab.text=recordModel.shopname;
    _totalLab.text=[NSString stringWithFormat:@"总需：%@人次",recordModel.Zongrenshu];
    _initLabl.text=[NSString stringWithFormat:@"参与期号：%@",recordModel.Shopqishu];
    _numberLab.attributedText = [[NSString stringWithFormat:@"幸运号码：<u>%@</u>",recordModel.Huode] attributedStringWithStyleBook:style];
    _nowDateLab.attributedText = [[NSString stringWithFormat:@"本期参与：<u>%@</u>人次",recordModel.Gonumber] attributedStringWithStyleBook:style];
    
    if ([_recordModel.isget isEqualToString:@"1"]) {
        _statsLab.text=@"已签收";
        _statsLab.textColor=RGBCOLOR(125, 162, 30);
    }else if ([_recordModel.isget isEqualToString:@"0"]){
        _statsLab.text=@"未签收";
        _statsLab.textColor=RGBCOLOR(85, 85, 85);
    }
    
    
    
    NSString *str=recordModel.Time;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    _timeLab.text = [dateFormatter stringFromDate: detaildate];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
