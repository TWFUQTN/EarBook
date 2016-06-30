//
//  ClassificationViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ClassificationCell.h"
#import "EB_URL.h"
#import "Classification.h"

#import <AFNetworking/AFNetworking.h>

@interface ClassificationViewController ()

//cell高度
@property (nonatomic, assign) CGFloat cellHeight;

//网络请求
@property (nonatomic, strong) AFHTTPSessionManager *session;

//存分类内小分类属性对象的数组
//@property (nonatomic, strong) NSMutableArray *allDataArray;

//存分类对象的collection的字典
@property (nonatomic, strong) NSMutableDictionary *allDataDict;

//存所有分类的数组
@property (nonatomic, strong) NSMutableArray *classificationArr;

//类型排序数组
@property (nonatomic, strong) NSArray *typeArray;


@end

@implementation ClassificationViewController

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
//- (NSMutableArray *)allDataArray {
//    if (!_allDataArray) {
//        _allDataArray = [[NSMutableArray alloc] init];
//    }
//    return _allDataArray;
//}
- (NSMutableDictionary *)allDataDict {
    if (!_allDataDict) {
        _allDataDict = [[NSMutableDictionary alloc] init];
    }
    return _allDataDict;
}
- (NSMutableArray *)classificationArr {
    if (!_classificationArr) {
        _classificationArr = [[NSMutableArray alloc] init];
    }
    return _classificationArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.typeArray = @[@"热门频道", @"主播电台", @"有声小说", @"文学名著", @"曲艺戏曲", @"相声评书", @"少儿天地", @"外语学习", @"娱乐综艺", @"人文社科", @"商业财经", @"健康养生", @"职业技能"];
    
    [self.tableView registerClass:[ClassificationCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self requestData];
    
    self.tableView.sectionHeaderHeight = 0;
    
    // 下拉刷新
    __weak typeof(self) classificationVC = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [classificationVC requestData];
    }];
    
    
    
}

//请求数据
- (void)requestData {
    
    __weak typeof(self) classificationVC = self;
    [self.session GET:EB_CLASSIFICATION_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *dataArray = responseObject[@"list"];
        for (NSDictionary *dict in dataArray) {
            NSString *name = dict[@"name"];
            NSString *url = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, name];
            //再次进行网络请求
            [classificationVC inRequestData:url];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败:%@", error);
    }];
    
}

//内层数据请求
- (void)inRequestData:(NSString *)urlString {
    
    __weak typeof(self) classificationVC = self;
    [self.session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        for (NSDictionary *dataDict in responseObject[@"list"]) {
            NSString *key = dataDict[@"name"];
            NSMutableArray *allDataArray = [NSMutableArray array];
            NSArray *array = dataDict[@"subList"];
            if ([array class] != [NSNull class]) {
                for (NSDictionary *dict in array) {
                    Classification *classification = [[Classification alloc] init];
                    [classification setValuesForKeysWithDictionary:dict];
                    [allDataArray addObject:classification];
                }
            }else {
                allDataArray = NULL;
            }
            if (allDataArray != NULL) {
                [classificationVC.allDataDict setValue:allDataArray forKey:key];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [classificationVC.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"第二次网络请求失败");
    }];
}

//设置segment的标题
-(NSString *)segmentTitle
{
    return @"分类";
}
//添加tableView到scrollView上
-(UIScrollView *)streachScrollView
{
    return self.tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.allDataDict allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.typeLabel.text = self.typeArray[indexPath.section];
    NSMutableArray *allDataArray = [NSMutableArray array];
    allDataArray = self.allDataDict[self.typeArray[indexPath.section]];
    cell.cellArray = allDataArray;
    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 12) {
        return [ClassificationCell heightOfCellByNumberFromItems:[self.allDataDict[self.typeArray[indexPath.section]] count]] + 20;
    }
    return [ClassificationCell heightOfCellByNumberFromItems:[self.allDataDict[self.typeArray[indexPath.section]] count]];
}

//cell点击效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 17;
    }
    return 0.01;
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
