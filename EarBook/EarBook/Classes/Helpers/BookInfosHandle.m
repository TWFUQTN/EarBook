//
//  BookInfosHandle.m
//  EarBook
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookInfosHandle.h"
#import "EB_URL.h"

@interface BookInfosHandle ()

@end

@implementation BookInfosHandle

// 实现单例
singleton_implementation(BookInfosHandle)
//BookInfoHandle的单例
#define kDocumentsHandle [DocumentsHandle shareDocumentsHandle]
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
    _bookCrentlyArray = nil;
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
    _bookCrentlyArray = nil;
    return self.bookInfosArray[*index];
    
    }
// 点击第几集数
- (BookList *)bookInfoWithIndex:(NSInteger *)index {

    _indexout = *index;
    _bookCrentlyArray = nil;
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
#pragma mark - 最近播放写入
- (void)recentlyBookToAVObject{
    if ([AVUser currentUser]) {
        BookList *list =  _bookInfosArray[_indexout];
        NSMutableArray * currentArray = [NSMutableArray array];
        NSString *CQLString = [NSString stringWithFormat:@"select * from %@ where username = %@ and booKID = %@",@"recently",[AVUser currentUser].username,_bookMP3.ID];
        [AVQuery doCloudQueryInBackgroundWithCQL:CQLString callback:^(AVCloudQueryResult *result, NSError *error) {
            if (!error) {
                NSString *CQLUpdteString =[NSString stringWithFormat:@"update recently set index = %@ and bookMP3URL = %@ and bookMP3Name= %@ and listArray = %@ where username = %@ and booKID = %@",[NSString stringWithFormat:@"%ld",_indexout],list.path,list.name,_bookInfosArray,[AVUser currentUser].username,_bookMP3.ID];
                      [AVQuery doCloudQueryInBackgroundWithCQL:CQLUpdteString callback:^(AVCloudQueryResult *result, NSError *error) {
                         if (!error) {
                           NSLog(@"更新成功");
                              }
                         else{
                           NSLog(@"更新失败");
                           }
                            }];
                                 }
         else{
//             bookID;
//              index;
//             bookImageURL;
//                     ;
//             bookMP3URL;
//             bookAnnouncer;
//             listArray;
//             bookMP3Name;

             NSString *CQLInsertString =[NSString stringWithFormat:@"insert into recently (username,bookID,index,bookImageURL,bookName) values()",_indexout,list.path,list.name,_bookInfosArray,[AVUser currentUser].username,_bookMP3.ID];
     
             [AVQuery doCloudQueryInBackgroundWithCQL:@"insert into TodoFolder(name, priority) values('工作', 1) " callback:^(AVCloudQueryResult *result, NSError *error) {
                 // 如果 error 为空，说明保存成功
                 
             }];
                
                
                
            }
            
        }];
        _bookCrentlyArray = currentArray;
        
    }
    AVObject *ob = [[AVObject alloc] initWithClassName:@"recently"];
    [ob setObject:_bookMP3.ID forKey:@"bookID"];
    [ob setObject:_bookMP3.name forKey:@"bookName"];
    [ob setObject:_bookMP3.cover forKey:@"bookImageURL"];
    [ob setObject:[AVUser currentUser].username forKey:@"username"];
    [ob setObject:[NSString stringWithFormat:@"%ld",_indexout] forKey:@"index"];
    [ob saveInBackground];
}

#pragma mark - 最近播放AVObject转换成转换成NBAseModel
- (BaseModel *)recentlyAVObjectToNews:(AVObject *)object {
    BaseModel *baseModel = [[BaseModel alloc] init];
    baseModel.bookID = [object objectForKey:@"bookID"];
    baseModel.bookName = [object objectForKey:@"bookName"];
    baseModel.bookImageURL = [object objectForKey:@"bookImageURL"];
    baseModel.index = [[object objectForKey:@"index"] integerValue];
    baseModel.bookDate = [object objectForKey:@"updatedAt"];
    baseModel.bookMP3URL = [object objectForKey:@"bookMP3URL"];
    baseModel.listArray = [object objectForKey:@"listArray"];
    baseModel.bookMP3Name = [object objectForKey:@"bookMP3Name"];
    baseModel.bookAnnouncer = [object objectForKey:@"bookAnnouncer"];
    return baseModel;
}
#pragma mark - 从最近播放表中获取数据
- (void)selectFromRecentlyTable{
    if ([AVUser currentUser]) {
        NSMutableArray * currentArray = [NSMutableArray array];
        NSString *CQLString = [NSString stringWithFormat:@"select * from %@ where username = %@",@"recently",[AVUser currentUser].username];
        [AVQuery doCloudQueryInBackgroundWithCQL:CQLString callback:^(AVCloudQueryResult *result, NSError *error) {
            if (!error) {
                for (AVObject *obj in result.results) {
                   BaseModel *model = [self recentlyAVObjectToNews:obj];
                    [currentArray addObject:model];
                }
            }else{
                NSLog(@"%@",error);
            }
        }];
        _bookCrentlyArray = currentArray;
    }
}

#pragma mark - 收藏AVObject转换成转换成NBAseModel
- (BaseModel *)likeAVObjectToNews:(AVObject *)object {
    BaseModel *baseModel = [[BaseModel alloc] init];
    baseModel.bookID = [object objectForKey:@"bookID"];
    baseModel.bookName = [object objectForKey:@"bookName"];
    baseModel.bookImageURL = [object objectForKey:@"bookImageURL"];
    baseModel.bookDate = [object objectForKey:@"updatedAt"];
    return baseModel;
}
#pragma mark - 收藏
- (void)likeAddBook{
    if ([AVUser currentUser]) {
        AVObject *ob = [[AVObject alloc] initWithClassName:@"like"];
        [ob setObject:_bookMP3.ID forKey:@"bookID"];
        [ob setObject:_bookMP3.name forKey:@"bookName"];
        [ob setObject:_bookMP3.cover forKey:@"bookImageURL"];
        [ob setObject:[AVUser currentUser].username forKey:@"username"];
        [ob saveInBackground];
    }
}
//- (void)loadData
//{
//    AVUser *currentUser = [AVUser currentUser];
//    
//    AVQuery *query = [AVQuery queryWithClassName:@"DownloadBook"];
//    [query whereKey:@"username" equalTo:currentUser.username];
//    
//    __weak typeof(self)downloadVC = self;
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        if (!error) {
//            for (AVObject *oneObject in objects) {
//                
////                DownloadModel *downloadModel = [DownloadModel new];
////                
////                // 从云端取出数据
////                downloadModel.bookName = [oneObject objectForKey:@"bookName"];
////                downloadModel.bookListName = [oneObject objectForKey:@"bookListName"];
////                downloadModel.ID = [oneObject objectForKey:@"ID"];
////                downloadModel.url = [oneObject objectForKey:@"url"];
////                downloadModel.path = [oneObject objectForKey:@"path"];
////                downloadModel.cover = [oneObject objectForKey:@"cover"];
////                downloadModel.downloadTime = oneObject.createdAt;
////                
////                [downloadVC.downloadPathArray addObject:downloadModel];
//                
//            }
//            
////            [downloadVC.tableView reloadData];
//        }
//    }];
//}
#pragma mark - 从like表中获取数据
- (void)selectAllFromLikeBooksTable{
    NSMutableArray *array = [NSMutableArray array];
    AVQuery *query = [AVQuery queryWithClassName:@"like"];
    [query whereKey:@"username" equalTo:[AVUser currentUser].username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 操作成功
            for (AVObject *object in objects) {
                BaseModel *model = [[BaseModel alloc]init];
                model.bookID = [object objectForKey:@"bookID"];
                model.bookImageURL = [object objectForKey:@"bookImageURL"];
                model.bookName = [object objectForKey:@"bookName"];
                [array addObject:model];
            }
        }
        else{
            NSLog(@"%@",error);
        }
    }];
        _bookLikeArray = array;
}
#pragma mark - 从like表中获取数据判断是否收藏
-(void)selectFromLikeBooksTable {
    if ([AVUser currentUser]) {
        AVQuery *query = [AVQuery queryWithClassName:@"like"];
        [query whereKey:@"username" equalTo:[AVUser currentUser].username];
        [query whereKey:@"bookName" equalTo:_bookMP3.name];
        __weak typeof(self)weakSelf = self;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            NSArray<AVObject *> *priorityEqualsZeroTodos = objects;// 符合 priority = 0 的 Todo 数组
            if (!error) {
                weakSelf.isCollected = YES;
            }
            else{
                weakSelf.isCollected = NO;
            }
        }];
    }
}
#pragma mark - 收藏
- (void)likeItemAction {
    __weak typeof(self)weakSelf = self;

    if ([AVUser currentUser]) {
        if (self.isCollected == YES) {
            // 删除逻辑

            NSString *CQL = [NSString stringWithFormat:@"delete from like where username = %@ and bookName = %@",[AVUser currentUser].username,_bookMP3.name];
               [AVQuery doCloudQueryInBackgroundWithCQL:CQL callback:^(AVCloudQueryResult *result, NSError *error) {
              // 如果 error 为空，说明删除成功
               if (!error) {
              weakSelf.isCollected = NO;
                   NSLog(@"删除成功");

                 } else {
                    NSLog(@"~~~~~~error = %@", error);
              }
            }];
                }
        else{
            AVObject *todo = [AVObject objectWithClassName:@"like"];
            [todo setObject:[AVUser currentUser].username forKey:@"username"];
            [todo setObject:_bookMP3.name forKey:@"bookName"];
            [todo setObject:_bookMP3.ID forKey:@"bookID"];
            [todo setObject:_bookMP3.cover forKey:@"bookImageURL"];
            [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // 存储成功
                    weakSelf.isCollected = YES;

                    NSLog(@"%@",todo.objectId);// 保存成功之后，objectId 会自动从云端加载到本地
                } else {
                    NSLog(@"存储失败")
                    // 失败的话，请检查网络环境以及 SDK 配置是否正确
                }
            }];
        }
    }
}
@end
