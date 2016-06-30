//
//  RankingHeader.h
//  EarBook
//
//  Created by lanou3g on 16/6/30.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;

// 按钮
@property (nonatomic, strong) UIButton *weekRankingBtn;
@property (nonatomic, strong) UIButton *monthRankingBtn;
@property (nonatomic, strong) UIButton *totalRankingBtn;

@end
