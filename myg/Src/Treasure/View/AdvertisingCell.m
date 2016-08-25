//
//  AdvertisingCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "AdvertisingCell.h"


#import "AdModel.h"


@implementation AdvertisingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self requestPicture];

    }
    
    return self;
}

#pragma mark - 轮播图
- (void)requestPicture
{
    self.imageArray = [NSMutableArray array];
    [MDYAFHelp AFGetHost:APPHost bindPath:ShufflingFigure param:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        if ([responseDic isKindOfClass:[NSDictionary class]])
        {
            if ([responseDic[@"code"] isEqualToString:@"200"])
            {
                NSArray *array = responseDic[@"data"];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AdModel *model = [[AdModel alloc]initWithDictionary:obj];
                    [self.imageArray addObject:model];
                }];
                [self createUI];

            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];

}

- (void)createUI
{

    self.scrollView = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, MSW, 150)];
  //  AdDataModel * dataModel = [AdDataModel adDataModelWithImageNameAndAdTitleArray];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    //scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
   // NSLog(@"%@",dataModel.adTitleArray);
    self.scrollView.imageNameArray = self.imageArray;
   // DebugLog(@"%@",scrollView.imageNameArray);
    self.scrollView.PageControlShowStyle = UIPageControlShowStyleRight;
    self.scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
  //  [scrollView setAdTitleArray:dataModel.adTitleArray withShowStyle:AdTitleShowStyleLeft];
    
    self.scrollView.pageControl.currentPageIndicatorTintColor = MainColor;
    [self addSubview:self.scrollView];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   self.pageControl.currentPage =  scrollView.contentOffset.x / MSW;

}



- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
