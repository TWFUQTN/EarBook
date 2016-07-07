//
//  DownloadFile.m
//  EarBook
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "DownloadFile.h"
#import "BookList.h"
#import "BookMP3.h"
#import "DownloadModel.h"

@implementation DownloadFile

singleton_implementation(DownloadFile)

#pragma mark - 下载
- (void)downloadWithBookList:(BookList *)bookList
                        Book:(BookMP3 *)book
                        User:(AVUser *)user
{
    //下载
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSURL *URL = [NSURL URLWithString:bookList.path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%@", downloadProgress);
        
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        // 下载到沙盒的位置
        NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:[response suggestedFilename]];
//        NSLog(@"documentsDirectoryURL = %@", documentsDirectoryURL);
        
        // 将NSURL转为NSString
        NSString *documentsPath = [[documentsDirectoryURL absoluteString] substringFromIndex:7];
        
        [weakSelf saveToleanCloudWithdocumentsPath:documentsPath BookList:bookList Book:book User:user ClassName:@"DownloadBook"];
        
        return documentsDirectoryURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    //重新开始下载
    [downloadTask resume];
}

#pragma mark - 保存在云端数据库
- (void)saveToleanCloudWithdocumentsPath:(NSString *)documentsPath
                                BookList:(BookList *)bookList
                                    Book:(BookMP3 *)book
                                    User:(AVUser *)user
                               ClassName:(NSString *)className
{
    AVObject *downloadBook = [[AVObject alloc] initWithClassName:className];// 构建对象
    [downloadBook setObject:user.username forKey:@"username"];// 设置名字
    
//    NSData *DBookList = [self archiverWithObject:bookList Key:@"bookList"];
//    NSData *DBook = [self archiverWithObject:book Key:@"book"];
//    
//    [downloadBook setObject:DBookList forKey:@"bookList"];// 设置bookList
//    [downloadBook setObject:DBook forKey:@"book"];// 设置book
    
    [downloadBook setObject:book.name forKey:@"bookName"];// 设置书籍名
    [downloadBook setObject:bookList.name forKey:@"bookListName"];// 设置书籍列表名
    [downloadBook setObject:book.ID forKey:@"ID"];// 设置书籍ID
    [downloadBook setObject:book.url forKey:@"url"]; // 设置书籍的URL
    [downloadBook setObject:documentsPath forKey:@"path"];// 设置存储路径
    
    [downloadBook saveInBackground];// 保存到云端
}

#pragma mark - 从云端数据库获取数据
- (NSMutableArray *)queryData
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    AVUser *currentUser = [AVUser currentUser];
    
    AVQuery *query = [AVQuery queryWithClassName:@"DownloadBook"];
    [query whereKey:@"username" equalTo:currentUser.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for (AVObject *oneObject in objects) {
                
                DownloadModel *downloadModel = [DownloadModel new];
                
                downloadModel.bookName = [oneObject objectForKey:@"bookName"];
                downloadModel.bookListName = [oneObject objectForKey:@"bookListName"];
                downloadModel.ID = [oneObject objectForKey:@"ID"];
                downloadModel.path = [oneObject objectForKey:@"path"];
                
                downloadModel.downloadTime = oneObject.createdAt;
                
                [dataArray addObject:downloadModel];
                
            }
        }
    }];
    
    return dataArray;
}

#pragma mark - 归档
- (NSData *)archiverWithObject:(id)object
                           Key:(NSString *)key
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    
    return data;
}







@end
