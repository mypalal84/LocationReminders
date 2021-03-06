//
//  AppDelegate.m
//  LocationReminders
//
//  Created by A Cahn on 5/1/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "AppDelegate.h"

@import Parse;
@import UserNotifications;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerForNotifications];
    
    // Override point for customization after application launch.
    ParseClientConfiguration *parseConfig = [ParseClientConfiguration configurationWithBlock:^(id <ParseMutableClientConfiguration> _Nonnull configuration) {
        
        configuration.applicationId = @"325ohh325jhfd4";
        configuration.clientKey = @"joeitr3542hlk253lkj";
        
        configuration.server = @"https://alex-location-reminders-server.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:parseConfig];
    
    return YES;
}

-(void)registerForNotifications{
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
    
    UNUserNotificationCenter *current = [UNUserNotificationCenter currentNotificationCenter];
    
    [current requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error){
            NSLog(@"There was an error: %@", error.localizedDescription);
        }
        if (granted){
            NSLog(@"The user has allowed permissions for notifications!");
        } else {
            NSLog(@"The user has denied permissions for notifications :(");
        }
    }];
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
