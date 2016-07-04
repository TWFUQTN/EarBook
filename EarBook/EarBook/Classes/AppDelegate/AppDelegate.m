//
//  AppDelegate.m
//  EarBook
//
//  Created by lanou3g on 16/6/23.
//  Copyright © 2016年 赵符壹. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "HomeNavigationController.h"

#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import <UMSocialQQHandler.h>
#import <AVOSCloud/AVOSCloud.h>

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
    HomeNavigationController *nav = [[HomeNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];

    self.window.rootViewController = nav;
    
#pragma mark - 友盟
    [self shareUM];
    
#pragma mark - leanCloud
    // applicationId 即 App Id，clientKey 是 App Key。
    [AVOSCloud setApplicationId:@"Ms8SKLbB5oEPS5vSMNAHQCsc-gzGzoHsz"
                      clientKey:@"ix79U7yFCqWgyLU8oFv44VuS"];
    
    
    
    return YES;
}

#pragma mark - 友盟
- (void)shareUM
{
    [UMSocialData setAppKey:@"57767a3667e58e180b0006c2"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2189813254"
                                              secret:@"5d718c1ec72a8e273e5291207f45bc30"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

#pragma mark - 友盟配置系统回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
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
