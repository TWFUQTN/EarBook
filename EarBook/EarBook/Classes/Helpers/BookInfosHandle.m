//
//  BookInfosHandle.m
//  EarBook
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookInfosHandle.h"
#import "DocumentsHandle.h"
@interface BookInfosHandle ()

@end

@implementation BookInfosHandle

// 实现单例
singleton_implementation(BookInfosHandle)
//BookInfoHandle的单例
#define kDocumentsHandle [DocumentsHandle sharedocumentsHandle]
// 懒加载
- (NSMutableArray *)bookInfosArray {
    if (!_bookInfosArray) {
        _bookInfosArray = [NSMutableArray array];
    }
    
    return _bookInfosArray;
}
- (NSMutableArray *)bookCrentlyArray {
    if (!_bookCrentlyArray) {
        _bookCrentlyArray = [ NSMutableArray array];
    }
    return _bookCrentlyArray;
}
- (NSMutableArray *)bookLikeArray {
    if (!_bookLikeArray) {
        _bookLikeArray = [NSMutableArray array];
    }
    return _bookLikeArray;
}
#pragma mark - 配置播放音乐数据源相关操作
// 上一首数据源
- (BookList *)bookInfoPreviousWithIndex:(NSInteger *)index {
    if (*index == 0) {
        *index = self.bookInfosArray.count - 1;
        _indexout = *index;
        return self.bookInfosArray[*index];
    }
    (*index)--;
    NSLog(@"上一首index = %ld", *index);
    _indexout = *index;
    return self.bookInfosArray[*index];
    
}

// 下一首数据源
- (BookList *)bookInfoNextWithIndex:(NSInteger *)index {
    if (*index == self.bookInfosArray.count - 1) {
        *index = 0;
        _indexout = *index;
        return self.bookInfosArray[0];
        
    }
    (*index)++;
    NSLog(@"下一首index = %ld", *index);
    _indexout = *index;
    return self.bookInfosArray[*index];
}
//获取当前时间
- (void)getNowDate {
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    _nowDate =[dateformatter stringFromDate:senddate];
    NSDate *localDate = [NSDate date]; //获取当前时间
    _allSecond = [localDate timeIntervalSince1970];
}





@end
