//
//  BookList.h
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookList : NSObject

/// 名字
@property (nonatomic, copy) NSString *name;

/// 音频地址
@property (nonatomic, copy) NSString *path;

/// id
@property (nonatomic, copy) NSString *ID;

/// 集数
@property (nonatomic, copy) NSString *section;

/// 大小
@property (nonatomic, copy) NSString *size;



@end
