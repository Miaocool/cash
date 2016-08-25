//
//  TagsView.h
//  
//
//  Created by lidan on 16/7/6.
//  Copyright © 2016年 lidan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagsViewDelegate;


@interface TagsView : UIView

@property (nonatomic) UIEdgeInsets contentInsets;  //default is (10,10,10,10)

@property (nonatomic) NSArray<NSString *>*tagsArray;  //数据源
@property (nonatomic, weak) id<TagsViewDelegate>delegate;

@property (nonatomic) CGFloat lineSpace;  //行间距, 默认为10
@property (nonatomic) CGFloat interitemSpace; //元素之间的间距，默认为5

//---------标签属性-------
@property (nonatomic) UIEdgeInsets tagInsets; // default is (5,5,5,5)
@property (nonatomic) CGFloat tagBorderWidth;  //标签边框宽度, default is 0
@property (nonatomic) CGFloat tagcornerRadius;  // default is 0
@property (nonatomic, strong) UIColor *tagBorderColor;
@property (nonatomic, strong) UIColor *tagSelectedBorderColor;
@property (nonatomic, strong) UIColor *tagBackgroundColor;
@property (nonatomic, strong) UIColor *tagSelectedBackgroundColor;
@property (nonatomic, strong) UIFont *tagFont;
@property (nonatomic, strong) UIFont *tagSelectedFont;
@property (nonatomic, strong) UIColor *tagTextColor;
@property (nonatomic, strong) UIColor *tagSelectedTextColor;

@property (nonatomic) CGFloat tagHeight;        //标签高度，默认28
@property (nonatomic) CGFloat mininumTagWidth;  //tag 最小宽度值, 默认是0，即不作最小宽度限制
@property (nonatomic) CGFloat maximumTagWidth;  //tag 最大宽度值, 默认是CGFLOAT_MAX， 即不作最大宽度限制


#pragma mark - ......::::::: 选中 :::::::......

@property (nonatomic) BOOL allowsSelection;             //是否允许选中, default is YES
@property (nonatomic) BOOL allowsMultipleSelection;     //是否允许多选, default is NO

@property (nonatomic, readonly) NSUInteger selectedIndex;   //选中索引
@property (nonatomic, readonly) NSArray<NSString *> *selecedTags;     //多选状态下，选中的Tags

- (void)selectTagAtIndex:(NSUInteger)index animate:(BOOL)animate;
- (void)deSelectTagAtIndex:(NSUInteger)index animate:(BOOL)animate;

#pragma mark - ......::::::: Edit :::::::......

//if not found, return NSNotFount
- (NSUInteger)indexOfTag:(NSString *)tagName;

- (void)addTag:(NSString *)tagName;
- (void)insertTag:(NSString *)tagName AtIndex:(NSUInteger)index;

- (void)removeTagWithName:(NSString *)tagName;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)removeAllTags;

@end



@protocol TagsViewDelegate <NSObject>

@optional
- (BOOL)tagsView:(TagsView *)tagsView shouldSelectTagAtIndex:(NSUInteger)index;
- (void)tagsView:(TagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index;

- (BOOL)tagsView:(TagsView *)tagsView shouldDeselectItemAtIndex:(NSUInteger)index;
- (void)tagsView:(TagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index;

@end