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
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    self.myImageView.image = [UIImage imageNamed:@"error.jpg"];
    self.myImageView.userInteractionEnabled = YES;
    [self addSubview:self.myImageView];
    
    self.myButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myButton.frame = CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width);
    self.myButton.titleLabel.font = [UIFont systemFontOfSize:20];
//    self.myButton.backgroundColor = [UIColor orangeColor];
    [self.myButton setTitle:@"获取不到数据,点我重新加载..." forState:UIControlStateNormal];
    self.myButton.tintColor = [UIColor blackColor];
    [self.myButton addTarget:self action:@selector(myButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.myButton];
    self.myButton.userInteractionEnabled = YES;
    
}

- (void)myButtonAction{
    self.block();
}




@end
