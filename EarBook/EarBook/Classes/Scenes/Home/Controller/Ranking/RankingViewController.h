//
//  RankingViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageController.h"

typedef void(^RankingVCBlock)(id  _Nullable responseObject);
@interface RankingViewController : UITableViewController<ARSegmentControllerDelegate>

@end
