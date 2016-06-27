//
//  ClassificationCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "ClassificationCell.h"
#define kNumber 3


@interface ClassificationCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

//collectionView底视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//collectionViewFlowLayout
@property (nonatomic, strong) UICollectionViewFlowLayout *myFlowLayout;

//collectionView
@property (nonatomic, strong) UICollectionView *myCollectionView;


@end


@implementation ClassificationCell

- (void)layoutSubviews {
    //1.定义collectionView样式
    self.myFlowLayout = [UICollectionViewFlowLayout new];
    //设置属性
    //每两个item的最小间距(垂直滚动)
    self.myFlowLayout.minimumInteritemSpacing = 10;
    //每两个item的最小间距(水平滚动)
    self.myFlowLayout.minimumLineSpacing = 10;
    //滚动方向
    self.myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置视图的内边距（上左下右）
    self.myFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //给定item的大小
    self.myFlowLayout.itemSize = CGSizeMake((self.bottomView.bounds.size.width - (self.myFlowLayout.sectionInset.left + (self.myFlowLayout.minimumLineSpacing * (kNumber - 1)) + self.myFlowLayout.sectionInset.right)) / kNumber - 0.0001, ((self.bottomView.bounds.size.width - (self.myFlowLayout.sectionInset.left + (self.myFlowLayout.minimumInteritemSpacing * (kNumber - 1)) + self.myFlowLayout.sectionInset.right)) / kNumber - 0.0001) / 4);
    NSLog(@"%f, %f", self.myFlowLayout.itemSize.height, self.myFlowLayout.itemSize.width);
    
    
    //布局collectionView
    //创建对象并指定样式
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bottomView.bounds collectionViewLayout:self.myFlowLayout];
    [self.bottomView addSubview:self.myCollectionView];
    
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collecell"];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.bottomView.frame = CGRectMake(self.bounds.size.width * 0.25, 0, self.bounds.size.width * 0.75, 300);
    CGRect frame = self.cellView.frame;
    frame.size.height = self.bottomView.frame.size.height;
    self.cellView.frame = frame;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collecell" forIndexPath:indexPath];
    NSLog(@"========");
    cell.backgroundColor = [UIColor purpleColor];
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