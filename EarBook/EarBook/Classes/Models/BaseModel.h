//
//  BaseModel.h
//  EarBook
//
//  Created by lanou3g on 16/7/5.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
/// bookid
@property (nonatomic, strong) NSString *ID;
// index
@property (nonatomic, assign) NSInteger index;
// 时间戳
@property (nonatomic, assign) NSInteger time;
// 播放的时间数值
@property (nonatomic, assign) CGFloat value;
@end
