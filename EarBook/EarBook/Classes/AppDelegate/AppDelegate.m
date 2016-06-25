//
//  AppDelegate.m
//  EarBook
//
//  Created by lanou3g on 16/6/23.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
<<<<<<< HEAD

#import "DetailViewController.h"
=======
#import "HomeNavigationController.h"
>>>>>>> 6adf13dc5945c88c299e1202dad7f203e102eb5e
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 1.创建window对象并设置为屏幕大小
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2.设置window的背景颜色
    self.window.backgroundColor = [UIColor whiteColor];
    // 3.显示window
    [self.window makeKeyAndVisible];
    
    // 4.设置根视图控制器
    
    // 设置导航控制器(第一个入栈的控制器,也就是第一个显示的控制器)
<<<<<<< HEAD
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[DetailViewController alloc] init]];
    
=======
    HomeNavigationController *nav = [[HomeNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];

>>>>>>> 6adf13dc5945c88c299e1202dad7f203e102eb5e
    self.window.rootViewController = nav;
    
//    [UINavigationBar appearance].translucent = NO;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
