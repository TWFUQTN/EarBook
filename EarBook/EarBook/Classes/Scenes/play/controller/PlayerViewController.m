//
//  PlayerViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()



@end

@implementation PlayerViewController

- (void)viewDidAppear:(BOOL)animated {
    [self addDefaultSlider];
    self.isPlaying = NO;
    self.isSound = YES;
    CIContext *context = [CIContext contextWithOptions:nil];
    NSURL *imageURL = [NSURL URLWithString:@"http://bookpic.lrts.me/d3d2da637c634fd789b7061a2bc3de25.jpg"];
    CIImage *image = [CIImage imageWithContentsOfURL:imageURL];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@2.0f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    _backgroundImageView.image = blurImage;
    _songImageView.layer.cornerRadius = 100;
    _songImageView.layer.masksToBounds = YES;
    _songImageView.layer.borderWidth = 1;
    [_playButton setTintColor:[UIColor whiteColor]];
   _nextButton;
    _lastButton;
    _soundButton;
    [self beginimagerevole];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor grayColor];

}
- (void)beginimagerevole{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imageViewRevolve) userInfo:nil repeats:YES];
}
- (void)imageViewRevolve{
    [UIView animateWithDuration:0.1 animations:^{
        _songImageView.transform = CGAffineTransformRotate(_songImageView.transform, - M_PI / 100);
    }];
}
- (void)stopimagerevole{

    
    
    
}

- (void)addDefaultSlider{
    _defaultSlider = [[MTTCircularSlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height  - 110, 100, 100)];
    _defaultSlider.lineWidth = 5;
    _defaultSlider.angle = 45;
    _defaultSlider.maxValue = 100;
    _defaultSlider.selectColor = [UIColor blackColor];
    _defaultSlider.unselectColor = [UIColor whiteColor];
    _defaultSlider.tag = 1;
    [self.view addSubview:_defaultSlider];
    [self.view bringSubviewToFront:_playButton];
}


- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)settingAction:(id)sender {
    
    
}
- (IBAction)soundAction:(id)sender {
    if (_isSound) {
        [_soundButton setImage:[UIImage imageNamed:@"playnosound"] forState:UIControlStateNormal];
        _isSound = NO;
    }
    else {
        [_soundButton setImage:[UIImage imageNamed:@"playsound"] forState:UIControlStateNormal];
        _isSound = YES;
    
    }
    
}
- (IBAction)listAction:(id)sender {
    
    
}

- (IBAction)playAction:(id)sender {
    if (self.isPlaying) {
        [_playButton setImage:[UIImage imageNamed:@"playPause"] forState:UIControlStateNormal];
        _isPlaying = NO;
    }
    else {
        [_playButton setImage:[UIImage imageNamed:@"playPlay"] forState:UIControlStateNormal];
        _isPlaying = YES;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



@end
