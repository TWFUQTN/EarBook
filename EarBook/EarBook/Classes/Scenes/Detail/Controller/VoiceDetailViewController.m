//
//  VoiceDetailViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/29.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "VoiceDetailViewController.h"
#import "ZF_SegmentLabelView.h"
#import "BookMP3.h"
#import "BookList.h"
#import "VoiceProgram.h"
#import "ListCell.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "LoginViewController.h"
#import "DownloadFile.h"
#import "Voice.h"
#import "BookInfosHandle.h"
#import "PlayerViewController.h"
#import "MBProgressHUD+GifHUD.h"
#import "ReloadView.h"

#define kBookInfosHandle [BookInfosHandle shareBookInfosHandle]

#import <AVOSCloud.h>
#import <UMSocial.h>

#define kButtonTag 989132

@interface VoiceDetailViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UMSocialUIDelegate>

//segment及滑动的label视图
@property (nonatomic, strong) ZF_SegmentLabelView *SLView;

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
//声音
@property (weak, nonatomic) IBOutlet UILabel *voicesLabel;
//播放量
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
//更新日期
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
//详情介绍
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

//内层scrollView高度（自适应高）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

//底层scroll
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;

//tableView目录列表
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

//装目录列表信息
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, strong) VoiceProgram *detailVoice;

//重新加载视图
@property (nonatomic, strong) ReloadView *reloadView;


@end

@implementation VoiceDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (ReloadView *)reloadView {
    if (!_reloadView) {
        _reloadView = [[ReloadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350)];
    }
    return _reloadView;
}

//显示等待视图
- (void)showGif {
    [MBProgressHUD setUpGifWithFrame:CGRectMake(0, 0, 80, 80) gifName:@"wait" andShowToView:self.view];
}

//隐藏等待视图
- (void)hideGifView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showGif];
    // 请求详情数据
    [self requestDetailData];
    // 请求列表数据
    [self requestListData];
    
    // 设置navigationBar
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    self.bottomScrollView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    [self layoutSubView];
    
    // 注册cell
    [self.listTableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

//- (void)setVoice:(Voice *)voice {
//    if (_voice != voice) {
//        _voice = voice;
//    }
//    _book.url = _voice.ID;
//}

- (void)setBook:(BookMP3 *)book {
    if (_book != book) {
        _book = book;
    }
    if (!_book.url) {
        _book.url = _book.ID;
    }
}

#pragma mark - 请求详情数据
- (void)requestDetailData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", EB_VOICE_BASE_URL, _book.url, EB_VOICE_URL];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) voiceDetailVC = self;
    [session GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             //刷新数据
             for (UIView *view in self.view.subviews) {
                 if (view == self.reloadView) {
                     NSLog(@"dfjaldsfj=======");
                     [view removeFromSuperview];
                 }
             }
             
             [self hideGifView];
             
             NSDictionary *dict = responseObject[@"ablumn"];
             VoiceProgram *voice = [VoiceProgram new];
             [voice setValuesForKeysWithDictionary:dict];
             voiceDetailVC.detailVoice = voice;
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 刷新列表
                 [voiceDetailVC reloadUIWithVoice:voice];
             });
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideGifView];
             [self.view addSubview:self.reloadView];
             __weak typeof(self) weakSelf = self;
             self.reloadView.block = ^() {
                 
                 [weakSelf requestDetailData];
                 NSLog(@"*******");
                 [weakSelf showGif];
                 
             };
    }];
}

