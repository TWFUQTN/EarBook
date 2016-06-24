//
//  Tool_CountTextHeight.m
//  UILesson12_3Cell自适应高度
//
//  Created by lanou3g on 16/4/21.
//  Copyright © 2016年 张非. All rights reserved.
//

// 用于 Cell 的自适应,存在文本高度自适应和图片高度自适应

#import "Tool_AdaptiveHeight.h"

@implementation Tool_AdaptiveHeight

// 计算文本的高度
//
+ (CGFloat)textHeightWithText:(NSString *)text
                     fontSize:(CGFloat *)fontSize
                    viewWidth:(CGFloat)viewWidth
{
    // iOS7.0中求文本高度的方法,返回一个CGRect的高度
    
    // 第一个参数
    CGSize size = CGSizeMake(viewWidth, 10000);
    
    // 第二个参数:设置以行高为单位
    // 第三个参数:文本的样式
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
}

// 计算图片的高度
+ (CGFloat)imageHeightWithImage:(UIImage *)image
                      viewWidth:(CGFloat)viewWidth
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    NSLog(@"%f", width);
    
    float scile = height / width;
    float scileW = viewWidth;
    
    return  scile * scileW;
}

@end
