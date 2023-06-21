//
//  ViewController.m
//  HuiYanAuthDemo
//
//  Copyright © 2020 tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[HomeViewController new]];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;

    return YES;
}


@end
