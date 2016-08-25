//
//  RedPacketView.h
//  yyxb
//
//  Created by lili on 15/12/14.
//  Copyright © 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketView : UIView<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)PullingRefreshTableView *tableView;
@property (nonatomic, assign) NSInteger num; //记录当前页数

@property (nonatomic, strong) NSMutableArray *couldarray;;//可以使用数据源
@property (nonatomic, strong) NSMutableArray *didArray; //过期
- (id)initWithFrame:(CGRect)frame AndNum:(NSString *)num;
@property (nonatomic, copy) NSString *numStr;



@end
