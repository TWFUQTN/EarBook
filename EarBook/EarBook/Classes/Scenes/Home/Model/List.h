//
//  List.h
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject

#pragma mark - 书籍列表
/// 列表名字
@property (nonatomic, copy) NSString *name;
/// 拼地址的URL
@property (nonatomic, copy) NSString *url;
/// 列表数组
@property (nonatomic, strong) NSArray *list;
/// 列表类型
@property (nonatomic, copy) NSString *type;

#pragma mark - 榜单
/// 榜单列表
@property (nonatomic, copy) NSArray *bookList;
/// 榜单名字
@property (nonatomic, copy) NSString *rankName;
/// 榜单类型
@property (nonatomic, copy) NSString *rankType;

@end
