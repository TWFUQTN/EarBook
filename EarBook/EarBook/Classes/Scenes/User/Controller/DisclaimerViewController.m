//
//  Disclaimer ViewController.m
//  EarBook
//
//  Created by lanou3g on 16/7/9.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"免责声明";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
