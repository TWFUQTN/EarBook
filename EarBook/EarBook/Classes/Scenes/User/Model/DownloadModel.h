//
//  DownloadModel.h
//  EarBook
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadModel : NSObject

@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *bookListName;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDate *downloadTime;

@end
