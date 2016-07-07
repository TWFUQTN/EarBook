//
//  VoiceDetailViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import "ZF_SegmentLabelView.h"
#import "BookMP3.h"
#import "BookList.h"
#import "VoiceProgram.h"
#import "ListCell.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "Voice.h"

@interface VoiceDetailViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

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
//声音
@property (weak, nonatomic) IBOutlet UILabel *voicesLabel;
//播放量
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
//更新日期
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
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

@implementation VoiceDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 请求详情数据
    [self requestDetailData];
    // 请求列表数据
    [self requestListData];
    
    // 设置navigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    self.bottomScrollView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    [self layoutSubView];
    
    // 注册cell
    [self.listTableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

- (void)setVoice:(Voice *)voice {
    if (_voice != voice) {
        _voice = voice;
    }
    _book.url = _voice.ID;
}

#pragma mark - 请求详情数据
- (void)requestDetailData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", EB_VOICE_BASE_URL, _book.url, EB_VOICE_URL];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) voiceDetailVC = self;
    [session GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dict = responseObject[@"ablumn"];
             VoiceProgram *voice = [VoiceProgram new];
             [voice setValuesForKeysWithDictionary:dict];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 刷新列表
                 [voiceDetailVC reloadUIWithVoice:voice];
             });
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
    }];
}

#pragma mark - 请求播放列表数据
- (void)requestListData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", EB_VOICE_LIST_BASE_URL, _book.url, EB_VOICE_LIST_URL];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) voiceDetailVC = self;
    [session GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

             for (NSDictionary *dict in responseObject[@"list"]) {
                 BookList *list = [BookList new];
                 [list setValuesForKeysWithDictionary:dict];
                 [voiceDetailVC.listArray addObject:list];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 刷新列表
                 [voiceDetailVC.listTableView reloadData];
             });
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
}

#pragma mark - 刷新列表
- (void)reloadUIWithVoice:(VoiceProgram *)voice
{
    self.title = voice.name;
    
    self.nameLabel.text = voice.name;
    self.typeLabel.text = [NSString stringWithFormat:@"类别：%@", voice.typeName];
    self.voicesLabel.text = [NSString stringWithFormat:@"声音：%@", voice.sections];
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@", voice.author];
    self.playLabel.text = [NSString stringWithFormat:@"播放：%.1f万", voice.playCount. floatValue / 10000];
    self.announcerLabel.text = [NSString stringWithFormat:@"主播：%@", voice.announcer];
    self.descLabel.text = voice.Description;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:voice.cover] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    // 时间戳转为时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval time = [voice.updateTime doubleValue] / 1000;
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:time];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    self.updateLabel.text = [NSString stringWithFormat:@"更新日期：%@", [formatter stringFromDate:updateTime]];
}

#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//页面布局
- (void)layoutSubView {
    //设置segment
    [self addSegment];
}


#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (_listArray.count > 0) {
        cell.bookList = _listArray[indexPath.row];
    }
    
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
    
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:EB_MAIN_COLOR,NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
    
    self.SLView = [[ZF_SegmentLabelView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50) viewBackgroundColor:EB_COLOR(245, 245, 245, 1) items:self.itemArr dicNormal:dicNormal dicSelected:dicSelected labelBackgroundColor:EB_MAIN_COLOR];
    
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
