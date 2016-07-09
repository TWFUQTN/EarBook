//
//  PersonalDataViewController.m
//  EarBook
//
//  Created by lanou3g on 16/7/2.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "EB_COLOR.h"
#import "UserCoverCell.h"
#import "UserBasicDataCell.h"
#import "User.h"
#import "PwdResetViewController.h"
#import <AVOSCloud.h>

#define kTextFieldTag 7834

@interface PersonalDataViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *personDatatypeArray; // 用户属性名数组
@property (nonatomic, strong) NSMutableArray *userArray; // 用户信息数组

@property (nonatomic, strong) AVUser *user; // 用户
@property (nonatomic, strong) User *userModel;

@property (nonatomic, strong) UIImagePickerController *imagePicker; //图片选择器

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation PersonalDataViewController

- (NSArray *)personDatatypeArray
{
    if (!_personDatatypeArray) {
        _personDatatypeArray = @[@"昵称", @"邮箱"];
    }
    return _personDatatypeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    self.userModel = [User new];
    
    // 设置navigationBar
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(editFinish)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"back10.jpg"];
    self.tableView.backgroundView =imageView;
    
    // 注册cell
    [self.tableView registerClass:[UserCoverCell class] forCellReuseIdentifier:@"UserCoverCell"];
    [self.tableView registerClass:[UserBasicDataCell class] forCellReuseIdentifier:@"UserBasicDataCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 获取当前用户
    self.user = [AVUser currentUser];
    NSString *nickName = [_user objectForKey:@"nickName"];
    NSString *email = [_user objectForKey:@"email"];
    
    self.userArray = [NSMutableArray array];
    [self.userArray addObject:nickName];
    [self.userArray addObject:email];
    
    self.imagePicker = [UIImagePickerController new];
    _imagePicker.delegate = self;
}

#pragma mark - 完成编辑
- (void)editFinish
{
    [self.user setObject:self.userModel.cover forKey:@"cover1"];
    [self.user setObject:self.userModel.nickname forKey:@"nickName"];
    [self.user setObject:self.userModel.email forKey:@"email"];
    [self.user saveInBackground];// 保存到云端
    NSLog(@"haha");
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return self.personDatatypeArray.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        UserCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCoverCell" forIndexPath:indexPath];
        
        NSData *cover = [_user objectForKey:@"cover1"];
        if (cover.length > 0) {
            cell.cover = [self.user objectForKey:@"cover1"];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UserBasicDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserBasicDataCell" forIndexPath:indexPath];
        cell.detailLabel.text = _personDatatypeArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.basicDataTextField.text = _userArray[indexPath.row];
            cell.basicDataTextField.delegate = self;
            cell.basicDataTextField.tag = kTextFieldTag + indexPath.row;
            self.userModel.nickname = cell.basicDataTextField.text;
        }
        if (indexPath.row == 1) {
            cell.basicDataTextField.text = _userArray[indexPath.row];
            cell.basicDataTextField.delegate = self;
            cell.basicDataTextField.tag = kTextFieldTag + indexPath.row;
            self.userModel.email = cell.basicDataTextField.text;
        }
        
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"修改密码";
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self invokeSystemCamera];
        self.indexPath = indexPath;
    }
    if (indexPath.section == 2) {
        
        PwdResetViewController *pwdResetVC = [PwdResetViewController new];
        
        AVUser *currentUser = [AVUser currentUser];
        
        pwdResetVC.email = currentUser.email;
        
        [self.navigationController pushViewController:pwdResetVC animated:YES];
    }
}



#pragma mark 点击头像的方法
- (void)invokeSystemCamera
{
    // 调用系统相机、相册
    // 添加Alertsheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"图库" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }];
    
    [alert addAction:photoAction];
    [alert addAction:cameraAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 赋值头像
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *cover = UIImageJPEGRepresentation(image, 1.0);
    
    UserCoverCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    cell.cover = cover;
    self.userModel.cover = cover;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImage), nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage
{
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == kTextFieldTag) {
        self.userModel.nickname = textField.text;
    }
    if (tag == kTextFieldTag + 1) {
        
        if ([self isEmail:textField.text]) {
            self.userModel.email = textField.text;
        } else {
            [self errorAlertWithMessage:@"邮箱格式不符"];
        }
    }
}

#pragma mark - 错误提示的alert
- (void)errorAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 点击键盘return键的时候
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // 释放第一响应者,回收键盘
    NSLog(@"点击键盘return键");
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES]; // 当前视图结束编辑
}

- (BOOL)isEmail:(NSString *)email
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRange range = [email rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return NO;
    }
    return YES;
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
