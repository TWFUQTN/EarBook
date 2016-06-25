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
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *coverImageView;


@end

@implementation RecommendCell

- (void)setBook:(BookMP3 *)book
{
    if (_book != book) {
        _book = nil;
        _book = book;
        
        _nameLabel.text = _book.name;
        _reasonLabel.text = _book.reason;
        _coverImageView.layer.cornerRadius = (self.bounds.size.height - 20) / 2;
        _coverImageView.layer.masksToBounds = YES;
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
