//
//  DetailViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "DetailViewController.h"
#import "ZF_SegmentLabelView.h"
#import "ListCell.h"
#import "DB_COLOR.h"

#define kScrollWidth self.scrollView.frame.size.width
#define kScrollHeight self.scrollView.frame.size.height


@interface DetailViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//segment及滑动的label视图
@property (nonatomic, strong) ZF_SegmentLabelView *SLView;

//装标题的数组
@property (nonatomic, strong) NSArray *itemArr;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//类别
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//原著
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
//主播
@property (weak, nonatomic) IBOutlet UILabel *announcerLabel;
//状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//集数
@property (weak, nonatomic) IBOutlet UILabel *sectionsLabel;
//播放量
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
//详情介绍
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

//内层scrollView高度（自适应高）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

//底层scroll
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;

//tableView目录列表
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

//装目录列表信息
@property (nonatomic, strong) NSMutableArray *listArray;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomScrollView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    self.contentHeight.constant = CGRectGetMaxY(self.descLabel.frame) + 90;
    NSLog(@"%f", self.contentHeight.constant);
    
    [self layoutSubView];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

//页面布局
- (void)layoutSubView {
    //设置segment
    [self addSegment];
    
    //设置scrollView
//    [self addScrollView];
}

//添加一个scrollView
- (void)addScrollView{
    
//    UIView *dd = [[UIView alloc] initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height - self.SLView.frame.size.height - 64)];
//    
//    dd.backgroundColor = [UIColor cyanColor];
//    
//    [self.view addSubview:dd];
    
//    self.detailView = [[DetailView alloc] initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height - self.SLView.frame.size.height - 64)];
//    
//    [self.view addSubview:self.detailView];
    
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    
    return cell;
}

#pragma mark - scrollView代理方法
//已经结束滚动的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.bottomScrollView.contentOffset.x == 0) {
        NSInteger index = 0;
        self.SLView.upSegment.selectedSegmentIndex = index;
        [self moveLabelAndViewByIndex:index];
    } else {
        NSInteger index = 1;
        self.SLView.upSegment.selectedSegmentIndex = index;
        [self moveLabelAndViewByIndex:index];
    }
}

//添加一个segment和随之移动的label
- (void)addSegment {
    
    self.itemArr = @[@"详情介绍", @"章节列表"];
    
    NSDictionary *dicNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:15],NSFontAttributeName ,nil];
    
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
    
    self.SLView = [[ZF_SegmentLabelView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50) viewBackgroundColor:DB_COLOR(245, 245, 245, 1) items:self.itemArr dicNormal:dicNormal dicSelected:dicSelected labelBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:self.SLView];
    
    [self.SLView.upSegment addTarget:self action:@selector(segmentClick:) forControlEvents:(UIControlEventValueChanged)];
}


//segment点击响应方法
- (void)segmentClick:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    [self moveLabelAndViewByIndex:index];
}

//根据点击segment的位置移动下面的滑动条以及切换页面
- (void)moveLabelAndViewByIndex:(NSInteger)index {
    // 添加动画
    [UIView animateWithDuration:0.1 animations:^{
        
        CGRect frame = self.SLView.downLabel.frame;
        // 移动label
        frame.origin.x = CGRectGetWidth(self.SLView.upSegment.frame) / self.itemArr.count * index;
        
        self.SLView.downLabel.frame = frame;
        
        // 移动scroll视图
        self.bottomScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * index, 0) ;
        
    }];
    
    NSLog(@"我是第%ld页", index + 1);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
