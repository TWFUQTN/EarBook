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
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()<AVAudioSessionDelegate>
{
    UIBackgroundTaskIdentifier _bgTaskId;
}

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
    
#pragma mark - 后台
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *setCategoryError = nil;
//    [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
//    NSError *activationError = nil;
//    [session setActive:YES error:&activationError];
    
#pragma mark - 耳机
    [self listeningEarphone];
    
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

- (void)listeningEarphone
{
    //监听耳机事件
    [[AVAudioSession sharedInstance] setDelegate:self];
    
    // Use this code instead to allow the app sound to continue to play when the screen is locked.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // Registers the audio route change listener callback function
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback, (__bridge void *)(self));
}

void audioRouteChangeListenerCallback (
                                       void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueS,
                                       const void                *inPropertyValue
                                       ) {
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    CFStringRef state = nil;
    
    //获取音频路线
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);//kAudioSessionProperty_AudioRoute：音频路线
    NSLog(@"%@",state);//Headphone 耳机  Speaker 喇叭.
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
//    //开启后台处理多媒体事件
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    AVAudioSession *session=[AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    //后台播放
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
//    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
//    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
}

//实现一下backgroundPlayerID:这个方法:
//+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
//{
//    //设置并激活音频会话类别
//    AVAudioSession *session=[AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [session setActive:YES error:nil];
//    //允许应用程序接收远程控制
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    //设置后台任务ID
//    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
//    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
//    {
//        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
//    }
//    return newTaskId;
//}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#pragma mark - 后台播放
    [application beginReceivingRemoteControlEvents];
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
