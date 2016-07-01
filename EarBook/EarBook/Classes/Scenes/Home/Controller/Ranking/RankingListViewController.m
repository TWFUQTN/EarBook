//
//  RankingListViewController.m
//  EarBook
//
//  Created by lanou3g on 16/7/1.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RankingListViewController.h"
#import "DetailViewController.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "List.h"
#import "BookMP3.h"
#import "ZF_SegmentLabelView.h"
#import "MoreListCell.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kRankingTableViewTag 321230

@interface RankingListViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *itemArr;

// 头视图
@property (nonatomic, strong) ZF_SegmentLabelView *topList;

// 底部滚动视图
@property (nonatomic, strong) UIScrollView *rankingScrollView;

// 榜单的tableView
@property (nonatomic, strong) UITableView *weekRankingTableView;
@property (nonatomic, strong) UITableView *monthRankingTableView;
@property (nonatomic, strong) UITableView *totalRankingTableView;

// 数组
@property (nonatomic, strong) NSMutableArray *weekRankingArray;
@property (nonatomic, strong) NSMutableArray *monthRankingArray;
@property (nonatomic, strong) NSMutableArray *totalRankingArray;

@end

@implementation RankingListViewController

- (NSMutableArray *)weekRankingArray
{
    if (!_weekRankingArray) {
        _weekRankingArray = [NSMutableArray array];
    }
    return _weekRankingArray;
}

- (NSMutableArray *)monthRankingArray
{
    if (!_monthRankingArray) {
        _monthRankingArray = [NSMutableArray array];
    }
    return _monthRankingArray;
}

- (NSMutableArray *)totalRankingArray
{
    if (!_totalRankingArray) {
        _totalRankingArray = [NSMutableArray array];
    }
    return _totalRankingArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *weekURLStr = [NSString stringWithFormat:@"%@%@%@", EB_WEEK_BASE_URL, _bookList.rankType, EB_WEEK_RANKING_URL];
    NSString *monthURLStr = [NSString stringWithFormat:@"%@%@%@", EB_MONTH_BASE_URL, _bookList.rankType, EB_MONTH_RANKING_URL];
    NSString *totalURLStr = [NSString stringWithFormat:@"%@%@%@", EB_TOTAL_BASE_URL, _bookList.rankType, EB_TOTAL_RANKING_URL];
    [self requestDataWithURLString:weekURLStr DataArray:self.weekRankingArray];
    [self requestDataWithURLString:monthURLStr DataArray:self.monthRankingArray];
    [self requestDataWithURLString:totalURLStr DataArray:self.totalRankingArray];
    
    // 初始化布局
    [self initLayout];

    // 返回cell
    [self.weekRankingTableView registerNib:[UINib nibWithNibName:@"MoreListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.monthRankingTableView registerNib:[UINib nibWithNibName:@"MoreListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.totalRankingTableView registerNib:[UINib nibWithNibName:@"MoreListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 初始化布局
- (void)initLayout
{
    self.title = _bookList.rankName;
    
    // 设置navigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    // 头视图
    self.itemArr = @[@"周榜", @"月榜", @"总榜"];
    NSDictionary *dicNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:15],NSFontAttributeName ,nil];
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:EB_MAIN_COLOR,NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
    
    ZF_SegmentLabelView *topList = [[ZF_SegmentLabelView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40) viewBackgroundColor:EB_COLOR(245, 245, 245, 1) items:_itemArr dicNormal:dicNormal dicSelected:dicSelected labelBackgroundColor:EB_MAIN_COLOR];
    
    // 设置选中的榜单
    topList.upSegment.selectedSegmentIndex = _rangeType - 1;
    
    self.topList = topList;
    
    [self.view addSubview:topList];
    
    [topList.upSegment addTarget:self action:@selector(segmentClick:) forControlEvents:(UIControlEventValueChanged)];
    
    // 滚动视图
    UIScrollView *rankingScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topList.frame), kScreenW, kScreenH - CGRectGetHeight(topList.frame))];
    rankingScrollView.alwaysBounceHorizontal = YES;
    rankingScrollView.pagingEnabled = YES;
//    rankingScrollView.backgroundColor = [UIColor redColor];
    rankingScrollView.contentSize = CGSizeMake(kScreenW * _itemArr.count, 0);
    self.rankingScrollView = rankingScrollView;
    [self.view addSubview:rankingScrollView];
    
    rankingScrollView.delegate = self;
    
    for (int i = 0; i < _itemArr.count; i++) {
        UITableView *rankingTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenW * i, 0, kScreenW, CGRectGetHeight(rankingScrollView.frame)) style:(UITableViewStylePlain)];
        rankingTableView.tableHeaderView = [UIView new];
        rankingTableView.tag = kRankingTableViewTag + i;
        
        rankingTableView.delegate = self;
        rankingTableView.dataSource = self;
        
        [self.rankingScrollView addSubview:rankingTableView];
    }
    
    // 通过tag取出对应的tableView
    self.weekRankingTableView = [self.rankingScrollView viewWithTag:kRankingTableViewTag];
