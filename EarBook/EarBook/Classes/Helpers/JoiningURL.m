//
//  JoiningURL.m
//  EarBook
//
//  Created by lanou3g on 16/6/28.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "JoiningURL.h"

@implementation JoiningURL

// 拼图片地址
+ (NSString *)urlWithCoverStr:(NSString *)coverStr
                   joiningStr:(NSString *)joiningStr
{
    NSString *subStr = [coverStr substringToIndex:coverStr.length - 4];
    
    return [NSString stringWithFormat:@"%@%@.jpg", subStr, joiningStr];
}

@end
