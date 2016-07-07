//
//  BookList.m
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookList.h"

@implementation BookList

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.section forKey:@"section"];
    [aCoder encodeObject:self.size forKey:@"size"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.path = [aDecoder decodeObjectForKey:@"name"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.section = [aDecoder decodeObjectForKey:@"section"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        
    }
    return self;
}

@end
