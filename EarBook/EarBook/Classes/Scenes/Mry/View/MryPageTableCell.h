//
//  MryPageTableCell.h
//  EarBook
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookMP3;
@class Voice;

@interface MryPageTableCell : UITableViewCell

@property (nonatomic, strong) BookMP3 *book;

@property (nonatomic, strong) Voice *classifyVoice;

@end
