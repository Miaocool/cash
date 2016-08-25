//
//  RefreshView.h
//  yyxb
//
//  Created by lili on 15/11/25.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyBuyListModel;
@interface RefreshView : UIView<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIScrollViewDelegate>
- (id)initWithFrame:(CGRect)frame AndNum:(NSString *)num;


@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic, assign) int num; //记录当前页数
@property (nonatomic, strong) NSMutableArray *willArray; //数据源
@property (nonatomic, strong) NSMutableArray *didArray; //数据源
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源


@property (nonatomic, strong) MyBuyListModel*model; //数据源
@property (nonatomic, copy) NSString *numStr;
@property (nonatomic, strong) NSString *allcount; //所有数据数量

@property (nonatomic, strong) NSString *jiexiaocount; //揭晓数量
@property (nonatomic, strong) NSString *jinxingcount; //进行数量


@property (nonatomic, assign) int index; //button下标


@end
