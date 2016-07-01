//
//  HomeViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "HomeViewController.h"
#import "RecommendViewController.h"
#import "ClassificationViewController.h"
#import "RankingViewController.h"
#import "HomeCustomHeader.h"
#import "UIImage+ImageEffects.h"
#import "PCStackMenu.h"
#import "PlayerViewController.h"
#import "TabBarListViewCell.h"
#import "UserTableViewController.h"
#import "AVPlayerManager.h"
#import "BookInfosHandle.h"
// AVPlayerManager的单例
#define kAVPlayerManager [AVPlayerManager shareAVPlayerManager]
//BookInfoHandle的单例
#define kBookInfosHandle [BookInfosHandle shareBookInfosHandle]

void *CustomHeaderInsetObserver = &CustomHeaderInsetObserver;

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate,AVPlayerManagerDelegate>
//透视图
@property (nonatomic, strong) HomeCustomHeader *header;
//mp3time
@property (nonatomic, assign) CGFloat mp3Time;


@end

@implementation HomeViewController


-(instancetype)init
{
//    页面 登录
    RecommendViewController *recommendVC = [[RecommendViewController alloc] initWithNibName:@"RecommendViewController" bundle:nil];
    ClassificationViewController *classificationVC = [[ClassificationViewController alloc] initWithNibName:@"ClassificationViewController" bundle:nil];
    RankingViewController *rankingVC = [[RankingViewController alloc] initWithNibName:@"RankingViewController" bundle:nil];
    
    
    self = [super initWithControllers:recommendVC,classificationVC, rankingVC ,nil];
    if (self) {
        // your code
        self.segmentMiniTopInset = 64;
        self.headerHeight = 150;
    }
    
    return self;
}
#pragma mark - override

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    if (_header == nil) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"HomeCustomHeader" owner:nil options:nil] lastObject];
//        _header.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_header addGestureRecognizer:tap];
    }
    return _header;
}


- (void)tap
{
    UserTableViewController *userVC = [UserTableViewController new];
    
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
}

//tabbar 加载
-(void)tabBarViewLoad{
    
    
    _tabbarHomeView.userInteractionEnabled = YES;
    _tabbarSongView.layer.cornerRadius = 35;
    _tabbarSongView.layer.masksToBounds = YES;
    _tabbarSongImageView.layer.cornerRadius = 30;
    _tabbarSongImageView.layer.masksToBounds = YES;
    _isTabBarListOpen = NO;
    _tabbarListUpView.layer.borderWidth = 2;
    self.tabBarListTableView.dataSource = self;
    self.tabBarListTableView.delegate = self;
    if (kBookInfosHandle.bookInfosArray != nil  && kBookInfosHandle.bookMP3 != nil) {
        _bookList = kBookInfosHandle.bookInfosArray[_index];
        _bookInformation = kBookInfosHandle.bookMP3;
        [kAVPlayerManager playWithUrl:_bookList.path currentIndex:self.index];
        // 改变播放按钮的状态
        [_tabBarPlayButton setImage:[UIImage imageNamed:@"tabBarpause"] forState:UIControlStateNormal];
        // tabbar image
        _tabbarSongImageView.layer.cornerRadius = 30;
        _tabbarSongImageView.layer.masksToBounds = YES;
        _tabbarSongImageView.layer.borderWidth = 1;
        [_tabbarSongImageView sd_setImageWithURL:[NSURL URLWithString:_bookInformation.cover]];
        //    tabBar name
        _tabBarSongName.text = _bookList.name;
        //tabBar deit
        _tabBarSongAuthor.text  = _bookInformation.announcer;
        // 设置timeSlider
        _progressSlider.minimumValue = 0.0;
        _mp3Time = [kAVPlayerManager getMp3TimeOfurl:_bookList.path];
        _progressSlider.maximumValue = _mp3Time;
    }
    [self.tabBarListTableView registerNib:[UINib nibWithNibName:@"TabBarListViewCell" bundle:nil] forCellReuseIdentifier:@"listcell"];
    NSLog(@"%@",_bookInformation.announcer);
 
    
}
- (IBAction)tabBarListDelete:(id)sender {
    
    
}
- (IBAction)tabBarListLikes:(id)sender {
    
    
}

