//
//  NotifyViewCell.m
//  yyxb
//
//  Created by lili on 15/11/18.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "NotifyViewCell.h"
#import "NoticeDto.h"

@implementation NotifyViewCell
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
    
    
    self.lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, [UIScreen mainScreen].bounds.size.width-60, 50)];
    self.lbtitle.text=@"关于海购商品类需要验证身份证的说明";
    self.lbtitle. font=[UIFont systemFontOfSize:20];
    self.lbtitle.numberOfLines=0;
    self.lbtitle.textColor=[UIColor blackColor];
    [self addSubview:self.lbtitle];
    
    
    self.lbdetail=[[UILabel alloc]initWithFrame:CGRectMake(20, 65, 200, 30)];
    self.lbdetail.text=@"2015-08-21 00:00:00";
    self.lbdetail. font=[UIFont systemFontOfSize:16];
    self.lbdetail.textColor=[UIColor grayColor];
    [self addSubview:self.lbdetail];
    
}

-(void)setNoticeModel:(NoticeDto *)noticeModel
{
    _noticeModel=noticeModel;
    self.lbtitle.text=noticeModel.title;
    
    
    NSString *str=noticeModel.Posttime;//时间戳
    NSTimeInterval time=[str doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.lbdetail.text=[dateFormatter stringFromDate: detaildate];
    
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
