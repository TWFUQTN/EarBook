//
//  SpecialSubjectListCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/28.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "SpecialSubjectListCell.h"
#import "BookMP3.h"
#import "JoiningURL.h"

@interface SpecialSubjectListCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *descLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *coverImageView;
@end

@implementation SpecialSubjectListCell

- (void)setBook:(BookMP3 *)book
{
    if (_book != book) {
        _book = nil;
        _book = book;
        
        _nameLabel.text = _book.name;
        _descLabel.text = _book.desc;
        
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[JoiningURL urlWithCoverStr:_book.cover joiningStr:@"_338x170"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
}

@end
