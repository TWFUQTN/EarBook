//
//  ZF_SegmentLabelView.h
//  UILesson5_SegmentView
//
//  Created by lanou3g on 16/4/11.
//  Copyright © 2016年 张非. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZF_SegmentLabelView : UIView

// 视图声明
@property (nonatomic, strong) UISegmentedControl *upSegment;
@property (nonatomic, strong) UILabel *downLabel;

// 定义栏目数组
@property (nonatomic, strong) NSArray *items;

// 字体字典

// 背景色的声明
@property (nonatomic, strong) UIColor *viewBackgroundColor;
@property (nonatomic, strong) UIColor *labelBackgroundColor;

- (instancetype)initWithFrame:(CGRect)frame
          viewBackgroundColor:(UIColor *)viewBackgroundColor
                        items:(NSArray *)items
                    dicNormal:(NSDictionary *)dicNormal
                  dicSelected:(NSDictionary *)dicSelected
         labelBackgroundColor:(UIColor *)labelBackgroundColor;

@end
