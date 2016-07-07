//
//  VoiceDetailViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookMP3;
@class Voice;

typedef NS_ENUM(NSUInteger, PushFrom1) {
    PushFromRecommendVC1,
    PushFromMoreListVC1,
    PushFromRankingVC1
};

@interface VoiceDetailViewController : UIViewController

@property (nonatomic, strong) BookMP3 *book;


/// 页面判断
@property (nonatomic, assign) PushFrom1 pushFrom;

@property (nonatomic, strong) Voice *voice;

@end
