//
//  AppDelegate.m
//  KYDrawProject
//
//  Created by 魏柯岩 on 2017/11/2.
//  Copyright © 2017年 mengmengda. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <WilddogSync/WilddogSync.h>
#import <WilddogCore/WilddogCore.h>
#import "SDWebImageDownloader.h"
#import "QCAPIManager.h"
#import "QCModel.h"
#import "QCWebViewController.h"
#import "RootViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#ifdef DEBUG
static BOOL const isProduction = NO;
#else
static BOOL const isProduction = YES;
#endif

#define JPUSHAppkey @"b481756facd001bd9d5cab3b"
#import "KLoadingView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    //初始化 WDGApp
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/imgad/pic/item/78310a55b319ebc4b37daea08926cffc1e171685.jpg"] options:SDWebImageDownloaderContinueInBackground progress:nil completed:nil];
    [self initPush:launchOptions];

    RootViewController * vc = [[RootViewController alloc]init];
    self.window.rootViewController = vc;
    [[QCAPIManager sharedManager]getInfoSuccess:^(QCModel * model) {
        [QCAPIManager sharedManager].modelItem  = model;
        [self showWebView:NO];
        return ;

        if ([model.status integerValue]==0) {
            if ([model.isshowwap boolValue]) {
                [self showWebView:YES];
            }else{
                [self showWebView:NO];
            }
        }else if ([model.status integerValue]==2){
            [self showWebView:NO];
        }else{
            [self showAppstore];
        }
        
    } failure:^(NSError *error) {
        [self showAppstore];
    }];
 
    return YES;
}
- (void)showAppstore{
    WDGOptions *option = [[WDGOptions alloc] initWithSyncURL:@"https://qingclassdraw.wilddogio.com"];
    [WDGApp configureWithOptions:option];
    //获取一个指向根节点的 WDGSyncReference 实例
    WDGSyncReference *ref = [[WDGSync sync] reference];
    
    ViewController * vc = [[ViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
}
- (void)showWebView:(BOOL)isShow{
    
    QCWebViewController *vc = [[QCWebViewController alloc] init];
   
    if (isShow) {
        vc.url = [NSURL URLWithString:[QCAPIManager sharedManager].modelItem.wapurl];
    }else{
        vc.url = [NSURL URLWithString:@"http://www.baidu.com"];
    }
    vc.title = @"test";
    self.window.rootViewController = vc;
}

- (void)initPush:(NSDictionary *)launchOptions
{
    // 激光
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //init Push
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAppkey channel:nil apsForProduction:isProduction];
    
    //get registrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            QCLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            QCLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    QCLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    QCLog(@"%@",userInfo);
    NSDictionary * info = userInfo;
    [JPUSHService setBadge:0];
    [JPUSHService handleRemoteNotification:info];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [JPUSHService setBadge:0];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [JPUSHService setBadge:0];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
  
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
