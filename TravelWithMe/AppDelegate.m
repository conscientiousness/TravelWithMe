//
//  AppDelegate.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/7.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UITabBarController *tabBarController = (UITabBarController*)_window.rootViewController;
    
    //NSLog(@"tabBarController's viewcontrollers: %@",[tabBarController.viewControllers description]);
    
    UIStoryboard *favoriteStoryboard = [UIStoryboard storyboardWithName:@"Favorite" bundle:nil];
    
    
    UIViewController *favoriteViewController = [favoriteStoryboard instantiateViewControllerWithIdentifier:@"favoriteViewController"];
    
    
    UIStoryboard *settingStoryboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    
    UIViewController *settingViewController = [settingStoryboard instantiateViewControllerWithIdentifier:@"settingViewController"];
    
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"Map" bundle:nil];
    
    
    UIViewController *mapViewController = [mapStoryboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    
    
    
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
    
    [newArray addObject:favoriteViewController];
    [newArray addObject:mapViewController];
    [newArray addObject:settingViewController];
    
    tabBarController.viewControllers = newArray;
    
    /*
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"mB7J0y9ThM6CmfTNJVLfqy3tz3XMcs4dVn0D1FP5"
                  clientKey:@"jm30Xr6lqx2E4GOMPJdc7y01Hd50BLZ8QAJSHRX7"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    */
    
    sleep(3);
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                           didFinishLaunchingWithOptions:launchOptions];
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
   [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
