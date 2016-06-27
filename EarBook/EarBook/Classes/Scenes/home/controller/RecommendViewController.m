//
//  RecommendViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RecommendViewController.h"
#import "WYScrollView.h"
#import "BookCell.h"
#import "RecommendCell.h"
#import "EB_URL.h"
#import "BookMP3.h"
#import "RecommendHeaderView.h"
#import "SpecialSubjectCell.h"
#import <AFNetworking/AFNetworking.h>

@interface RecommendViewController ()<WYScrollViewNetDelegate>

/** 网络图片数组*/
@property(nonatomic,strong) NSMutableArray *NetImageArray;

@property (nonatomic, strong) NSMutableDictionary *bookDict;

/// 录播图
@property (nonatomic, strong) WYScrollView *wyNetScrollView;

/// 网络请求
@property (nonatomic, strong)  AFHTTPSessionManager *session;

@property (nonatomic, assign) NSInteger groupNumber;

@end

@implementation RecommendViewController

// 懒加载
- (AFHTTPSessionManager *)session
{
    if (!_session) {
        _session = [AFHTTPSessionManager manager];
        // 设置请求接口回来的时候,支持什么类型的数据
        _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    }
    return _session;
}

-(NSMutableArray *)NetImageArray
{
    if(!_NetImageArray)
    {

        _NetImageArray = @[@"http://ws.xzhushou.cn/focusimg/201508201549023.jpg",@"http://ws.xzhushou.cn/focusimg/52.jpg",@"http://ws.xzhushou.cn/focusimg/51.jpg",@"http://ws.xzhushou.cn/focusimg/50.jpg"].mutableCopy;
//        _NetImageArray = [NSMutableArray array];
    }
    return _NetImageArray;
}

- (NSMutableDictionary *)bookDict
{
    if (!_bookDict) {
        _bookDict = [NSMutableDictionary dictionary];
    }
    return _bookDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
    [self requestData];
    
    // 隐藏每一行的分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 注册cell
    [self.tableView registerClass:[BookCell class] forCellReuseIdentifier:@"bookCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:@"recommendCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecialSubjectCell" bundle:nil] forCellReuseIdentifier:@"SpecialSubjectCell"];
    
    // 添加轮播图
    [self createNetScrollView];
}

#pragma mark - 加载数据
- (void)requestData
{
    __weak typeof(self) recommendVC = self;
    [self.session GET:EB_RECOMMEND_LIST_URL
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                  NSLog(@"%@", responseObject[@"list"]);
                  
                  NSArray *dataArray = responseObject[@"list"];

                  recommendVC.groupNumber = dataArray.count;
                  NSMutableArray *urlArray = [NSMutableArray array];
                  for (NSDictionary *dict in dataArray) {
                      
                      NSString *urlBody = dict[@"name"];
                      
                      // 拼接
                      NSString *urlStr = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, urlBody];
                      [urlArray addObject:urlStr];
//                      NSLog(@"%@", urlStr);
                  }
                  
                  // 分析section = 0的数据
                  [recommendVC analyzeDataWithURLString:urlArray[1] section0:@0];
                  
                  // 分析section = 1的数据
                  [recommendVC analyzeDataWithURLString:urlArray[3] section1:@1];
                  
                  // 分析section = 2的数据
                  [recommendVC analyzeDataWithURLString:urlArray[4] section1:@2];
                  
                  // 返回主线程
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      [self.tableView reloadData];
                  });

              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"网络请求错误");
              }];
}

#pragma mark - 分析section = 0的数据
- (void)analyzeDataWithURLString:(NSString *)urlString
                         section0:(NSNumber *)section
{
    [self.session GET:urlString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSMutableArray *array = [NSMutableArray array];
                         for (NSDictionary *dict in responseObject[@"list"]) {
                             BookMP3 *book = [BookMP3 new];
                             [book setValuesForKeysWithDictionary:dict];
//                             NSLog(@"%@", book.name);
                             [array addObject:book];
//                             [self.bookArray addObject:book];
                             [self.bookDict setObject:array forKey:section];
                         }
                         // 返回主线程
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             [self.tableView reloadData];
                         });
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"网络请求错误");
                     }];
}

