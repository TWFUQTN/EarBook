//
//  DocumentsHandle.h
//  EarBook
//
//  Created by lanou3g on 16/7/2.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookMP3.h"
#import "BookList.h"
#import "Singleton.h"
#import "BaseModel.h"
@interface DocumentsHandle : NSObject
//booklist 对象
@property (nonatomic, strong)BookList *bookList;
//传进来list的数组
@property (nonatomic, strong)NSMutableArray *listArray;
//bookMp3 对象
@property (nonatomic, strong)BookMP3 *bookInformation;
//最近播放数组
@property (nonatomic, strong)NSMutableArray *recentlyArray;
//收藏的的数组
@property (nonatomic, strong)NSMutableArray *likeArray;


//声明单列
singleton_interface(DocumentsHandle)
//创建最近播放表
- (void)createRecentTable;
//读写更改最近播放记录
- (NSMutableArray *)recentlyTableWithBookID:(NSString *)ID index:(NSInteger )index second:(NSInteger)second value:(CGFloat)value;
//删除最近播放的书籍
- (NSMutableArray *)recentlyTableDeteleWithBookID:(NSString *)ID;
//传出一个数组
- (NSMutableArray *)getArrayFromRcentlyTable;
//创建最近播放表
- (void)createLikeTable;
//创建喜欢收藏表
- (NSMutableArray *)likeTableWithBookID:(NSString *)ID index:(NSInteger )index second:(NSInteger)second value:(CGFloat)value;
//删除喜欢播放的书籍
- (NSMutableArray *)likeTableDeteleWithBookID:(NSString *)ID;
//传出一个喜欢数组
- (NSMutableArray *)getArrayFromLikeTable;

@end
