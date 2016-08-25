//
//  ExchangeRecordCell.m
//  yyxb
//
//  Created by mac03 on 15/12/2.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ExchangeRecordCell.h"

@interface ExchangeRecordCell() {
    UIView         *_bgView;
    UIView         *_line;                      //分隔线
    UILabel                    *_timeLab;       //时间
    UILabel                    *_titleLab;      //标题
    UILabel                    *_moneyLab;      //号码
    UILabel                    *_statsLab;     //状态
   
}

@end

@implementation ExchangeRecordCell

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
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MSW, 50)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    
    _timeLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, MSW/4, 30)];
    _timeLab.textColor=[UIColor blackColor];
    _timeLab.numberOfLines=0;
    _timeLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_timeLab];
    
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(_timeLab.right+10, 10, MSW/4, 30)];
    _titleLab.textColor=[UIColor blackColor];
    _titleLab.text=@"米币";
    _titleLab.numberOfLines=0;
    _titleLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_titleLab];
    
    _moneyLab=[[UILabel alloc]initWithFrame:CGRectMake(_titleLab.right, 10, MSW/4, 30)];
    _moneyLab.textColor=[UIColor blackColor];
    _moneyLab.text=@"￥100";
    _moneyLab.numberOfLines=0;
    _moneyLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_moneyLab];
    
    _statsLab=[[UILabel alloc]initWithFrame:CGRectMake(_moneyLab.right, 10, MSW/4, 30)];
//    _statsLab.textColor=[UIColor blackColor];
    _statsLab.text=@"通过";
    _statsLab.textColor=RGBCOLOR(51, 75, 0);
    _statsLab.numberOfLines=0;
    _statsLab.font=[UIFont systemFontOfSize:MiddleFont];
    [_bgView addSubview:_statsLab];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.bottom -1, MSW, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_bgView addSubview:line];
    
}

-(void)setExchangeRecordModel:(ExchangeRecordDto *)exchangeRecordModel{
    
    _exchangeRecordModel=exchangeRecordModel;

    NSString *str=_exchangeRecordModel.addtime;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd "];
    
    _timeLab.text = [dateFormatter stringFromDate: detaildate];

    _moneyLab.text=_exchangeRecordModel.money;
    
    
//    if ([_exchangeRecordModel.status isEqualToString:@"0"]) {
//        _statsLab.text=@"未通过";
//        _statsLab.textColor=RGBCOLOR(250, 47, 0);
//    }
//    else if ([_exchangeRecordModel.status isEqualToString:@"1"]){
//        _statsLab.text=@"通过";
//        _statsLab.textColor=RGBCOLOR(51, 75, 0);
//    }
//    else if([_exchangeRecordModel.status isEqualToString:@"2"]){
//        _statsLab.text=@"审核中";
//        _statsLab.textColor=RGBCOLOR(0, 167, 168);
//    }
    
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
