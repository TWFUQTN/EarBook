//
//  RankingListViewController.h
//  EarBook
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class List;

typedef void(^RankingListVCBlock)(id responseObject);

@interface RankingListViewController : UIViewController

@property (nonatomic, strong) List *bookList;

@property (nonatomic, assign) NSInteger rangeType;

@end
