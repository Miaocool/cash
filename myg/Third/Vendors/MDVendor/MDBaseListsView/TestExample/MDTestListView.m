//
//  MDTestListView.m
//  MDYNews
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDTestListView.h"

@implementation MDTestListView



// 下载数据
-(void)requestData
{
    [super requestData];//  必须 调用 super
    
    BOOL requestSuccess = YES;
    
    if (requestSuccess) // 请求成功
    {
        [self.baseDataArray addObject:@"1"];
        
        [self.baseDataArray addObject:@"2"];
        
        [self showData];//  成功取得数据后必须调用
    }else // 请求失败
    {
        
        [self failRequest:nil]; // 传入 网络错误的 参数 不为nil
    }
    
    
}


#pragma mark tableView 代理方法
#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baseDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }
    
    cell.textLabel.text = self.baseDataArray[indexPath.row];
    
    return cell;
}


@end
