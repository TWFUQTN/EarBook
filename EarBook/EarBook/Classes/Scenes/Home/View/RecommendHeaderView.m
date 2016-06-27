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
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.text = @"专题名字";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-100);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    self.moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.moreButton setTitle:@"更多" forState:(UIControlStateNormal)];
    [self addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

@end
