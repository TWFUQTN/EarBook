//
//  RankingViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RankingViewController.h"
#import "DetailViewController.h"
#import "RankingListViewController.h"
#import "MoreListViewController.h"
#import "BookCell.h"
#import "BookMP3.h"
#import "List.h"
#import "EB_URL.h"
#import "RankingHeader.h"
#import "RecommendHeaderView.h"
#import "MBProgressHUD+GifHUD.h"
#import "ReloadView.h"



#define kRankingListTag 542308

@interface RankingViewController ()

/// 榜单列表数组
@property (nonatomic, strong) NSMutableArray *rankingListArray;

/// 列表数组
@property (nonatomic, strong) NSMutableArray *listArray;

/// 数据字典
@property (nonatomic, strong) NSMutableDictionary *bookDict;

/// 列表字典
@property (nonatomic, strong) NSMutableDictionary *listDict;

/// title数组
@property (nonatomic, strong) NSMutableArray *titleArray;

//@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, strong) RankingHeader *header1;
@property (nonatomic, strong) RankingHeader *header2;
@property (nonatomic, strong) RankingHeader *header3;
@property (nonatomic, strong) RankingHeader *header4;

//重新加载视图
@property (nonatomic, strong) ReloadView *reloadView;


@end

@implementation RankingViewController

- (NSMutableDictionary *)listDict
{
    if (!_listDict) {
        _listDict = [NSMutableDictionary dictionary];
    }
    return _listDict;
}

- (NSMutableDictionary *)bookDict
{
    if (!_bookDict) {
        _bookDict = [NSMutableDictionary dictionary];
    }
    return _bookDict;
}

- (NSMutableArray *)rankingListArray
{
    if (!_rankingListArray) {
        _rankingListArray = [NSMutableArray array];
    }
    return _rankingListArray;
}

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"热门榜", @"好评榜", @"搜索榜", @"下载榜", @"男生必听", @"女生爱听"].mutableCopy;
    }
    return _titleArray;
}

- (ReloadView *)reloadView {
    if (!_reloadView) {
        _reloadView = [[ReloadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _reloadView;
}


//显示等待视图
- (void)showGif {
    [MBProgressHUD setUpGifWithFrame:CGRectMake(0, 0, 80, 80) gifName:@"wait" andShowToView:self.view];
}

//隐藏等待视图
- (void)hideGifView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"back2.jpg"];
    self.tableView.backgroundView = imageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //等待视图
    [self showGif];
    
    // 请求数据
    [self requestData];
    // 注册cell
    [self.tableView registerClass:[BookCell class] forCellReuseIdentifier:@"BookCell"];
    // 注册头视图
    [self.tableView registerClass:[RankingHeader class] forHeaderFooterViewReuseIdentifier:@"RankingHeader"];
    
    // 下拉刷新
    __weak typeof(self) rankingVC = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self showGif];
        [rankingVC requestData];
        // 结束刷新
        [rankingVC.tableView.mj_footer endRefreshing];
        [self hideGifView];
    }];
    
}

#pragma mark - 请求数据
- (void)requestData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) rankingVC = self;
    [session GET:EB_RANKING_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             //刷新数据
             for (UIView *view in self.view.superview.subviews) {
                 if (view == self.reloadView) {
                     NSLog(@"dfjaldsfj=======");
                     [view removeFromSuperview];
                 }
             }
             
             // 解析数据
             NSString *urlString = @"";
             NSArray *resultArray = responseObject[@"list"];
             if (resultArray.count > 0) {
                 for (NSDictionary *dict in resultArray) {
                     urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, dict[@"name"]];
                     NSLog(@"%@", urlString);
                     [rankingVC requestDataTowWithURLString:urlString];
                 }
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [rankingVC.tableView reloadData];
             });
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideGifView];
             [self.view.superview addSubview:self.reloadView];
             __weak typeof(self) weakSelf = self;
             self.reloadView.block = ^() {
                 
                 [weakSelf requestData];
                 NSLog(@"*******");
                 [weakSelf showGif];
                 
             };

         }];
}

