//
//  BookInfosHandle.h
//  EarBook
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <UIKit/UIKit.h>
#import "BookList.h"
#import "BookMP3.h"

// 获取数据源接口的反馈结果

@interface BookInfosHandle : NSObject
// 存放所有book信息的数组
@property (nonatomic, strong) NSMutableArray *bookInfosArray;
//Book 信息
@property (nonatomic, strong) BookMP3 * bookMP3;
//book index
@property (nonatomic, assign) NSInteger indexout;
//存储最近播放名字
@property (nonatomic, strong) NSMutableArray *bookCrentlyArray;
//喜欢的收藏名字
@property (nonatomic, strong) NSMutableArray *bookLikeArray;

// 声明单例
singleton_interface(BookInfosHandle)

#pragma mark - 配置播放音乐数据源相关操作
// 上一首数据源
- (BookList *)bookInfoPreviousWithIndex:(NSInteger *)index;

// 下一首数据源
- (BookList *)bookInfoNextWithIndex:(NSInteger *)index;

// 记录播放数据
@end
