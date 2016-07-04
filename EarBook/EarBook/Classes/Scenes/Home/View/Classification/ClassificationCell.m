//
//  ClassificationCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "ClassificationCell.h"
#import "MyCollectionViewCell.h"
#import "Classification.h"
#import "EB_COLOR.h"
#import "EB_URL.h"

#define kNumber 3
#define kWidth (([UIScreen mainScreen].bounds.size.width * 3 / 4) - (self.myFlowLayout.sectionInset.left + (self.myFlowLayout.minimumLineSpacing * (kNumber - 1)) + self.myFlowLayout.sectionInset.right)) / kNumber - 1

@interface ClassificationCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

//
@property (nonatomic, strong) UIView *bottomView;

//collectionViewFlowLayout
@property (nonatomic, strong) UICollectionViewFlowLayout *myFlowLayout;

//collectionView
@property (nonatomic, strong) UICollectionView *myCollectionView;


@end


@implementation ClassificationCell


//cellArray的set方法
- (void)setCellArray:(NSMutableArray *)cellArray {
    
    if (_cellArray != cellArray) {
        _cellArray = nil;
        _cellArray = cellArray;
    }
    //    NSLog(@"%d", i);
    //    i++;
    //    self.myCollectionView.backgroundColor = [UIColor redColor];
    //    NSLog(@"%@", self.myCollectionView.backgroundColor);
    
    [self.myCollectionView reloadData];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    
    UIView *leftView = [[UIView alloc] init];
    [self.contentView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width /4);
    }];
    
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderImage"]];
    [leftView addSubview:myImageView];
    [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.centerY.equalTo(leftView).offset(-14);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width / 8);
        make.height.mas_equalTo(myImageView.mas_width);
    }];
    //给myImageView宽赋值第二种
//    CGRect frame = myImageView.frame;
//    frame.size.width = leftView.frame.size.width / 2;
//    myImageView.frame = frame;
    
    self.typeLabel = [[UILabel alloc] init];
    [leftView addSubview:self.typeLabel];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.width.equalTo(leftView);
//        make.width.equalTo(leftView.mas_width);
//        make.width.mas_equalTo(leftView.mas_width);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width / 24);
        make.top.equalTo(myImageView.mas_bottom);
    }];
    //给typeLabel高的第二种赋值
//    CGRect frame = self.typeLabel.frame;
//    frame.size.height = self.typeLabel.frame.size.width / 6;
//    self.typeLabel.frame = frame;
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 4, 0, CGRectGetWidth(self.frame) * 3 / 4, CGRectGetHeight(self.frame))];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(leftView.mas_right);
        make.bottom.equalTo(self);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 3 / 4);
    }];
    //给myImageView宽赋值第二种
//    CGRect frame = self.bottomView.frame;
//    frame.size.width = leftView.frame.size.width * 3;
//    self.bottomView.frame = frame;
    
    
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
    self.myFlowLayout.itemSize = CGSizeMake(kWidth, (kWidth) / 4);
    //    NSLog(@"%f, %f", self.myFlowLayout.itemSize.height, self.myFlowLayout.itemSize.width);
    
    
    //布局collectionView
    //创建对象并指定样式
    
    //删除之前所有布局
//    for (UIView *view in self.bottomView.subviews) {
//        [view removeFromSuperview];
//    }
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bottomView.bounds collectionViewLayout:self.myFlowLayout];
    [self.bottomView addSubview:self.myCollectionView];
    
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView);
    }];
    
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    [self.myCollectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"collecell"];
    //    [self.myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
}




//- (void)layoutSubviews {
////#pragma mark - 初始高度赋值，程序完成后删除
////    self.bottomView.frame = CGRectMake(self.bounds.size.width * 0.25, 0, self.bounds.size.width * 0.75, 300);
////    CGRect frame = self.cellView.frame;
////    frame.size.height = self.bottomView.frame.size.height;
////    self.cellView.frame = frame;
//    
//    
//    
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collecell" forIndexPath:indexPath];
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collecell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor purpleColor];
    Classification *classification = self.cellArray[indexPath.row];
//    NSLog(@"%d", i);
//    i++;
    cell.titleLabel.text = classification.name;
    return cell;
}


+ (CGFloat)heightOfCellByNumberFromItems:(NSInteger)number {
    NSInteger i = 0;
    if (number % kNumber == 0) {
        i = number / kNumber;
    } else {
        i = (number / kNumber) + 1;
    }
    
    CGFloat itemsHeight = i * ((((([UIScreen mainScreen].bounds.size.width * 3 / 4) - (10 + (10 * (kNumber - 1)) + 10)) / kNumber - 1) / 4));
    CGFloat spaceHeight = ((i - 1) * 10);
    CGFloat allHeight = itemsHeight + spaceHeight + 10 + 10;
    return allHeight;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    MRYViewController *mryVC = [[MRYViewController alloc] init];
//    NSString *url = [[NSString alloc] init];
//    if (classification.url) {
//        url = classification.url;
//    } else {
//        url = classification.ID;
//    }
//    mryVC.url = url;
    Classification *classification = self.cellArray[indexPath.row];
    self.block(classification);
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
