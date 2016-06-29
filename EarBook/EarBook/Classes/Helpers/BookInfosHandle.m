//
//  BookInfosHandle.m
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookInfosHandle.h"
#import "NetWorkRequestManager.h"

@interface BookInfosHandle()

// 存放所有歌曲信息的数组
@property (nonatomic, strong) NSMutableArray *bookInfosArray;

@end

@implementation BookInfosHandle

// 实现单例
singleton_implementation(BookInfosHandle)
// 懒加载
- (NSMutableArray *)bookInfosArray {
    if (!_bookInfosArray) {
        _bookInfosArray = [NSMutableArray array];
    }
    return _bookInfosArray;
}
// 配置列表相关数据源的操作接口
// url地址  反馈结果
- (void)getMusicInfoWithUrl:(NSString *)urlString
                 completion:(Completion)completion {
    // 网络请求
    [NetWorkRequestManager requestType:RequestTypeGet urlString:urlString prama:nil success:^(id data) {
        NSError *error = nil;
        // 生成存储data的plist文件路径
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileNamePath = [filePath stringByAppendingPathComponent:@"BookInfos.plist"];
        BOOL result = [data writeToFile:fileNamePath options:NSDataWritingAtomic error:&error];
        if (result && !error) {
            NSArray *resultArray = [NSArray arrayWithContentsOfFile:fileNamePath];
            // 每一次处理数据源时要考虑是添加还是覆盖
            [self.bookInfosArray removeAllObjects];
            // 将数组中的数据生成musicInfo的对象
            for (NSDictionary *dic in resultArray) {
                BookList *info = [[BookList alloc] init];
                [info setValuesForKeysWithDictionary:dic];
                [self.bookInfosArray addObject:info];
            }
            
        } else {
            NSLog(@"数据写入失败  %@", error);
        }
        // 将数据反馈
        if (completion) {
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(_bookInfosArray, error);
            });
        }
    } fail:^(NSError *error) {
        if (completion) {
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }];
}

// 获取分组个数
- (NSInteger)numberOfSections {
    return 1;
}

// 获取指定分组行数
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return self.bookInfosArray.count;
}
// 获取某个分区下某行的booklistinfo
- (BookList *)musicInfoForRowInIndexPath:(NSIndexPath *)indexPath {
    return self.bookInfosArray[indexPath.row];
}
#pragma mark - 配置播放音乐数据源相关操作
// 上一首数据源
- (BookList *)musicInfoPreviousWithIndex:(NSInteger *)index {
    if (*index == 0) {
        *index = self.bookInfosArray.count - 1;
        return self.bookInfosArray[*index];
    }
    (*index)--;
    NSLog(@"上一首index = %ld", *index);
    return self.bookInfosArray[*index];
    
}

// 下一首数据源
- (BookList *)musicInfoNextWithIndex:(NSInteger *)index {
    if (*index == self.bookInfosArray.count - 1) {
        *index = 0;
        return self.bookInfosArray[0];
    }
    (*index)++;
    NSLog(@"下一首index = %ld", *index);
    return self.bookInfosArray[*index];
    
}



@end
