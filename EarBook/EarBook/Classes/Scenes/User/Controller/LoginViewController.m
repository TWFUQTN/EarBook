//
//  LoginViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserTableViewController.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "User.h"
#import "AVUserManager.h"

@interface LoginViewController ()

/// 账号
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

/// 密码
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;


@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.alpha = 0.8;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    // 设置navigationBar
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:(UIBarButtonItemStylePlain) target:self action:@selector(registerAction)];
    self.navigationItem.rightBarButtonItem = right;

}

#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 注册右按钮点击事件
- (void)registerAction
{
    RegisterViewController *registerVC = [RegisterViewController new];
    
    registerVC.block = ^(AVUserManager *user) {
        _usernameTextField.text = user.username;
        _pwdTextField.text = user.password;
    };
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - 登录按钮点击事件
- (IBAction)loginAction:(UIButton *)sender
{
    [self validateInput];
    
    [AVUserManager logInWithUsernameInBackground:_usernameTextField.text password:_pwdTextField.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            
            // 登录成功
            UserTableViewController *userVC = [UserTableViewController new];
//            userVC.user = (AVUserManager *)user;
            [self.navigationController pushViewController:userVC animated:YES];

        } else {
            
        }
    }];
}

#pragma mark - 验证输入的值
- (void)validateInput
{
    if (self.usernameTextField.text.length <= 0) {
        [self errorAlertWithMessage:@"用户名不能为空"];
    }
    if (self.pwdTextField.text.length <= 0) {
        [self errorAlertWithMessage:@"密码不能为空"];
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

//- (BOOL)isEmail:(NSString *)email
//{
//    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    
//    NSRange range = [email rangeOfString:regex options:NSRegularExpressionSearch];
//    if (range.location != NSNotFound) {
//        return NO;
//    }
//    return YES;
//}



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
