//
//  VoiceProgram.h
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceProgram : NSObject

/// 主播
@property (nonatomic, copy) NSString *announcer;
/// 作者
@property (nonatomic, copy) NSString *author;
/// 图片
@property (nonatomic, copy) NSString *cover;
/// 简介
@property (nonatomic, copy) NSString *Description;
/// id
@property (nonatomic, copy) NSString *ID;
/// 名字
@property (nonatomic, copy) NSString *name;
/// 播放数量
@property (nonatomic, copy) NSString *playCount;
/// 集数
@property (nonatomic, copy) NSString *sections;
/// 类型名
@property (nonatomic, copy) NSString *typeName;
/// 更新时间
@property (nonatomic, copy) NSString *updateTime;

@end
