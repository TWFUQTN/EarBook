//
//  recommendCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RecommendCell.h"

#import "BookMP3.h"

@interface RecommendCell()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *reasonLabel;


@end

@implementation RecommendCell

- (void)setBook:(BookMP3 *)book
{
    if (_book != book) {
        _book = nil;
        _book = book;
        self.backgroundColor = [UIColor clearColor];
        _nameLabel.text = _book.name;
        _reasonLabel.text = _book.reason;
        _coverImageView.layer.cornerRadius = (self.bounds.size.height - 20) / 2;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.borderWidth = 1;
        
        
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
