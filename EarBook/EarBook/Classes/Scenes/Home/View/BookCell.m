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

#import "BookMP3.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface BookCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *myFlowLayout;

@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation BookCell

- (void)setBookArray:(NSArray *)bookArray
{
    if (_bookArray != bookArray) {
        _bookArray = bookArray;
    }
    [self.myCollectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self layoutView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutView
{
    // 1. 定义 collectionView 的样式
    self.myFlowLayout = [UICollectionViewFlowLayout new];
    // 设置属性
    // 给定Item的大小
    self.myFlowLayout.itemSize = CGSizeMake((kWidth - 20) / 3, 161);
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.myFlowLayout];
    
    // 取消水平滚动条,关闭滑动效果
    self.myCollectionView.scrollEnabled = NO;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    self.myCollectionView.bounces = NO;
    [self.contentView addSubview:_myCollectionView];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(-10);
    }];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"BookCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    if (self.bookArray.count > 0) {
        cell.book = self.bookArray[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookMP3 *book = self.bookArray[indexPath.row];
    self.block(book);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
