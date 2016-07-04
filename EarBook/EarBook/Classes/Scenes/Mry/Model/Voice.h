//
//  Voice.h
//  EarBook
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Voice : NSObject

//名字
@property (nonatomic, strong) NSString *name;

//上传人
@property (nonatomic, strong) NSString *nickName;

//描述
@property (nonatomic, strong) NSString *Description;

//播放量
@property (nonatomic, strong) NSString *playCount;

//id
@property (nonatomic, strong) NSString *ID;

//图片
@property (nonatomic, strong) NSString *cover;


@end
