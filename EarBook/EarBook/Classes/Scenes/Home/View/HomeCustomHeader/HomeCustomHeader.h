//
//  HomeCustomHeader.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageController.h"
#import "ARSegmentPageControllerHeaderProtocol.h"

@interface HomeCustomHeader : UIView<ARSegmentPageControllerHeaderProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *tapView;

- (void)updateHeadPhotoWithTopInset:(CGFloat)inset;

@end
