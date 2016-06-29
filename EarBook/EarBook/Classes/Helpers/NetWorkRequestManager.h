//
//  NetWorkRequestManager.h
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
// 1、类型的枚举  Get Post
// 做项目中，当需要实现某些固定类型选择的需求时，使用枚举
typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
};
// 2、成功和失败的回调 block
typedef void(^requestSuccessd)(id data);

typedef void(^requestFailed)(NSError *error);

@interface NetWorkRequestManager : NSObject
// 单例
singleton_interface(NetWorkRequestManager)

// 3、接口 调用
+ (void)requestType:(RequestType)type
          urlString:(NSString *)urlString
              prama:(NSDictionary *)pramas
            success:(requestSuccessd)success
               fail:(requestFailed)fail;

// 预留(目前没有在需求中，但是后面可能添加进需求里面的接口)

@end
