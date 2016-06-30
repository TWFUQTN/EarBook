//
//  RankingHeader.m
//  EarBook
//
//  Created by lanou3g on 16/6/30.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RankingHeader.h"
#import "EB_COLOR.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface RankingHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RankingHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

// 布局
- (void)initLayout
{
    self.contentView.backgroundColor = EB_COLOR(255, 255, 255, 1);
    // 榜单名Label
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"榜单名";
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-100);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    // 总榜button
    UIButton *totalRankingBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [totalRankingBtn setTitle:@"总榜" forState:(UIControlStateNormal)];
    totalRankingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [totalRankingBtn setTintColor:EB_COLOR(243, 159, 25, 1.0)];
    [self.contentView addSubview:totalRankingBtn];
    self.totalRankingBtn = totalRankingBtn;
    [totalRankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(kScreenWidth / 12);
    }];
    
    // 月榜button
    UIButton *monthRankingBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [monthRankingBtn setTitle:@"月榜" forState:(UIControlStateNormal)];
    monthRankingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [monthRankingBtn setTintColor:EB_COLOR(243, 159, 25, 1.0)];
    [self.contentView addSubview:monthRankingBtn];
    self.monthRankingBtn = monthRankingBtn;
    [monthRankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.totalRankingBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(kScreenWidth / 12);
    }];
    
    // 周榜button
    UIButton *weekRankingBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [weekRankingBtn setTitle:@"周榜" forState:(UIControlStateNormal)];
    [weekRankingBtn setTintColor:EB_COLOR(243, 159, 25, 1.0)];
    weekRankingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:weekRankingBtn];
    self.weekRankingBtn = weekRankingBtn;
    [weekRankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.monthRankingBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(kScreenWidth / 12);
    }];
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = nil;
        _title = title;
        
        _titleLabel.text = _title;
    }
}

@end
