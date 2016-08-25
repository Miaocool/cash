//
//  InviteFriendsView.h
//  myg
//
//  Created by lidan on 16/7/12.
//  Copyright © 2016年 bxs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteFriendsViewDelegate <NSObject>

-(void)shouldPushControllerWithUid:(NSString *)uid;
-(void)shouldPushInstructionsView;


@end

@interface InviteFriendsView : UIView<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)PullingRefreshTableView *tableView;

@property (nonatomic, assign) int num; //当前页数
@property (nonatomic, strong) NSString *type;  //下级级别  1 or 2 or 3

@property (nonatomic, strong) NSMutableArray * friendArray1;  //一级好友列表
@property (nonatomic, strong) NSMutableArray * friendArray2;  //二级好友列表
@property (nonatomic, strong) NSMutableArray * friendArray3;  //三级好友列表
@property (nonatomic, strong) NSMutableArray * rankingArray;  //排行榜列表

@property (nonatomic, strong) NoDataView *nodataView;

@property (nonatomic, assign) id<InviteFriendsViewDelegate>delegate;


- (id)initWithFrame:(CGRect)frame withType:(NSString *)type;
@end
