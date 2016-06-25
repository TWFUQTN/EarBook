//
//  BookCollectionCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookCollectionCell.h"
#import "BookMP3.h"
#import <UIImageView+WebCache.h>

@interface BookCollectionCell ()

/// 图片
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation BookCollectionCell

- (void)setBook:(BookMP3 *)book
{
    if (_book != book) {
        _book = nil;
        _book = book;
        
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_book.cover]];
        _nameLabel.text = _book.name;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

@end