#pragma mark - 分析section = 1/2的数据
- (void)analyzeDataWithURLString:(NSString *)urlString
                         section1:(NSNumber *)section
{
    [self.session GET:urlString
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSArray *listArray = [[responseObject[@"list"] firstObject] objectForKey:@"list"];
                  NSMutableArray *bookArray = [NSMutableArray array];
                  NSMutableArray *bookArr1 = [NSMutableArray array];
                  NSMutableArray *bookArr2 = [NSMutableArray array];
                  for (int i = 0; i < listArray.count; i++) {
                      BookMP3 *book = [BookMP3 new];
                      [book setValuesForKeysWithDictionary:listArray[i]];
                      if (i < 3) {
                          [bookArr1 addObject:book];
                      } else {
                          [bookArr2 addObject:book];
                      }
                  }
                  [bookArray addObject:bookArr1];
                  [bookArray addObject:bookArr2];
                  [self.bookDict setObject:bookArray forKey:section];
                  // 返回主线程
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      [self.tableView reloadData];
                  });
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"网络请求错误");
              }];
}


-(NSString *)segmentTitle
{
    return @"推荐";
}

#pragma mark - 轮播图
-(void)createNetScrollView
{
    /** 设置网络scrollView的Frame及所需图片*/
    WYScrollView *wyNetScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150) WithNetImages:self.NetImageArray];
    
    /** 设置滚动延时*/
    wyNetScrollView.AutoScrollDelay = 3;
    
    /** 设置占位图*/
    wyNetScrollView.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
    
    
    /** 获取网络图片的index*/
    wyNetScrollView.netDelagate = self;
    
    self.wyNetScrollView = wyNetScrollView;
    /** 添加到当前tableView上*/
//    self.tableView.tableHeaderView = WYNetScrollView;
    
}
/** 获取网络图片的index*/
-(void)didSelectedNetImageAtIndex:(NSInteger)index
{
    NSLog(@"点中网络图片的下标是:%ld",(long)index);
}

//-(UIScrollView *)streachScrollView
//{
//    return self.tableView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0 || section == 1 || section == 2) {
        return 2;
    }
    return 1;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            RecommendCell *recCell = [tableView dequeueReusableCellWithIdentifier:@"recommendCell"];
            
            // 获取字典中对应的数据数组
            NSArray *arr = _bookDict[@0];
            
            if (arr.count > 0) {
                recCell.book = arr[indexPath.row];
            }
            
            return recCell;
            break;
        }
        case 1: {
            BookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
            
            bookCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *arr = _bookDict[@1];
            
            if (arr.count > 0) {
                if (indexPath.row == 0) {
                    bookCell.bookArray = arr[0];
                }
                if (indexPath.row == 1) {
                    bookCell.bookArray = arr[1];
                }
            }
            
            return bookCell;
            break;
        }
        case 2: {
            BookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
            
            bookCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *arr = _bookDict[@2];
            
            if (arr.count > 0) {
                if (indexPath.row == 0) {
                    bookCell.bookArray = arr[0];
                }
                if (indexPath.row == 1) {
                    bookCell.bookArray = arr[1];
                }
            }
            
            return bookCell;
            break;
        }
        case 3: {
            SpecialSubjectCell *specialSubjectCell = [tableView dequeueReusableCellWithIdentifier:@"SpecialSubjectCell"];
            specialSubjectCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return specialSubjectCell;
            break;
        }
            
        default: {
            
            break;
        }
    }
    BookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
    
    bookCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return bookCell;
}

#pragma mark 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 65;
    }
    if (indexPath.section == 3) {
        return 90;
    }
    return 168;
}

#pragma mark 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RecommendHeaderView *headerView = [RecommendHeaderView new];
    switch (section) {
        case 0: {
            return self.wyNetScrollView;
            break;
        }
        case 1:
            headerView.titleLabel.text = @"小编推荐";
            return headerView;
            break;
        case 2:
            headerView.titleLabel.text = @"新书推荐";
            return headerView;
            break;
        case 3:
            headerView.titleLabel.text = @"更多专题";
            return headerView;
            break;
        default:
            return headerView;
            break;
    }
}

#pragma mark 头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 155;
    }
    return 40;
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
