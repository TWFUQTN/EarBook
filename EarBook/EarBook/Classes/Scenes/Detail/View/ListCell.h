//
//  ListCell.h
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookList;
@interface ListCell : UITableViewCell

@property (nonatomic, strong) BookList *bookList;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;


@end
