//
//  HomeCustomHeader.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "HomeCustomHeader.h"

@interface HomeCustomHeader ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;


@end

@implementation HomeCustomHeader

-(void)awakeFromNib
{
    
}

- (UIImageView *)backgroundImageView {
    return self.imageView;
    
}

- (void)updateHeadPhotoWithTopInset:(CGFloat)inset {
    CGFloat ratio = (inset - 64) / 150.0;
    self.bottomConstraint.constant = ratio * 30 + 10;
    self.widthConstraint.constant = 30 + ratio * 50;
}

@end
