//
//  DetailViewController.m
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "DetailViewController.h"
#import "ZF_SegmentLabelView.h"

@interface DetailViewController ()

@property (nonatomic, strong) ZF_SegmentLabelView *SLView;

@property (nonatomic, strong) NSArray *itemArr;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self addSegment];
    
    [self layoutSubView];
    
}

- (void)layoutSubView {
    
    
    
    
}


//添加一个segment和随之移动的label
- (void)addSegment {
    
    self.itemArr = @[@"详情介绍", @"章节列表"];
    
    NSDictionary *dicNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:15],NSFontAttributeName ,nil];
    
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
    
    self.SLView = [[ZF_SegmentLabelView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) viewBackgroundColor:[UIColor clearColor] items:self.itemArr dicNormal:dicNormal dicSelected:dicSelected labelBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:self.SLView];
    
    [self.SLView.upSegment addTarget:self action:@selector(segmentClick:) forControlEvents:(UIControlEventValueChanged)];
    
    
}


//segment点击响应方法
- (void)segmentClick:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    [self moveLabelAndViewByIndex:index];
}

//根据点击segment的位置移动下面的滑动条以及切换页面
- (void)moveLabelAndViewByIndex:(NSInteger)index {
    // 添加动画
    [UIView animateWithDuration:0.6 animations:^{
        
        CGRect frame = self.SLView.downLabel.frame;
        
        // 移动label
        frame.origin.x = CGRectGetWidth(self.SLView.upSegment.frame) / self.itemArr.count * index;
        
        self.SLView.downLabel.frame = frame;
    }];
    
    NSLog(@"我是第%ld页", index + 1);
    
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