//列表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kBookInfosHandle.bookInfosArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TabBarListViewCell *listCell = [self.tabBarListTableView dequeueReusableCellWithIdentifier:@"listcell"];
    BookList * book = kBookInfosHandle.bookInfosArray[indexPath.row];
    listCell.listLabel.text = book.name;
    return listCell;
}
- (void)selectMenuAtIndex:(NSInteger)index {
    NSLog(@"选中:%zd",index);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置头像图
//    self.header.headImageView.layer.cornerRadius = self.header.headImageView.frame.size.width / 4;
//    self.header.headImageView.layer.masksToBounds = YES;
    
    // 边框
//    self.header.headImageView.layer.borderWidth = 2;
    [self addObserver:self forKeyPath:@"segmentTopInset" options:NSKeyValueObservingOptionNew context:CustomHeaderInsetObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self tabBarViewLoad];
    self.navigationController.navigationBar.translucent = YES;
}
#pragma mark view
// 更新并设置view上所有子视图
- (void)playAndSetUpViews {
    _bookList = kBookInfosHandle.bookInfosArray[_index];
    _bookInformation = kBookInfosHandle.bookMP3;
    [kAVPlayerManager playWithUrl:_bookList.path currentIndex:self.index];
    // 改变播放按钮的状态
    [_tabBarPlayButton setImage:[UIImage imageNamed:@"tabBarpause"] forState:UIControlStateNormal];
    // tabbar image
    _tabbarSongImageView.layer.cornerRadius = 30;
    _tabbarSongImageView.layer.masksToBounds = YES;
    _tabbarSongImageView.layer.borderWidth = 1;
    [_tabbarSongImageView sd_setImageWithURL:[NSURL URLWithString:_bookInformation.cover]];
//    tabBar name
    _tabBarSongName.text = _bookList.name;
//tabBar deit
    _tabBarSongAuthor.text  = _bookInformation.author;
    // 设置timeSlider
    _progressSlider.minimumValue = 0.0;
    _mp3Time = [kAVPlayerManager getMp3TimeOfurl:_bookList.path];
    _progressSlider.maximumValue = _mp3Time;
    _progressSlider.value = 0;
}
#pragma mark progress按钮
- (IBAction)progressButton:(id)sender {
    [kAVPlayerManager seekToTime:_progressSlider.value];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (context == CustomHeaderInsetObserver) {
        CGFloat inset = [change[NSKeyValueChangeNewKey] floatValue];
        [self.header updateHeadPhotoWithTopInset:inset];
        // 设置头像图
        self.header.headImageView.layer.cornerRadius = self.header.headImageView.frame.size.width / 2;
        self.header.headImageView.layer.masksToBounds = YES;
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentTopInset"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//弹出按钮
- (IBAction)SongButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    PCStackMenu *stackMenu = [[PCStackMenu alloc] initWithTitles:[NSArray arrayWithObjects:@"Setting", @"Search", @"Twitter", @"Message", @"Share", @"More ...", nil]
                                                      withImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"gear@2x.png"], [UIImage imageNamed:@"magnifier@2x.png"], [UIImage imageNamed:@"twitter@2x.png"], [UIImage imageNamed:@"speech@2x.png"], [UIImage imageNamed:@"actions@2x"], nil]
                                                    atStartPoint:CGPointMake(button.frame.origin.x, button.frame.origin.y)
                                                          inView:self.view
                                                      itemHeight:40
                                                   menuDirection:PCStackMenuDirectionCounterClockWiseUp];
    for(PCStackMenuItem *item in stackMenu.items)
        item.stackTitleLabel.textColor = [UIColor yellowColor];
				
    [stackMenu show:^(NSInteger selectedMenuIndex) {
        NSLog(@"menu index : %ld", (long)selectedMenuIndex);
    }];

    
}
//tabBar 列表按钮
- (IBAction)tabBarListButton:(id)sender {
    [self.tabBarListTableView reloadData];
    self.tabBarListTableView.contentOffset = CGPointMake(0, 100);
    if (self.isTabBarListOpen) {
        [UIView animateWithDuration:1 animations:^{
            _tabbarListOtherView.hidden = YES;
            _tabBarListView.hidden = YES;
            _isTabBarListOpen = NO;
        }];

    }
    else {
        [UIView animateWithDuration:1 animations:^{
            _tabBarListView.hidden = NO;
            _tabbarListOtherView.hidden = NO;
            _isTabBarListOpen = YES;
        }];
    }
}
#pragma mark 下一曲
- (IBAction)tabBarLastButton:(id)sender {
    _bookList = [kBookInfosHandle bookInfoNextWithIndex:&_index];
    [self playAndSetUpViews];
    
}
#pragma mark 播放
- (IBAction)tabBarPlayButton:(id)sender {
    
    if (kAVPlayerManager.status == isPaused || kAVPlayerManager.status == isStoped) {
        [kAVPlayerManager play];
        [_tabBarPlayButton setImage:[UIImage imageNamed:@"playPause"] forState:UIControlStateNormal];
    } else if (kAVPlayerManager.status == isPlaying) {
        [kAVPlayerManager pause];
        [_tabBarPlayButton setImage:[UIImage imageNamed:@"playPlay"] forState:UIControlStateNormal];
    }
    
}
#pragma mark - 定时器改变时间
- (void)changeTime:(CGFloat)time {
    // 改变silder的位置
    _progressSlider.value = time;

    // 转动imageView
    [UIView animateWithDuration:0.1 animations:^{
        _tabbarSongImageView.transform = CGAffineTransformRotate(_tabbarSongImageView.transform, 0.05);
    }];
}
- (IBAction)tabBarListDisapperAction:(id)sender {
    
    _tabBarListView.hidden = YES;
    _tabbarListOtherView.hidden = YES;
    _isTabBarListOpen = NO;
}

- (IBAction)tabBarSongImageViewAction:(id)sender {
    
    PlayerViewController *playVC = [[PlayerViewController alloc]init];
    [self presentViewController:playVC animated:YES completion:nil];

    
}

#pragma mark - 根据播放模式取出下一首播放的music
- (void)getMusicByLoopMode {
    switch (kAVPlayerManager.loopMode) {
        case LoopModeOrderMode:
            _bookList = [kBookInfosHandle bookInfoNextWithIndex:&_index];
            [self playAndSetUpViews];
            break;
        case LoopModeSingleMond:
            [self playAndSetUpViews];
            break;
        case LoopModeRandomMode:
            [self playAndSetUpViews];
            break;
        default:
            NSLog(@"未知播放模式，请设置");
            break;
    }
}
- (void)playDidFinished {
    // 根据模式取出下一首播放的music
    [self getMusicByLoopMode];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
