//
//  CollectionTableViewController.m
//  EarBook
//
//  Created by lanou3g on 16/7/9.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "CollectionTableViewController.h"
#import "BookInfosHandle.h"
#import "CollectionTableViewCell.h"
#import "BaseModel.h"
#import <UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "BookMP3.h"
#define kBookInfosHandle [BookInfosHandle shareBookInfosHandle]



@interface CollectionTableViewController ()

@end

@implementation CollectionTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArray = [NSMutableArray array];
    self.title = @"我的收藏";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"back13.jpg"];
    self.tableView.backgroundView =imageView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置navigationBar
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self loadData];
}
#pragma mark - 获取数据
- (void)loadData
{
    AVUser *currentUser = [AVUser currentUser];
    
    AVQuery *query = [AVQuery queryWithClassName:@"like"];
    [query whereKey:@"username" equalTo:currentUser.username];
    
    __weak typeof(self)weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            for (int i = 0; i < objects.count; i++) {
                // 操作成功
           
                    BaseModel *model = [[BaseModel alloc]init];
                    model.bookID = [objects[i] objectForKey:@"bookID"];
                    model.bookImageURL = [objects[i] objectForKey:@"bookImageURL"];
                    model.bookName = [objects[i] objectForKey:@"bookName"];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"collectionCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectionCell" forIndexPath:indexPath];
    BaseModel *model = [[BaseModel alloc]init];
    model = _dataArray[indexPath.row];
    cell.bookNameLabel.text = model.bookName;
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.bookImageURL]];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == _dataArray.count) {
        cell.cellBackImageView.image = [UIImage imageNamed:@"cellback4.jpg"];
    }
   else if (indexPath.row == _dataArray.count - 1 ) {
        cell.cellBackImageView.image = [UIImage imageNamed:@"cellback3.jpg"];
    }
   else if (indexPath.row == _dataArray.count - 2) {
        
        cell.cellBackImageView.image = [UIImage imageNamed:@"cellback2.jpg"];
    }
    else{
        cell.cellBackImageView.image = [UIImage imageNamed:@"cellback1.jpg"];

    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseModel *model = [[BaseModel alloc]init];
    model = _dataArray[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    BookMP3 *bookModel = [[BookMP3 alloc]init];
    bookModel.ID = model.bookID;
    detailVC.book = bookModel;
    detailVC.joiningURLString = JoiningURLStringByID;
    detailVC.pushFrom = PushFromRankingVC;
    [self.navigationController pushViewController:detailVC animated:YES];
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
