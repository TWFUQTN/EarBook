//
//  ReloadView.h
//  MusicPlayer
//
//  Created by lanou3g on 16/6/13.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)();
@interface ReloadView : UIView

@property (nonatomic, strong) UIImageView *myImageView;

@property (nonatomic, strong) UIButton *myButton;

@property (nonatomic, copy) Block block;

@end
