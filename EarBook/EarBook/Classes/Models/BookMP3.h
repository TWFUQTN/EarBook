//
//  BookMP3.h
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookMP3 : NSObject<NSCoding>

#pragma mark - 书籍详情
/// 主播
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

@end
