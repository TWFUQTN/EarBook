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
    
    //解析数据
    [self requestData];
    
    self.tableArray = [NSMutableArray arrayWithCapacity:self.menuArray.count];
    NSLog(@"-=-=-=-=-=%ld", self.tableArray.count);
    for (NSString *title in self.menuArray) {
        MryPageTable *table = [[MryPageTable alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        table.title = title;
        table.dataArray = self.dataArray;
        [self.tableArray addObject:table];
    }
    
    self.menuframe = CGRectMake(0, 0, ScreenW, 40);
    self.tableframe = CGRectMake(0, CGRectGetMaxY(self.menuframe), ScreenW, ScreenH - CGRectGetMaxY(self.menuframe));
    
    [super viewDidLoad];
    
}

//外层网络请求
- (void)requestData {
    
    __weak typeof(MRYViewController *) mryVC = self;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    if (self.classification.url) {
        self.url = self.classification.url;
    } else {
        self.url = self.classification.ID;
    }
    
    if ([self.classification.name isEqualToString:@"主播电台"]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", EB_CLASSIFICATION_VOICE_DETAIL_BASE_URL, EB_CLASSIFICATION_VOICE_DETAIL_BODY1_URL, self.url, EB_CLASSIFICATION_VOICE_DETAIL_BODY2_URL, self.url, EB_CLASSIFICATION_VOICE_DETAIL_BODY3_URL, self.url, EB_CLASSIFICATION_VOICE_DETAIL_BODY4_URL];
        
        [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array = responseObject[@"list"];
            mryVC.partUrl = array[1][@"name"];
            [mryVC requestVoiceData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败：%@", error);
        }];
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", EB_CLASSIFICATION_BOOK_DETAIL_BASE_URL, EB_CLASSIFICATION_BOOK_DETAIL_BODY1_URL, self.url,  EB_CLASSIFICATION_BOOK_DETAIL_BODY2_URL, self.url,  EB_CLASSIFICATION_BOOK_DETAIL_BODY3_URL];
        
        [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array1 = responseObject[@"list"];
            for (NSDictionary *dict in array1) {
                mryVC.partUrl = dict[@"name"];
                [mryVC requestBookData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败：%@", error);
        }];
        
    }
    
    
}

//分类声音型的网络请求
- (void)requestVoiceData {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, self.partUrl];
    
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败：%@", error);
    }];
    
    
}

//分类书籍型的网络请求
- (void)requestBookData {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, self.partUrl];
    
    [self.dataArray removeAllObjects];
    
    __weak typeof(MRYViewController *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"list"];
        for (NSDictionary *dict in dataArray) {
            NSString *bookId = dict[@"id"];
            mryVC.bookUrl = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, bookId, EB_BOOK_DETAIL_URL];
            [mryVC requestDetailBookData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败:%@", error);
    }];
    
}

//解析book详细属性
- (void)requestDetailBookData {
    
    __weak typeof(MRYViewController *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:self.bookUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BookMP3 *book = [[BookMP3 alloc] init];
        [book setValuesForKeysWithDictionary:responseObject];
        [mryVC.dataArray addObject:book];
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
