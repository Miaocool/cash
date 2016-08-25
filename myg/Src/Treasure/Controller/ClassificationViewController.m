//
//  ClassificationViewController.m
//  yyxb
//
//  Created by 杨易 on 15/11/10.
//  Copyright (c) 2015年 杨易. All rights reserved.
//

#import "ClassificationViewController.h"

#import "ClassificationCell.h"

#import "ClassificationGoodsViewController.h" //分类展示

#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "ClassModel.h" 
#import "ClassifyViewCell.h"

@interface ClassificationViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView * collectView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *allDataArray;

@property (nonatomic, strong) NSMutableArray *VipArray;

@end

@implementation ClassificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分类浏览";
[self initData];
}

- (void)initData
{
_dataArray=[NSMutableArray array];
    self.allDataArray=[NSMutableArray array];
    _VipArray=[NSMutableArray array];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [MDYAFHelp AFPostHost:APPHost bindPath:Fenlei postParam:dict1 getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"---%@-----%@－－－－",responseDic,responseDic[@"msg"]);
        NSArray*array=responseDic[@"data"];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"type"] isEqualToString:@"1"])
            {
                ClassModel *model = [[ClassModel alloc]initWithDictionary:obj];
                [self.dataArray addObject:model];
            }
            else  if([obj[@"type"] isEqualToString:@"2"])
            {
                ClassModel *model = [[ClassModel alloc]initWithDictionary:obj];
                [self.allDataArray addObject:model];
            }
            else
            {
                
            ClassModel *model = [[ClassModel alloc]initWithDictionary:obj];
                [_VipArray addObject:model];
            
            }
            DebugLog(@"data:%li",self.dataArray.count);
            DebugLog(@"alldataL%li",self.allDataArray.count);
            
        }];
        
        for (int i=0; i<_VipArray.count; i++) {
            ClassModel*model=[_VipArray objectAtIndex:i];
            
            [_dataArray addObject:model];
        }
        DebugLog(@"==--data%li---all%li---vip%li",_dataArray.count,_allDataArray.count,_VipArray.count);
[self initCollectView];
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
       [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        
    }];

    
}

-(void)initCollectView{
    
    UIView*_headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    _headview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_headview];
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10, 8, MSW-20, 35)];
    button.backgroundColor=[UIColor whiteColor];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 13, 25, 25)];
    image.image=[UIImage imageNamed:@"SearchContactsBarIcon"];
    [_headview addSubview:button];
    [_headview addSubview:image];
    UILabel*lbtitle=[[UILabel alloc]initWithFrame:CGRectMake(55, 15, 60, 20)];
    lbtitle.text=@"搜索商品";
    lbtitle.numberOfLines=0;
    
    lbtitle.textColor=[UIColor grayColor];
    lbtitle.font=[UIFont systemFontOfSize:BigFont];
    [_headview addSubview:lbtitle];
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.itemSize = CGSizeMake(MSW / 2, 100);
    
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _headview.bottom, MSW, MSH - 64 - 50) collectionViewLayout:layOut];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.backgroundColor = RGBCOLOR(234, 234, 235);
    //注册
    [_collectView registerClass:[ClassifyViewCell class]forCellWithReuseIdentifier:@"ClassifyViewCell"];
    [self.view addSubview:_collectView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count + self.allDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ClassifyViewCell";
    ClassifyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0 ) {
        cell.lbTitle.text = ((ClassModel *)self.allDataArray[0]).name;
        [cell.img sd_setImageWithURL:[NSURL URLWithString:((ClassModel *)self.allDataArray[0]).thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    }else{
        cell.lbTitle.text = ((ClassModel *)self.dataArray[indexPath.row -1]).name;
        [cell.img sd_setImageWithURL:[NSURL URLWithString:((ClassModel *)self.dataArray[indexPath.row -1]).thumb] placeholderImage:[UIImage imageNamed:DefaultImage]];
    }

    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MSW/2 -1, IPhone4_5_6_6P(50, 60, 70, 70));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 1;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
        classVC.fromcateid = ((ClassModel *)self.allDataArray[0]).cateid;
        classVC.isSection = YES;
        classVC.isSarch=NO;
        classVC.titlestr=((ClassModel *)self.allDataArray[0]).name;
        classVC.nameString = ((ClassModel *)self.allDataArray[0]).name;
        [self.navigationController pushViewController:classVC animated:YES];
    }else{
        ClassificationGoodsViewController *classVC = [[ClassificationGoodsViewController alloc]init];
        classVC.fromcateid = ((ClassModel *)self.dataArray[indexPath.row-1 ]).cateid;
        classVC.nameString = ((ClassModel *)self.dataArray[indexPath.row -1]).name;
        classVC.isSection = YES;
        classVC.isSarch=NO;
        
        classVC.titlestr=((ClassModel *)self.dataArray[indexPath.row -1]).name;
        [self.navigationController pushViewController:classVC animated:YES];
    }
}

#pragma mark  - 搜索
- (void)search
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
