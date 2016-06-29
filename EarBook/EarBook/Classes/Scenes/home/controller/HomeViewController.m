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

void *CustomHeaderInsetObserver = &CustomHeaderInsetObserver;

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) HomeCustomHeader *header;

@end

@implementation HomeViewController


-(instancetype)init
{
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
    [self tabBarViewLoad];
}
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
    [self.tabBarListTableView registerNib:[UINib nibWithNibName:@"TabBarListViewCell" bundle:nil] forCellReuseIdentifier:@"listcell"];
    
}
- (IBAction)tabBarListDelete:(id)sender {
}
- (IBAction)tabBarListLikes:(id)sender {
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TabBarListViewCell *listCell = [self.tabBarListTableView dequeueReusableCellWithIdentifier:@"listcell"];
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
    self.navigationController.navigationBar.translucent = YES;
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
- (IBAction)tabBarListButton:(id)sender {
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
- (IBAction)tabBarLastButton:(id)sender {
}
- (IBAction)tabBarPlayButton:(id)sender {
}
- (IBAction)tabBarListDisapperAction:(id)sender {
    _tabBarListView.hidden = YES;
    _tabbarListOtherView.hidden = YES;
    _isTabBarListOpen = NO;
}
- (IBAction)tabBarSongImageViewAction:(id)sender {
    PlayerViewController *playVC = [[PlayerViewController alloc]init];
//    UINavigationController *dog = [[UINavigationController alloc]initWithRootViewController:playVC];
    [self presentViewController:playVC animated:YES completion:nil];
//    [self.navigationController pushViewController:playVC animated:YES];
//    [self presentViewController:dog animated:YES completion:nil];
    
}
- (IBAction)tabBarListPlayAction:(id)sender {
    PlayerViewController *playVC = [[PlayerViewController alloc]init];
    [self presentViewController:playVC animated:YES completion:nil];
    
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
