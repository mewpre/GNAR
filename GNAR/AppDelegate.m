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
#import "Player.h"
#import "GameManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // Provide a local datastore which can be used to store and retrieve PFObjects, even when the network is unavailable
//    [Parse enableLocalDatastore];

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

    // Global UI stuff
    [[UILabel appearanceWhenContainedIn: [UITableViewCell class], nil] setTextColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UISegmentedControl class], nil] setTextColor:[UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:138.0/255.0 green:69.0/255.0 blue:138.0/255.0 alpha:1.0]];
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithWhite:( 30/255.0) alpha:1.0]];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor colorWithWhite:( 30/255.0) alpha:1.0]];
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[UITableView appearance] setSeparatorColor:[UIColor colorWithWhite:0.40 alpha:1.0]];
    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];

    // Registering for local subclassing of Parse objects
    [User registerSubclass];
    [Achievement registerSubclass];
    [Game registerSubclass];
    [Score registerSubclass];
    [Player registerSubclass];

//    GameManager *myGameManager = [GameManager sharedManager];

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
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler
{
    [PFInstallation currentInstallation].badge = 0;
    //    [PFPush handlePush:userInfo];

    if ([[userInfo objectForKey:@"type"] isEqualToString:@"gameAlert"])
    {
        NSString *gameID = [userInfo objectForKey:@"gameID"];
        PFObject *targetGame = [PFObject objectWithoutDataWithClassName:@"Game"
                                                               objectId:gameID];
        [targetGame fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error)
            {
                handler(UIBackgroundFetchResultFailed);
            }
            else if ([User currentUser])
            {
                // Executed if receiving a push notification about being added to a game
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[userInfo objectForKey:@"aps"][@"alert"] message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];

                // If accepted, adds game to player's games relation
                UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                         {
                                             PFRelation *gamesRelation = [[User currentUser] relationForKey:@"games"];
                                             [gamesRelation addObject:targetGame];
                                             [[User currentUser] saveInBackground];
//                                             NSLog(@"Received notification!");
                                         }];
                // If declined, removes all relationships between the user and the game
                UIAlertAction *decline = [UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                          {
                                              PFRelation *playersRelation = [targetGame relationForKey:@"players"];
                                              [playersRelation removeObject:[User currentUser]];
                                              [targetGame saveInBackground];
                                          }];

                [alert addAction:decline];
                [alert addAction:accept];

                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            
            handler(UIBackgroundFetchResultNewData);
            }
            else
            {
                //            handler(UIBackgroundModeNoData);
            }
        }];
    }
    else if ([[userInfo objectForKey:@"type"] isEqualToString:@"scoreAlert"])
    {
        if ([User currentUser])
        {
            // Executed if receiving a push notification about being added to a game
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[userInfo objectForKey:@"aps"][@"alert"] message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];

            [alert addAction:ok];

            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];

            handler(UIBackgroundFetchResultNewData);
        }
    }
    else
    {
        // Do nothing; can extend if we decide to do more types of notifications
    }
}

@end
