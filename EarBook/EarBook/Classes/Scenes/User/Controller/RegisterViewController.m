//
//  RegisterViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "RegisterViewController.h"

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
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 注册按钮点击事件
- (IBAction)registerAction:(UIButton *)sender
{
    
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
