//
//  AppDelegate.m
//  CCDropboxApp
//
//  Created by Mitesh on 13/03/15.
//  Copyright (c) 2015 Mitesh. All rights reserved.
//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import "AFNetworkReachabilityManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];//Monitor for Reachability
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"bzdn94jrvwnx58p"
                            appSecret:@"68tynskzpo29e04"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    [self navigationBarAppearance];
    
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL*)url {
    if([[DBSession sharedSession] handleOpenURL:url]) {
        if([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

#pragma mark - Appearence

- (void)navigationBarAppearance
{
    
    NSDictionary *navbarTitleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:22],
                                                NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"backButtonNew.png"]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBackground.png"] forBarMetrics:UIBarMetricsDefault];
    
}
@end
