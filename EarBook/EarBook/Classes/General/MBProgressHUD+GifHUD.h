//
//  MBProgressHUD+GifHUD.h
//  Day_07DouBan
//
//  Created by lanou3g on 16/6/17.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (GifHUD)

//设置GIF
//fram 标记视图的大小
//gifName gif图的名字
//ShowToView 目标View（显示gif的view）
+ (void)setUpGifWithFrame:(CGRect)frame
                  gifName:(NSString *)gifName
            andShowToView:(UIView *)view;



@end
