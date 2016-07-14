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
#import "BaseModel.h"
#import <AVOSCloud.h>
#import "AVPlayerManager.h"
// 获取数据源接口的反馈结果

@interface BookInfosHandle : NSObject
// 存放所有book信息的数组
@property (nonatomic, strong) NSMutableArray *bookInfosArray;
//Book 信息
@property (nonatomic, strong) BookMP3 * bookMP3;
//book index
@property (nonatomic, assign) NSInteger indexout;
//最近列表
@property (nonatomic, strong) NSMutableArray *bookCrentlyArray;
//喜欢收藏
@property (nonatomic, strong) NSMutableArray *bookLikeArray;
//当前的时间
@property (nonatomic, strong) NSString *nowDate;
//时间戳
@property (nonatomic, assign) NSInteger allSecond;
//当前书籍是否被收藏
@property (nonatomic, assign) BOOL isCollected;

// 声明单例
singleton_interface(BookInfosHandle)

#pragma mark - 配置播放音乐数据源相关操作
// 上一首数据源
- (BookList *)bookInfoPreviousWithIndex:(NSInteger *)index;

// 下一首数据源
- (BookList *)bookInfoNextWithIndex:(NSInteger *)index;
// 点击第几集数
- (BookList *)bookInfoWithIndex:(NSInteger *)index;
//获取当前时间及其时间戳
- (void)getNowDate;
#pragma mark - 最近播放写入转换成AVObject
- (void)recentlyBookToAVObject;
#pragma mark - 最近播放AVObject转换成转换成NBAseModel
- (BaseModel *)recentlyAVObjectToNews:(AVObject *)object ;
#pragma mark - 搜藏写入转换成AVObject
//- (void)likeBookToAVObject;
#pragma mark - 搜藏AVObject转换成转换成NBAseModel
- (BaseModel *)likeAVObjectToNews:(AVObject *)object;


#pragma mark - 从like表中获取所有数据
- (void)selectAllFromLikeBooksTable;
#pragma mark - 从like表中获取数据
-(void)selectFromLikeBooksTable;
#pragma mark - 收藏
- (void)likeItemAction;

@end
