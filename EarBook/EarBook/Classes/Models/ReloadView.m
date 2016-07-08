//
//  ReloadView.m
//  MusicPlayer
//
//  Created by lanou3g on 16/6/13.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "ReloadView.h"

@implementation ReloadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout {
    
    self.myImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myImageView.image = [UIImage imageNamed:@"error.jpg"];
    self.myImageView.userInteractionEnabled = YES;
    [self addSubview:self.myImageView];
    
    self.myButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myButton.frame = CGRectMake(107, 50, 200, 50);
    self.myButton.backgroundColor = [UIColor orangeColor];
    [self.myButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.myButton addTarget:self action:@selector(myButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.myButton];
    self.myButton.userInteractionEnabled = YES;
    
}

- (void)myButtonAction{
    self.block();
}




@end
