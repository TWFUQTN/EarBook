//
//  AVPlayerManager.h
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"


@protocol AVPlayerManagerDelegate <NSObject>

// 当AVPlayer播放时间不断改变时 反馈
- (void)changeTime:(CGFloat)time;
// 当播放完成时反馈
- (void)playDidFinished;

@end

// 使用枚举进行状态的记录
typedef NS_ENUM(NSUInteger, AVPlayerManagerStatus) {
    isPlaying, // 正在播放
    isPaused,  // 暂停播放
    isStoped,  // 停止播放
};

typedef NS_ENUM(NSUInteger, LoopMode) {
    LoopModeOrderMode,   // 顺序
    LoopModeSingleMond,  // 单曲循环
    LoopModeRandomMode,  // 随机
};

@interface AVPlayerManager : NSObject
/// 代理
@property (nonatomic, weak) id<AVPlayerManagerDelegate> delegate;
/// 音乐播放状态
@property (nonatomic, assign) AVPlayerManagerStatus status;
/// 音量
@property (nonatomic, assign) CGFloat volume;
/// 播放模式
@property (nonatomic, assign) LoopMode loopMode;
/// 上一首歌曲index
@property (nonatomic, assign) CGFloat index;
// 声明单例
singleton_interface(AVPlayerManager)

// 当前想要播放的音乐
- (void)playWithUrl:(NSString *)urlString
       currentIndex:(NSInteger)currentIndex;

// 播放音乐
- (void)play;

// 暂停
- (void)pause;

// 跳到指定位置播放
- (void)seekToTime:(CGFloat)time;
@end
