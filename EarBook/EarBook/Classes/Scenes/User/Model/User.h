//
//  User.h
//  EarBook
//
//  Created by lanou3g on 16/6/30.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

///
@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) BOOL sex;

@property (nonatomic, assign) BOOL activate;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger userState;

@end
