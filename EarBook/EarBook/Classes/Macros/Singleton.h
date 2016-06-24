//
//  Singleton.h
//  MusicPlayer
//
//  Created by lanou3g on 16/6/13.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

//单例的声明
#define singleton_interface(className) \
+ (instancetype)share##className;

//单例的实现
#define singleton_implementation(className) \
static className *manager = nil; \
+ (instancetype)share##className { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
manager = [[className alloc] init]; \
}); \
return manager; \
}





#endif /* Singleton_h */
