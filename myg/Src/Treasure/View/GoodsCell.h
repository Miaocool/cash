//
//  GoodsCell.h
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *citys;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int indx;
@end
