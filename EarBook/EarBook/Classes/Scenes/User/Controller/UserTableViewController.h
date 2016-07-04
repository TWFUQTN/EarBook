//
//  UserTableViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/25.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AVUserManager.h"

//typedef void(^UserVCBlock)(AVUserManager *user);
typedef void(^UserVCBlock)();
@interface UserTableViewController : UITableViewController

//@property (nonatomic, strong) AVUserManager *user;

@property (nonatomic, copy) UserVCBlock block;

@end
