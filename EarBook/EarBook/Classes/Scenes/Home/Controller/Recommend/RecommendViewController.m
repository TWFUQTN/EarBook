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
#import "JoiningURL.h"
#import "RecommendHeaderView.h"
#import "SpecialSubjectCell.h"
#import "DetailViewController.h"
#import "MoreListViewController.h"
#import "SpecialSubjectViewController.h"
#import "SpecialSubjectDetailViewController.h"
#import "VoiceDetailViewController.h"
#import "MBProgressHUD+GifHUD.h"

#import <AVOSCloud.h>

#define baseTag 100

@interface RecommendViewController ()<WYScrollViewNetDelegate>

/** 网络图片数组*/
@property(nonatomic,strong) NSMutableArray *NetImageArray;

/// 数据字典
@property (nonatomic, strong) NSMutableDictionary *bookDict;

/// 录播图
@property (nonatomic, strong) WYScrollView *wyNetScrollView;

/// 网络请求
@property (nonatomic, strong)  AFHTTPSessionManager *session;

/// 标题数组
//@property (nonatomic, strong) NSMutableArray *titleArray;

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
        _NetImageArray = [NSMutableArray array];
        
        // @[@"http://ws.xzhushou.cn/focusimg/201508201549023.jpg",@"http://ws.xzhushou.cn/focusimg/52.jpg",@"http://ws.xzhushou.cn/focusimg/51.jpg",@"http://ws.xzhushou.cn/focusimg/50.jpg"].mutableCopy;
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
- (void)viewWillLayoutSubviews{
    // 添加轮播图
    [self createNetScrollView];
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
    imageView.image = [UIImage imageNamed:@"back1.jpg"];
    self.tableView.backgroundView = imageView;
    
    [self showGif];
    
    // 加载数据
    [self requestData];
    
    // 隐藏每一行的分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 注册cell
    [self.tableView registerClass:[BookCell class] forCellReuseIdentifier:@"bookCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:@"recommendCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SpecialSubjectCell" bundle:nil] forCellReuseIdentifier:@"SpecialSubjectCell"];
    
    // 下拉刷新
    __weak typeof(self) recommendVC = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self showGif];
        [recommendVC requestData];
        // 结束刷新
        [recommendVC.tableView.mj_footer endRefreshing];
        [self hideGifView];
    }];
    
    // 测试代码
//    AVObject *post = [AVObject objectWithClassName:@"TestObject"];
//    [post setObject:@"Hello World!" forKey:@"words"];
//    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            // 保存成功了！
//            NSLog(@"haha");
//        }
//    }];
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

                  NSMutableArray *urlArray = [NSMutableArray array];
                  for (NSDictionary *dict in dataArray) {
                      
                      NSString *urlBody = dict[@"name"];
                      
                      // 拼接
                      NSString *urlStr = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, urlBody];
                      [urlArray addObject:urlStr];
//                      NSLog(@"%@", urlStr);
                  }
                  // 分析section = 0头视图的数据
                  [recommendVC analyzeDataWithURLString:urlArray[0] sectionHead:@"Head"];
                  
                  // 分析section = 0的数据
                  [recommendVC analyzeDataWithURLString:urlArray[1] section0:@0];
                  
                  // 分析section = 1的数据
                  [recommendVC analyzeDataWithURLString:urlArray[3] section1:@1];
                  
                  // 分析section = 2的数据
                  [recommendVC analyzeDataWithURLString:urlArray[4] section1:@2];
                  
                  // 分析section = 3的数据
                  [recommendVC analyzeDataWithURLString:urlArray[5] section3:@3];
                  
                  // 返回主线程
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      [self.tableView reloadData];
                      [self hideGifView];
                  });

              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"网络请求错误");
              }];
}

#pragma mark - 分析section = 0头视图的数据
- (void)analyzeDataWithURLString:(NSString *)urlString
                     sectionHead:(NSString *)sectionHead
{
    [self analyzeDataWithURLString:urlString block:^(id  _Nullable responseObject) {
        // 解析数据
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"list"]) {
            BookMP3 *book = [BookMP3 new];
            [book setValuesForKeysWithDictionary:dict];
            [array addObject:book];
            [self.bookDict setObject:array forKey:sectionHead];
        }
        
        for (BookMP3 *book in _bookDict[@"Head"]) {
            NSString *str = [JoiningURL urlWithCoverStr:book.cover joiningStr:@"_720x333"];
            [self.NetImageArray addObject:str];
        }
    }];
}

