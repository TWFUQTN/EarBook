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
#import "BookInfosHandle.h"


// BookInfoHandle单例
@interface PlayerViewController ()
@property (nonatomic, assign) NSInteger lastIndex;  // 记录上一个歌词
@end

@implementation PlayerViewController

- (void)viewDidAppear:(BOOL)animated {
    [self initViewLayout];
}
//先前布局布局界面
- (void)initViewLayout{

    [self addDefaultSlider];
//    self.isPlaying = NO;
    self.isSound = YES;
//    CIContext *context = [CIContext contextWithOptions:nil];
//    NSURL *imageURL = [NSURL URLWithString:@"http://bookpic.lrts.me/d3d2da637c634fd789b7061a2bc3de25.jpg"];
//    CIImage *image = [CIImage imageWithContentsOfURL:imageURL];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:image forKey:kCIInputImageKey];
//    [filter setValue:@2.0f forKey: @"inputRadius"];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
//    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
//    _backgroundImageView.image = blurImage;
    _songImageView.layer.cornerRadius = 100;
    _songImageView.layer.masksToBounds = YES;
    _songImageView.layer.borderWidth = 1;
    [self beginimagerevole];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
// 播放歌曲并设置view上所有子视图
- (void)playAndSetUpViews {
 
}
#pragma mark - 开始转动
- (void)beginimagerevole{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imageViewRevolve) userInfo:nil repeats:YES];
}
- (void)imageViewRevolve{
    [UIView animateWithDuration:0.1 animations:^{
        _songImageView.transform = CGAffineTransformRotate(_songImageView.transform, - M_PI / 100);
    }];
}
#pragma mark - 进度条slider
- (IBAction)progressChange:(id)sender {
    
    
}
#pragma mark - 停止转动
- (void)stopimagerevole{

    
    
    
}
#pragma mark - 声音控制
- (void)addDefaultSlider{
    _defaultSlider = [[MTTCircularSlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height  - 110, 100, 100)];
    _defaultSlider.lineWidth = 5;
    _defaultSlider.angle = 45;
    _defaultSlider.maxValue = 1;
    _defaultSlider.minValue = 0;
    _defaultSlider.selectColor = [UIColor blackColor];
    _defaultSlider.unselectColor = [UIColor whiteColor];
    _defaultSlider.tag = 1;
    [self.view addSubview:_defaultSlider];
    [self.view bringSubviewToFront:_playButton];
    
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
    if (_isSound) {
        [_soundButton setImage:[UIImage imageNamed:@"playnosound"] forState:UIControlStateNormal];
        _isSound = NO;
        _defaultSlider.value = 0;
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
//    if (kAVPlayerManager.status == isPaused) {
////        [kAVPlayerManager play];
//        [_playButton setImage:[UIImage imageNamed:@"playPause"] forState:UIControlStateNormal];
////        _isPlaying = NO;
//    }
//    else {
////        [kAVPlayerManager pause];
//        [_playButton setImage:[UIImage imageNamed:@"playPlay"] forState:UIControlStateNormal];
////        _isPlaying = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
