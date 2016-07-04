//
//  PlayerViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "PlayerViewController.h"
#import "AVPlayerManager.h"
#import <UIImageView+WebCache.h>
#import "NSString+TimeFormatter.h"
#import "BookInfosHandle.h"
//BookInfoHandle的单例
#define kBookInfosHandle [BookInfosHandle shareBookInfosHandle]

// AVPlayerManager的单例
#define kAVPlayerManager [AVPlayerManager shareAVPlayerManager]
@interface PlayerViewController () <AVPlayerManagerDelegate>
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

//是否有声音
@property (nonatomic,assign)BOOL isSound;
//书名
@property (weak, nonatomic) IBOutlet UILabel *bookName;
//当前集数
@property (weak, nonatomic) IBOutlet UILabel *bookCurrent;
//当前MP3的长度
@property (nonatomic ,assign) CGFloat mp3Time;



@end

@implementation PlayerViewController


- (void)viewDidAppear:(BOOL)animated {
    
}
- (void)viewWillAppear:(BOOL)animated {
    // 设置代理
    kAVPlayerManager.delegate = self;
    
    //    声音加载
    [self addDefaultSlider];

    // 播放并设置view上所有子视图
    [self playAndSetUpViews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置代理
    
    
}
// 播放并设置view上所有子视图
- (void)playAndSetUpViews {
    _index = kBookInfosHandle.indexout;
    _bookList = kBookInfosHandle.bookInfosArray[_index];
//    _bookList = _playList[_index];
    _bookInformation = kBookInfosHandle.bookMP3;
    [kAVPlayerManager playWithUrl:_bookList.path currentIndex:self.index];
    // 改变播放按钮的状态
    [_playButton setImage:[UIImage imageNamed:@"playPause"] forState:UIControlStateNormal];
//    中心图片
    _songImageView.layer.cornerRadius = 100;
    _songImageView.layer.masksToBounds = YES;
    _songImageView.layer.borderWidth = 1;
    [_songImageView sd_setImageWithURL:[NSURL URLWithString:_bookInformation.cover]];
// 听书名称
    _bookName.text = _bookInformation.name;
//    背景模糊处理
    CIContext *context = [CIContext contextWithOptions:nil];
    NSURL *imageURL = [NSURL URLWithString:_bookInformation.cover];
    CIImage *image = [CIImage imageWithContentsOfURL:imageURL];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@2.0f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    _backgroundImageView.image = blurImage;
//   集数
    _bookCurrent.text = _bookList.name;
    // 设置timeSlider
    _progressSlider.minimumValue = 0.0;
    _mp3Time = [kAVPlayerManager getMp3TimeOfurl:_bookList.path];
    _progressSlider.maximumValue = _mp3Time;
    _progressSlider.value = 0;
    [kBookInfosHandle getNowDate];
    NSLog(@"%@",kBookInfosHandle.nowDate);

    
}
#pragma mark - 开始转动
- (void)beginimagerevole{
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imageViewRevolve) userInfo:nil repeats:YES];
}
- (void)imageViewRevolve{
    [UIView animateWithDuration:0.1 animations:^{
        _songImageView.transform = CGAffineTransformRotate(_songImageView.transform,  -M_PI / 100);
    }];
}
#pragma mark - 进度条slider
- (IBAction)progressChange:(id)sender {
    
    [kAVPlayerManager seekToTime:_progressSlider.value];
    
}

#pragma mark - 声音加载
- (void)addDefaultSlider{
    
    _defaultSlider = [MTTCircularSlider new];
    _defaultSlider.lineWidth = 5;
    _defaultSlider.angle = 45;
    _defaultSlider.maxValue = 1;
    _defaultSlider.minValue = 0;
    _defaultSlider.selectColor = [UIColor blackColor];
    _defaultSlider.unselectColor = [UIColor whiteColor];
    _defaultSlider.tag = 1;
    _defaultSlider.minValue = 0.0;
    _defaultSlider.maxValue = 1.0;
    _defaultSlider.value = [kAVPlayerManager volume];
    [self.view addSubview:_defaultSlider];
    [self.view bringSubviewToFront:_playButton];
    [_defaultSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [_defaultSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_playButton.mas_centerX);
        make.centerY.equalTo(_playButton.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
}

#pragma mark - 回到上一层
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 设置按钮
- (IBAction)settingAction:(id)sender {
    
    
}
#pragma mark - 声音按钮
- (IBAction)soundAction:(id)sender {
    if (_defaultSlider.value > 0) {
        [_soundButton setImage:[UIImage imageNamed:@"playnosound"] forState:UIControlStateNormal];
        _isSound = NO;
        _defaultSlider.value = 0;
        kAVPlayerManager.volume = _defaultSlider.value;
    }
    else {
        [_soundButton setImage:[UIImage imageNamed:@"playsound"] forState:UIControlStateNormal];
        _isSound = YES;
    }
    
}
#pragma mark - 列表按钮
- (IBAction)listAction:(id)sender {

}
#pragma mark - 播放按钮
- (IBAction)playAction:(id)sender {

    if (kAVPlayerManager.status == isPaused || kAVPlayerManager.status == isStoped) {
        [kAVPlayerManager play];
        [_playButton setImage:[UIImage imageNamed:@"playPause"] forState:UIControlStateNormal];
    } else if (kAVPlayerManager.status == isPlaying) {
        [kAVPlayerManager pause];
        [_playButton setImage:[UIImage imageNamed:@"playPlay"] forState:UIControlStateNormal];
    }

}
#pragma mark 上一首
- (IBAction)nextButton:(id)sender {
    _bookList = [kBookInfosHandle bookInfoNextWithIndex:&_index];

    
    [self playAndSetUpViews];

}
#pragma mark 下一首
- (IBAction)lastButton:(id)sender {
    _bookList = [kBookInfosHandle bookInfoPreviousWithIndex:&_index];


    [self playAndSetUpViews];
}

#pragma mark 声音调节

- (void)sliderValueChanged{
    kAVPlayerManager.volume = _defaultSlider.value;
    if (kAVPlayerManager.volume > 0 ) {
        [_soundButton setImage:[UIImage imageNamed:@"playsound"] forState:UIControlStateNormal];
        _isSound = YES;
    }
}

- (void)playDidFinished {
    // 根据模式取出下一首播放的music
    [self getMusicByLoopMode];
}

#pragma mark - 定时器改变时间
- (void)changeTime:(CGFloat)time {
    // 改变silder的位置
    _progressSlider.value = time;
    _beginTimeLabel.text = [NSString getStringWithTime:time];
    _endTimeLabel.text = [NSString getStringWithTime:_mp3Time ];
    
    // 转动imageView
    [UIView animateWithDuration:0.1 animations:^{
        _songImageView.transform = CGAffineTransformRotate(_songImageView.transform, 0.05);
    }];
}

#pragma mark - 根据播放模式取出下一首播放的music
- (void)getMusicByLoopMode {
    switch (kAVPlayerManager.loopMode) {
        case LoopModeOrderMode:
            _bookList = [kBookInfosHandle bookInfoNextWithIndex:&_index];
            [self playAndSetUpViews];
            break;
        case LoopModeSingleMond:
            [self playAndSetUpViews];
            break;
        case LoopModeRandomMode:
            [self playAndSetUpViews];
            break;
        default:
            NSLog(@"未知播放模式，请设置");
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
