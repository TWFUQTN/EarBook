//
//  DownloadListViewController.m
//  EarBook
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "DownloadListViewController.h"
#import "PlayerViewController.h"
#import "BookList.h"
#import "BookMP3.h"
#import "DownloadModel.h"
#import "EB_COLOR.h"
#import "DownloadFile.h"
#import "BookInfosHandle.h"
#import "AVPlayerManager.h"
#import <AVOSCloud.h>

#define kBookInfosHandle [BookInfosHandle shareBookInfosHandle]

@interface DownloadListViewController ()

/// 下载沙盒路径
@property (nonatomic, strong) NSMutableArray *downloadPathArray;

/// 书籍详情数组
//@property (nonatomic, strong) NSMutableArray *bookArray;

/// 书籍列表数组
//@property (nonatomic, strong) NSMutableArray *bookListArray;

@end

@implementation DownloadListViewController

- (NSMutableArray *)downloadPathArray
{
    if (!_downloadPathArray) {
        _downloadPathArray = [NSMutableArray array];
    }
    return _downloadPathArray;
}

//- (NSMutableArray *)bookArray
//{
//    if (!_bookArray) {
//        _bookArray = [NSMutableArray array];
//    }
//    return _bookArray;
//}
//
//- (NSMutableArray *)bookListArray
//{
//    if (!_bookListArray) {
//        _bookListArray = [NSMutableArray array];
//    }
//    return _bookListArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的下载";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"back9.jpg"];
    self.tableView.backgroundView =imageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 获取数据
    [self loadData];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 设置navigationBar
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
}

#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取数据
- (void)loadData
{
    AVUser *currentUser = [AVUser currentUser];
    
    AVQuery *query = [AVQuery queryWithClassName:@"DownloadBook"];
    [query whereKey:@"username" equalTo:currentUser.username];
    
    __weak typeof(self)downloadVC = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for (AVObject *oneObject in objects) {

                DownloadModel *downloadModel = [DownloadModel new];
                
                // 从云端取出数据
                downloadModel.bookName = [oneObject objectForKey:@"bookName"];
                downloadModel.bookListName = [oneObject objectForKey:@"bookListName"];
                downloadModel.ID = [oneObject objectForKey:@"ID"];
                downloadModel.url = [oneObject objectForKey:@"url"];
                downloadModel.path = [oneObject objectForKey:@"path"];
                downloadModel.cover = [oneObject objectForKey:@"cover"];
                downloadModel.downloadTime = oneObject.createdAt;
                
                [downloadVC.downloadPathArray addObject:downloadModel];
                
            }
            
            [downloadVC.tableView reloadData];
        }
    }];
}

#pragma mark - 解挡
//- (id)unarchiverWithData:(NSData *)data
//                     key:(NSString *)key
//{
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    id object = [unarchiver decodeObjectForKey:key];
//    
//    [unarchiver finishDecoding];
//    
//    return object;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.downloadPathArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    
    if (_downloadPathArray.count > 0) {
        
        DownloadModel *model = _downloadPathArray[indexPath.row];
        
//        NSDateFormatter *formatter = [NSDateFormatter new];
        
        cell.textLabel.text = model.bookListName;
//        cell.detailTextLabel.text = @"播放";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadModel *model = _downloadPathArray[indexPath.row];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *bundlePlayPath = [NSString stringWithFormat:@"file://%@", [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:model.path]];
    AVPlayerManager *manager = [AVPlayerManager shareAVPlayerManager];
    if (manager.status == isPlaying) {
        [manager pause];
        manager.status = isPaused;
//        cell.detailTextLabel.text = @"播放";
    } else {
        [manager playWithUrl:bundlePlayPath currentIndex:indexPath.row];
        [manager play];
        manager.status = isPlaying;
//        cell.detailTextLabel.text = @"暂停";
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
