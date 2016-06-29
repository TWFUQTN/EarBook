//
//  NetWorkRequestManager.m
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager
// 单例
singleton_implementation(NetWorkRequestManager)

// 接口 调用
+ (void)requestType:(RequestType)type
          urlString:(NSString *)urlString
              prama:(NSDictionary *)pramas
            success:(requestSuccessd)success
               fail:(requestFailed)fail {
    // 转到对象方法进行实现
    NetWorkRequestManager *manager = [NetWorkRequestManager shareNetWorkRequestManager];
    [manager requestWithType:type urlString:urlString prama:pramas success:success fail:fail];
}

- (void)requestWithType:(RequestType)type
              urlString:(NSString *)urlString
                  prama:(NSDictionary *)pramas
                success:(requestSuccessd)success
                   fail:(requestFailed)fail {
    // 1、使用URLSession
    NSURLSession *session = [NSURLSession sharedSession];
    // 2、准备URL
    NSURL *url = [NSURL URLWithString:urlString];
    // 3、设置request对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 4、判断请求类型
    if (type == RequestTypePost) {
        // 设置请求方式
        request.HTTPMethod = @"POST";
        // post参数需要加进body里，将字典中的内容转成符合key=value&key=value的形式
        if (pramas.count > 0) {
            NSData *data = [self parDicToDataWithDic:pramas];
            [request setHTTPBody:data];
        }
    }
    // 链接并发送请求
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 当调用block之前必须确认存在，否则崩溃
        
        if (data && !error) {
            if (success) {
                success(data);
            }
            
        } else {
            if (!data) {
                NSLog(@"请求数据为空");
            }
            if (error) {
                if (fail) {
                    fail(error);
                }
                
            }
        }
    }];
    [task resume];
}

- (NSData *)parDicToDataWithDic:(NSDictionary *)dic {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    // 遍历字典中所有的key和value(数组中也有类似方法)
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    // 使用&进行数组中参数的拼接
    NSString *parString = [array componentsJoinedByString:@"&"];
    return [parString dataUsingEncoding:NSUTF8StringEncoding];
}


@end
