//
//  recommendCell.h
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookMP3;
@interface RecommendCell : UITableViewCell

@property (nonatomic, strong) BookMP3 *book;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end
