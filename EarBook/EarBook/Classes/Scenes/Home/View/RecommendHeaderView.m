//
//  RecommendHeaderView.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RecommendHeaderView.h"

#import <Masonry.h>

@implementation RecommendHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加子视图
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
#warning 布局头视图
    UILabel *titleLabel = [UILabel new];
    
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-100);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

@end
