//
//  BookInfosHandle.h
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "BookMP3.h"
#import "BookList.h"
#import <UIKit/UIKit.h>
// 获取数据源接口的反馈结果
typedef void(^Completion)(NSArray *array, NSError *error);
@interface BookInfosHandle : NSObject
// 声明单例
singleton_interface(MusicInfosHandle)
// 书籍表相关数据源的操作接口
// url地址  反馈结果
- (void)getMusicInfoWithUrl:(NSString *)urlString
                 completion:(Completion)completion;
// 获取分组个数
- (NSInteger)numberOfSections;

// 获取指定分组行数
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

// 获取某个分区下某行的book
- (BookList *)musicInfoForRowInIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 配置播放音乐数据源相关操作
// 上一首数据源
- (BookList *)musicInfoPreviousWithIndex:(NSInteger *)index;

// 下一首数据源
- (BookList *)musicInfoNextWithIndex:(NSInteger *)index;



@end
