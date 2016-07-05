//
//  PlayerViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTTCircularSlider.h"
#import "BookList.h"
#import "Singleton.h"
#import "BookMP3.h"

@interface PlayerViewController : UIViewController
//获取当前对应的集数下标
@property (nonatomic,assign)NSInteger index;
//当前对应的model
@property (nonatomic,strong)BookList *bookList;
@property (nonatomic,strong)BookMP3 *bookInformation;

//播放列表
@property (nonatomic,copy) NSMutableArray *playList;
//设置的视图
@property (weak, nonatomic) IBOutlet UIView *playSettingView;

@end
