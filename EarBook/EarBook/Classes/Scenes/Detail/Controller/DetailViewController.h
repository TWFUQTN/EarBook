//
//  DetailViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZF_SegmentLabelView.h"

@class BookMP3;

typedef NS_ENUM(NSUInteger, PushFrom) {
    PushFromRecommendVC,
    PushFromMoreListVC,
    PushFromRankingVC
};

typedef NS_ENUM(NSUInteger, JoiningURLString) {
    JoiningURLStringByURL,
    JoiningURLStringByID
};

@interface DetailViewController : UIViewController

/// 传来的书籍
@property (nonatomic, strong) BookMP3 *book;

/// 页面判断
@property (nonatomic, assign) PushFrom pushFrom;

/// 拼接URL判断
@property (nonatomic, assign) JoiningURLString joiningURLString;
@property (nonatomic, assign) NSInteger pageNum;
//tableView目录列表
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
//segment及滑动的label视图
@property (nonatomic, strong) ZF_SegmentLabelView *SLView;
//底层scroll
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
//是否被收藏
@property (nonatomic,assign) BOOL isCollected;
//收藏数组
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
