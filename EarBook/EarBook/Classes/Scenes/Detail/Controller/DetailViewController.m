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
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "BookMP3.h"

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
    
    if (self.pushFrom == PushFromMoreListVC) {
        [self reloadUIWithBook:self.book];
        [self bookListWithBook:self.book];
    } else {
        // 请求数据
        [self requestData];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.bottomScrollView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    self.contentHeight.constant = CGRectGetMaxY(self.descLabel.frame) + 90;
//    NSLog(@"%f", self.contentHeight.constant);
    
    [self layoutSubView];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载详情数据
- (void)requestData
{
    // 详情页数据加载
    NSString *bookDetailURL = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, _book.url, EB_BOOK_DETAIL_URL];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    BookMP3 *book = [BookMP3 new];
    
    __weak typeof(self) detailVC = self;
    [session GET:bookDetailURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             [book setValuesForKeysWithDictionary:responseObject];
//             book.ID = responseObject[@"id"];
             
             [detailVC bookListWithBook:book];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 刷新详情界面
                 [detailVC reloadUIWithBook:book];
             });
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning Alert
             NSLog(@"请求出错");
         }];
    
    
}

#pragma mark - 加载列表数据
- (void)bookListWithBook:(BookMP3 *)book
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 列表页数据加载
    NSString *bookListURL = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_LIST_BASE_URL, book.ID, EB_BOOK_LIST_URL];
    [session GET:bookListURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             for (NSDictionary *dict in responseObject[@"list"]) {
                 BookMP3 *book = [BookMP3 new];
                 [book setValuesForKeysWithDictionary:dict];
                 [self.listArray addObject:book];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.listTableView reloadData];
             });
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning Alert
             NSLog(@"请求出错");
         }];
}

#pragma mark - 刷新详情界面
- (void)reloadUIWithBook:(BookMP3 *)book
{
    
    self.navigationItem.title = book.name;
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:book.cover]];
    _nameLabel.text = book.name;
    _typeLabel.text = [NSString stringWithFormat:@"类别：%@",book.type];
    _authorLabel.text = [NSString stringWithFormat:@"原著：%@",book.author];
    _announcerLabel.text = [NSString stringWithFormat:@"主播：%@",book.announcer];
    _sectionsLabel.text = [NSString stringWithFormat:@"集数：%@",book.sections];
    _playLabel.text = [NSString stringWithFormat:@"播放量：%.1f万",book.play.floatValue / 10000];
    _descLabel.text = book.desc;
    if (book.state.integerValue == 2) {
        _statusLabel.text = @"状态：完结";
    } else {
        _statusLabel.text = @"状态：连载";
    }
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