//    self.weekRankingTableView.delegate = self;
//    self.weekRankingTableView.dataSource = self;
    
    self.monthRankingTableView = [self.rankingScrollView viewWithTag:kRankingTableViewTag + 1];
//    self.monthRankingTableView.delegate = self;
//    self.monthRankingTableView.dataSource = self;
    
    self.totalRankingTableView = [self.rankingScrollView viewWithTag:kRankingTableViewTag + 2];
//    self.totalRankingTableView.delegate = self;
//    self.totalRankingTableView.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self moveLabelAndViewByIndex:_rangeType - 1];
}

#pragma mark - 请求数据
- (void)requestDataWithURLString:(NSString *)urlString
                       DataArray:(NSMutableArray *)dataArray
{
    
    __weak typeof(self)rankingListVC = self;
    
    [self requestDataWithURLString:urlString Block:^(id responseObject) {
        NSArray *resultArray = responseObject[@"list"];
        if (resultArray.count > 0) {
            for (NSDictionary *dict in resultArray) {
                BookMP3 *book = [BookMP3 new];
                [book setValuesForKeysWithDictionary:dict];
                
                [rankingListVC requestDetailDataWithBook:book DataArray:dataArray];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [rankingListVC reloadUIWithDataArray:dataArray];
        });
    }];
}

#pragma mark - 二次请求数据
- (void)requestDetailDataWithBook:(BookMP3 *)book
                        DataArray:(NSMutableArray *)dataArray
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, book.ID, EB_BOOK_DETAIL_URL];
    __weak typeof(self)rankingListVC = self;
    
    [self requestDataWithURLString:urlString Block:^(id responseObject) {
        BookMP3 *book = [BookMP3 new];
        [book setValuesForKeysWithDictionary:responseObject];
        [dataArray addObject:book];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [rankingListVC reloadUIWithDataArray:dataArray];
        });
    }];
}

#pragma mark - 刷新UI
- (void)reloadUIWithDataArray:(NSMutableArray *)dataArray
{
    if (dataArray == _weekRankingArray) {
        [self.weekRankingTableView reloadData];
    }
    if (dataArray == _monthRankingArray) {
        [self.monthRankingTableView reloadData];
    }
    if (dataArray == _totalRankingArray) {
        [self.totalRankingTableView reloadData];
    }
}

#pragma mark - 请求数据封装
- (void)requestDataWithURLString:(NSString *)urlString
                           Block:(RankingListVCBlock)block
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             block(responseObject);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
}

#pragma mark - scrollView代理方法
//已经结束滚动的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = 0;
    
    index = self.rankingScrollView.contentOffset.x / kScreenW;
    self.topList.upSegment.selectedSegmentIndex = index;
    [self moveLabelAndViewByIndex:index];
}

#pragma mark - segment点击响应方法
- (void)segmentClick:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    
    [self moveLabelAndViewByIndex:index];
}

#pragma mark - 根据点击segment的位置移动下面的滑动条以及切换页面
- (void)moveLabelAndViewByIndex:(NSInteger)index {
    // 添加动画
    [UIView animateWithDuration:0.1 animations:^{
        
        CGRect frame = self.topList.downLabel.frame;
        // 移动label
        frame.origin.x = CGRectGetWidth(self.topList.upSegment.frame) / self.itemArr.count * index;
        
        self.topList.downLabel.frame = frame;
        
        self.rankingScrollView.contentOffset = CGPointMake(kScreenW * index, 0);
    }];
}

#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == kRankingTableViewTag) {
        return _weekRankingArray.count;
    }
    if (tableView.tag == kRankingTableViewTag + 1) {
        return _monthRankingArray.count;
    }
    return _totalRankingArray.count;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     MoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (tableView.tag == kRankingTableViewTag) {
        cell.book = _weekRankingArray[indexPath.row];
    }
    if (tableView.tag == kRankingTableViewTag + 1) {
        cell.book = _monthRankingArray[indexPath.row];
    }
    if (tableView.tag == kRankingTableViewTag + 2) {
        cell.book = _totalRankingArray[indexPath.row];
    }
    return cell;
}

#pragma mark cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailVC = [DetailViewController new];
    detailVC.pushFrom = PushFromMoreListVC;
    
    if (tableView.tag == kRankingTableViewTag) {
        detailVC.book = _weekRankingArray[indexPath.row];
    }
    if (tableView.tag == kRankingTableViewTag + 1) {
        detailVC.book = _monthRankingArray[indexPath.row];
    }
    if (tableView.tag == kRankingTableViewTag + 2) {
        detailVC.book = _totalRankingArray[indexPath.row];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
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
