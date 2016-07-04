//
//  RegisterViewController.h
//  EarBook
//
//  Created by lanou3g on 16/6/24.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AVUserManager.h"

typedef void(^RegisterVCBlock)(AVUserManager *user);
@interface RegisterViewController : UIViewController

@property (nonatomic, copy) RegisterVCBlock block;

@end
