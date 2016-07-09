//
//  UserBasicDataCell.m
//  EarBook
//
//  Created by lanou3g on 16/7/9.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "UserBasicDataCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kBasicTextHeight 30

@implementation UserBasicDataCell

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
    self.alpha = 0.5;
    
    UITextField *basicDataTextField = [UITextField new];
    basicDataTextField.placeholder = @"尚未填写";
    basicDataTextField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:basicDataTextField];
    
    self.basicDataTextField = basicDataTextField;
    
    [basicDataTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.width.mas_equalTo(kScreenWidth / 2);
        make.height.mas_equalTo(kBasicTextHeight);
    }];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.text = @"昵称";
    [self.contentView addSubview:detailLabel];
    
    self.detailLabel = detailLabel;
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.right.equalTo(basicDataTextField.mas_left).offset(-30);
    }];
}

@end
