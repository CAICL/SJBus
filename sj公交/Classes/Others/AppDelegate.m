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
@interface AppDelegate ()
@property (nonatomic,strong) BMKMapManager *manager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.manager = [[BMKMapManager alloc]init];
    BOOL ifSuccess = [self.manager start:@"FMaBWYMGrZASoenmmxRFIdI9" generalDelegate:nil];
    if (ifSuccess) {
        NSLog(@"百度地图授权成功");
    }else{
        NSLog(@"授权失败");
    }

    
    SJMainViewController *QDMainVC = [[SJMainViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:QDMainVC];
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.viewControllers = @[nav1];
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];

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
