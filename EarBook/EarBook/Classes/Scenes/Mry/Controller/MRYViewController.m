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
    
    //navigation设置
    self.title = self.classification.name;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    self.tableArray = [NSMutableArray arrayWithCapacity:self.menuArray.count];
    
    //解析数据
    for (self.i = 0; self.i < self.menuArray.count; self.i++) {
        
        [self requestData];
    }
    
    self.menuframe = CGRectMake(0, 0, ScreenW, 40);
    self.tableframe = CGRectMake(0, CGRectGetMaxY(self.menuframe), ScreenW, ScreenH - CGRectGetMaxY(self.menuframe));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTitle:) name:@"changeTitle" object:nil];
    
    [super viewDidLoad];
    
}

//通知方法，修改标题
- (void)changeTitle:(NSNotification *)noti{
    
    NSNumber *tag = [noti userInfo][@"tag"];
    if ([tag integerValue] || [tag isEqual:@0]) {
        self.navigationItem.title = self.menuArray[[tag integerValue]];
    }
}

//外层网络请求
- (void)requestData {
    
    self.classification = self.allDataArray[self.i];
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
