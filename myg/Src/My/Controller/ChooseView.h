//
//  ChooseView.h
//  yyxb
//
//  Created by 杨易 on 15/11/17.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseView : UIView<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end
