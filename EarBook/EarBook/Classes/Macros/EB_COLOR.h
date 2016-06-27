//
//  DB_COLOR.h
//  Day_07DouBan
//
//  Created by lanou3g on 16/6/16.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#ifndef EB_COLOR_h
#define EB_COLOR_h

//根据r，g，b，a的值获取颜色
#define EB_COLOR(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]

//随机色
#define EB_RANDOM_COLOR EB_COLOR(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1.0)

//主题色
#define EB_MAIN_COLOR EB_COLOR(0,200,17,1.0)


#endif /* EB_COLOR_h */
