//
//  DiscountCell.h
//  yyxb
//
//  Created by 杨易 on 15/12/7.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *hongbaoArray;
@property (nonatomic, assign) BOOL isOpen;
@end
