//
//  UserCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)cellBindWithDictionary:(NSDictionary *)dictionary
                         Index:(NSInteger)index{
    
    NSArray *imageArr = dictionary[@"image"];
    NSArray *titleArr = dictionary[@"title"];
    self.icon.image = [UIImage imageNamed:imageArr[index]];
    self.titleLabel.text = titleArr[index];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
