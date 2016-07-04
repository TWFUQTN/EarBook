//
//  DocumentsHandle.m
//  EarBook
//
//  Created by lanou3g on 16/7/2.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "DocumentsHandle.h"
// 引入框架，引入支持类库(libsqlite3.0)
#import <FMDB.h>
@interface DocumentsHandle()


#pragma mark - 书籍详情

/*/// 主播
@property (nonatomic, copy) NSString *announcer;

/// 作者
@property (nonatomic, copy) NSString *author;

/// 图片
@property (nonatomic, copy) NSString *cover;

/// 书籍名称
@property (nonatomic, copy) NSString *name;

/// 类型
@property (nonatomic, copy) NSString *type;

/// 集数
@property (nonatomic, copy) NSString *sections;

/// 内容简介
@property (nonatomic, copy) NSString *desc;

/// 播放次数
@property (nonatomic, copy) NSString *play;

/// 更新时间
@property (nonatomic, copy) NSString *update;

/// 状态 1为连载，2为完结
@property (nonatomic, copy) NSString *state;

#pragma mark - 书籍推荐

/// url
@property (nonatomic, copy) NSString *url;
/// 原因叙述
@property (nonatomic, copy) NSString *reason;
/// id
@property (nonatomic, copy) NSString *ID;
///
@property (nonatomic, copy) NSString *publishType;

// list~


/// 名字
@property (nonatomic, copy) NSString *listname;

/// 音频地址
@property (nonatomic, copy) NSString *path;

/// id
@property (nonatomic, copy) NSString *listID;

/// 集数
@property (nonatomic, copy) NSString *section;

/// 大小
@property (nonatomic, copy) NSString *size;

*/
/// 声明数据库对象
@property (nonatomic, strong)FMDatabase *dataBase;
/// 数据库存储路径
@property (nonatomic, copy)NSString *filePath;

@end

@implementation DocumentsHandle

singleton_implementation(DocumentsHandle)
- (NSMutableArray *)recentlyArray{
    if (!_recentlyArray) {
        _recentlyArray = [NSMutableArray array];
    }
    return _recentlyArray;
}
- (NSMutableArray *)likeArray {

    if (!_likeArray) {
        _likeArray = [NSMutableArray array];
    }
    return _likeArray;
}
//创建最近播放表
- (void)createRecentTable {
    // 创建数据库
    // 1、找到数据库存储路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.filePath = [document stringByAppendingPathComponent:@"recentlyBooks.sqlite"];
    // 2、使用路径初始化FMDB对象
    self.dataBase = [FMDatabase databaseWithPath:self.filePath];
    // 3、判断数据库是否打开，打开时才执行sql语句
    if ([self.dataBase open]) {
        // 1、创建建表sql语句
        NSString *createSql = @"create table if not exists recentlyBook(ID text not null, index integer not null, time integer not null, value double not null)";
        BOOL result = [self.dataBase executeUpdate:createSql];
        if (result) {
            NSLog(@"建表成功");
        } else {
            NSLog(@"建表失败 %d", result);
            }
        }
    // 关闭数据库
    [self.dataBase close];
}
//读写更改最近播放记录
- (NSMutableArray *)recentlyTableWithBookID:(NSString *)ID index:(NSInteger )index second:(NSInteger)second value:(CGFloat)value {
    // 1、打开数据库
    [self.dataBase open];
    // 2、进行相关操作
    NSString *insertSql = @"insert into recentlyBook(ID, index, time, value) values (?, ?, ?, ?)";
    BOOL result = [self.dataBase executeUpdate:insertSql, ID, index , second, value];
    if (result) {
        NSLog(@"添加成功");
        return [self getArrayFromRcentlyTable];
    }
    else {
        NSString *updateSql = @"update recentlyBook set index = ?, time = ?, value = ?  where ID = ?";
    BOOL updateResult = [self.dataBase executeUpdate:updateSql, index, second, value, ID];
        if (updateResult) {
            NSLog(@"跟新成功");
            return [self getArrayFromRcentlyTable];
        } else {
            NSLog(@"更新失败 %d", updateResult);
        }
    }

    // 关闭数据库
    [self.dataBase close];
    return nil;
}
//删除最近播放的书籍
- (NSMutableArray *)recentlyTableDeteleWithBookID:(NSString *)ID {
    // 打开数据库
    [self.dataBase open];
    BOOL result = [self.dataBase executeUpdate:@"delete from recentlyBook where ID = ?", ID];
    if (result) {
        NSLog(@"删除成功");
        return [self getArrayFromRcentlyTable];
    } else {
        NSLog(@"删除失败 %d", result);
    }
    // 关闭数据库
    [self.dataBase close];
    return nil;
    
}