#pragma mark - 分析section = 0的数据
- (void)analyzeDataWithURLString:(NSString *)urlString
                         section0:(NSNumber *)section
{
    [self analyzeDataWithURLString:urlString block:^(id  _Nullable responseObject) {
        // 解析数据
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"list"]) {
            BookMP3 *book = [BookMP3 new];
            [book setValuesForKeysWithDictionary:dict];
            [array addObject:book];
            [self.bookDict setObject:array forKey:section];
        }
    }];
}

#pragma mark - 分析section = 1/2的数据
- (void)analyzeDataWithURLString:(NSString *)urlString
                         section1:(NSNumber *)section
{
    [self analyzeDataWithURLString:urlString block:^(id  _Nullable responseObject) {
        // 解析数据
        NSDictionary *listDict = [responseObject[@"list"] firstObject];
        NSArray *listArray = listDict[@"list"];
        
        [self.bookDict setObject:listDict[@"url"] forKey:listDict[@"name"]];
        
        NSMutableArray *bookArray = [NSMutableArray array];
        for (int i = 0; i < listArray.count; i++) {
            BookMP3 *book = [BookMP3 new];
            [book setValuesForKeysWithDictionary:listArray[i]];
            [bookArray addObject:book];
        }
        [self.bookDict setObject:bookArray forKey:section];
        
    }];
}

#pragma mark - 分析section = 3的数据
- (void)analyzeDataWithURLString:(NSString *)urlString
                        section3:(NSNumber *)section
{
    
    [self analyzeDataWithURLString:urlString block:^(id  _Nullable responseObject) {
        // 解析数据
        NSMutableArray *bookArray = [NSMutableArray array];
        if (responseObject[@"count"] > 0) {
            for (NSDictionary *dict in responseObject[@"list"]) {
                
                BookMP3 *book = [BookMP3 new];
                [book setValuesForKeysWithDictionary:dict];
                [bookArray addObject:book];
            }
            [self.bookDict setObject:bookArray forKey:section];
        }

    }];
    
}

#pragma mark - 分析section的数据
- (void)analyzeDataWithURLString:(NSString *)urlString
                           block:(RecommendVCBlock)block
{
    [self.session GET:urlString
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  block(responseObject);
                  
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
#pragma mark 获取网络图片的index+点击跳转
-(void)didSelectedNetImageAtIndex:(NSInteger)index
{
    BookMP3 *book = _bookDict[@"Head"][index];
    NSInteger publishType = book.publishType.integerValue;
    switch (publishType) {
        case 0: {
            DetailViewController *detailVC = [DetailViewController new];
            detailVC.book = book;
            detailVC.pushFrom = PushFromRecommendVC;
            [self.navigationController pushViewController:detailVC animated:YES];
            break;
        }
        case 2: {
            VoiceDetailViewController *voiceDetailVC = [VoiceDetailViewController new];
            voiceDetailVC.book = book;
            [self.navigationController pushViewController:voiceDetailVC animated:YES];
            break;
        }
        case 3: {
            NSLog(@"暂时无链接");
            break;
        }
        case 9: {
            NSLog(@"暂时无链接");
            break;
        }
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 2;
    }
    return 1;
}

#pragma mark cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DetailViewController *detailVC = [DetailViewController new];
            
            detailVC.book = _bookDict[@0][indexPath.row];
            
            detailVC.pushFrom = PushFromRecommendVC;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        } else {
            VoiceDetailViewController *voiceDetailVC = [VoiceDetailViewController new];
            voiceDetailVC.book = _bookDict[@0][indexPath.row];
            [self.navigationController pushViewController:voiceDetailVC animated:YES];
        }
    }
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) recommendVC = self;
    switch (indexPath.section) {
        case 0: {
            RecommendCell *recCell = [tableView dequeueReusableCellWithIdentifier:@"recommendCell"];
            
            // 获取字典中对应的数据数组
            NSArray *arr = _bookDict[@0];
            
            if (arr.count > 0) {
                if (indexPath.row == 0) {
                    recCell.coverImageView.image = [UIImage imageNamed:@"cellImage1.jpg"];
                    recCell.backImageView.image = [UIImage imageNamed:@"cell11.jpg"];
                    recCell.backImageView.alpha = 0.8;
                }
                if (indexPath.row == 1) {
                    recCell.coverImageView.image = [UIImage imageNamed:@"cellImage2.jpg"];
                    recCell.backImageView.image = [UIImage imageNamed:@"cell12.jpg"];
                    recCell.backImageView.alpha = 0.8;


                }
                recCell.book = arr[indexPath.row];
            }
            recCell.alpha = 0.8;
            return recCell;
            break;
        }
        case 1: {
            BookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
            
            bookCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *arr = _bookDict[@1];
            
            if (arr.count > 0) {
                bookCell.bookArray = arr;
            }
            
            bookCell.block = ^void(BookMP3 *book) {
                
                DetailViewController *detailVC = [DetailViewController new];
                
                detailVC.book = book;
                
                detailVC.pushFrom = PushFromRecommendVC;
                
                [recommendVC.navigationController pushViewController:detailVC animated:YES];
            };
            
            return bookCell;
            break;
        }
        case 2: {
            BookCell *bookCell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
            
            bookCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *arr = _bookDict[@2];
            
            if (arr.count > 0) {
                bookCell.bookArray = arr;
            }
            
            bookCell.block = ^void(BookMP3 *book) {
                
                DetailViewController *detailVC = [DetailViewController new];
                
                detailVC.book = book;
                
                detailVC.pushFrom = PushFromRecommendVC;
                
                [self.navigationController pushViewController:detailVC animated:YES];
            };
            
            return bookCell;
            break;
        }
        case 3: {
            SpecialSubjectCell *specialSubjectCell = [tableView dequeueReusableCellWithIdentifier:@"SpecialSubjectCell"];
            
            specialSubjectCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *arr = _bookDict[@3];
            
            if (arr.count > 0) {
                BookMP3 *book0 = arr[0];
                BookMP3 *book1 = arr[1];
                
                NSString *coverStr0 = [JoiningURL urlWithCoverStr:book0.cover joiningStr:@"_338x170"];
                NSString *coverStr1 = [JoiningURL urlWithCoverStr:book1.cover joiningStr:@"_338x170"];
                
                [specialSubjectCell.specialSubImage1 sd_setImageWithURL:[NSURL URLWithString:coverStr0]];
                [specialSubjectCell.specialSubImage2 sd_setImageWithURL:[NSURL URLWithString:coverStr1]];
            }
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1)];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
            
            [specialSubjectCell.specialSubImage1 addGestureRecognizer:tap1];
            [specialSubjectCell.specialSubImage2 addGestureRecognizer:tap2];
            
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

