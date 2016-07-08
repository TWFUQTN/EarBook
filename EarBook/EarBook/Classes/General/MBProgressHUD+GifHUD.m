//
//  MBProgressHUD+GifHUD.m
//  Day_07DouBan
//
//  Created by lanou3g on 16/6/17.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "MBProgressHUD+GifHUD.h"
#import <SDWebImage/UIImage+GIF.h>
#import "EB_COLOR.h"


@implementation MBProgressHUD (GifHUD)

+ (void)setUpGifWithFrame:(CGRect)frame gifName:(NSString *)gifName andShowToView:(UIView *)view {
    
    //使用MBProgressHUD播放GIF需要自定义视图显示
    UIImage *image = [UIImage sd_animatedGIFNamed:gifName];
    //自定义视图
    UIImageView *gifView = [[UIImageView alloc] initWithFrame:frame];
    gifView.image = image;
    
    MBProgressHUD *hud = [self showHUDAddedTo:view animated:YES];
    
    //设置属性
    hud.customView = gifView;
    hud.color = EB_COLOR(100, 200, 100, 0.5);
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"获取数据中...";
    hud.customView = gifView;
    
}

@end
