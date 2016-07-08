//
//  DetailViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "DetailViewController.h"
#import "ListCell.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "BookMP3.h"
#import "BookList.h"
#import "Tool_AdaptiveHeight.h"
#import "PlayerViewController.h"
#import "LoginViewController.h"
#import "BookInfosHandle.h"
#import "DownloadFile.h"
#import <UMSocial.h>
#import <AVOSCloud.h>


#define kBookInfosHandle [BookInfosHandle shareBookInfosHandle]
#define kScrollWidth self.scrollView.frame.size.width
#define kScrollHeight self.scrollView.frame.size.height

#define kButtonTag 9891

@interface DetailViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UMSocialUIDelegate, NSURLSessionDelegate>
//{
//    NSInteger *page;
//}



//装标题的数组
@property (nonatomic, strong) NSArray *itemArr;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//类别
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//原著
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
//主播
@property (weak, nonatomic) IBOutlet UILabel *announcerLabel;
//状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//集数
@property (weak, nonatomic) IBOutlet UILabel *sectionsLabel;
//播放量
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
//详情介绍
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

//内层scrollView高度（自适应高）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

//装目录列表信息
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) BookMP3 *detailBook;

/// 下载任务的属性
@property (nonatomic, strong) NSURLSessionDownloadTask *task;

/// 网络请求类
@property (nonatomic, strong) NSURLSession *session;

/// 发送请求类
@property (nonatomic, strong) NSURLRequest *request;

/// 用于保存已经下载的数据，供继续下载使用
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation DetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pageNum = 1;
    if (self.pushFrom == PushFromMoreListVC) {
        
        [self reloadUIWithBook:self.book];
        [self bookListWithBook:self.book];
        
        // 下拉刷新
        __weak typeof(self) detailVC = self;
        self.listTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            detailVC.pageNum += 1;
            [detailVC bookListWithBook:_book];
            // 结束刷新
            [detailVC.listTableView.mj_footer endRefreshing];
        }];
        
    } else {
        // 请求数据
        [self requestData];
        // 下拉刷新
        __weak typeof(self) detailVC = self;
        self.listTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            detailVC.pageNum += 1;
            [detailVC requestData];
            // 结束刷新
            [detailVC.listTableView.mj_footer endRefreshing];
        }];
    }
    // 设置navigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.bottomScrollView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    [self layoutSubView];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
}
#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载详情数据
- (void)requestData
{
    NSString *bookDetailURL = @"";
    if (_book.url) {
        // 详情页数据加载
        bookDetailURL = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, _book.url, EB_BOOK_DETAIL_URL];
    }
    
    if (_joiningURLString == JoiningURLStringByID && _book.ID) {
        // 详情页数据加载
        bookDetailURL = [NSString stringWithFormat:@"%@%@%@", EB_BOOK_DETAIL_BASE_URL, _book.ID, EB_BOOK_DETAIL_URL];
    }
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    BookMP3 *book = [BookMP3 new];
    
    __weak typeof(self) detailVC = self;
    [session GET:bookDetailURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             [book setValuesForKeysWithDictionary:responseObject];
//             book.ID = responseObject[@"id"];
             
             detailVC.detailBook = book;
             
             [detailVC bookListWithBook:book];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 刷新详情界面
                 [detailVC reloadUIWithBook:book];
             });
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning Alert
             NSLog(@"请求出错");
         }];
}

#pragma mark - 加载列表数据
- (void)bookListWithBook:(BookMP3 *)book
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 列表页数据加载
    NSString *bookListURL = [NSString stringWithFormat:@"%@%@%@%ld%@", EB_BOOK_LIST_BASE_URL, book.ID, EB_BOOK_LIST_URL1, self.pageNum, EB_BOOK_LIST_URL2];
    __weak typeof(self) detailVC = self;
    [session GET:bookListURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             for (NSDictionary *dict in responseObject[@"list"]) {
                 BookList *bookList = [BookList new];
                 [bookList setValuesForKeysWithDictionary:dict];
                 [detailVC.listArray addObject:bookList];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [detailVC.listTableView reloadData];
             });
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning Alert
             NSLog(@"请求出错");
         }];
}

#pragma mark - 刷新详情界面
- (void)reloadUIWithBook:(BookMP3 *)book
{
    
    self.navigationItem.title = book.name;
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:book.cover]];
    _nameLabel.text = book.name;
    _typeLabel.text = [NSString stringWithFormat:@"类别：%@",book.type];
    _authorLabel.text = [NSString stringWithFormat:@"原著：%@",book.author];
    _announcerLabel.text = [NSString stringWithFormat:@"主播：%@",book.announcer];
    _sectionsLabel.text = [NSString stringWithFormat:@"集数：%@",book.sections];
    _playLabel.text = [NSString stringWithFormat:@"播放量：%.1f万",book.play.floatValue / 10000];
    _descLabel.text = book.desc;
    CGFloat heightOfText = [Tool_AdaptiveHeight textHeightWithText:book.desc fontSize:14 viewWidth:_descLabel.frame.size.width];
    self.contentHeight.constant = heightOfText + 70 + 136 + self.view.bounds.size.width * 0.28 / 105 * 150;
    if (book.state.integerValue == 2) {
        _statusLabel.text = @"状态：完结";
    } else {
        _statusLabel.text = @"状态：连载";
    }
}

//页面布局
- (void)layoutSubView {
    //设置segment
    [self addSegment];
}


