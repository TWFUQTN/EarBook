//
//  SpecialSubjectDetailViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/28.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "SpecialSubjectDetailViewController.h"
#import "JoiningURL.h"
#import "EB_COLOR.h"
#import "BookMP3.h"
#import <UMSocial.h>

@interface SpecialSubjectDetailViewController ()<UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation SpecialSubjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _book.name;
    
    // 设置navigationBar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = EB_MAIN_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    
    NSURL *url = [NSURL URLWithString:[JoiningURL urlWithCoverStr:_book.cover joiningStr:@"_338x170"]];
    
    [self.coverImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    self.descLabel.text = _book.desc;
    
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


- (IBAction)shareAction:(UIButton *)sender
{
    [UMSocialData defaultData].extConfig.title = _book.name;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
