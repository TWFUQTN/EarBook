//
//  MRYViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/30.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MryScrollPageVC.h"

@class Classification;

@interface MRYViewController : MryScrollPageVC

//传值model
@property (nonatomic, strong) Classification *classification;


@end
