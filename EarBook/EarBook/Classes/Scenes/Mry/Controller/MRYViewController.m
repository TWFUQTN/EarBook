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

@interface MRYViewController ()

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *partUrl;


@end

@implementation MRYViewController

- (NSString *)url {
    if (!_url) {
        _url = [NSString new];
    }
    return _url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //navigation设置
    self.title = self.classification.name;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    

    [self requestData];
    
    
}

//外层网络请求
- (void)requestData {
    
    __weak typeof(MRYViewController *) weakSelf = self;
    
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
            self.partUrl = array[1][@"name"];
            [self requestVoiceData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败：%@", error);
        }];
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", EB_CLASSIFICATION_BOOK_DETAIL_BASE_URL, EB_CLASSIFICATION_BOOK_DETAIL_BODY1_URL, self.url,  EB_CLASSIFICATION_BOOK_DETAIL_BODY2_URL, self.url,  EB_CLASSIFICATION_BOOK_DETAIL_BODY3_URL];
        
        [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array1 = responseObject[@"list"];
            for (NSDictionary *dict in array1) {
                self.partUrl = dict[@"name"];
                [self requestBookData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"网络请求失败：%@", error);
        }];
        
    }
    
    
}

//热门分类的网络请求
- (void)requestVoiceData {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, self.partUrl];
    
    __weak typeof(MRYViewController *) weakSelf = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"list"];
        for (NSDictionary *dict in dataArray) {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败：%@", error);
    }];
    
    
}

//最新分类的网络请求
- (void)requestBookData {
    
    
    
    
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
