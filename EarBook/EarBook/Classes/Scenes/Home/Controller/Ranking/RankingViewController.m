//
//  RankingViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RankingViewController.h"
#import "DetailViewController.h"
#import "BookCell.h"
#import "BookMP3.h"
#import "List.h"
#import "EB_URL.h"
#import "RankingHeader.h"

@interface RankingViewController ()

/// 列表数组
@property (nonatomic, strong) NSMutableArray *listArray;

/// 数据字典
@property (nonatomic, strong) NSMutableDictionary *bookDict;

/// title数组
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation RankingViewController

- (NSMutableDictionary *)bookDict
{
    if (!_bookDict) {
        _bookDict = [NSMutableDictionary dictionary];
    }
    return _bookDict;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求数据
    [self requestData];
    // 注册cell
    [self.tableView registerClass:[BookCell class] forCellReuseIdentifier:@"BookCell"];
    // 注册头视图
    [self.tableView registerClass:[RankingHeader class] forHeaderFooterViewReuseIdentifier:@"RankingHeader"];
    
    // 下拉刷新
    __weak typeof(self) rankingVC = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [rankingVC requestData];
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
             
             // 解析数据
             NSArray *resultArray = responseObject[@"list"];
             if (resultArray.count > 0) {
                 for (NSDictionary *dict in resultArray) {
                     List *bookList = [List new];
                     [bookList setValuesForKeysWithDictionary:dict];
                     [rankingVC.listArray addObject:bookList];
                     NSMutableArray *bookArray = [NSMutableArray array];
                     if (bookList.list.count > 0) {
                         for (NSDictionary *dict in bookList.list) {
                             BookMP3 *book = [BookMP3 new];
                             [book setValuesForKeysWithDictionary:dict];
                             [bookArray addObject:book];
                         }
                         [rankingVC.bookDict setObject:bookArray forKey:bookList.name];
                     } else {
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
             });
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
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
    if (_bookDict.count > 0 && self.titleArray.count > 0) {

        NSString *key = self.titleArray[indexPath.section];
        cell.bookArray = _bookDict[key];
    }
    
    cell.block = ^void(BookMP3 *book) {
        DetailViewController *detailVC = [DetailViewController new];
        detailVC.book = book;
        detailVC.pushFrom = PushFromRecommendVC;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    
    return cell;
}

#pragma mark - header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RankingHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RankingHeader"];
    
    header.title = _titleArray[section];
    
    return header;
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
