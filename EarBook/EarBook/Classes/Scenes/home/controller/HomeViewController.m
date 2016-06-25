//
//  HomeViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "HomeViewController.h"
#import "RecommendViewController.h"
#import "ClassificationViewController.h"
#import "RankingViewController.h"
#import "HomeCustomHeader.h"
#import "UIImage+ImageEffects.h"
void *CustomHeaderInsetObserver = &CustomHeaderInsetObserver;

@interface HomeViewController ()
@property (nonatomic, strong) HomeCustomHeader *header;

@end

@implementation HomeViewController


-(instancetype)init
{
    RecommendViewController *recommendVC = [[RecommendViewController alloc] initWithNibName:@"RecommendViewController" bundle:nil];
    ClassificationViewController *classificationVC = [[ClassificationViewController alloc] initWithNibName:@"ClassificationViewController" bundle:nil];
    RankingViewController *rankingVC = [[RankingViewController alloc] initWithNibName:@"RankingViewController" bundle:nil];
    
    
    self = [super initWithControllers:recommendVC,classificationVC, rankingVC ,nil];
    if (self) {
        // your code
        self.segmentMiniTopInset = 64;
        self.headerHeight = 150;
    }
    
    return self;
}
#pragma mark - override

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    if (_header == nil) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"HomeCustomHeader" owner:nil options:nil] lastObject];
        _header.backgroundColor = [UIColor redColor];
    }
    return _header;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置头像图
//    self.header.headImageView.layer.cornerRadius = self.header.headImageView.frame.size.width / 4;
//    self.header.headImageView.layer.masksToBounds = YES;
    
    // 边框
//    self.header.headImageView.layer.borderWidth = 2;
    [self addObserver:self forKeyPath:@"segmentTopInset" options:NSKeyValueObservingOptionNew context:CustomHeaderInsetObserver];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (context == CustomHeaderInsetObserver) {
        CGFloat inset = [change[NSKeyValueChangeNewKey] floatValue];
        [self.header updateHeadPhotoWithTopInset:inset];
        
        // 设置头像图
        self.header.headImageView.layer.cornerRadius = self.header.headImageView.frame.size.width / 2;
        self.header.headImageView.layer.masksToBounds = YES;
        
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentTopInset"];
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
