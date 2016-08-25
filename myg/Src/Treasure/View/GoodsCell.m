//
//  GoodsCell.m
//  yyxb
//
//  Created by 杨易 on 15/11/9.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "GoodsCell.h"

#import "GoodsCollectionViewCell.h"

#import "GoodsDetailsViewController.h" //商品详情

#import "GoodsModel.h"

@implementation GoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        [self createUI];
    }
    
    return self;
}
static NSString *collectionCellName = @"GoodsCollectionViewCell";

- (void)createUI
{
  
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake(MSW / 2, 180);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MSW, self.dataArray.count / 2 * 180) collectionViewLayout:layOut];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[GoodsCollectionViewCell class] forCellWithReuseIdentifier:collectionCellName];
   // self.collectionView.scrollEnabled = YES;
    [self addSubview:self.collectionView];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //有多少个Cell
  self.collectionView.frame = CGRectMake(0, 0, MSW, self.dataArray.count / 2 * 180);
    DebugLog(@"%d------------------------",self.dataArray.count);
    return self.dataArray.count;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    DebugLog(@"-----------------------------------------------?????%d",indexPath.item);
    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
  

    cell.goodsModel = self.dataArray[indexPath.item];

   // cell.backgroundColor = [UIColor redColor];
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}





- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//修改的－－－主页网格cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"===================%d",indexPath.row);
    GoodsModel *model = self.dataArray[indexPath.row];
    NSDictionary *cID = [NSDictionary dictionaryWithObjectsAndKeys:model,@"Id", nil];
    NSNotification *notificationID =[NSNotification notificationWithName:@"NavPushi" object:nil userInfo:cID];
    [[NSNotificationCenter defaultCenter] postNotification:notificationID];

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
