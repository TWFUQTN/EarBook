//
//  BookCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookCell.h"
#import "BookCollectionCell.h"
#import <Masonry.h>

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface BookCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *myFlowLayout;

@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation BookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self layoutView];
    }
    return self;
}

- (void)layoutView
{
    // 1. 定义 collectionView 的样式
    self.myFlowLayout = [UICollectionViewFlowLayout new];
    // 设置属性
    // 给定Item的大小
    self.myFlowLayout.itemSize = CGSizeMake((kWidth - 40) / 3, kWidth / 3);
    // 每两个Item之间的最小间隙(垂直滚动)
    self.myFlowLayout.minimumInteritemSpacing = 10;
    // 每两个Item之间的最小间隙(水平滚动)
    self.myFlowLayout.minimumLineSpacing = 10;
    // 设置滚动方向
    self.myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical; // 垂直方向
    //    self.myFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 水平方向
    // 设置视图的内边距(上左下右)
    self.myFlowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    
//    // 布局头视图尺寸
//    self.myFlowLayout.headerReferenceSize = CGSizeMake(0, 50);
//    
//    // 布局尾视图尺寸
//    self.myFlowLayout.footerReferenceSize = CGSizeMake(0, 50);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.myFlowLayout];
    
    [self.contentView addSubview:_myCollectionView];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"BookCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    cell.book = self.book;
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
