//
//  SpecialSubjectDetailViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/28.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "SpecialSubjectDetailViewController.h"
#import "JoiningURL.h"
#import "BookMP3.h"

@interface SpecialSubjectDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation SpecialSubjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _book.name;
    
    NSURL *url = [NSURL URLWithString:[JoiningURL urlWithCoverStr:_book.cover joiningStr:@"_338x170"]];
    
    [self.coverImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    self.descLabel.text = _book.desc;
    
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