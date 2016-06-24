//
//  Tool_CountTextHeight.h
//  UILesson12_3Cell自适应高度
//
//  Created by lanou3g on 16/4/21.
//  Copyright © 2016年 张非. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Tool_AdaptiveHeight : NSObject

// 声明类方法,用于计算文本的高度
+ (CGFloat)textHeightWithText:(NSString *)text
                     fontSize:(CGFloat)fontSize
                    viewWidth:(CGFloat)viewWidth;

// 声明类方法,用于计算图片的高度
+ (CGFloat)imageHeightWithImage:(UIImage *)image
                      viewWidth:(CGFloat)viewWidth;

@end
