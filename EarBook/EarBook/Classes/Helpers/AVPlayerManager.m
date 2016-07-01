//
//  AVPlayerManager.m
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "AVPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerManager ()

@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
@implementation AVPlayerManager
singleton_implementation(AVPlayerManager)

- (instancetype)init {
    if (self = [super init]) {
        // 设置播放的初始状态
        self.status = isStoped;
        // 使用通知中心监听播放状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        // 创建定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        // 主线程runloop默认开启
        // 子线程runloop默认关闭（此时不能监听事件，是无效的）
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        // 定时器默认暂停
        _timer.fireDate = [NSDate distantFuture];
        self.volume = 0.5;
        self.index = -1;
    }
    return self;
}

// 播放结束时执行的方法
- (void)playerItemDidPlayFinished {
    if ([_delegate respondsToSelector:@selector(playDidFinished)]) {
        [_delegate playDidFinished];
    }
}
// 定时
- (void)timerAction:(NSTimer *)timer {
    if ([_delegate respondsToSelector:@selector(changeTime:)]) {
        // 传回当前的播放时间
        // 使用CMTime.value / timescale(时间的单位) = seconds  得到秒
        CGFloat time = _avPlayer.currentTime.value / _avPlayer.currentTime.timescale;
        [_delegate changeTime:time];
    }
}

// 当前想要播放的书籍
- (void)playWithUrl:(NSString *)urlString
       currentIndex:(NSInteger)currentIndex {
    if (self.index == currentIndex) {
        self.index = currentIndex;
        return;
    }
    // 创建一个音乐播放的item
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
    if (!_avPlayer) {
        // 创建新的进行播放
        _avPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        _avPlayer.volume = 0.5;
        
    } else {
        // 替换当前播放item
        [_avPlayer replaceCurrentItemWithPlayerItem:playerItem];
        
    }
    // 播放
    
    [self play];
    
    self.index = currentIndex;
}
//当前播放书籍的时长

// 播放音乐
- (void)play {
    [_avPlayer play];
    // 开启定时器
    _timer.fireDate = [NSDate distantPast];
    // 改变播放状态
    _status = isPlaying;
    
    
}

// 暂停
- (void)pause {
    [_avPlayer pause];
    // 暂停定时器
    _timer.fireDate = [NSDate distantFuture];
    self.status = isPaused;
}

// 跳到指定位置播放
- (void)seekToTime:(CGFloat)time {
    // value = seconds * timescale
    [_avPlayer seekToTime:CMTimeMake(time *   _avPlayer.currentTime.timescale, _avPlayer.currentTime.timescale)];
}

// 改变音量 (用户滑动slider操作，使用set方法)
- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    _avPlayer.volume = _volume;
}
- (CGFloat)getMp3TimeOfurl:(NSString *)urlString {
//   _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:urlString] error:nil ];
//    NSLog(@"%@",_audioPlayer);
//    
//   return  (CGFloat)_audioPlayer.duration;
    
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL URLWithString:urlString] options:nil];
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}


@end
