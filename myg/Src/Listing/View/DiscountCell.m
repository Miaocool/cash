//
//  DiscountCell.m
//  yyxb
//
//  Created by 杨易 on 15/12/7.
//  Copyright (c) 2015年 杨易. All rights reserved.
//红包

#import "DiscountCell.h"

#import "DiscountSecondCell.h"

#import "HongbaoModel.h"

@implementation DiscountCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    
    return self;
}
static NSString *cellName = @"Cell";

- (void)createUI
{

    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layOut.itemSize = CGSizeMake(77, 130);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MSW, 130) collectionViewLayout:layOut];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[DiscountSecondCell class] forCellWithReuseIdentifier:cellName];

    [self addSubview:self.collectionView];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hongbaoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    DiscountSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    if (self.hongbaoArray.count > 0)
    {
        cell.hongbaoModel = self.hongbaoArray[indexPath.row];
    }
    if (self.isOpen == NO)
    {
        cell.selectedImageView.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(state:) name:@"isOpen" object:nil];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [collectionView numberOfItemsInSection:indexPath.section]
    
 
    for (int i=0; i< [collectionView numberOfItemsInSection:indexPath.section] ;i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        DiscountSecondCell *unchechCell = (DiscountSecondCell*)[collectionView cellForItemAtIndexPath:path];
        unchechCell.isChoose = NO;
        DiscountSecondCell *cell = (DiscountSecondCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //    NSUInteger row = [indexPath row];
        cell.isChoose = YES;
       
        //点击选中，再次点击取消选中
        //    NSMutableDictionary *dic = [_contacts objectAtIndex:row];
        //    if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
        //        [dic setObject:@"YES" forKey:@"checked"];
        //        cell.choosed = YES;
        //        _cityId = [NSString stringWithFormat:@"%@",model.cityId ];
        //    }else{
        //        [dic setObject:@"NO" forKey:@"checked"];
        //        cell.choosed = NO;
        //        _cityId = NULL;
        //    }
    }
    
    HongbaoModel *model = self.hongbaoArray[indexPath.row];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: model,@"model", nil];
    NSNotification *modelNotification =[NSNotification notificationWithName:@"remaining" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:modelNotification];

}

#pragma mark 通知更新米币
- (void)state:(NSNotification *)text
{
    
    self.isOpen = [text.userInfo[@"bool"] boolValue];
    [self.collectionView reloadData];

}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