#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (_listArray.count > 0) {
        cell.bookList = _listArray[indexPath.row];
    }
    cell.uploadButton.tag = kButtonTag + indexPath.row;
    
    [cell.uploadButton addTarget:self action:@selector(uploadButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return cell;
}

#pragma mark - 下载按钮点击方法
- (void)uploadButtonAction:(UIButton *)sender
{
    [sender setTitle:@"已下载" forState:(UIControlStateNormal)];
    
    NSInteger index = sender.tag - kButtonTag;
    
    BookList *bookList = _listArray[index];
    
    AVUser *currentUser = [AVUser currentUser];
    
    if (currentUser != nil) {
//        if (self.pushFrom == PushFromMoreListVC) {
            // 下载
//            [downloadFile downloadWithBookList:bookList Book:_book User:currentUser];
            
//            [downloadFile.progress addObserver:self forKeyPath:@"fractionCompleted" options:(NSKeyValueObservingOptionNew) context:NULL];
            
//            [self uploadWithBookList:bookList CurrentUser:currentUser];
        
//        } else {
            // 下载
//            [downloadFile downloadWithBookList:bookList Book:_detailBook User:currentUser];
//            [downloadFile.progress addObserver:self forKeyPath:@"fractionCompleted" options:(NSKeyValueObservingOptionNew) context:NULL];
            
            [self uploadWithBookList:bookList CurrentUser:currentUser];

//        }
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.flag = 1;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - 下载
- (void)uploadWithBookList:(BookList *)bookList
               CurrentUser:(AVUser *)currentUser
{
    DownloadFile *downloadFile = [DownloadFile shareDownloadFile];
    
    //下载
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSURL *URL = [NSURL URLWithString:bookList.path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%@", downloadProgress);
        
        [downloadProgress addObserver:self forKeyPath:@"fractionCompleted" options:(NSKeyValueObservingOptionNew) context:NULL];
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        // 下载到沙盒的位置
        NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:[response suggestedFilename]];
        
        NSString *documentsPath = [response suggestedFilename];
        
        [downloadFile saveToleanCloudWithdocumentsPath:documentsPath BookList:bookList Book:_detailBook User:currentUser ClassName:@"DownloadBook"];
        
        return documentsDirectoryURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    //重新开始下载
    [downloadTask resume];
    
}

#pragma mark - 拿到进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //拿到进度
    //    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        if (progress.fractionCompleted == 1.0) {
            [self errorAlertWithMessage:@"下载完成！"];
        }
    }
}

#pragma mark - 错误提示的alert
- (void)errorAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - scrollView代理方法
//已经结束滚动的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.bottomScrollView.contentOffset.x == 0) {
        NSInteger index = 0;
        self.SLView.upSegment.selectedSegmentIndex = index;
        [self moveLabelAndViewByIndex:index];
    } else {
        NSInteger index = 1;
        self.SLView.upSegment.selectedSegmentIndex = index;
        [self moveLabelAndViewByIndex:index];
    }
}

//添加一个segment和随之移动的label
- (void)addSegment {
    
    self.itemArr = @[@"详情介绍", @"章节列表"];
    
    NSDictionary *dicNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:15],NSFontAttributeName ,nil];
    
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:EB_MAIN_COLOR,NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
    
    self.SLView = [[ZF_SegmentLabelView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50) viewBackgroundColor:EB_COLOR(245, 245, 245, 1) items:self.itemArr dicNormal:dicNormal dicSelected:dicSelected labelBackgroundColor:EB_MAIN_COLOR];
    
    [self.view addSubview:self.SLView];
    
    [self.SLView.upSegment addTarget:self action:@selector(segmentClick:) forControlEvents:(UIControlEventValueChanged)];
}


//segment点击响应方法
- (void)segmentClick:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;

    [self moveLabelAndViewByIndex:index];
}

//根据点击segment的位置移动下面的滑动条以及切换页面
- (void)moveLabelAndViewByIndex:(NSInteger)index {
    // 添加动画
    [UIView animateWithDuration:0.1 animations:^{
        
        CGRect frame = self.SLView.downLabel.frame;
        // 移动label
        frame.origin.x = CGRectGetWidth(self.SLView.upSegment.frame) / self.itemArr.count * index;
        
        self.SLView.downLabel.frame = frame;
        
        // 移动scroll视图
        self.bottomScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * index, 0) ;
        
    }];
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    kBookInfosHandle.bookInfosArray = _listArray;
    
    
    if (self.pushFrom == PushFromMoreListVC) {
        kBookInfosHandle.bookMP3 = _book;
    } else {
        kBookInfosHandle.bookMP3 = _detailBook;
    }
    
    PlayerViewController * playerViewVC = [[PlayerViewController alloc]init];
    BookList *bookList = self.listArray[indexPath.row];
    playerViewVC.bookList = bookList;
    playerViewVC.index = indexPath.row;
    kBookInfosHandle.indexout  = indexPath.row;
//    playerViewVC.bookInformation = _book;
//    playerViewVC.playList = _listArray;

//    [self presentViewController:playerViewVC animated:YES completion:nil];
    [self.navigationController pushViewController:playerViewVC animated:YES];

}

#pragma mark - 分享
- (IBAction)shareAction:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.title = _nameLabel.text;

    NSString *shareText = @"";
    if (_descLabel.text.length > 140) {
        shareText = [_descLabel.text substringToIndex:140];
    } else {
        shareText = _descLabel.text;
    }
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"57767a3667e58e180b0006c2"
                                      shareText:shareText
                                     shareImage:_coverImageView.image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
}

#pragma mark - 收藏
- (IBAction)collectionAction:(UIButton *)sender
{
    
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