#pragma mark - 二次请求数据
- (void)requestDataTowWithURLString:(NSString *)urlString
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) rankingVC = self;
    [session GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             //刷新数据
             for (UIView *view in self.view.superview.subviews) {
                 if (view == self.reloadView) {
                     NSLog(@"dfjaldsfj=======");
                     [view removeFromSuperview];
                 }
             }
             
             // 解析数据
             NSArray *resultArray = responseObject[@"list"];
             if (resultArray.count > 0) {
                 for (NSDictionary *dict in resultArray) {
                     List *bookList = [List new];
                     [bookList setValuesForKeysWithDictionary:dict];
//                     [rankingVC.listDict setObject:bookList forKey:bookList.name];
                     
                     NSMutableArray *bookArray = [NSMutableArray array];
                     if (bookList.list.count > 0) {
                         [rankingVC.listArray addObject:bookList];
                         for (NSDictionary *dict in bookList.list) {
                             BookMP3 *book = [BookMP3 new];
                             [book setValuesForKeysWithDictionary:dict];
                             [bookArray addObject:book];
                         }
                         [rankingVC.bookDict setObject:bookArray forKey:bookList.name];
                     } else {
                         [rankingVC.rankingListArray addObject:bookList];
                         for (NSDictionary *dict in bookList.bookList) {
                             BookMP3 *book = [BookMP3 new];
                             [book setValuesForKeysWithDictionary:dict];
                             [bookArray addObject:book];
                         }
                         [rankingVC.bookDict setObject:bookArray forKey:bookList.rankName];
                     }
                 }
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [rankingVC.tableView reloadData];
                 [self hideGifView];
             });
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideGifView];
             [self.view.superview addSubview:self.reloadView];
             __weak typeof(self) weakSelf = self;
             self.reloadView.block = ^() {
                 
                 [weakSelf requestData];
                 NSLog(@"*******");
                 [weakSelf showGif];
                 
             };
         }];
    
}

#pragma mark - 请求数据封装
//- (void)getData

-(NSString *)segmentTitle
{
    return @"榜单";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.bookDict.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

#pragma mark - cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell"];
    cell.alpha = 0.7;

    if (_bookDict.count > 0 && self.titleArray.count > 0) {

        NSString *key = self.titleArray[indexPath.section];
        cell.bookArray = _bookDict[key];
        
    }
    
    cell.block = ^void(BookMP3 *book) {
        DetailViewController *detailVC = [DetailViewController new];
        detailVC.book = book;
        detailVC.pushFrom = PushFromRecommendVC;
        detailVC.joiningURLString = JoiningURLStringByID;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    return cell;
}

#pragma mark - header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    self.flag = section;
    
    if (section == 4 || section == 5) {
        RecommendHeaderView *header = [RecommendHeaderView new];
        
        header.titleLabel.text = _titleArray[section];
        
        header.moreButton.tag = kRankingListTag + section;
        
        [header.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        header.alpha = 0.8;
        return header;
    }
    
    RankingHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RankingHeader"];
    header.alpha = 0.8;
    header.title = _titleArray[section];
    header.tag = kRankingListTag + section;
    self.header1.alpha = 0.8;
    self.header2.alpha = 0.8;
    self.header3.alpha = 0.8;
    self.header4.alpha = 0.8;

    switch (section) {
        case 0:
            self.header1 = header;
            break;
        case 1:
            self.header2 = header;
            break;
        case 2:
            self.header3 = header;
            break;
        case 3:
            self.header4 = header;
            break;
            
        default:
            break;
    }
    
    // 周榜
    header.weekRankingBtn.tag = kRankingListTag + 10;
    [header.weekRankingBtn addTarget:self action:@selector(rankingBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    // 月榜
    header.monthRankingBtn.tag = kRankingListTag + 20;
    [header.monthRankingBtn addTarget:self action:@selector(rankingBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    // 总榜
    header.totalRankingBtn.tag = kRankingListTag + 30;
    [header.totalRankingBtn addTarget:self action:@selector(rankingBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    

    return header;
}

#pragma mark - 更多按钮的点击事件
- (void)moreButtonAction:(UIButton *)sender
{
    MoreListViewController *moreListVC = [MoreListViewController new];
    
    List *bookList = [List new];
    
    if (sender.tag == kRankingListTag + 4) {
        bookList = _listArray[0];
    }
    if (sender.tag == kRankingListTag + 5) {
        bookList = _listArray[1];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_MORE_EDIT_RECOMMEND_URL, bookList.url];
    moreListVC.moreListURL = urlString;
    
    [self.navigationController pushViewController:moreListVC animated:YES];
}

#pragma mark - 榜单Button的点击事件
- (void)rankingBtnAction:(UIButton *)sender
{
    RankingListViewController *rankingListVC = [RankingListViewController new];

    // 取出数组中的值
    switch ([[sender superview] superview].tag) {
        case kRankingListTag:
            rankingListVC.bookList = _rankingListArray[0];
            break;
        case kRankingListTag + 1:
            rankingListVC.bookList = _rankingListArray[1];
            break;
        case kRankingListTag + 2:
            rankingListVC.bookList = _rankingListArray[2];
            break;
        case kRankingListTag + 3:
            rankingListVC.bookList = _rankingListArray[3];
            break;
            
        default:
            break;
    }
    
    
//    rankingListVC.bookList = _rankingListArray[_flag - 1];
    
    // 周榜
    if (sender.tag == kRankingListTag + 10) {
        rankingListVC.rangeType = 1;
    }
    // 月榜
    if (sender.tag == kRankingListTag + 20) {
        rankingListVC.rangeType = 2;
    }
    // 总榜
    if (sender.tag == kRankingListTag + 30) {
        rankingListVC.rangeType = 3;
    }
    
    [self.navigationController pushViewController:rankingListVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 336;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
