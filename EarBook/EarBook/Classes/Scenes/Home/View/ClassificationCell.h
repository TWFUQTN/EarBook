//
//  ClassificationCell.h
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationCell : UITableViewCell

//self.view
@property (weak, nonatomic) IBOutlet UIView *cellView;

///类型名
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//传值数组
@property (nonatomic, strong) NSMutableArray *cellArray;


@end
