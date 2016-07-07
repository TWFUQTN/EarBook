//
//  BaseModel.h
//  EarBook
//
//  Created by lanou3g on 16/7/5.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, strong) NSString *bookID;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSString *bookImageURL;

@property (nonatomic, strong) NSString *bookName;

@property (nonatomic, strong) NSDate *bookDate;

@property (nonatomic, strong) NSString *bookMP3URL;

@property (nonatomic, strong) NSString *bookAnnouncer;

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) NSString *bookMP3Name;

@end
