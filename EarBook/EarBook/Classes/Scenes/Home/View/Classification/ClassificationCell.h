//
//  ClassificationCell.h
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationCell : UITableViewCell

//类型名
@property (nonatomic, strong) UILabel *typeLabel;


//传值数组
@property (nonatomic, strong) NSMutableArray *cellArray;


+ (CGFloat)heightOfCellByNumberFromItems:(NSInteger)number;


@end
