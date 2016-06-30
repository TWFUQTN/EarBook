//
//  RegisterViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RegisterViewController.h"
#import "EB_COLOR.h"
#import "EB_URL.h"
#import "User.h"

@interface RegisterViewController ()

/// 账号
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

/// 昵称
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;

/// 密码
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

/// 确认密码
@property (weak, nonatomic) IBOutlet UITextField *rePWDTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置navigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
}

#pragma mark - 返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 注册按钮点击事件
- (IBAction)registerAction:(UIButton *)sender
{
    [self validateInput];
    
    NSDictionary *userDict = @{
                               @"account" : _accountTextField.text,
                               @"nickname" : _nicknameTextField.text,
                               @"pwd" : _pwdTextField.text,
                               @"imei" : @"=MEFFQTExOTMtMDlGRi00OTlBLTlGNjgtQjk2NjEzNjc2NzIx",
                               @"token" : @"iEd4QgrcSw1-rXvkr8xNcXuanaVqazN3Qb63ToXOFc8*",
                               @"nwt" : @"1"
                               };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    __weak typeof(self)registerVC = self;
    [session POST:EB_REGISTER_URL
       parameters:userDict
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              User *user = [User new];
              [user setValuesForKeysWithDictionary:responseObject];
            
//              if (user.userId) { &token=
//                  NSLog(@"注册成功");
//                  
//                  dispatch_async(dispatch_get_main_queue(), ^{
//                      [registerVC.navigationController popViewControllerAnimated:YES];
//                  });
//
//              } else {
//                  if (user.status == 1002) {
//                      [registerVC errorAlertWithMessage:user.msg];
//                  }
//              }
              
              NSLog(@"%@", responseObject);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [registerVC.navigationController popViewControllerAnimated:YES];
              });

              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
}

#pragma mark - 验证输入的值
- (void)validateInput
{
    if (self.accountTextField.text.length <= 0) {
        [self errorAlertWithMessage:@"邮箱不能为空"];
    }
    if ([self isEmail:_accountTextField.text]) {
        [self errorAlertWithMessage:@"邮箱格式不正确"];
    }
    if (self.nicknameTextField.text.length <= 0) {
        [self errorAlertWithMessage:@"昵称不能为空"];
    }
    if (self.pwdTextField.text.length <= 0) {
        [self errorAlertWithMessage:@"密码不能为空"];
    }
    if (self.rePWDTextField.text.length <= 0) {
        [self errorAlertWithMessage:@"确认密码不能为空"];
    }
    if (![self.pwdTextField.text isEqualToString:self.rePWDTextField.text]) {
        [self errorAlertWithMessage:@"两次密码输入不匹配"];
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

- (BOOL)isEmail:(NSString *)email
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRange range = [email rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return NO;
    }
    return YES;
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
