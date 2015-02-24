//
//  AppDelegate.m
//  GNAR
//
//  Created by Yi-Chin Sun on 2/9/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
#import "Achievement.h"
#import "Game.h"
#import "Score.h"
#import "GameManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // Provide a local datastore which can be used to store and retrieve PFObjects, even when the network is unavailable
    [Parse enableLocalDatastore];

    // Added to allow access to parse database created for GNAR
    [Parse setApplicationId:@"edM3ZgRhFNDpw2KyVaUcvmGBn6O8DsifkZsSJ1hr"
                  clientKey:@"tDWtQucoKGDKM0rOIkBiMkKq0skhCbgDA2ME4ctU"];

    // Initialize Parse's Facebook Utilities singleton. This uses the FacebookAppID we specified in our App bundle's plist.
    //TODO: This is running a long-running operation on the main thread          ***
    [PFFacebookUtils initializeFacebook];

    // To track statistics around application opens
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    // Register for Push Notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    [[UILabel appearance] setTextColor:[UIColor whiteColor]];
    [[UIDatePicker appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0]];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithWhite:( 30/255.0) alpha:1.0]];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor colorWithWhite:( 30/255.0) alpha:1.0]];

    [User registerSubclass];
    [Achievement registerSubclass];
    [Game registerSubclass];
    [Score registerSubclass];

//    GameManager *myGameManager = [GameManager sharedManager];

    // Extract the notification data
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationPayload)
    {
        // Create a pointer to the Photo object
        NSString *gameID = [notificationPayload objectForKey:@"gameID"];
        PFObject *targetGame = [PFObject objectWithoutDataWithClassName:@"Game" objectId:gameID];

        // Fetch game object
        [targetGame fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            // Show photo view controller
            if (!error && [PFUser currentUser])
            {
                //Do logic to somehow bring up game view controller and an alert asking if you want to join the game??
            }
        }];
    }
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
    
    // Logs 'install' and 'app activate' App Events.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Does Facebook call using Parse' Facebook utilities
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

// Used to inform Parse about device registration
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    if ([PFUser currentUser])
    {
        [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
    }

    [currentInstallation saveEventually];
}

// Handles push notification when app is running
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler
{
    [PFPush handlePush:userInfo];

    NSString *gameID = [userInfo objectForKey:@"gameID"];
    PFObject *targetGame = [PFObject objectWithoutDataWithClassName:@"Game"
                                                            objectId:gameID];

    [targetGame fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error)
        {
            handler(UIBackgroundFetchResultFailed);
        }
        else if ([PFUser currentUser])
        {
            //Do logic to somehow bring up game view controller and an alert asking if you want to join the game??
            handler(UIBackgroundFetchResultNewData);
        }
        else
        {
//            handler(UIBackgroundModeNoData);
        }
    }];
}

@end
