//
//  MRYViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/30.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "MRYViewController.h"
#import "Classification.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "BookMP3.h"
#import "Voice.h"
#import "DetailViewController.h"
#import "VoiceDetailViewController.h"


#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height


@interface MRYViewController ()

//collection的点击id
@property (nonatomic, strong) NSString *url;

//对应分类内的书籍url后缀
@property (nonatomic, strong) NSString *partUrl;

//装数据的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

//book详细情况的url
@property (nonatomic, strong) NSString *bookUrl;

//存值字典
@property (nonatomic, strong) NSMutableDictionary *allDataDict;

//排序用字母i标记
@property (nonatomic, assign) NSInteger i;

@end

@implementation MRYViewController

//懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
        
    //navigation设置
    self.title = self.classification.name;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    self.tableArray = [NSMutableArray arrayWithCapacity:self.menuArray.count];
    
    //解析数据
    for (self.i = 0; self.i < self.menuArray.count; self.i++) {
        NSLog(@"~~~~~~~______+++++  %ld", self.i);
        [self requestData];
        
//        MryPageTable *table = [[MryPageTable alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        //        table.title = title;
//        NSString *string = [NSString stringWithFormat:@"%ld", self.myIndexPath];
//        NSMutableArray *array = self.allDataDict[string];
//        self.dataArray = array;
//        table.dataArray = self.dataArray;
//        NSLog(@"self.dataArray的数量是：%ld", self.dataArray.count);
        
//        [table reloadData];
//        NSLog(@"总 i = %ld", self.i);
        
    }
    
//    for (NSString *title in self.menuArray) {
//        MryPageTable *table = [[MryPageTable alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
////        table.title = title;
//        NSString *string = [NSString stringWithFormat:@"%ld", self.myIndexPath];
//        NSMutableArray *array = self.allDataDict[string];
//        self.dataArray = array;
//        table.dataArray = self.dataArray;
//        NSLog(@"self.dataArray的数量是：%ld", self.dataArray.count);
//        [self.tableArray addObject:table];
//    }
    
    self.menuframe = CGRectMake(0, 0, ScreenW, 40);
    self.tableframe = CGRectMake(0, CGRectGetMaxY(self.menuframe), ScreenW, ScreenH - CGRectGetMaxY(self.menuframe));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTitle:) name:@"changeTitle" object:nil];
    
    [super viewDidLoad];
    
}

//通知方法
- (void)changeTitle:(NSNotification *)noti{
    
    NSNumber *tag = [noti userInfo][@"tag"];
    if ([tag integerValue] || [tag isEqual:@0]) {
        self.navigationItem.title = self.menuArray[[tag integerValue]];
    }
}

//外层网络请求
- (void)requestData {
    
//    __weak typeof(MRYViewController *) mryVC = self;
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    self.classification = self.allDataArray[self.i];
//    NSLog(@"%@, %@", self.classification.url, self.classification.ID);
    if (self.classification.url) {
        self.url = self.classification.url;
    } else {
        self.url = self.classification.ID;
    }
    
    MryPageTable *table = [[MryPageTable alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    BOOL a = [self.menuArray[0] isEqualToString:@"情感治愈"] || self.classification.url;
    table.status = a;
    table.urlString = self.url;
    [self.tableArray addObject:table];
    
    
    table.bookBlock = ^(BookMP3 *book) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.book = book;
        detailVC.pushFrom = PushFromMoreListVC;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    
    table.voiceBlock = ^(BookMP3 *book) {
        VoiceDetailViewController *voiceDetailVC = [[VoiceDetailViewController alloc] init];
        voiceDetailVC.book = book;
        voiceDetailVC.pushFrom = PushFromMoreListVC1;
        [self.navigationController pushViewController:voiceDetailVC animated:YES];
    };
    
//    if ([self.menuArray[0] isEqualToString:@"情感治愈"] || self.classification.url) {
//        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", EB_CLASSIFICATION_VOICE_DETAIL_BASE_URL, EB_CLASSIFICATION_VOICE_DETAIL_BODY1_URL, self.url, EB_CLASSIFICATION_VOICE_DETAIL_BODY2_URL, self.url, EB_CLASSIFICATION_VOICE_DETAIL_BODY3_URL, self.url, EB_CLASSIFICATION_VOICE_DETAIL_BODY4_URL];
//        
//        [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSArray *array = responseObject[@"list"];
//            mryVC.partUrl = array[1][@"name"];
//            [mryVC requestVoiceData:mryVC.partUrl];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableArray[self.i - 1] reloadData];
//            });
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"网络请求失败：%@", error);
//        }];
//    }
//    else {
//        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", EB_CLASSIFICATION_BOOK_DETAIL_BASE_URL, EB_CLASSIFICATION_BOOK_DETAIL_BODY1_URL, self.url,  EB_CLASSIFICATION_BOOK_DETAIL_BODY2_URL, self.url,  EB_CLASSIFICATION_BOOK_DETAIL_BODY3_URL];
//        
//        [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSArray *array1 = responseObject[@"list"];
//            for (NSDictionary *dict in array1) {
//                mryVC.partUrl = dict[@"name"];
//                [mryVC requestBookData:mryVC.partUrl];
//                NSLog(@"%ld",self.i);
//                
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableArray[self.i - 1] reloadData];
//            });
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"网络请求失败：%@", error);
//            NSLog(@"%ld", self.i);
//        }];
//        
//    }
//    
    
}

//分类声音型的网络请求
- (void)requestVoiceData:(NSString *)url {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, url];
    
    [self.dataArray removeAllObjects];
    
    __weak typeof(MRYViewController *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"list"];
        for (NSDictionary *dict in dataArray) {
            Voice *voice = [[Voice alloc] init];
            [voice setValuesForKeysWithDictionary:dict];
            [mryVC.dataArray addObject:voice];
        }
        NSString *number = [NSString stringWithFormat:@"%ld", self.i];
        [self.allDataDict setValue:self.dataArray forKey:number];
        NSLog(@"音乐i = %ld", self.i);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableArray[self.i - 1] reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败：%@", error);
    }];
    
    
}

//分类书籍型的网络请求
- (void)requestBookData:(NSString *)url {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, url];
    
    [self.dataArray removeAllObjects];
    
    __weak typeof(MRYViewController *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"list"];
        for (NSDictionary *dict in dataArray) {
            NSLog(@"%ld", dataArray.count);
            NSLog(@"%ld", dict.count);
            NSString *bookId = dict[@"id"];
            mryVC.bookUrl = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, bookId, EB_BOOK_DETAIL_URL];
            [mryVC requestDetailBookData:mryVC.bookUrl];
        }
        NSString *number = [NSString stringWithFormat:@"%ld", self.i];
        [self.allDataDict setValue:self.dataArray forKey:number];
        NSLog(@"书本i = %ld", self.i);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableArray[self.i - 1] reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败:%@", error);
    }];
    
}

//解析book详细属性
- (void)requestDetailBookData:(NSString *)url {
    
    __weak typeof(MRYViewController *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BookMP3 *book = [[BookMP3 alloc] init];
        [book setValuesForKeysWithDictionary:responseObject];
        [mryVC.dataArray addObject:book];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableArray[self.i - 1] reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求:%@", error);
    }];
    
}


#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
