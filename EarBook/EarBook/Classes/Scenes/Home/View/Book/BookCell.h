//
//  BookCell.h
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookMP3;

typedef void(^BookCellBlock)(BookMP3 *book);

@interface BookCell : UITableViewCell

@property (nonatomic, strong) NSArray *bookArray;

@property (nonatomic, copy) BookCellBlock block;

@end