//创建喜欢收藏播放表
- (void)createLikeTable {
    // 创建数据库
    // 1、找到数据库存储路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.filePath = [document stringByAppendingPathComponent:@"likeBooks.sqlite"];
    // 2、使用路径初始化FMDB对象
    self.dataBase = [FMDatabase databaseWithPath:self.filePath];
    // 3、判断数据库是否打开，打开时才执行sql语句
    if ([self.dataBase open]) {
        // 1、创建建表sql语句
        NSString *createSql = @"create table if not exists likeBook(ID text not null, index integer not null, time integer not null, value double not null)";
        BOOL result = [self.dataBase executeUpdate:createSql];
        if (result) {
            NSLog(@"建表成功");
        } else {
            NSLog(@"建表失败 %d", result);
        }
    }
    // 关闭数据库
    [self.dataBase close];
}

//添加喜欢收藏表
- (NSMutableArray *)likeTableWithBookID:(NSString *)ID index:(NSInteger )index second:(NSInteger)second value:(CGFloat)value {
    // 1、打开数据库
    [self.dataBase open];
    // 2、进行相关操作
    NSString *insertSql = @"insert into likeBook(ID, index, time, value) values (?, ?, ?, ?)";
    BOOL result = [self.dataBase executeUpdate:insertSql, ID, index , second, value];
    if (result) {
        NSLog(@"添加成功");
        return [self getArrayFromLikeTable];
    }
    else {
        NSString *updateSql = @"update likeBook set index = ?, time = ?, value = ?  where ID = ?";
        BOOL updateResult = [self.dataBase executeUpdate:updateSql, index, second, value, ID];
        if (updateResult) {
            NSLog(@"跟新成功");
            return [self getArrayFromLikeTable];
        } else {
            NSLog(@"更新失败 %d", updateResult);
        }
    }
    // 关闭数据库
    [self.dataBase close];
    return nil;

}

//删除喜欢的书籍
- (NSMutableArray *)likeTableDeteleWithBookID:(NSString *)ID {
    // 打开数据库
    [self.dataBase open];
    BOOL result = [self.dataBase executeUpdate:@"delete from likeBook where ID = ?", ID];
    if (result) {
        NSLog(@"删除成功");
        [self getArrayFromLikeTable];
    } else {
        NSLog(@"删除失败 %d", result);
    }
    // 关闭数据库
    [self.dataBase close];
    return nil;
}
//传出一个数组
- (NSMutableArray *)getArrayFromRcentlyTable{
    // 接收查询结果的类 -- FMResultSet
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *resultSet = [self.dataBase executeQuery:@"select * from recentlyBook"];
    if (resultSet) {
        // 遍历出需要的结果内容
        while ([resultSet next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *ID = [resultSet stringForColumn:@"ID"];
            NSInteger index = [resultSet intForColumn:@"index"];
            NSInteger second = [resultSet intForColumn:@"time"];
            CGFloat value = [resultSet doubleForColumn:@"value"];
            [dic setObject:ID forKey:@"ID"];
            [dic setObject:[NSNumber numberWithInteger:index] forKey:@"index"];
            [dic setObject:[NSNumber numberWithInteger:second] forKey:@"time"];
            [dic setObject:[NSNumber numberWithFloat:value] forKey:@"value"];
            [array addObject:dic];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"ID" : ID, @"index" : index, @"time" :second ,@"value" : value}];
        }
    } else {
        NSLog(@"查询失败");
    }
    return array;
}
- (NSMutableArray *)getArrayFromLikeTable {

    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *resultSet = [self.dataBase executeQuery:@"select * from likeBook"];
    if (resultSet) {
        // 遍历出需要的结果内容
        while ([resultSet next]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *ID = [resultSet stringForColumn:@"ID"];
            NSInteger index = [resultSet intForColumn:@"index"];
            NSInteger second = [resultSet intForColumn:@"time"];
            CGFloat value = [resultSet doubleForColumn:@"value"];
            [dic setObject:ID forKey:@"ID"];
            [dic setObject:[NSNumber numberWithInteger:index] forKey:@"index"];
            [dic setObject:[NSNumber numberWithInteger:second] forKey:@"time"];
            [dic setObject:[NSNumber numberWithFloat:value] forKey:@"value"];
            [array addObject:dic];
            //            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"ID" : ID, @"index" : index, @"time" :second ,@"value" : value}];
        }
    } else {
        NSLog(@"查询失败");
    }
    return array;

}
//
//NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//
//NSLog(@"document %@", document);
//self.filePath = [document stringByAppendingPathComponent:@"Recently.sqlite"];
//
//// 创建对象
//NSFileManager *manager = [NSFileManager defaultManager];
//
//NSError *error = nil;
//
//// 创建文件夹
//BOOL success = [manager fileExistsAtPath:_filePath];
//
//if (!success) {
//    // 2、使用路径初始化FMDB对象
//    self.dataBase = [FMDatabase databaseWithPath:self.filePath];
//    // 3、判断数据库是否打开，打开时才执行sql语句
//    if ([self.dataBase open]) {
//        // 1、创建建表sql语句
//        NSString *createSql = @"create table if not exists t_student(id integer primary key autoincrement not null, name text not null, age integer not null, sex text not null)";
//        BOOL result = [self.dataBase executeUpdate:createSql];
//        if (result) {
//            NSLog(@"建表成功");
//        } else {
//            NSLog(@"建表失败 %d", result);
//        }
//    }
//    // 关闭数据库
//    [self.dataBase close];
//}


@end
