//
//  PwdResetViewController.m
//  EarBook
//
//  Created by lanou3g on 16/7/9.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "PwdResetViewController.h"
#import <AVOSCloud.h>

@interface PwdResetViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation PwdResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailTextField.text = self.email;
    
    self.title = @"邮箱重置密码";
    
    self.emailTextField.delegate = self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendToEmail:(UIButton *)sender
{
    __weak typeof(self) pwdResetVC = self;
    [AVUser requestPasswordResetForEmailInBackground:self.emailTextField.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [pwdResetVC errorAlertWithMessage:@"请登录邮箱修改密码！"];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

#pragma mark - 提示的alert
- (void)errorAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    __weak typeof(self) pwdResetVC = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [pwdResetVC.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alert addAction:sureAction];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
