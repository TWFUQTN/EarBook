//
//  DetailViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookMP3;

typedef NS_ENUM(NSUInteger, PushFrom) {
    PushFromRecommendVC,
    PushFromMoreListVC,
    PushFromRankingVC
};

@interface DetailViewController : UIViewController

/// 传来的书籍
@property (nonatomic, strong) BookMP3 *book;

/// 页面判断
@property (nonatomic, assign) PushFrom pushFrom;

@end
