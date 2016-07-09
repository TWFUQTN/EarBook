//
//  UserCoverCell.m
//  EarBook
//
//  Created by lanou3g on 16/7/9.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "UserCoverCell.h"

#define kCoverImageWidth 70

@interface UserCoverCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation UserCoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutView];
    }
    return self;
}

- (void)layoutView
{
    UIImageView *coverImageView = [UIImageView new];
    coverImageView.image = [UIImage imageNamed:@"DefaultAvatar"];
    coverImageView.layer.cornerRadius = kCoverImageWidth / 2;
    coverImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:coverImageView];
    
    self.coverImageView = coverImageView;
    
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.mas_equalTo(kCoverImageWidth);
        make.height.mas_equalTo(kCoverImageWidth);
    }];
    
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"修改头像";
    [self.contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
        make.right.equalTo(coverImageView.mas_left).offset(-50);
    }];
}

- (void)setCover:(NSData *)cover
{
    if (_cover != cover) {
        _cover = nil;
        _cover = cover;
        
        _coverImageView.image = [UIImage imageWithData:_cover];
    }
}

@end
