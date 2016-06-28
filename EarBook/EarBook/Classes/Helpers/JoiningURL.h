//
//  JoiningURL.h
//  EarBook
//
//  Created by lanou3g on 16/6/28.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoiningURL : NSObject

// 拼图片地址
+ (NSString *)urlWithCoverStr:(NSString *)coverStr
                   joiningStr:(NSString *)joiningStr;

@end
