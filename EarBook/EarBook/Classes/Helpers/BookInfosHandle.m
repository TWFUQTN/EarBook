//
//  BookInfosHandle.m
//  EarBook
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookInfosHandle.h"

@interface BookInfosHandle ()



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
#pragma mark - 配置播放音乐数据源相关操作
// 上一首数据源
- (BookList *)bookInfoPreviousWithIndex:(NSInteger *)index {
    if (*index == 0) {
        *index = self.bookInfosArray.count - 1;
        return self.bookInfosArray[*index];
    }
    (*index)--;
    NSLog(@"上一首index = %ld", *index);
    return self.bookInfosArray[*index];
    
}

// 下一首数据源
- (BookList *)bookInfoNextWithIndex:(NSInteger *)index {
    if (*index == self.bookInfosArray.count - 1) {
        *index = 0;
        return self.bookInfosArray[0];
    }
    (*index)++;
    NSLog(@"下一首index = %ld", *index);
    return self.bookInfosArray[*index];
    
}

@end