#pragma mark - 请求播放列表数据
- (void)requestListData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", EB_VOICE_LIST_BASE_URL, _book.url, EB_VOICE_LIST_URL];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self) voiceDetailVC = self;
    [session GET:urlString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             //刷新数据
             for (UIView *view in self.view.subviews) {
                 if (view == self.reloadView) {
                     NSLog(@"dfjaldsfj=======");
                     [view removeFromSuperview];
                 }
             }
             [self hideGifView];

             for (NSDictionary *dict in responseObject[@"list"]) {
                 BookList *list = [BookList new];
                 [list setValuesForKeysWithDictionary:dict];
                 [voiceDetailVC.listArray addObject:list];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 刷新列表
                 [voiceDetailVC.listTableView reloadData];
             });
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideGifView];
             [self.view addSubview:self.reloadView];
             __weak typeof(self) weakSelf = self;
             self.reloadView.block = ^() {
                 
                 [weakSelf requestListData];
                 NSLog(@"*******");
                 [weakSelf showGif];
                 
             };
         }];
}

#pragma mark - 刷新列表
- (void)reloadUIWithVoice:(VoiceProgram *)voice
{
    self.title = voice.name;
    
    self.nameLabel.text = voice.name;
    self.typeLabel.text = [NSString stringWithFormat:@"类别：%@", voice.typeName];
    self.voicesLabel.text = [NSString stringWithFormat:@"声音：%@", voice.sections];
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@", voice.author];
    self.playLabel.text = [NSString stringWithFormat:@"播放：%.1f万", voice.playCount. floatValue / 10000];
    self.announcerLabel.text = [NSString stringWithFormat:@"主播：%@", voice.announcer];
    self.descLabel.text = voice.Description;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:voice.cover] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    // 时间戳转为时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval time = [voice.updateTime doubleValue] / 1000;
    NSDate *updateTime = [NSDate dateWithTimeIntervalSince1970:time];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    self.updateLabel.text = [NSString stringWithFormat:@"更新日期：%@", [formatter stringFromDate:updateTime]];
}

#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [self uploadWithBookList:bookList CurrentUser:currentUser];

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
    __weak typeof(self) voiceVC = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%@", downloadProgress);
        voiceVC.progress = downloadProgress;
        [downloadProgress addObserver:self forKeyPath:@"fractionCompleted" options:(NSKeyValueObservingOptionNew) context:NULL];
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        // 下载到沙盒的位置
        NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:[response suggestedFilename]];

       NSString *documentsPath = [response suggestedFilename];
        
        [downloadFile saveToleanCloudWithdocumentsPath:documentsPath BookList:bookList Book:_book User:currentUser ClassName:@"DownloadBook"];
        
        // 移除观察者
        [voiceVC.progress removeObserver:self forKeyPath:@"fractionCompleted"];
        
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
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"收藏" message:@"是否收藏" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AVObject *todo = [AVObject objectWithClassName:@"like"];
        [todo setObject:[AVUser currentUser].username forKey:@"username"];
        [todo setObject:kBookInfosHandle.bookMP3.name forKey:@"bookName"];
        [todo setObject:kBookInfosHandle.bookMP3.ID forKey:@"bookID"];
        [todo setObject:kBookInfosHandle.bookMP3.cover forKey:@"bookImageURL"];
        [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"%@",todo.objectId);// 保存成功之后，objectId 会自动从云端加载到本地
            }
        }];
    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertC addAction:alertA];
    [alertC addAction:alertB];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    kBookInfosHandle.bookInfosArray = _listArray;
    
    if (self.pushFrom == PushFromMoreListVC1) {
        kBookInfosHandle.bookMP3 = _book;
    } else {
        
        kBookInfosHandle.bookMP3.announcer = _detailVoice.announcer;
        kBookInfosHandle.bookMP3.cover = _detailVoice.cover;
        kBookInfosHandle.bookMP3.name = _detailVoice.name;
        kBookInfosHandle.bookMP3.type = _detailVoice.typeName;
        kBookInfosHandle.bookMP3.sections = _detailVoice.sections;
        kBookInfosHandle.bookMP3.desc = _detailVoice.Description;
        kBookInfosHandle.bookMP3.play = _detailVoice.playCount;
        kBookInfosHandle.bookMP3.update = _detailVoice.updateTime;
        
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
