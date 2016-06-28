//
//  MoreListViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/27.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "MoreListViewController.h"
#import "DetailViewController.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "BookMP3.h"
#import "MoreListCell.h"

@interface MoreListViewController ()

/// 数据数组
@property (nonatomic, strong) NSMutableArray *allBookArray;

@end

@implementation MoreListViewController

- (NSMutableArray *)allBookArray
{
    if (!_allBookArray) {
        _allBookArray = [NSMutableArray array];
    }
    return _allBookArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求数据
    [self requestData];
    
    // 设置navigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MoreListCell" bundle:nil] forCellReuseIdentifier:@"MoreListCell"];
}

#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)requestData
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) moreListVC = self;
    [session GET:self.moreListURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             // 标题赋值
             moreListVC.navigationItem.title = responseObject[@"name"];
             // 初始化用于拼接URL的id
             NSString *idForURL = @"";
             if ([responseObject[@"count"] integerValue] > 0) {
                 for (NSDictionary *dict in responseObject[@"list"]) {
                     // 用于拼接URL的id赋值
                     idForURL = dict[@"id"];
                     
                     // 使用id拼接URL并二次请求
                     [moreListVC requestDataTowWithID:idForURL];
                 }
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [moreListVC.tableView reloadData];
             });
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
}

#pragma mark - 使用id拼接URL并二次请求
- (void)requestDataTowWithID:(NSString *)ID
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, ID, EB_BOOK_DETAIL_URL];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) moreListVC = self;
    [session GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             BookMP3 *book = [BookMP3 new];
             
             [book setValuesForKeysWithDictionary:responseObject];
             
             [moreListVC.allBookArray addObject:book];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [moreListVC.tableView reloadData];
             });
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allBookArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreListCell"];
    
    cell.book = _allBookArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailVC = [DetailViewController new];
    
    detailVC.book = _allBookArray[indexPath.row];
    
    detailVC.pushFrom = PushFromMoreListVC;
    
    [self.navigationController pushViewController:detailVC animated:YES];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
