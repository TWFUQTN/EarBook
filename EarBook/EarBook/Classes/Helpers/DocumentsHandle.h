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
@interface DocumentsHandle : NSObject
//booklist 对象
@property (nonatomic, strong)BookList *bookList;
//传进来list的数组
@property (nonatomic, strong)NSMutableArray *listArray;
//bookMp3 对象
@property (nonatomic, strong)BookMP3 *bookInformation;
//最近播放数组
@property (nonatomic, strong)NSMutableArray *currentlyArray;
//收藏的的数组
@property (nonatomic, strong)NSMutableArray *likeArray;


//声明单列
singleton_interface(documentsHandle)

//创建表
- (void)createRecentlyTable;
//

@end