- (void)tap1
{
    SpecialSubjectDetailViewController *detailVC = [SpecialSubjectDetailViewController new];
    detailVC.book = _bookDict[@3][0];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tap2
{
    SpecialSubjectDetailViewController *detailVC = [SpecialSubjectDetailViewController new];
    detailVC.book = _bookDict[@3][1];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 65;
    }
    if (indexPath.section == 3) {
        return 115;
    }
    return 336;
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
            headerView.moreButton.tag = baseTag + section;
            [self moreActionForHeaderView:headerView];
            headerView.alpha = 0.8;
            return headerView;
            break;
        case 2:
            headerView.titleLabel.text = @"新书推荐";
            headerView.moreButton.tag = baseTag + section;
            [self moreActionForHeaderView:headerView];
            headerView.alpha = 0.8;

            return headerView;
            break;
        case 3:
            headerView.titleLabel.text = @"更多专题";
            headerView.moreButton.tag = baseTag + section;
            [self moreActionForHeaderView:headerView];
            headerView.alpha = 0.8;

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

#pragma mark - 更多按钮
- (void)moreActionForHeaderView:(RecommendHeaderView *)headerView
{
    [headerView.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)moreButtonAction:(UIButton *)moreButton
{
    switch (moreButton.tag) {
        case 101: {
            MoreListViewController *moreListVC = [MoreListViewController new];
            NSString *moreListURL = [NSString stringWithFormat:@"%@%@", EB_MORE_EDIT_RECOMMEND_URL, _bookDict[@"小编推荐"]];
            moreListVC.moreListURL = moreListURL;
            [self.navigationController pushViewController:moreListVC animated:YES];
            break;
        }
        case 102: {
            MoreListViewController *moreListVC = [MoreListViewController new];
            NSString *moreListURL = [NSString stringWithFormat:@"%@%@", EB_MORE_EDIT_RECOMMEND_URL, _bookDict[@"新书推荐"]];
            moreListVC.moreListURL = moreListURL;
            [self.navigationController pushViewController:moreListVC animated:YES];
            break;
        }
        case 103: {
            SpecialSubjectViewController *specialSubjectVC = [SpecialSubjectViewController new];
            
            specialSubjectVC.bookArray = _bookDict[@3];
            
            [self.navigationController pushViewController:specialSubjectVC animated:YES];
            break;
        }
        default:
            break;
    }
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
