//
//  HomeViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "ARSegmentPageController.h"
#import "BookMP3.h"
#import "BookList.h"
@interface HomeViewController : ARSegmentPageController

@property (weak, nonatomic) IBOutlet UIView *tabbarHomeView;
@property (weak, nonatomic) IBOutlet UIView *tabbarListUpView;
@property (weak, nonatomic) IBOutlet UIView *tabbarListDownView;

@property (weak, nonatomic) IBOutlet UIView *tabbarSongView;
@property (weak, nonatomic) IBOutlet UIImageView *tabbarSongImageView;

@property (weak, nonatomic) IBOutlet UILabel *tabBarSongName;
@property (weak, nonatomic) IBOutlet UILabel *tabBarSongAuthor;
@property (weak, nonatomic) IBOutlet UILabel *tabBarSlider;
@property (weak, nonatomic) IBOutlet UIView *tabBarListView;
@property (weak, nonatomic) IBOutlet UIView *tabbarListOtherView;
@property (weak, nonatomic) IBOutlet UITableView *tabBarListTableView;
@property (weak, nonatomic) IBOutlet UIView *tabBarListPlayView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic,assign) BOOL isTabBarListOpen;


//tabBarView
//获取当前对应的集数下标
@property (nonatomic,assign)NSInteger index;
//当前对应的model
@property (nonatomic,strong)BookList *bookList;
@property (nonatomic,strong)BookMP3 *bookInformation;

//播放列表
@property (nonatomic,copy) NSMutableArray *playList;

@property (weak, nonatomic) IBOutlet UIButton *tabBarPlayButton;



@end
