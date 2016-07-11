//
//  AppDelegate.m
//  Cushion
//
//  Created by QUAN on 16/6/21.
//  Copyright © 2016年 QUAN. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _byte = [[ByteModel alloc] init];
    
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    
    self.window.rootViewController = navVC;
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    [WXApi registerApp:@"wx65c7a1a1441cb1da"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    
    //把返回的类型转换成与发送时相对于的返回类型,这里为SendMessageToWXResp
    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    
    //使用UIAlertView 显示回调信息
    NSString *str = [NSString stringWithFormat:@"%d",sendResp.errCode];
    
    switch (sendResp.errCode) {
        case 0:
            
            str = @"分享成功";
            
            break;
        case -1:
            
            str = @"分享失败";
            
            break;
        case -2:
            
            str = @"分享取消";
            
            break;
            
        default:
            break;
    }
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"回调信息" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alertview show];
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
