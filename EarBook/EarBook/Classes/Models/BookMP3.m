//
//  BookMP3.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "BookMP3.h"

@implementation BookMP3

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.announcer forKey:@"announcer"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.sections forKey:@"sections"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.play forKey:@"play"];
    [aCoder encodeObject:self.update forKey:@"update"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.reason forKey:@"reason"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.publishType forKey:@"publishType"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.announcer = [aDecoder decodeObjectForKey:@"announcer"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.sections = [aDecoder decodeObjectForKey:@"sections"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.play = [aDecoder decodeObjectForKey:@"play"];
        self.update = [aDecoder decodeObjectForKey:@"update"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.reason = [aDecoder decodeObjectForKey:@"reason"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.publishType = [aDecoder decodeObjectForKey:@"publishType"];
    }
    return self;
}

@end
