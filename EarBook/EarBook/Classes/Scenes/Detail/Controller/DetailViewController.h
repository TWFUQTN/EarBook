//
//  DetailViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

/// 详情页数据请求地址字符串(详情)
@property (nonatomic, copy) NSString *bookDetailURL;
/// 详情页数据请求地址字符串(列表)
@property (nonatomic, copy) NSString *bookListURL;

@end
