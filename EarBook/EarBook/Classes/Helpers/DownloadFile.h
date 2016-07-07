//
//  DownloadFile.h
//  EarBook
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
#import "Singleton.h"

@class BookList;
@class BookMP3;

//typedef void(^DownloadFileBlock)(NSString *str);

@interface DownloadFile : NSObject

//@property (nonatomic, copy) DownloadFileBlock block;

@property (nonatomic, assign) NSProgress *progress;

singleton_interface(DownloadFile)
/**
 * 下载文件
 *
 * @param string urlString 请求文件地址
 */
- (void)downloadWithBookList:(BookList *)bookList
                        Book:(BookMP3 *)book
                        User:(AVUser *)user;

@end
