//
//  HomeViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "ARSegmentPageController.h"

@interface HomeViewController : ARSegmentPageController
@property (weak, nonatomic) IBOutlet UIView *tabbarHomeView;
@property (weak, nonatomic) IBOutlet UIView *tabbarMainView;
@property (weak, nonatomic) IBOutlet UIView *tabbarSongView;
@property (weak, nonatomic) IBOutlet UIImageView *tabbarSongImageView;

@property (weak, nonatomic) IBOutlet UILabel *tabBarSongName;
@property (weak, nonatomic) IBOutlet UILabel *tabBarSongAuthor;
@property (weak, nonatomic) IBOutlet UILabel *tabBarSlider;
@property (weak, nonatomic) IBOutlet UIView *tabBarListView;
@property (weak, nonatomic) IBOutlet UIView *tabbarListOtherView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic,assign) BOOL isTabBarListOpen;
@end
