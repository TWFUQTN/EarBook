//
//  Book.h
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, copy) NSString *ID;

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

@end
