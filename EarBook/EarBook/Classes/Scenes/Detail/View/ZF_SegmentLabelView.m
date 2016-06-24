//
//  ZF_SegmentLabelView.m
//  UILesson5_SegmentView
//
//  Created by lanou3g on 16/4/11.
//  Copyright © 2016年 张非. All rights reserved.
//

#import "ZF_SegmentLabelView.h"

#define kUpSegmentFrameX 20
#define kUpSegmentFrameY 5


@implementation ZF_SegmentLabelView

// 自定义初始化
- (instancetype)initWithFrame:(CGRect)frame
          viewBackgroundColor:(UIColor *)viewBackgroundColor
                        items:(NSArray *)items
                    dicNormal:(NSDictionary *)dicNormal
                  dicSelected:(NSDictionary *)dicSelected
         labelBackgroundColor:(UIColor *)labelBackgroundColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 添加子视图
        [self addAllViewsWithViewBackgroundColor:viewBackgroundColor items:items dicNormal:dicNormal dicSelected:dicSelected labelBackgroundColor:labelBackgroundColor];
    }
    return self;
}

// 添加子视图方法
- (void)addAllViewsWithViewBackgroundColor:(UIColor *)viewBackgroundColor
                       items:(NSArray *)items
                   dicNormal:(NSDictionary *)dicNormal
                 dicSelected:(NSDictionary *)dicSelected
        labelBackgroundColor:(UIColor *)labelBackgroundColor
{
    
    self.backgroundColor = viewBackgroundColor;
    
    // 创建一个Segment

    self.upSegment = [[UISegmentedControl alloc] initWithItems:items];

    // 确定frame
    self.upSegment.frame = CGRectMake(kUpSegmentFrameX, kUpSegmentFrameY, CGRectGetWidth(self.frame) - kUpSegmentFrameX * 2, CGRectGetHeight(self.frame) - kUpSegmentFrameY * 2);
    
    // 设置背景颜色
    self.upSegment.tintColor = self.backgroundColor;

    // 设置初始字体样式
    
    [self.upSegment setTitleTextAttributes:dicNormal forState:UIControlStateNormal];
    
    // 设置点击后的字体样式
    
    [self.upSegment setTitleTextAttributes:dicSelected forState:UIControlStateSelected];

    // 设置初始按钮
    self.upSegment.selectedSegmentIndex = 0;
    
    // 添加到父视图
    [self addSubview:self.upSegment];
    
    // 创建Label
    self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUpSegmentFrameX, CGRectGetMaxY(self.upSegment.frame), CGRectGetWidth(self.upSegment.frame) / items.count, CGRectGetHeight(self.frame) - CGRectGetMaxY(self.upSegment.frame))];

    self.downLabel.backgroundColor = labelBackgroundColor;
    
    // 添加到父视图
    [self addSubview:self.downLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
