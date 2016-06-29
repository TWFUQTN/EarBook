//
//  PlayerViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTCircularSlider.h"
#import "BookList.h"
#import "Singleton.h"
@protocol AVPlayerManagerDelegate <NSObject>

// 当AVPlayer播放时间不断改变时 反馈
- (void)changeTime:(CGFloat)time;
// 当播放完成时反馈
- (void)playDidFinished;
@end
// 使用枚举进行状态的记录
//typedef NS_ENUM(NSUInteger, AVPlayerManagerStatus) {
//    isPlaying, // 正在播放
//    isPaused,  // 暂停播放
//};
//
//typedef NS_ENUM(NSUInteger, LoopMode) {
//    LoopModeOrderMode,   // 顺序
//    LoopModeSingleMond,  // 单曲循环
//};

@interface PlayerViewController : UIViewController
//音量控制器
@property (nonatomic, strong) MTTCircularSlider* defaultSlider;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//播放图片
@property (weak, nonatomic) IBOutlet UIButton *playButton;
//下一首按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//上一首按钮
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
//歌曲图片
@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
//结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
//播放进度
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//声音按🐂
@property (weak, nonatomic) IBOutlet UIButton *soundButton;
//是否播放
//@property (nonatomic,assign)BOOL isPlaying;
//是否有声音
@property (nonatomic,assign)BOOL isSound;
//当前对应的model
@property (nonatomic,strong)BookList *bookList;


@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookCurrent;


//获取当前对应的集数下标
@property (nonatomic,assign)NSInteger index;






@end
