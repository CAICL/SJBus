//
//  AppDelegate.m
//  sj公交
//
//  Created by 蔡春雷 on 15/12/12.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import "AppDelegate.h"
#import "BaiduMapAPI_Base/BMKMapManager.h"
#import "SJMainViewController.h"
#import "SJMapViewController.h"
#import "SJWeatherViewController.h"
#import "SJWelcomeViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+KR.h"

@interface AppDelegate ()
@property (nonatomic,strong) BMKMapManager *manager;
@property (nonatomic, strong) AFNetworkReachabilityManager *afn_Reachability_Manager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //百度地图
    [self baiduMap];
    // 检查联网状态
    [self checkConnectInternet];
    
    //初始化window
    [self initWindow];
    //3Dtouch
    /*
     当程序启动时
     
     1、判断launchOptions字典内的UIApplicationLaunchOptionsShortcutItemKey是否为空
     2、当不为空时,application:didFinishLaunchWithOptions方法返回NO，否则返回YES
     3、在application:performActionForShortcutItem:completionHandler方法内处理点击事件
     */
    [self configShortCutItems];
    if (launchOptions[@"UIApplicationLaunchOptionsShortcutItemKey"] == nil) {
        return YES;
    } else {
        return NO;
    }
}
- (void)checkConnectInternet
{
    // 1.获得网络监控的管理者
    self.afn_Reachability_Manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [self.afn_Reachability_Manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                [MBProgressHUD showError:@"请检查网络"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [self.afn_Reachability_Manager startMonitoring];
    
}

/** 创建shortcutItems */
- (void)configShortCutItems {
    NSMutableArray *shortcutItems = [NSMutableArray array];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"车次查询历史" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation] userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"2" localizedTitle:@"换乘历史查询" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    [shortcutItems addObject:item1];
    [shortcutItems addObject:item2];
    
    [[UIApplication sharedApplication] setShortcutItems:shortcutItems];
}

/** 处理shortcutItem */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    switch (shortcutItem.type.integerValue) {
        case 1: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoVc" object:self userInfo:@{@"type":@"1"}];
        }
        break;
        case 2: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoVc" object:self userInfo:@{@"type":@"2"}];
        }
        break;
        default:
        break;
    }
    
}

//百度地图
-(void)baiduMap{
    self.manager = [[BMKMapManager alloc]init];
    BOOL ifSuccess = [self.manager start:@"8OMYPN7MmFBOSwK0PICMlTRM" generalDelegate:nil];
    if (ifSuccess) {
        NSLog(@"百度地图授权成功");
    }else{
        NSLog(@"授权失败");
    }
}
//初始化window
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        self.window.rootViewController = [[SJWelcomeViewController alloc]init];
    }else{
        SJMainViewController *QDMainVC = [[SJMainViewController alloc]init];
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:QDMainVC];
        UITabBarController *tabBar = [[UITabBarController alloc]init];
        
        SJWeatherViewController *weatherVC = [SJWeatherViewController new];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:weatherVC];
        
        SJMapViewController *mapVC = [[SJMapViewController alloc] init];
        UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:mapVC];
        tabBar.viewControllers = @[nav1, nav2, nav3];
         [tabBar.tabBar setTintColor:[UIColor colorWithRed:98.0/255 green:158.0/255 blue:245.0/255 alpha:1]];
        self.window.rootViewController = tabBar;
    }
    [self.window makeKeyAndVisible];
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
