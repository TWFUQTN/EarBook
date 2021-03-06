//
//  MainTableView.m
//  MryNewsFrameWork
//
//  Created by mryun11 on 16/6/7.
//  Copyright © 2016年 mryun11. All rights reserved.
//

#import "MryPageTable.h"
#import "MryPageTableCell.h"
#import "BookMP3.h"
#import "Voice.h"
#import "EB_URL.h"
#import "MBProgressHUD+GifHUD.h"
#import "ReloadView.h"

@interface MryPageTable ()<UITableViewDelegate,UITableViewDataSource>

//加载界面
@property (nonatomic, strong) ReloadView *reloadView;


@end

@implementation MryPageTable
@synthesize dataArray=_dataArray;
//懒加载

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ReloadView *)reloadView {
    if (!_reloadView) {
        _reloadView = [[ReloadView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _reloadView.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    }
    return _reloadView;
}

//显示等待视图
- (void)showGif {
    [MBProgressHUD setUpGifWithFrame:CGRectMake(0, 0, 80, 80) gifName:@"wait" andShowToView:self];
}

//隐藏等待视图
- (void)hideGifView {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MryPageTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self showGif];
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString {
    if (_urlString != urlString) {
        _urlString = urlString;
    }
    [self requestData];
}

//解析数据
- (void)requestData {
    __weak typeof(MryPageTable *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

    if (self.status) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", EB_CLASSIFICATION_VOICE_DETAIL_BASE_URL, EB_CLASSIFICATION_VOICE_DETAIL_BODY1_URL, self.urlString, EB_CLASSIFICATION_VOICE_DETAIL_BODY2_URL, self.urlString, EB_CLASSIFICATION_VOICE_DETAIL_BODY3_URL, self.urlString, EB_CLASSIFICATION_VOICE_DETAIL_BODY4_URL];
        
        [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //刷新数据
            for (UIView *view in self.superview.subviews) {
                if (view == self.reloadView) {
                    NSLog(@"dfjaldsfj=======");
                    [view removeFromSuperview];
                }
            }
            
            NSArray *array = responseObject[@"list"];
            NSString *partUrl = array[1][@"name"];
            [mryVC requestVoiceData:partUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self hideGifView];
            [self.superview addSubview:self.reloadView];
            __weak typeof(self) weakSelf = self;
            self.reloadView.block = ^() {
                
                [weakSelf requestData];
                NSLog(@"*******");
                [weakSelf showGif];
                
            };
            NSLog(@"网络请求失败：%@", error);
        }];
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", EB_CLASSIFICATION_BOOK_DETAIL_BASE_URL, EB_CLASSIFICATION_BOOK_DETAIL_BODY1_URL, self.urlString,  EB_CLASSIFICATION_BOOK_DETAIL_BODY2_URL, self.urlString,  EB_CLASSIFICATION_BOOK_DETAIL_BODY3_URL];
        
        [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //刷新数据
            for (UIView *view in self.superview.subviews) {
                if (view == self.reloadView) {
                    NSLog(@"dfjaldsfj=======");
                    [view removeFromSuperview];
                }
            }
            
            NSArray *array1 = responseObject[@"list"];
            for (NSDictionary *dict in array1) {
                NSString *partUrl = dict[@"name"];
                [mryVC requestBookData:partUrl];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self hideGifView];
            [self.superview addSubview:self.reloadView];
            __weak typeof(self) weakSelf = self;
            self.reloadView.block = ^() {
                
                [weakSelf requestData];
                NSLog(@"*******");
                [weakSelf showGif];
                
            };
            NSLog(@"网络请求失败：%@", error);
        }];
        
    }
    
}

//分类声音型的网络请求
- (void)requestVoiceData:(NSString *)url {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, url];
    
    __weak typeof(MryPageTable *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //刷新数据
        for (UIView *view in self.superview.subviews) {
            if (view == self.reloadView) {
                NSLog(@"dfjaldsfj=======");
                [view removeFromSuperview];
            }
        }
        
        NSArray *dataArray = responseObject[@"list"];
        for (NSDictionary *dict in dataArray) {
            BookMP3 *book = [[BookMP3 alloc] init];
            [book setValuesForKeysWithDictionary:dict];
            [mryVC.dataArray addObject:book];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
            [self hideGifView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideGifView];
        [self.superview addSubview:self.reloadView];
        __weak typeof(self) weakSelf = self;
        self.reloadView.block = ^() {
            
            [weakSelf requestData];
            NSLog(@"*******");
            [weakSelf showGif];
            
        };
        NSLog(@"网络请求失败：%@", error);
    }];
    
    
}

//分类书籍型的网络请求
- (void)requestBookData:(NSString *)url {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", EB_BASE_URL, url];
        
    __weak typeof(MryPageTable *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //刷新数据
        for (UIView *view in self.superview.subviews) {
            if (view == self.reloadView) {
                NSLog(@"dfjaldsfj=======");
                [view removeFromSuperview];
            }
        }
        
        NSArray *dataArray = responseObject[@"list"];
        for (NSDictionary *dict in dataArray) {
            NSString *bookId = dict[@"id"];
            NSString *bookUrl = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, bookId, EB_BOOK_DETAIL_URL];
            [mryVC requestDetailBookData:bookUrl];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideGifView];
        [self.superview addSubview:self.reloadView];
        __weak typeof(self) weakSelf = self;
        self.reloadView.block = ^() {
            
            [weakSelf requestData];
            NSLog(@"*******");
            [weakSelf showGif];
            
        };
        NSLog(@"网络请求失败:%@", error);
    }];
    
}

//解析book详细属性
- (void)requestDetailBookData:(NSString *)url {
    
    __weak typeof(MryPageTable *) mryVC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //刷新数据
        for (UIView *view in self.superview.subviews) {
            if (view == self.reloadView) {
                NSLog(@"dfjaldsfj=======");
                [view removeFromSuperview];
            }
        }
        
        BookMP3 *book = [[BookMP3 alloc] init];
        [book setValuesForKeysWithDictionary:responseObject];
        [mryVC.dataArray addObject:book];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
            [self hideGifView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideGifView];
        [self.superview addSubview:self.reloadView];
        __weak typeof(self) weakSelf = self;
        self.reloadView.block = ^() {
            
            [weakSelf requestData];
            NSLog(@"*******");
            [weakSelf showGif];
            
        };
        NSLog(@"网络请求:%@", error);
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MryPageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([self.dataArray[indexPath.row] class] == [BookMP3 class]) {
        cell.book = self.dataArray[indexPath.row];
    }
    else if ([self.dataArray[indexPath.row] class] == [Voice class]) {
        cell.classifyVoice = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self deselectRowAtIndexPath:indexPath animated:YES];
    
    BookMP3 *book = self.dataArray[indexPath.row];
    
    if (book.state) {
        self.bookBlock(book);
    }
    else {
        self.voiceBlock(book);
    }
    
}


//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

//赋值时刷新视图
- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    [self reloadData];
}
@end
