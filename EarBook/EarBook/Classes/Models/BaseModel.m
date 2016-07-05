//
//  BaseModel.m
//  EarBook
//
//  Created by lanou3g on 16/7/5.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
