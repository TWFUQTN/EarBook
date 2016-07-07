//
//  UserTableViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "UserTableViewController.h"
#import "LoginViewController.h"
#import "PersonalDataViewController.h"
#import "HomeViewController.h"
#import "DownloadListViewController.h"
#import "UserCell.h"
#import "EB_COLOR.h"
#import "FileManagerHandle.h"
#import "AVUserManager.h"

@interface UserTableViewController ()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation UserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"back12.jpg"];
    self.tableView.backgroundView =imageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置navigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.dictionary = @{@"image":@[@"Useruser", @"Userheart", @"Userfolder", @"Usertrashcan", @"Userpie"],
                        @"title":@[@"完善资料", @"我的收藏", @"我的下载", @"清除缓存", @"最近播放"]
                        };
    
    // 判断用户是否登录
    [self isLogin];
    
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    self.navigationController.navigationBar.alpha = 0.8;

}

#pragma mark - 判断用户是否登录
- (void)isLogin
{
    AVUserManager *currentUser = [AVUserManager currentUser];
    if (currentUser != nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:(UIBarButtonItemStylePlain) target:self action:@selector(logoutAction)];
//        self.user = currentUser;
    }
//    else {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:(UIBarButtonItemStylePlain) target:self action:@selector(loginAction)];
//    }
}

#pragma mark - 返回按钮
- (void)back
{
//    if (self.block) {
//        self.block(self.user);
//    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 注销
- (void)logoutAction
{
    [AVUserManager logOut];  //清除缓存用户对象
    if (self.block) {
        self.block();
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_dictionary[@"title"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell cellBindWithDictionary:self.dictionary Index:indexPath.row];
    
    if (indexPath.row == 3) {
        // caches文件夹路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        // 获取caches文件夹的大小
        float size = [FileManagerHandle folderSizeAtPath:cachesPath];
        
        cell.cacheLabel.text = [NSString stringWithFormat:@"%.2fM", size];
    }
//    cell.alpha = 0.7;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            
            PersonalDataViewController *personalDataVC = [PersonalDataViewController new];
            
            [self.navigationController pushViewController:personalDataVC animated:YES];
            
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            
            DownloadListViewController *downloadListVC = [DownloadListViewController new];
            [self.navigationController pushViewController:downloadListVC animated:YES];
            
            break;
        }
        case 3: {
            
            // 清除缓存
            // caches文件夹路径
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            // 获取caches文件夹的大小
            float size = [FileManagerHandle folderSizeAtPath:cachesPath];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否清除大小为%.2fM的缓存", size] preferredStyle:UIAlertControllerStyleAlert];
            
            __weak typeof(self)userListVC = self;
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                // 清除缓存
                [FileManagerHandle clearCache:cachesPath];
                [userListVC.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            break;
        }
        case 4: {
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
