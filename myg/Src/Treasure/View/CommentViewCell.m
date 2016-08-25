//
//  CommentViewCell.m
//  yyxb
//
//  Created by lili on 15/11/17.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import "CommentViewCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

@implementation CommentViewCell
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
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};

    
//    修改的－－－获奖cell
    self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.imghead=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.imghead.backgroundColor=[UIColor clearColor];
    self.imghead.layer.masksToBounds = YES;
    self.imghead.layer.cornerRadius =25;
    [self addSubview:self.imghead];
    
    self.lbname=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 250, 20)];
    
    self.lbname.font=[UIFont systemFontOfSize:MiddleFont];
    self.lbname.textColor=RGBCOLOR(59, 164, 250) ;
    [self addSubview:self.lbname];
    
    self.lbuserip=[[UILabel alloc]initWithFrame:CGRectMake(70, 30, 250, 15)];
    
    
    
    self.lbuserip.text=@"(河北省石家庄市IP：12:12:02)";

    
    self.lbuserip.font=[UIFont systemFontOfSize:SmallFont];
    self.lbuserip.textColor=[UIColor grayColor];
    [self addSubview:self.lbuserip];
 
    self.lbcount=[[UILabel alloc]initWithFrame:CGRectMake(70,45, MSW-70, 15)];
    self.lbcount.attributedText=[@"参与了<u>22</u>人次"attributedStringWithStyleBook:style1];
//    _lbcount.backgroundColor=[UIColor greenColor];
    self.lbcount.font=[UIFont systemFontOfSize:SmallFont];
    [self addSubview:self.lbcount];
    
//    self.lbtime=[[UILabel alloc]initWithFrame:CGRectMake(MSW-160, 30, 150, 20)];
////    self.lbtime=[[UILabel alloc]initWithFrame:CGRectMake(MSW-185, 30, 180, 20)];
//    self.lbtime.text=@"2015-10-10 12;05:10";
//    self.lbtime.font=[UIFont systemFontOfSize:SmallFont];
//    self.lbtime.textColor=[UIColor grayColor];
//    _lbtime.textAlignment=NSTextAlignmentRight;
//    _lbtime.backgroundColor=[UIColor clearColor];
//    [self addSubview:self.lbtime];

}



-(void)setModel:(TakepateNoteModel *)model{
    _model=model;
    NSDictionary* style1 = @{@"body" :
                                 @[[UIFont systemFontOfSize:SmallFont],
                                   [UIColor grayColor]],
                             @"u": @[MainColor,
                                     
                                     ]};
    
    _lbname.text=_model.username;
    [_imghead sd_setImageWithURL:[NSURL URLWithString:_model.uphoto] placeholderImage:[UIImage imageNamed:DefaultImage]];
    _lbuserip.text=[NSString stringWithFormat:@"(%@)",_model.ip];
    
    
    
//    _lbuserip.attributedText=[[NSString stringWithFormat:@"<u>%@</u> (%@)",_model.username,_model.ip]attributedStringWithStyleBook:style1];
    _lbuserip.font=[UIFont systemFontOfSize:SmallFont];
    
    _lbuserip.text=[NSString stringWithFormat:@"%@ IP:%@",_model.ip,_model.ip1];
    
    _lbcount.attributedText=[[NSString stringWithFormat:@"本次参与了<u>%@</u>人次",_model.gonumber]attributedStringWithStyleBook:style1];
    _lbcount.font=[UIFont systemFontOfSize:SmallFont];
    NSString*strtime=_model.time;
    NSArray *array = [strtime componentsSeparatedByString:@"."];
    NSString*strms=[array objectAtIndex:1];
    int msint=[_model.time intValue]+1;
    float ms= [_model.time floatValue];
    DebugLog(@"时间戳：%f",ms);
    NSString *str2=[NSString stringWithFormat:@"%i",msint] ;//时间戳
    NSTimeInterval time2=[str2 doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate2=[NSDate dateWithTimeIntervalSince1970:time2];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter2 setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss.%@",strms]];
    _lbtime.text=[dateFormatter2 stringFromDate: detaildate2];
    _lbtime.font=[UIFont systemFontOfSize:SmallFont];
    
    _lbcount.attributedText=[[NSString stringWithFormat:@"本次参与了<u>%@</u>人次 %@",_model.gonumber,[dateFormatter2 stringFromDate: detaildate2]]attributedStringWithStyleBook:style1];

    
    
    
    
    
}








- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
