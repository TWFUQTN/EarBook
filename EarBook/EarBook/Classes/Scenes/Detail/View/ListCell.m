//
//  ListCell.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "ListCell.h"
#import "BookList.h"

@interface ListCell ()

@property (weak, nonatomic) IBOutlet UILabel *listName;

@end

@implementation ListCell

- (void)setBookList:(BookList *)bookList
{
    if (_bookList != bookList) {
        _bookList = nil;
        _bookList = bookList;
        
        _listName.text = _bookList.name;
    }
}

@end
