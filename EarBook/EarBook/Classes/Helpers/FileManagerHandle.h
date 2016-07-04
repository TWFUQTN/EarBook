//
//  FileManagerHandle.h
//  DouBan
//
//  Created by lanou3g on 16/6/21.
//  Copyright © 2016年 yyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManagerHandle : NSObject
#pragma mark - 计算单个文件大小
+(float)fileSizeAtPath:(NSString *)path;

#pragma mark - 计算目录大小
+(float)folderSizeAtPath:(NSString *)path;

#pragma mark - 清理文件
+(void)clearCache:(NSString *)path;

@end
